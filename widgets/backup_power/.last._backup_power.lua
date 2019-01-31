-- -----------
-- _backup.lua
-- -----------
-- Backup power (UPS) status information _plus_ keyboard &	mouse interaction
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

local string	= { sub = string.sub }

-- Prepare the widget
local function creator( props )
	local props = props or {}

	-- User adjustable properties can contain any/all of the next 14 items
	local font			= props.font		or beautiful.font
	local fg_normal		= props.fg_normal	or beautiful.fg_normal
	local bg_normal		= props.bg_normal	or beautiful.bg_normal
	local fg_focus		= props.fg_focus	or beautiful.fg_focus
	local bg_focus		= props.bg_focus	or beautiful.bg_focus
	local popup_font	= props.popup_font	or beautiful.font
	local margin		= props.margin		or 12
	local timeout		= props.timeout		or 600
	local show_mod		= props.show_mod	or beautiful.c_altkey
	local show_key		= props.show_key	or "b"
	local status_cmd	= props.status_cmd	or "upsc myups ups.status"
	local detail_cmd	= props.detail_cmd	or "upsc myups | column -t -s :"
	local reset_cmd		= props.reset_cmd	or "sudo /etc/init.d/nut-server restart; sleep 10; sudo /etc/init.d/nut-client restart"
	local test_cmd		= props.test_cmd	or "upscmd -u monuser -p qaz myups test.battery.start.deep"

	-- Variables
	local popup		= nil
	local presets	= {	font = popup_font, text = "", title = nil }

	-- Widget
	local textbox = wibox.widget.textbox( "?" )
	textbox:set_font( font )
	local widget = wibox.container.background( textbox, bg_normal )
	widget:set_fg( fg_normal )

	-- Function to refresh the popup
	local function detail()
		awful.spawn.easy_async_with_shell( detail_cmd,
			function( stdout, stderr, exitreason, exitcode )
				local text = "<big><u>Backup power (UPS) information</u></big>\n\n" .. stdout:sub( 1, -2 )

				presets.text = text
				if popup then naughty.replace_text( popup, presets.title, presets.text ) end
			end )
	end

	-- Function to refresh the widget
	local function refresh()
		awful.spawn.easy_async_with_shell( status_cmd,
			function( stdout, stderr, exitreason, exitcode )
				local on_ac = (stdout == "OL\n")

				widget:set_fg( on_ac and fg_normal or fg_focus )
				widget:set_bg( on_ac and bg_normal or bg_focus )
				textbox.text = on_ac and " AC " or " DC "

				if popup then detail() end
			end )
	end

	-- Do a scheduled refresh of the widget
	refresh()
	gears.timer( { timeout = timeout, autostart = true, call_now = true, callback = refresh } )

	-- Functions to update NUT
	local function action( command )
		awful.spawn.easy_async_with_shell( command, function( stdout, stderr, exitreason, exitcode) refresh() end )
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
	widget:buttons( gears.table.join(	awful.button( {}, 1, refresh )								,
										awful.button( {}, 2, function() action( test_cmd ) end )	,
										awful.button( {}, 3, function() action( reset_cmd ) end )	)	)

	-- Add widgets global keys
	utils.add_key(	{ show_mod }, show_key, toggle,
					{ description = "show backup power (UPS) info.", group = "widgets" }	)

	-- Make the widget + more externally accessible
	return {	widget		= widget				,
				commands	= { toggle = toggle }	}
end

-- Execute and return the widget function to build and enable it
return creator
