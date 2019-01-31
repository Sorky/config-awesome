-- -----------
-- _system.lua
-- -----------
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
local awful		= {	spawn	= require( "awful.spawn" )	,
					button	= require( "awful.button" )	}
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

	-- User adjustable properties can contain any/all of the next 12 items
	local icon			= props.icon		or debug.getinfo( 1, "S" ).source:match( "/.*/" ) .. "icons/cpu.png"
	local icon_space	= props.icon_space	or 4
	local font			= props.font		or beautiful.font
	local bg_normal		= props.bg_normal	or beautiful.bg_normal
	local popup_font	= props.popup_font	or beautiful.font
	local margin		= props.margin		or 12
	local timeout		= props.timeout		or 2
	local show_mod		= props.show_mod	or beautiful.c_altkey
	local show_key		= props.show_key	or "s"
	local status_cmd	= props.status_cmd	or "cat /proc/stat"
	local detail_cmd	= props.detail_cmd	or "cat /sys/class/thermal/thermal_zone?/temp | tr '\n' ' '"
	local info_cmd		= props.info_cmd	or "xterm top"

	-- Variables
	local popup		= nil
	local presets	= {	font = popup_font, text = "", title = nil }
	local old_data	= { cpu = "0 0 0 0 0 0 0 0 0 0" }
	local new_data	= { cpu = "1 1 1 1 1 1 1 1 1 1" }
	local cpu_usage	= " 0.0%"

	-- Widget
	local imagebox	= wibox.widget.imagebox( icon )
	local textbox	= wibox.widget.textbox( " " )
	local group		= wibox.widget.base.make_widget_declarative( { imagebox, textbox, layout = wibox.layout.fixed.horizontal } )
	local wrapper	= wibox.container.margin( group, icon_space )
	local widget	= wibox.container.background( wrapper, bg_normal )
	textbox:set_font( font )

	-- Helper functions
	local function usage( key )
		if not old_data[ key ] then return " 0.0" end

		local old_values, old_total = {}, 0
		for value in old_data[ key ]:gmatch("%w+") do old_values[ #old_values + 1 ] = tonumber( value ) end
		for _, value in ipairs( old_values ) do old_total = old_total + value end
		local old_active = old_total - old_values[ 4 ] - old_values[ 5 ]

		local new_values, new_total = {}, 0
		for value in new_data[ key ]:gmatch("%w+") do new_values[ #new_values + 1 ] = tonumber( value ) end
		for _, value in ipairs( new_values ) do new_total = new_total + value end
		local new_active = new_total - new_values[ 4 ] - new_values[ 5 ]

		return string.format( "%2.1f", ( new_active - old_active ) / ( new_total - old_total ) * 100 )
	end

	-- Function to refresh the popup
	local function detail()
		awful.spawn.easy_async_with_shell( detail_cmd,
			function( stdout, stderr, exitreason, exitcode )
				local temps = {}
				for value in stdout:gmatch("%w+") do temps[ #temps + 1 ] = tonumber( value ) / 1000 end

				local text = "<big><u>System information</u></big>\n"
				text = text .. "\nCPU usages...\n\n"
				text = text .. string.format( " CPU 0 %3s%6s%%\n", "=", usage( "cpu0" ) )
				text = text .. string.format( " CPU 1 %3s%6s%%\n", "=", usage( "cpu1" ) )
				text = text .. string.format( " CPU 2 %3s%6s%%\n", "=", usage( "cpu2" ) )
				text = text .. string.format( " CPU 3 %3s%6s%%\n", "=", usage( "cpu3" ) )
				text = text .. string.format( " CPU 4 %3s%6s%%\n", "=", usage( "cpu4" ) )
				text = text .. string.format( " CPU 5 %3s%6s%%\n", "=", usage( "cpu5" ) )
				text = text .. string.format( " CPU 6 %3s%6s%%\n", "=", usage( "cpu6" ) )
				text = text .. string.format( " CPU 7 %3s%6s%%\n", "=", usage( "cpu7" ) )
				text = text .. string.format( "\n Average %s%6s%%\n", "=", usage( "cpu" ) )

				text = text .. "\nTemperatures...\n\n"
				text = text .. string.format( " Temp 0 %2s%6s°C\n", "=", temps[ 1 ] )
				text = text .. string.format( " Temp 1 %2s%6s°C\n", "=", temps[ 2 ] )
				text = text .. string.format( " Temp 2 %2s%6s°C\n", "=", temps[ 3 ] )

				presets.text = text
				if popup then naughty.replace_text( popup, presets.title, presets.text ) end
			end )
	end

	-- Function to refresh the widget
	local function refresh()
		for key, value in pairs( new_data ) do old_data[ key ] = value end
		awful.spawn.easy_async_with_shell( status_cmd,
			function( stdout, stderr, exitreason, exitcode )
				for line in stdout:gmatch( "([^\n]*)\n?" ) do
					local key, remainder = line:match( "(%w+) +(.*)" )
					new_data[ key ] = remainder
				end

				cpu_usage = usage( "cpu" )
				textbox.text = string.format( "%4s%% ", cpu_usage )
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

	-- Mouse buttons that work on the widget
	widget:buttons( awful.button( {}, 1, function() awful.spawn( info_cmd ) end ) )

	-- Add widgets global keys
	utils.add_key(	{ show_mod }, show_key, toggle,
					{ description = "show system info.", group = "widgets" }		)

	-- Make the widget + more externally accessible
	return {	widget		= widget														,
				cpu_usage	= cpu_usage												,
				commands	= { info_cmd	= function() awful.spawn( info_cmd ) end	,
								toggle		= toggle 									}	}
end

-- Execute and return the widget function to build and enable it
return creator
