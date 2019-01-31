-- -----------
-- clients.lua
-- -----------
-- Each window is refered to as a client
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local lgi		= require( "lgi" )
local naughty	= require( "naughty" )
local beautiful	= require( "beautiful" )
local gears		= { table	= require( "gears.table" ) }
local utils		= { add_key	= require( "utils.add_key" ) }
local awful		= {	key			= require( "awful.key" )		,
					mouse		= require( "awful.mouse" )		,
					rules		= require( "awful.rules" )		,
					spawn		= require( "awful.spawn" )		,
					button		= require( "awful.button" )		,
					client		= require( "awful.client" )		,
					screen		= require( "awful.screen" )		,
					titlebar	= require( "awful.titlebar" )	,
					autofocus	= require( "awful.autofocus" )	,
					placement	= require( "awful.placement" )	}
local wibox		= { layout	= { flex	= require( "wibox.layout.flex" )	,
								align	= require( "wibox.layout.align" )	,
								fixed	= require( "wibox.layout.fixed" )	}	}

local string	= { format = string.format	}

-- Default client focus
utils.add_key(	{ beautiful.c_altkey, }, "j",
				function() awful.client.focus.byidx( 1 ) end,
				{ description = "focus next by index", group = "client" }	)
utils.add_key(	{ beautiful.c_altkey, }, "k",
				function() awful.client.focus.byidx( -1 ) end,
				{ description = "focus previous by index", group = "client" }	)

-- By direction client focus
utils.add_key(	{ beautiful.c_modkey }, "j",
				function()
					awful.client.focus.global_bydirection( "down" )
					if client.focus then client.focus:raise() end
				end,
				{ description = "focus down", group = "client" }	)
utils.add_key(	{ beautiful.c_modkey }, "k",
				function()
					awful.client.focus.global_bydirection( "up" )
					if client.focus then client.focus:raise() end
				end,
				{ description = "focus up", group = "client" }	)
utils.add_key(	{ beautiful.c_modkey }, "h",
				function()
					awful.client.focus.global_bydirection( "left" )
					if client.focus then client.focus:raise() end
				end,
				{ description = "focus left", group = "client" }	)
utils.add_key(	{ beautiful.c_modkey }, "l",
				function()
					awful.client.focus.global_bydirection( "right" )
					if client.focus then client.focus:raise() end
				end,
				{ description = "focus right", group = "client" }	)

-- Client swap
utils.add_key(	{ beautiful.c_modkey, "Shift" }, "j",
				function() awful.client.swap.byidx( 1 ) end,
				{ description = "swap with next client by index", group = "client" }	)
utils.add_key(	{ beautiful.c_modkey, "Shift" }, "k",
				function() awful.client.swap.byidx( -1 ) end,
				{ description = "swap with previous client by index", group = "client" }	)

-- Restore client
utils.add_key(	{ beautiful.c_modkey, "Control" }, "n",
				function()
					local c = awful.client.restore()
					-- Focus restored client
					if c then
						client.focus = c
						c:raise()
					end
				end,
				{ description = "restore minimized", group = "client" }	)

-- Show urgent client
utils.add_key(	{ beautiful.c_modkey }, "u",
				awful.client.urgent.jumpto,
				{ description = "jump to urgent client", group = "client" }	)

-- Show last client
utils.add_key(	{ beautiful.c_modkey }, "Tab",
				function()
					awful.client.focus.history.previous()
					if client.focus then client.focus:raise() end
				end,
				{ description = "go back", group = "client" }	)

-- Client keys
local clientkeys =	gears.table.join(
						-- Mine
						awful.key(	{ "Control", "Shift" }, "1", nil,
									function()	awful.spawn.with_shell( beautiful.autotyper_1 ) end,
									{ description = "Auto Typer - 1", group = "personal" }					),

						-- Change positions
						awful.key(	{ beautiful.c_modkey }, "o",
									function( c ) c:move_to_screen() end,
									{ description = "Swap screen", group = "client" }						),
						awful.key(	{ beautiful.c_modkey, "Control" }, "Return",
									function( c ) c:swap( awful.client.getmaster() ) end,
									{ description = "move to master", group = "client" }					),

						-- Change states
						awful.key(	{ beautiful.c_modkey, "Control" }, "space",
									awful.client.floating.toggle,
									{ description = "toggle floating", group = "client" }					),
						awful.key(	{ beautiful.c_modkey }, "t",
									function( c ) c.ontop = not c.ontop end,
									{ description = "toggle on top", group = "client" }						),
						awful.key(	{ beautiful.c_modkey }, "n",
									function( c ) c.minimized = true end,
									{ description = "minimize", group = "client" }							),
						awful.key(	{ beautiful.c_modkey }, "m",
									function (c)
										c.maximized = not c.maximized
										c:raise()
									end,
									{ description = "(un)maximize", group = "client" }						),
						awful.key(	{ beautiful.c_modkey }, "f",
									function (c)
										c.fullscreen = not c.fullscreen
										c:raise()
									end,
									{ description = "toggle fullscreen", group = "client" }					),

						-- Kill
						awful.key(	{ beautiful.c_modkey, beautiful.c_altkey }, "k",
									function( c ) c:kill() end,
									{ description = "Kill", group = "client" }								))

-- Client buttons
local clientbuttons =	gears.table.join(
							-- Select
							awful.button(	{}, 1,
											function( c )
												beautiful.c_signal_raise( c )
											end																),

							-- Move
							awful.button(	{ beautiful.c_modkey }, 1,
											function( c )
												beautiful.c_signal_raise( c )
												awful.mouse.client.move( c )
											end																),

							-- Resize
							awful.button(	{ beautiful.c_modkey }, 3,
											function( c )
												beautiful.c_signal_raise( c )
												awful.mouse.client.resize( c )
											end																))

-- Rules to apply to new clients
awful.rules.rules =	{	-- All clients will match this rule.
						{	rule = { },
							properties = {	border_width = beautiful.border_width,
											border_color = beautiful.border_normal,
											focus = awful.client.focus.filter,
											raise = true,
											keys = clientkeys,
											buttons = clientbuttons,
											screen = awful.screen.preferred,
											--size_hints_honor = false,
											placement =	awful.placement.no_overlap +
														awful.placement.no_offscreen	}		},

						-- Add titlebars to normal clients and dialogs
						{	rule_any = { type = {	"dialog",
													"normal"	}		},
							except = { name = "Guake!" },
							properties = {	titlebars_enabled = true }							},

						-- Put dialogs near the mouse and keep on top
						{	rule = { type = "dialog" },
							properties = {	floating = true,
											above = true },
							callback =	function(c)
											awful.placement.under_mouse( c )
											awful.placement.no_offscreen( c )
										end														},

						-- Put Firefox "Places" on top and centered
						{	rule = {	instance = "Places",
										class = "Firefox"				},
							properties = {	floating = true,
											above = true },
							callback = function(c) awful.placement.centered( c ) end			},

						-- Put Firefox "Browser" on top and centered
						{	rule = {	instance = "Browser",
										class = "Firefox"				},
							properties = {	floating = true,
											above = true },
							callback = function(c) awful.placement.centered( c ) end			},

						-- Remove Guake titlebar
						{	rule = { name = "Guake!" },
							properties = {	titlebars_enabled = false }							},

						-- Remove Remmina client titlebar
						{	rule = {	name = "david",
										class = "Remmina"				},
							properties = {	titlebars_enabled = false,
											fullscreen = true			}						},

						-- Stop xfe enter password prompt being covered
						{	rule = { class = "st-256color" },
							properties = {	above = true }										},		}

-- Place clients appropriately when a new client appears
client.connect_signal(
	"manage",
	-- Set the windows at the slave, i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end
	function( c )
		if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
			-- Prevent clients from being unreachable after screen count changes.
			awful.placement.no_offscreen(c)
		end
	end )

-- Add a titlebar with mouse buttons when a new client appears if set in the rules
client.connect_signal(
	"request::titlebars",
	function( c )
		local buttons = gears.table.join(	awful.button(	{}, 1,
															function()
																c:emit_signal( "request::activate", "titlebar", {raise = true} )
																awful.mouse.client.move( c )
															end																		),
											awful.button(	{}, 2,
															function()
																c:kill()
															end																		),
											awful.button(	{}, 3,
															function()
																c:emit_signal( "request::activate", "titlebar", {raise = true} )
																awful.mouse.client.resize( c )
															end																		)	)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
		awful.titlebar(	c, {size = 20} ):setup {	layout = wibox.layout.align.horizontal							,
													{	-- Left
														awful.titlebar.widget.iconwidget( c )	,
														buttons = buttons						,
														layout = wibox.layout.fixed.horizontal	}					,
													{	-- Middle = title
														{	align = "center"								,
															widget = awful.titlebar.widget.titlewidget( c )	}	,
														buttons = buttons										,
														layout = wibox.layout.flex.horizontal					}	,
													{	-- Right
														awful.titlebar.widget.floatingbutton( c )	,
														awful.titlebar.widget.maximizedbutton( c )	,
														awful.titlebar.widget.stickybutton( c )		,
														awful.titlebar.widget.ontopbutton( c )		,
														awful.titlebar.widget.closebutton( c )		,
														layout = wibox.layout.fixed.horizontal()	}				}
	end )

-- Enable focus that follows the mouse
client.connect_signal( "mouse::enter", function( c ) c:emit_signal( "request::activate", "mouse_enter", {raise = true} ) end )

--{{
-- Adjust client window border display
function border_adjust( c, test )
	-- Set test to get display details shown as clients come into focus [helpful for creating rules]
	if test then
		naughty.notify( {	preset = naughty.config.presets.critical,
							title = "Client detail...",
							text =	string.format(	"Client info...\n c:%s\n name:%s\n instance:%s\n type:%s\n class:%s",
													tostring(c), c.name, c.instance, c.type, c.class )	}	)
	end

	-- No border for maximized or orphan clients
	if c.maximized then
		c.border_width = 0
	elseif #awful.screen.focused().clients > 1 then
		c.border_width = beautiful.border_width
		c.border_color = beautiful.border_focus
	end
end

-- Add code to run on client event signals
client.connect_signal( "property::maximized", border_adjust )
--}}
--client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal( "focus", function( c ) border_adjust( c ) end )
client.connect_signal( "unfocus", function( c ) c.border_color = beautiful.border_normal end )

-- On changing tags, move the focus to the client under the mouse (awful.autofocus will use the last client if none under)
local pending = false
tag.connect_signal(	"property::selected",
	function()
		if not pending then
			pending = true
			lgi.GLib.idle_add( lgi.GLib.PRIORITY_DEFAULT_IDLE,
				function()
					local c = mouse.current_client -- mouse.object_under_pointer() --
					if c then client.focus = c end
					pending = false

					return false
				end									)
		end
	end	)
