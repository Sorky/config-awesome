-- --------
-- _ram.lua
-- --------
-- Description
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local naughty	= require( "naughty" )
local beautiful	= require( "beautiful" )
local utils		= { add_key	= require( "utils.add_key" ) }
local awful		= {	spawn	= require( "awful.spawn" )	}
local gears		= {	timer	= require( "gears.timer" )	}
local wibox		= { widget		= { base		= require( "wibox.widget.base" )		,
									textbox		= require( "wibox.widget.textbox" )		,
									imagebox	= require( "wibox.widget.imagebox" )	}		,
					container	= { margin		= require( "wibox.container.margin" )		,
									background	= require( "wibox.container.background" )	}	,
					layout		= { fixed		= require( "wibox.layout.fixed" ) }				}

local debug		= { getinfo = debug.getinfo }
local string	= { match	= string.match	,
					gmatch	= string.gmatch	,
					format	= string.format	}

-- Prepare the widget
local function creator( props )
	local props = props or {}

	-- User adjustable properties can contain any/all of the next 10 items
	local icon			= props.icon		or debug.getinfo( 1, "S" ).source:match( "/.*/" ) .. "icons/mem.png"
	local icon_space	= props.icon_space	or 4
	local font			= props.font		or beautiful.font
	local bg_normal		= props.bg_normal	or beautiful.bg_normal
	local popup_font	= props.popup_font	or beautiful.font
	local margin		= props.margin		or 12
	local timeout		= props.timeout		or 5
	local show_mod		= props.show_mod	or beautiful.c_altkey
	local show_key		= props.show_key	or "r"
	local status_cmd	= props.status_cmd	or "cat /proc/meminfo"

	-- Variables
	local popup		= nil
	local presets	= {	font = popup_font, text = "", title = nil }
	local keys		= { "MemTotal", "Mem_next" }
	local data		= { MemTotal	= {	value = 0, unit = "kB" }	, 
						Mem_next	= {	value = 0, unit = "kB" }	}

	-- Widget
	local imagebox	= wibox.widget.imagebox( icon )
	local textbox	= wibox.widget.textbox( " " )
	local group		= wibox.widget.base.make_widget_declarative( { imagebox, textbox, layout = wibox.layout.fixed.horizontal } )
	local wrapper	= wibox.container.margin( group, icon_space )
	local widget	= wibox.container.background( wrapper, bg_normal )
	textbox:set_font( font )

	-- Function to refresh the popup
	local function detail()
		local text = "<big><u>RAM information</u></big>\n"
		for _, key in pairs( keys ) do text = text .. string.format( "\n%18s %12d%3s ", key, data[ key ].value, data[ key ].unit ) end

		presets.text = text
		if popup then naughty.replace_text( popup, presets.title, presets.text ) end
	end

	-- Function to refresh the widget
	local function refresh()
		awful.spawn.easy_async_with_shell( status_cmd,
			function( stdout, stderr, exitreason, exitcode )
				local total, avail = 0, 0
				local new_keys, new_data = {}, {}

				for line in stdout:gmatch( "([^\n]*)\n?" ) do
					local key, value, unit = line:match( "(.+): *(%d+)(.*)" )
					new_keys[ #new_keys + 1 ] = key
					new_data[ key ] = { value = tonumber( value ), unit = unit }
				end
				keys = new_keys
				data = new_data

				textbox.text = string.format( "%2.2f%% ", ( data[ "MemTotal" ].value - data[ "MemAvailable" ].value ) / data[ "MemTotal" ].value * 100 )
				if popup then detail() end
			end )
	end

	-- Do a scheduled refresh of the widget
	refresh()
	gears.timer( { timeout = timeout, autostart = true, call_now = true, callback = refresh } )

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

	-- Add widgets global keys
	utils.add_key(	{ show_mod }, show_key, toggle,
					{ description = "show ram info.", group = "widgets" }		)

	-- Make the widget + more externally accessible
	return {	widget		= widget				,
				commands	= { toggle = toggle }	}
end

-- Execute and return the widget function to build and enable it
return creator
