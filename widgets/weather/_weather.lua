-- ------------
-- _weather.lua
-- ------------
-- Weather icon + text with drop-down forecast
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local naughty	= require( "naughty" )
local beautiful	= require( "beautiful" )
local awful		= {	spawn	= require( "awful.spawn" )	,
					button	= require( "awful.button" )	}
local utils		= { json	= require( "utils.json" )		,
					add_key	= require( "utils.add_key" )	}
local gears		= {	table		= require( "gears.table" )		,
					timer		= require( "gears.timer" )		,
					filesystem	= require( "gears.filesystem" )	}
local wibox		= { widget		= { base		= require( "wibox.widget.base" )		,
									textbox		= require( "wibox.widget.textbox" )		,
									imagebox	= require( "wibox.widget.imagebox" )	}		,
					container	= { margin		= require( "wibox.container.margin" )		,
									background	= require( "wibox.container.background" )	}	,
					layout		= { fixed		= require( "wibox.layout.fixed" ) }				}

local os		= { date = os.date }
local debug		= { getinfo = debug.getinfo }
local string	= { match	= string.match	,
					format	= string.format	}

-- Prepare the widget
local function creator( props )
	local props = props or {}

	-- User adjustable properties can contain any/all of the next 22 + 2 + 1 items
	local icon_path		= props.icon_path	or debug.getinfo( 1, "S" ).source:match( "/.*/" ) .. "icons/"
	local icon_space	= props.icon_space	or 8
	local font			= props.font		or beautiful.font
	local bg_normal		= props.bg_normal	or beautiful.bg_normal
	local popup_font	= props.popup_font	or beautiful.font
	local margin		= props.margin		or 12
	local timeout		= props.timeout		or 60
	local show_mod		= props.show_mod	or beautiful.c_altkey
	local show_key		= props.show_key	or "w"
	local status_cmd	= props.status_cmd	or "curl -s -m 30 'http://api.openweathermap.org/data/2.5/weather?units=%s&lang=%s&id=%s&APPID=%s'"
	local detail_cmd	= props.detail_cmd	or "curl -s -m 30 'http://api.openweathermap.org/data/2.5/forecast?units=%s&lang=%s&id=%s&APPID=%s&cnt=%s'"
	local units			= props.units		or "metric"
	local lang			= props.lang		or "en"
	local id			= props.id			or 2147714									-- London (GB) = 2643743, Sydney (AU) = 2147714
	local APPID			= props.APPID		or "7c260271165888bc5e7b31759f0cfa3d"		-- lain's = "3e321f9414eaedbfab34983bda77a66e", sorky's = "7c260271165888bc5e7b31759f0cfa3d"
	local cnt			= props.cnt			or 40										-- 1 to 40
	local timeout_c		= props.timeout_c	or 15 * 60									-- current (15 min)
	local timeout_f		= props.timeout_f	or 1 * 60 * 60								-- forecast (1 hr / 3 hr forecasts)
	local coldest_s		= props.coldest_s	or "<span foreground='#0066FF'>"
	local coldest_e		= props.coldest_e	or "</span>"
	local hotest_s		= props.hotest_s	or "<span foreground='#FF0066'>"
	local hotest_e		= props.hotest_s	or "</span>"

	local icon_set		= { name	= props.icon_set_name	or "owm"																				,
							url		= props.icon_set_url	or "https://openweathermap.org/themes/openweathermap/assets/vendor/owm/img/widgets/"	}

	-- Derived properties
	local na_icon	= props.na_icon	or icon_path .. "na.png"

	-- Variables
	local popup		= nil
	local presets	= {	font = popup_font, text = "", title = nil }
	local data_c	= {	main	= { temp = 00.00 }, weather = { { icon = "na" } } }
	local data_f	= {	cnt		= 1																				,
						city	= { name = "Nowhere" }															,
						list	= { {	dt		= 1514678400											,
										main	= { humidity = 00, pressure = 0000.0, temp = 00.00 }	,
										weather	= { { description = "clear sky" } }						}	}	}

	-- Widget
	local imagebox	= wibox.widget.imagebox( icon )
	local textbox	= wibox.widget.textbox( " " )
	local group		= wibox.widget.base.make_widget_declarative( { imagebox, textbox, layout = wibox.layout.fixed.horizontal } )
	local wrapper	= wibox.container.margin( group, icon_space )
	local widget	= wibox.container.background( wrapper, bg_normal )
	textbox:set_font( font )

	-- Function to refresh the popup
	local function detail()
		local text = "<big><u>" .. 1 + ( cnt // 8 )  .. " Day Forecast for " .. data_f.city.name .. "</u></big>\n"
		local day_text = "Today"
		local prev_day = 0

		for i, forecast in ipairs( data_f.list ) do
			local day_this = os.date( "*t", forecast.dt )

			if i > 1 then day_text = day_this.day == prev_day and "" or os.date( "%a", forecast.dt ) end
			prev_day = day_this.day

			text = text .. string.format( "\n%-6s ", day_text )

			local temp_prev = i > 1 and data_f.list[ i - 1 ].main.temp or -99
			local temp_next = i < data_f.cnt and data_f.list[ i + 1 ].main.temp or 99
			local hotest = i > 1 and forecast.main.temp >= temp_next and forecast.main.temp > temp_prev
			local coldest = i < data_f.cnt and forecast.main.temp <= temp_next and forecast.main.temp < temp_prev

			text = text .. ( hotest and hotest_s or "" )
			text = text .. ( coldest and coldest_s or "" )
			text = text .. string.format( " %2d %s ", day_this.hour % 12, ( day_this.hour >= 12 and "PM" or "AM" ) )
			text = text .. string.format( " %-22s ", forecast.weather[ 1 ].description )
			text = text .. string.format( " %4s °C ", string.format( "%2.1f", forecast.main.temp ) )
			text = text .. string.format( " %3s %% ", forecast.main.humidity )
			text = text .. string.format( " %5s hPa", string.format( "%4.0f", forecast.main.pressure ) )
			text = text .. ( coldest and coldest_e or "" )
			text = text .. ( hotest and hotest_e or "" )
		end

		presets.text = text
		if popup then naughty.replace_text( popup, presets.title, presets.text ) end
	end

	-- Function to refresh the widget
	local function refresh()
		local new_icon = icon_path .. icon_set.name .. "/" .. data_c.weather[1].icon .. ".png"

		imagebox:set_image( gears.filesystem.file_readable( new_icon ) and new_icon or na_icon )
		textbox.text = string.format( " %2s°C ", string.format( "%2.0f", tonumber( data_c.main.temp ) ) )
		if popup then detail() end
	end

	-- Do a scheduled refresh of the widget
	refresh()
	gears.timer( { timeout = timeout, autostart = true, call_now = true, callback = refresh } )

	-- Data collectors
	local function get_current()
		awful.spawn.easy_async( string.format( status_cmd, units, lang, id, APPID ),
			function( stdout, stderr, exitreason, exitcode )
				local data = utils.json.decode( stdout )

				if data.cod == 200 then
					data_c = data
					refresh() 
				end
			end )
	end
	local function get_forecast()
		awful.spawn.easy_async( string.format( detail_cmd, units, lang, id, APPID, cnt ),
			function( stdout, stderr, exitreason, exitcode )
				local data = utils.json.decode( stdout )

				if data.cod == "200" then
					data_f = data
					refresh() 
				end
			end )
	end

	-- Do a scheduled refresh of the data collectors
	get_current()
	gears.timer( { timeout = timeout_c, autostart = true, call_now = true, callback = get_current } )
	get_forecast()
	gears.timer( { timeout = timeout_f, autostart = true, call_now = true, callback = get_forecast } )

	-- Icon updater
	local function get_icon()
		awful.spawn.easy_async( "wget -q -c " .. icon_set.url .. data_c.weather[1].icon .. ".png -P " .. icon_path .. icon_set.name,
			function( stdout, stderr, exitreason, exitcode )
				if gears.filesystem.file_readable( icon_path .. icon_set.name .. "/" .. data_c.weather[1].icon .. ".png" ) then
					refresh()
				end
			end )
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
	widget:buttons( gears.table.join(	awful.button( {}, 1, refresh )						,
										awful.button( {}, 2, get_icon )						,
										awful.button( {}, 3, get_current, get_forecast )	)	)

	-- Add widgets global keys
	utils.add_key(	{ show_mod }, show_key, toggle,
					{ description = "show weather", group = "widgets" }	)

	-- Make the widget + more externally accessible
	return {	widget		= widget				,
				commands	= { toggle = toggle }	}
end

-- Execute and return the widget function to build and enable it
return creator
