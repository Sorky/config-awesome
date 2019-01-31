-- ----------
-- config.lua
-- ----------
-- Load the theme related configuration
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local beautiful	= require( "beautiful" )
local widgets	= require( "widgets" )
local gears		= { table			= require( "gears.table" )				}
local utils		= { add_key			= require( "utils.add_key" )			,
					pcall_fallback	= require( "utils.pcall_fallback" )		}
local freedesktop	= { menu		= require( "freedesktop.menu" )	}
local awful			= { tag			= require( "awful.tag" )									,
						menu		= require( "awful.menu" )									,
						util		= require( "awful.util" )									,
--						wibar		= require( "awful.wibar" )									,
						button		= require( "awful.button" )									,
						client		= require( "awful.client" )									,
--						layout		= require( "awful.layout" )									,
--						prompt		= require( "awful.prompt" )									,
						screen		= require( "awful.screen" )									,
						widget		= { prompt		= require( "awful.widget.prompt" )		,			--
										taglist		= require( "awful.widget.taglist" )		,			--
										tasklist	= require( "awful.widget.tasklist" )	,			--
										layoutbox	= require( "awful.widget.layoutbox" )	}	}		--
local wibox			= { widget		= { systray		= require( "wibox.widget.systray" )			,		--
										textbox		= require( "wibox.widget.textbox" )			,		--
										imagebox	= require( "wibox.widget.imagebox" )		}	,
--						layout		= { align		= require( "wibox.layout.align" )			,
--										fixed		= require( "wibox.layout.fixed" )			}	,
						container	= { background	= require( "wibox.container.background" )	}	}	--

-- Derived constants
local path_this = awesome.conffile:match(".*/")

-- Setup beautiful -- Usage: "themes/@/theme.lua" -- Replace @ with the theme folder name
if not beautiful.init( path_this .. "themes/shelby/theme.lua" ) then
	beautiful.init( path_this .. "themes/shelby/.last.theme.lua" )
end

-- Setup client helpers
beautiful.autotyper_1 = "sleep 0.1; xdotool type ME@MINE.com"
beautiful.c_signal_raise = function( c ) c:emit_signal( "request::activate", "mouse_click", {raise = true} ) end

-- Set the default layout
--awful.layout.layouts = {	awful.layout.suit.floating	, 				-- Commented out & Clipped = Use the defaults

-- Awesome icon in the system bar
beautiful.menu_widget = wibox.widget.imagebox( beautiful.awesome_icon )
beautiful.menu_widget:connect_signal( "button::press", function() freedesktop.menu.menu:toggle() end )

-- Setup the tag list
beautiful.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

-- Taglist mouse commands
beautiful.taglist_buttons = gears.table.join(
	awful.button( {}, 1, function( t ) t:view_only() end																),
	awful.button( {}, 3, function( t ) awful.tag.viewtoggle( t ) end													),
	awful.button( {}, 4, function( t ) awful.tag.viewnext( t.screen ) end												),
	awful.button( {}, 5, function( t ) awful.tag.viewprev( t.screen ) end												),
	awful.button( { beautiful.c_modkey }, 1, function( t ) if client.focus then client.focus:move_to_tag( t ) end end	),
	awful.button( { beautiful.c_modkey }, 3, function( t ) if client.focus then client.focus:toggle_tag( t )end end		))

-- Setup mouse clicks for the task list
beautiful.tasklist_buttons = gears.table.join(
	awful.button( {}, 1,	function( c )
								if c == client.focus then
									c.minimized = true
								else
									c.minimized = false
									client.focus = c
									c:raise()
								end
							end																		),
	awful.button( {}, 2,	function( c ) c:kill() end												),
	awful.button( {}, 3,	function() awful.menu.client_list( { theme = { width = 400 } } ) end	),
	awful.button( {}, 4,	function() awful.client.focus.byidx( 1 ) end 							),
	awful.button( {}, 5,	function() awful.client.focus.byidx( -1 ) end							))

-- Widgets
beautiful.MySystem		= widgets.system()
beautiful.MyRAM			= widgets.ram( { bg_normal = beautiful.bg_focus } )
beautiful.MyUpdates		= widgets.updates()
beautiful.MyBackup		= widgets.backup_power( { bg_normal = beautiful.bg_focus } )
beautiful.MyVolumeBar	= widgets.volume_bar( { popup_font = "Monospace 20" } )
beautiful.MyWeather		= widgets.weather( { bg_normal = beautiful.bg_focus } )
beautiful.MyClockCal	= widgets.clock_calendar( { dt_format = " %a, %b %d, %R:%S ", popup_font = "Monospace 12", num_months = 5, timeout = 1 } )
