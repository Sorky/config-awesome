-- --------
-- menu.lua
-- --------
-- Menu
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local beautiful		= require( "beautiful" )
local debian 		= { menu	= require( "debian.menu" )			}
local menubar		= { utils	= require( "menubar.utils" )		}
local freedesktop	= { menu	= require( "freedesktop.menu" )		}
local utils			= { add_key			= require( "utils.add_key" ) 		,
						add_button		= require( "utils.add_button" ) 	}
local awful			= {	util			= require( "awful.util" )			,
						screen			= require( "awful.screen" )			,
						hotkeys_popup	= require( "awful.hotkeys_popup" )	}	

-- Sub-menu (awesome-default)
local default =	{	{ "hotkeys",			function() awful.hotkeys_popup.show_help( nil, awful.screen.focused() ) end	},
					{ "manual",				beautiful.c_terminal .. " -e man awesome"									},
					{ "edit config",		beautiful.c_editor .. " " .. awesome.conffile								},
					{ "restart (safe)",		awful.util.restart															}, -- NOT NORMALLY IN THE DEFAULT
					{ "restart (forced)",	awesome.restart																},
					{ "quit",				function() awesome.quit() end												}}

-- Sub-menu (awesome-testing)
local testing =	{	{ "Xephyr",				"Xephyr -ac -screen 1280x1024 :10"			},
					{ "Xephyr dual",		"Xephyr -screen 640x480 -screen 640x480 +xinerama :10"			},
					{ "Terminal",			beautiful.c_terminal .. " -e cd /_testing"								}}

-- Sub-menu (mine)
local mine =	{	{ "Testing",			testing																	},
					{ "Web browser",		beautiful.c_browser,		menubar.utils.lookup_icon( "firefox" )			},
					{ "Virtualbox",			"virtualbox",			menubar.utils.lookup_icon( "virtualbox" )		},
					{ "Kaffeine",			"kaffeine",				menubar.utils.lookup_icon( "kaffeine" )			},
					{ "MythTV Client",		"mythfrontend",			menubar.utils.lookup_icon( "mythtv" )			},
					{ "MythTV Server",		"mythtv-setup",			menubar.utils.lookup_icon( "mythtv" )			},
					{ "File explorer",		"xfe",					menubar.utils.lookup_icon( "xfe" )				},
					{ "File explorer (SU)",	"sudo -H -u root xfe",	menubar.utils.lookup_icon( "xfe" )				},
					{ "Drives (SU)",		"sudo gnome-disks",		menubar.utils.lookup_icon( "gnome-disks" )		},
					{ "Terminal",			beautiful.c_terminal,	menubar.utils.lookup_icon( "xterm-color" )		}}

-- The main menu
freedesktop.menu.build( {	icon_size	= beautiful.menu_height or 16									,
							before		= { { "Awesome",	default, beautiful.awesome_icon 	}	,
											{ "Debian",		debian.menu.menu.Debian_menu.Debian	}	}	,
							sub_menu	= "Freedesktop"													,
							after		= mine															} )

-- Menu access key
utils.add_key(	{ beautiful.c_modkey }, "w", function() freedesktop.menu.menu:show() end,
				{ description = "show main menu", group = "awesome" }	)

-- Mouse clicks
utils.add_button( {}, 3, function() freedesktop.menu.menu:toggle() end )

-- Hotkey info. access key
utils.add_key(	{ beautiful.c_modkey }, "s", awful.hotkeys_popup.show_help,
				{ description = "show hotkeys", group= "awesome" }	)
