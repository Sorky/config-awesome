-- ---------------
-- _volume_bar.lua
-- ---------------
-- Volume icon with drop-down volume bar _plus_ keyboard & mouse interaction
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
local wibox		= { container	= { margin		= require( "wibox.container.margin" )		,
									background	= require( "wibox.container.background" )	}	,
					widget		= { imagebox	= require( "wibox.widget.imagebox" )		}	}

local debug		= { getinfo = debug.getinfo }
local string	= { rep		= string.rep,
					match	= string.match,
					format	= string.format}

-- Prepare the widget
local function creator( props )
	local props = props or {}

	-- User adjustable properties can contain any/all of the next 14 + 1 + 6 + 6 + 6 items
	local icon_path		= props.icon_path	or debug.getinfo( 1, "S" ).source:match( "/.*/" ) .. "icons/"
	local icon_space	= props.icon_space	or 7
	local bg_normal		= props.bg_normal	or beautiful.bg_normal
	local popup_font	= props.popup_font	or beautiful.font
	local margin		= props.margin		or 12
	local timeout		= props.timeout		or 1
	local show_mod		= props.show_mod	or beautiful.c_altkey
	local show_key		= props.show_key	or "v"
	local media_keys	= props.media_keys	or true
	local slots			= props.slots		or 20
	local muted_s		= props.muted_s		or "<span foreground='#FF0000' background='#999999'>"
	local muted_e		= props.muted_e		or "</span>"
	local mixer_prog	= props.mixer_prog	or "amixer"
	local mixer_chan	= props.mixer_chan	or "Master"

	-- Derived properties
	local status_cmd	= props.status_cmd	or mixer_prog .. " -M get " .. mixer_chan

	local jobs = {	inc		= props.jobs_inc	or mixer_prog .. " -M set " .. mixer_chan .. " 1%+"					,
					max		= props.jobs_max	or mixer_prog .. " -M set " .. mixer_chan .. " 100%"				,
					dec		= props.jobs_dec	or mixer_prog .. " -M set " .. mixer_chan .. " 1%-"					,
					min		= props.jobs_min	or mixer_prog .. " -M set " .. mixer_chan .. " 0%"					,
					mute	= props.jobs_mute	or mixer_prog .. " -q -D pulse sset " .. mixer_chan .. " toggle"	,
					mixer	= props.jobs_mixer	or "pavucontrol"													}	-- "xterm -e alsamixer"

	local keys = {	inc		= { mod = props.keys_inc_mod	or show_mod, key = props.keys_inc_key	or "Up" }		,
					max		= { mod = props.keys_max_mod	or show_mod, key = props.keys_max_key	or "Prior" }	,
					dec		= { mod = props.keys_dec_mod	or show_mod, key = props.keys_dec_key	or "Down" }		,
					min		= { mod = props.keys_min_mod	or show_mod, key = props.keys_min_key	or "Next" }		,
					mute	= { mod = props.keys_mute_mod	or show_mod, key = props.keys_mute_key	or "m" }		,
					mixer	= { mod = props.keys_mixer_mod	or show_mod, key = props.keys_mixer_key	or "x" }		}

	local icons = { muted	= props.icons_muted	or icon_path .. "muted.png"		,
					off		= props.icons_off	or icon_path .. "level-0.png"	,
					low		= props.icons_low	or icon_path .. "level-1.png"	,
					med		= props.icons_med	or icon_path .. "level-2.png"	,
					high	= props.icons_high	or icon_path .. "level-3.png"	,
					full	= props.icons_full	or icon_path .. "level-4.png"	}

	-- Variables
	local popup		= nil
	local presets	= {	font = popup_font, text = "", title = nil }
	local data		= { state = "off", volume = -1 }

	-- Widget
	local imagebox	= wibox.widget.imagebox( icons.full )
	local wrapper	= wibox.container.margin( imagebox, icon_space, icon_space )
	local widget	= wibox.container.background( wrapper, bg_normal )

	-- Function to refresh the popup
	local function detail()
		local divs = ( data.volume * slots ) // 100
		local text = mixer_chan .. string.format( " = %3s%%", tostring( data.volume ) ) .. string.rep( " ", 3 )

		text = text .. ( data.state == "off" and " Muted\n" .. muted_s or "\n" )
		text = text .. string.format( "[%s%s]", string.rep( "|", divs ), string.rep( "-", slots - divs ) )
		text = text .. ( data.state == "off" and muted_e or "" )

		presets.text = text
		if popup then naughty.replace_text( popup, presets.title, presets.text ) end
	end

	-- Function to refresh the widget
	local function refresh()
		awful.spawn.easy_async_with_shell( status_cmd,
			function( stdout, stderr, exitreason, exitcode )
				local state = stdout:match( "%[([%l]+)%]" ) or "off"
				local volume = tonumber( stdout:match( "%[([%d]+)%%" ) ) or -1

				if data.state ~= state or data.volume ~= volume then
					if state == "off" then		imagebox:set_image( icons.muted )
					elseif volume <= 10 then	imagebox:set_image( icons.off )
					elseif volume <= 35 then	imagebox:set_image( icons.low )
					elseif volume <= 65 then	imagebox:set_image( icons.med )
					elseif volume <= 90 then	imagebox:set_image( icons.high )
					else						imagebox:set_image( icons.full )
					end

					data = { state = state, volume = volume }
					if popup then detail() end
				end
			end )
	end

	-- Do a scheduled refresh of the widget
	refresh()
	gears.timer( { timeout = timeout, autostart = true, call_now = true, callback = refresh } )

	-- Functions to change the volume
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
	widget:buttons( gears.table.join(	awful.button( {}, 1, function() action( jobs.mute ) end )	,
										awful.button( {}, 2, function() action( jobs.mixer ) end )	,
										awful.button( {}, 3, function() action( jobs.max ) end )	,
										awful.button( {}, 4, function() action( jobs.inc ) end )	,
										awful.button( {}, 5, function() action( jobs.dec ) end )	)	)

	-- Add widgets global keys
	utils.add_key(	{ show_mod }, show_key, toggle,
					{ description = "show volume", group = "widgets" }	)

	utils.add_key(	{ keys.inc.mod }, keys.inc.key, function() action( jobs.inc ) end,
					{ description = "volume up", group = "volume" }		)
	utils.add_key(	{ keys.max.mod }, keys.max.key, function() action( jobs.max ) end,
					{ description = "volume 100%", group = "volume" }	)
	utils.add_key(	{ keys.dec.mod }, keys.dec.key, function() action( jobs.dec ) end,
					{ description = "volume down", group = "volume" }	)
	utils.add_key(	{ keys.min.mod }, keys.min.key, function() action( jobs.min ) end,
					{ description = "volume 0%", group = "volume" }		)
	utils.add_key(	{ keys.mute.mod }, keys.mute.key, function() action( jobs.mute ) end,
					{ description = "toggle mute", group = "volume" }	)
	utils.add_key(	{ keys.mixer.mod }, keys.mixer.key, function() action( jobs.mixer ) end,
					{ description = "open mixer", group = "volume" }	)

	if media_keys then
		utils.add_key(	{}, "XF86AudioRaiseVolume", function() action( jobs.inc ) end,
						{ description = "volume up", group = "volume" }		)
		utils.add_key(	{ show_mod }, "XF86AudioRaiseVolume", function() action( jobs.max ) end,
						{ description = "volume 100%", group = "volume" }	)
		utils.add_key(	{}, "XF86AudioLowerVolume", function() action( jobs.dec ) end,
						{ description = "volume down", group = "volume" }	)
		utils.add_key(	{ show_mod }, "XF86AudioLowerVolume", function() action( jobs.min ) end,
						{ description = "volume 0%", group = "volume" }		)
		utils.add_key(	{}, "XF86AudioMute", function() action( jobs.mute ) end,
						{ description = "toggle mute", group = "volume" }	)
	end

	-- Make the widget + more externally accessible
	return {	widget		= widget												,
				state		= data.state											,
				volume		= data.volume											,
				commands	= { inc		= function() action( jobs.inc ) end		,
								max		= function() action( jobs.max ) end		,
								dec		= function() action( jobs.dec ) end		,
								min		= function() action( jobs.min ) end		,
								mute	= function() action( jobs.mute ) end	,
								mixer	= function() action( jobs.mixer ) end	,
								toggle	= toggle								}	}
end

-- Execute and return the widget function to build and enable it
return creator
