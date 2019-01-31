-- -----------
-- screens.lua
-- -----------
-- Backgrounds, decorations and widget
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local beautiful		= require( "beautiful" )
local gears			= { table		= require( "gears.table" )		,
						wallpaper	= require( "gears.wallpaper" )	}
local utils			= { add_key		= require( "utils.add_key" ) 	,
						add_button	= require( "utils.add_button" ) }
local awful			= { tag			= require( "awful.tag" )									,
						util		= require( "awful.util" )									,
						wibar		= require( "awful.wibar" )									,
						button		= require( "awful.button" )									,
						layout		= require( "awful.layout" )									,
						prompt		= require( "awful.prompt" )									,
						screen		= require( "awful.screen" )									,
						widget		= { prompt		= require( "awful.widget.prompt" )		,
										taglist		= require( "awful.widget.taglist" )		,
										tasklist	= require( "awful.widget.tasklist" )	,
										layoutbox	= require( "awful.widget.layoutbox" )	}	}
local wibox			= { widget		= { systray		= require( "wibox.widget.systray" )			,
										textbox		= require( "wibox.widget.textbox" )			}	,
						layout		= { align		= require( "wibox.layout.align" )			,
										fixed		= require( "wibox.layout.fixed" )			}	,
						container	= { background	= require( "wibox.container.background" )	}	}

-- Tag action keys
for i = 1, 9 do
	-- Link keys to tags
	utils.add_key(	{ beautiful.c_modkey }, "#" .. i + 9,
					function()
						local screen = awful.screen.focused()
						local tag = screen.tags[i]
						if tag then tag:view_only() end
					end,
					{ description = "view tag #", group = "tag" } )

	-- Move client to tag
	utils.add_key(	{ beautiful.c_modkey, "Shift" }, "#" .. i + 9,
					function()
						if client.focus then
							local tag = client.focus.screen.tags[ i ]
							if tag then client.focus:move_to_tag( tag ) end
						end
					end,
					{ description = "move focused client to tag #", group = "tag" } )

	-- Toggle tag display
	utils.add_key(	{ beautiful.c_modkey, "Control" }, "#" .. i + 9,
					function()
						local screen = awful.screen.focused()
						local tag = screen.tags[ i ]
						if tag then awful.tag.viewtoggle( tag ) end
					end,
					{ description = "toggle tag #", group = "tag"} )

	-- Toggle tag on focused client.
	utils.add_key(	{ beautiful.c_modkey, "Control", "Shift" }, "#" .. i + 9,
					function()
						if client.focus then
							local tag = client.focus.screen.tags[ i ]
							if tag then client.focus:toggle_tag( tag ) end
						end
					end,
					{ description = "toggle focused client on tag #", group = "tag" } )
end

-- Change screens
utils.add_key(	{ beautiful.c_modkey, "Control" }, "j",
				function() awful.screen.focus_relative( 1 ) end,
				{ description = "focus the next screen", group = "screen" }	)
utils.add_key(	{ beautiful.c_modkey, "Control" }, "k",
				function() awful.screen.focus_relative( -1 ) end,
				{ description = "focus the previous screen", group = "screen" }	)

-- Run shell command
utils.add_key(	{ beautiful.c_modkey }, "r",
				function() awful.screen.focused().promptbox:run() end,
				{ description = "run prompt", group = "launcher" }	)

-- Run lua command
utils.add_key(	{ beautiful.c_modkey }, "e",
				function()
					awful.prompt.run( {	prompt = "Run Lua code: ",
										textbox = awful.screen.focused().promptbox.widget,
										exe_callback = awful.util.eval,
										history_path = awful.util.get_cache_dir() .. "/history_eval"	} )
				end,
				{ description = "lua execute prompt", group = "launcher" }	)

-- Show/hide the system bar / tray [wibar]
utils.add_key(	{ beautiful.c_modkey }, "b", function() for s in screen do s.wibar.visible = not s.wibar.visible end end,
				{ description = "toggle system bar", group = "awesome" }	)

-- Tag browsing
utils.add_key(	{ beautiful.c_modkey }, "Left",
				awful.tag.viewprev,
				{ description = "view previous", group = "tag" }	)
utils.add_key(	{ beautiful.c_modkey }, "Right",
				awful.tag.viewnext,
				{ description = "view next", group = "tag" }	)
utils.add_key(	{ beautiful.c_modkey }, "Escape",
				awful.tag.history.restore,
				{ description = "go back", group = "tag" }	)

-- Layout manipulation
utils.add_key(	{ beautiful.c_altkey, "Shift" }, "l",
				function() awful.tag.incmwfact( 0.05 ) end,
				{ description = "increase master width factor", group = "layout" }	)
utils.add_key(	{ beautiful.c_altkey, "Shift" }, "h",
				function() awful.tag.incmwfact( -0.05 ) end,
				{ description = "decrease master width factor", group = "layout" }	)
utils.add_key(	{ beautiful.c_modkey, "Shift" }, "h",
				function() awful.tag.incnmaster( 1, nil, true ) end,
				{ description = "increase the number of master clients", group = "layout" }	)
utils.add_key(	{ beautiful.c_modkey, "Shift" }, "l",
				function() awful.tag.incnmaster( -1, nil, true ) end,
				{ description = "decrease the number of master clients", group = "layout" }	)
utils.add_key(	{ beautiful.c_modkey, "Control" }, "h",
				function() awful.tag.incncol( 1, nil, true ) end,
				{ description = "increase the number of columns", group = "layout" }	)
utils.add_key(	{ beautiful.c_modkey, "Control" }, "l",
				function() awful.tag.incncol( -1, nil, true ) end,
				{ description = "decrease the number of columns", group = "layout" }	)
utils.add_key(	{ beautiful.c_modkey }, "space",
				function() awful.layout.inc( 1 ) end,
				{ description = "select next", group = "layout" }	)
utils.add_key(	{ beautiful.c_modkey, "Shift" }, "space",
				function() awful.layout.inc( -1) end,
				{ description = "select previous", group = "layout" }	)

-- Tag navigation buttons elsewhere
utils.add_button( {}, 4, awful.tag.viewnext )
utils.add_button( {}, 5, awful.tag.viewprev )

-- Function to draw the wallpaper
local function wallpaper_maximized( s, wallpaper_mixed_types, wallpaper_path, ignore_aspect, offset )
	local wallpaper = ""
	local wallpaper_path = wallpaper_path or beautiful.theme_path
	local wallpaper_type = type( wallpaper_mixed_types )

	if		wallpaper_type == "string"		then wallpaper = wallpaper_mixed_types
	elseif	wallpaper_type == "table"		then wallpaper = wallpaper_mixed_types[ s.index ] or ""
	elseif	wallpaper_type == "function"	then wallpaper = wallpaper_mixed_types( s ) or ""
	end

	gears.wallpaper.maximized( wallpaper_path .. wallpaper, s, ignore_aspect, offset )
end

-- Reset wallpaper if a screen's geometry changes (e.g. different resolution)
screen.connect_signal( "property::geometry", function( s ) wallpaper_maximized( s, beautiful.wallpaper, beautiful.wallpaper_path ) end )

-- Screen builder
local function do_at_screen_connect( s )
	-- Draw the appropriate wallpaper
	wallpaper_maximized( s, beautiful.wallpaper, beautiful.theme_path .. "wallpapers/" )

	-- Create the tags and set the default layout
	awful.tag( beautiful.tagnames, s, awful.layout.layouts[ 1 ] )

	-- Create a promptbox for each screen
	s.promptbox = awful.widget.prompt()

	-- Create a widget which will contains an icon indicating which layout we're using
	s.layoutbox = awful.widget.layoutbox( s )
	s.layoutbox:buttons( gears.table.join(	awful.button( {}, 1, function () awful.layout.inc( 1 ) end ),
											awful.button( {}, 2, function () awful.layout.set( awful.layout.layouts[ 1 ] ) end ),
											awful.button( {}, 3, function () awful.layout.inc( -1 ) end ),
											awful.button( {}, 4, function () awful.layout.inc( 1 ) end ),
											awful.button( {}, 5, function () awful.layout.inc( -1 ) end )	) )

	-- Left part of wibar
	local wb_l	= {	layout = wibox.layout.fixed.horizontal														,
					beautiful.menu_widget																		,
					awful.widget.taglist( s, awful.widget.taglist.filter.all, beautiful.taglist_buttons )		,
					s.promptbox																					}

	-- Middle part of wibar
	local wb_m	=	awful.widget.tasklist( s, awful.widget.tasklist.filter.currenttags, beautiful.tasklist_buttons )

	-- Right part of wibar
	local wb_r	={	layout = wibox.layout.fixed.horizontal											,
					beautiful.MySystem.widget																	,
					beautiful.MyRAM.widget																	,
					beautiful.MyUpdates.widget																,
					beautiful.MyBackup.widget																	,
					beautiful.MyVolumeBar.widget																,
					beautiful.MyWeather.widget																,
					beautiful.MyClockCal.widget																,
					wibox.container.background( wibox.widget.textbox(" { "), beautiful.bg_focus )	,
					wibox.widget.systray()															,
					wibox.container.background( wibox.widget.textbox(" } "), beautiful.bg_focus )	,
					wibox.container.background( s.layoutbox, beautiful.bg_focus )					,
					wibox.container.background( wibox.widget.textbox(" "), beautiful.bg_focus )		}

	-- Create the system bar / tray [wibar]
	s.wibar = awful.wibar( { screen = s } )
	s.wibar:setup( { layout = wibox.layout.align.horizontal, wb_l, wb_m, wb_r } )
end

-- Create all screens with existing global actions (and add widgets from the theme)
awful.screen.connect_for_each_screen( function( s ) do_at_screen_connect( s ) end )
