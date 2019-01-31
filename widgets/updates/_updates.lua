-- ------------
-- _updates.lua
-- ------------
-- Show if updates are available with a detail popup _plus_ keyboard & mouse interaction
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local naughty	= require( "naughty" )
local beautiful	= require( "beautiful" )
local utils		= { add_key	= require( "utils.add_key" ) }
local awful		= {	spawn	= require( "awful.spawn" )	,
					button	= require( "awful.button" )	}
local gears		= {	table	= require( "gears.table" )	,
					timer	= require( "gears.timer" )	}
local wibox		= { widget		= { textbox		= require( "wibox.widget.textbox" )			}	,
					container	= { background	= require( "wibox.container.background" )	}	}

local string	= { sub		= string.sub	,
					gsub	= string.gsub	,
					match	= string.match	}

-- Prepare the widget
local function creator( props )
	local props = props or {}

	-- User adjustable properties can contain any/all of the next 11 + 4 items
	local font			= props.font		or beautiful.font
	local fg_normal		= props.fg_normal	or beautiful.fg_normal
	local bg_normal		= props.bg_normal	or beautiful.bg_normal
	local fg_focus		= props.fg_focus	or beautiful.fg_focus
	local popup_font	= props.popup_font	or beautiful.font
	local margin		= props.margin		or 12
	local timeout		= props.timeout		or 600
	local show_mod		= props.show_mod	or beautiful.c_altkey
	local show_key		= props.show_key	or "u"
	local status_cmd	= props.status_cmd	or "apt-get upgrade -s"										-- "apt list --upgradable | wc -l"
--	local detail_cmd	= props.detail_cmd	or "sudo apt list --upgradable | sed '/Listing.../d' | column -t"
	local detail_cmd	= props.detail_cmd	or "apt list --upgradable | sed '/Listing.../d' | column -t"

	-- Derived properties
	local jobs = {	update			= props.jobs_update			or "xterm -hold -e 'sudo apt-get update'"		,
					upgrade			= props.jobs_upgrade		or "xterm -hold -e 'sudo apt-get upgrade'"		,
					dist_upgrade	= props.jobs_dist_upgrade	or "xterm -hold -e 'sudo apt-get dist-upgrade'"	,
					autoremove		= props.jobs_autoremove		or "xterm -hold -e 'sudo apt-get autoremove'"	}

	-- Variables
	local popup		= nil
	local presets	= {	font = popup_font, text = "", title = nil }
	local busy		= false

	-- Widget
	local textbox = wibox.widget.textbox( "?" )
	textbox:set_font( font )
	local widget = wibox.container.background( textbox, bg_normal )
	widget:set_fg( fg_normal )

	-- Function to refresh the popup
	local function detail()
		awful.spawn.easy_async_with_shell( detail_cmd,
			function( stdout, stderr, exitreason, exitcode )
				local text, count = stdout:gsub( "\n", "" )
				text = "<big><u>Available updates</u></big>\n\n" .. ( count == 0 and "None" or stdout:sub( 1, -2 ) )

				presets.text = text
				if popup then naughty.replace_text( popup, presets.title, presets.text ) end
			end )
	end
	detail()

	-- Function to refresh the widget
	local function refresh()
		awful.spawn.easy_async_with_shell( status_cmd,
			function( stdout, stderr, exitreason, exitcode )
				local count1, count2, count3, count4 = stdout:match( "(%d+) to upgrade, (%d+) to newly install, (%d+) to remove and (%d+)" )
				local count = count1 + count2 + count3 + count4

				widget:set_fg( count == 0 and fg_normal or fg_focus )
				textbox.text = " Apt " .. tostring( count1 ) .. "/" .. tostring( count2 ) .. "/" .. tostring( count3 ) .. "/" .. tostring( count4 ) .. " "

				if popup then detail() end
			end )
	end

	-- Do a scheduled refresh of the widget
	refresh()
	gears.timer( { timeout = timeout, autostart = true, call_now = true, callback = refresh } )

	-- Function to update/review/apply the updates
	local function action_wait( command )
		if busy then
			naughty.notify( { text = "busy...", timeout = 2 } )
		else
			busy = true
			awful.spawn.easy_async( command,
				function( stdout, stderr, exitreason, exitcode )
					busy = false
					refresh()
				end )
		end
	end

	-- Functions to show/hide the popup
	local function hide()	if not popup then return end
							naughty.destroy( popup )
							popup = nil
	end
	local function show()	hide()
							detail()
							popup = naughty.notify( { preset = presets, margin = margin, timeout = 0 } )
	end
	local function toggle()	if popup then hide() else show() end end

	-- Show/hide the popup when the mouse moves over it
	widget:connect_signal( "mouse::enter", show )
	widget:connect_signal( "mouse::leave", hide )

	-- Mouse buttons that work on the widget
	widget:buttons( gears.table.join(	awful.button( {}, 1, refresh )											,
										awful.button( {}, 2, function() action_wait( jobs.update ) end )		,
										awful.button( {}, 3, function() action_wait( jobs.upgrade ) end )		,
										awful.button( {}, 4, function() action_wait( jobs.dist_upgrade ) end )	,
										awful.button( {}, 5, function() action_wait( jobs.autoremove ) end )	)	)

	-- Add widgets global keys
	utils.add_key(	{ show_mod }, show_key, toggle,
					{ description = "show updates", group = "widgets" }		)

	-- Make the widget + more externally accessible
	return {	widget		= widget															,
				commands	= {	update			= function() action( jobs.update ) end			,
								upgrade			= function() action( jobs.upgrade ) end			,
								dist_upgrade	= function() action( jobs.dist_upgrade ) end	,
								toggle	= toggle												}		}
end

-- Execute and return the widget function to build and enable it
return creator
