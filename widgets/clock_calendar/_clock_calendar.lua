-- -------------------
-- _clock_calendar.lua
-- -------------------
-- Date & time clock with popup multi-month calendar _plus_ keyboard & mouse intermonth_offset
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local naughty	= require( "naughty" )
local beautiful	= require( "beautiful" )
local utils		= { add_key	= require( "utils.add_key" ) }
local awful		= {	button	= require( "awful.button" )	}
local gears		= {	table	= require( "gears.table" )	,
					timer	= require( "gears.timer" )	}
local wibox		= { widget		= { textbox		= require( "wibox.widget.textbox" )			}	,
					container	= { background	= require( "wibox.container.background" )	}	}

local os		= { time	= os.time	,
					date	= os.date	}
local string	= { rep		= string.rep	,
					format	= string.format	}

-- Prepare the widget
local function creator( props )
	local props = props or {}

	-- User adjustable properties can contain any/all of the next 14 items
	local font			= props.font		or beautiful.font
	local bg_normal		= props.bg_normal	or beautiful.bg_normal
	local popup_font	= props.popup_font	or beautiful.font
	local margin		= props.margin		or 12
	local timeout		= props.timeout		or 60
	local show_mod		= props.show_mod	or beautiful.c_altkey
	local show_key		= props.show_key	or "c"
	local dt_format		= props.dt_format	or " %a, %d %b %Y, %R "									-- See https://www.lua.org/pil/22.1.html
	local start_day		= props.start_day	or 2													-- The day of the week, range 1 to 7, Sunday being 1
	local num_months	= props.num_months	or 3
	local show_now_s	= props.show_now_s	or "<span foreground='#000000' background='#FFFF00'>"
	local show_now_e	= props.show_now_e	or "</span>"
	local day_set		= props.day_set		or { "Su", "Mo", "Tu", "We", "Th", "Fr", "Sa" }
	local month_set		= props.month_set	or { "January", "February", "March" , "April", "May", "June", "July", "August", "September", "October", "November", "December" }

	-- Variables
	local popup			= nil
	local presets		= {	font = popup_font, text = "", title = nil }
	local months_offset	= 0

	-- Widget
	local textbox = wibox.widget.textbox( "?" )
	textbox:set_font( font )
	local widget = wibox.container.background( textbox, bg_normal )

	-- Function to refresh the popup
	local function detail( offset )
		local text	= ""
		local today	= os.date( "*t" )

		-- Allow scrolling the open calendar forward and backward
		months_offset = ( offset and months_offset + offset or 0 )

		for i = 1, num_months do
			-- Data for month being generated
			local month		= today.month - months_offset + ( i - 1 ) - ( num_months // 2 )
			local showing	= os.date( "*t", os.time( { year = today.year, month = month, day = 1 } ) )
			local day_count	= os.date( "*t", os.time( { year = today.year, month = month + 1, day = 0 } ) ).day
			local blanks	= showing.wday - start_day + ( start_day > showing.wday and 7 or 0 )

			-- Calendar headings
			text = text .. string.format( " <b><big><big><u>%-15s%s</u></big></big>\n ", month_set[ showing.month ], showing.year )
			for j = 1, 7 do text = text .. string.format( "%-4s", day_set[ ( ( 5 + start_day + j ) % 7 ) + 1 ] ) end
			text = text .. "</b>\n"

			-- Calendar days
			for j = 1 - blanks, day_count do
				local d = j > 0 and string.format( "%2s", tostring( j ) ) or string.rep( " ", 2 )
				local t = j == today.day and showing.month == today.month and showing.year == today.year

				text = text .. ( t and show_now_s .. " " .. d .. " " .. show_now_e or " " .. d .. " " )
				text = text .. ( ( j > 0 and ( j + blanks ) % 7 == 0 and j < day_count ) and "\n" or "" )
			end

			-- Show more months?
			if i < num_months then text = text .. "\n\n" end
		end

		presets.text = text
		if popup then naughty.replace_text( popup, presets.title, presets.text ) end
	end

	-- Function to refresh the widget
	local function refresh()
		textbox.text = os.date( dt_format )
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
	widget:buttons( gears.table.join(	awful.button( {}, 1, function() detail( 1 ) end )	,
										awful.button( {}, 2, function() detail( nil ) end )	,
										awful.button( {}, 3, function() detail( -1 ) end )	,
										awful.button( {}, 4, function() detail( 1 ) end )	,
										awful.button( {}, 5, function() detail( -1 ) end )	)	)

	-- Add widgets global keys
	utils.add_key(	{ show_mod }, show_key, toggle,
					{ description = "show calendar", group = "widgets" }	)

	-- Make the widget + more externally accessible
	return {	widget		= widget				,
				commands	= { toggle = toggle }	}
end

-- Execute and return the widget function to build and enable it
return creator
