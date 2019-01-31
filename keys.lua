-- --------
-- keys.lua
-- --------
-- Assign keyboard shortcuts
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local beautiful	= require( "beautiful" )
local awful		= {	util			= require( "awful.util" )	,
					spawn			= require( "awful.spawn" )	}
local utils		= { add_key			= require( "utils.add_key" ) 		,
					screenshot		= require( "utils.screenshot" ) 		,
					pcall_continue	= require( "utils.pcall_continue" ) }

local os		= { date = os.date	}
local root 		= { keys = root.keys }

-- System ( restart & quit )
utils.add_key(	{ beautiful.c_modkey, "Control" }, "r", awful.util.restart,		-- awesome.restart
				{ description = "reload awesome", group = "awesome" }	)
utils.add_key(	{ beautiful.c_modkey, "Shift" }, "q", awesome.quit,
				{ description = "quit awesome", group = "awesome" }	)

-- Clipboard gtk copy (terminals to gtk / gtk to terminals )
utils.add_key(	{ beautiful.c_modkey }, "c", function() awful.spawn( "xsel | xsel -i -b" ) end,
				{ description = "copy terminal to gtk", group = "hotkeys" }	)
utils.add_key(	{ beautiful.c_modkey }, "v", function() awful.spawn( "xsel -b | xsel" ) end,
				{ description = "copy gtk to terminal", group = "hotkeys" }	)

-- Take a screenshot
utils.add_key(	{}, "Print", function() utils.screenshot( true ) end,
				{ description = "Current mouse screen screenshot", group = "hotkeys" }	)
utils.add_key(	{ beautiful.c_modkey }, "Print", function() utils.screenshot() end,
				{ description = "Desktop screenshot ", group = "hotkeys" }	)
utils.add_key(	{ beautiful.c_altkey }, "p", function() utils.screenshot( true ) end,
				{ description = "Current mouse screen screenshot", group = "hotkeys" }	)
utils.add_key(	{ beautiful.c_modkey, beautiful.c_altkey }, "p", function() utils.screenshot() end,
				{ description = "Desktop screenshot ", group = "hotkeys" }	)

-- User programs
utils.add_key(	{ beautiful.c_modkey }, "q",
				function() awful.spawn( beautiful.c_browser ) end,
				{ description = "run browser", group = "launcher" }	)
utils.add_key(	{ beautiful.c_modkey }, "a",
				function() awful.spawn( beautiful.c_editor ) end,
				{ description = "run gui editor", group = "launcher" }	)
utils.add_key(	{ beautiful.c_modkey }, "z",
				function() awful.spawn( beautiful.c_terminal ) end,
				{ description = "open a terminal", group = "launcher" }	)
utils.add_key(	{ beautiful.c_modkey }, "Return",
				function() awful.spawn( beautiful.c_terminal ) end,
				{ description = "open a terminal", group = "launcher" }	)

-- Run test.lua
utils.add_key(	{ beautiful.c_modkey }, "t", function() utils.pcall_continue( beautiful.config_path, "test.lua" ) end,
				{ description = "run test.lua", group = "launcher" }	)

-- Special - Disable/Enable all keys using: <mod> + d / <mod> + e
local saved_keys = {}
utils.add_key(	{ beautiful.c_modkey }, "d",
				function()
					saved_keys = root.keys()
					root.keys( {} )
					utils.add_key(	{ beautiful.c_modkey }, "e",
									function() root.keys( saved_keys ) end,
									{ description = "return all global keys", group = "special" } )
				end,
				{ description = "repkace all global keys with only a restore function (mod-e)", group = "special" } )
