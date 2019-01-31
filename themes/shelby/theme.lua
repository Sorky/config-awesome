-- ----------
-- shelby.lua
-- ----------
-- Beautiful theme definition
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local gears = { shape = require( "gears.shape" ) }
--local utils = { get_random_file = require( "utils.get_random_file" ) }

-- Derived constants
local path_this = debug.getinfo( 1, "S" ).source:match( "/.*/" )

-- Theme variables to set/return
local me										= {}

-- User defined constants
me.c_modkey										= "Mod4"
me.c_altkey										= "Mod1"
me.c_editor										= "xfwrite"
me.c_browser									= "firefox"
me.c_terminal									= "xterm"

me.icon_path									= path_this .. "icons/"
me.config_path									= awesome.conffile:match(".*/")
me.wallpaper_path								= path_this .. "wallpapers/"
me.screenshot_path								= os.getenv( "HOME" ) .. "/Screenshots/"

-- https://awesomewm.org/doc/api/libraries/beautiful.html
me.font											= "Monospace Bold 12"
me.useless_gap									= 0
me.border_width									= 1
me.border_normal								= "#3F3F3F"
me.border_focus									= "#7F7F7F"
me.border_marked								= "#CC9393"
--me.wallpaper									= me.wallpaper_path .. "Shelby1.png"
me.wallpaper									= { "Shelby1.png", "Shelby2.png" }
--me.wallpaper									= function() get_random_file( me.wallpaper_path, "png, jpg" ) end
me.awesome_icon									= me.icon_path .. "awesome.png"

-- ??? https://awesomewm.org/doc/api/documentation/06-appearance.md.html
me.bg_normal									= "#1A1A1A"
me.fg_normal									= "#DDDDFF"
me.bg_focus										= "#777777"
me.fg_focus										= "#EA6F81"
me.bg_urgent									= "#1A1A1A"
me.fg_urgent									= "#CC9393"
--me.bg_minimize
--me.fg_minimize
--me.bg_systray

-- https://awesomewm.org/doc/api/libraries/awful.layout.html
me.layout_cornernw								= me.icon_path .. "cornernww.png"
me.layout_cornerne								= me.icon_path .. "cornernew.png"
me.layout_cornersw								= me.icon_path .. "cornersww.png"
me.layout_cornerse								= me.icon_path .. "cornersew.png"
me.layout_fairh									= me.icon_path .. "fairhw.png"
me.layout_fairv									= me.icon_path .. "fairvw.png"
me.layout_floating								= me.icon_path .. "floatingw.png"
me.layout_magnifier								= me.icon_path .. "magnifierw.png"
me.layout_max									= me.icon_path .. "maxw.png"
me.layout_fullscreen							= me.icon_path .. "fullscreenw.png"
me.layout_spiral								= me.icon_path .. "spiralw.png"
me.layout_dwindle								= me.icon_path .. "dwindlew.png"
me.layout_tile									= me.icon_path .. "tilew.png"
me.layout_tiletop								= me.icon_path .. "tiletopw.png"
me.layout_tilebottom							= me.icon_path .. "tilebottomw.png"
me.layout_tileleft								= me.icon_path .. "tileleftw.png"

-- https://awesomewm.org/doc/api/libraries/awful.menu.html
me.menu_submenu_icon							= me.icon_path .. "submenu.png"
me.menu_height									= 16
me.menu_width									= 200
--me.menu_border_color 							The menu item border color.
--me.menu_border_width 							The menu item border width.
--me.menu_fg_focus 								The default focused item foreground (text) color.
--me.menu_bg_focus 								The default focused item background color.
--me.menu_fg_normal 							The default foreground (text) color.
--me.menu_bg_normal 							The default background color.
--me.menu_submenu								The default sub-menu indicator if no menusubmenuicon is provided.

-- https://awesomewm.org/doc/api/libraries/naughty.html
--me.notification_font 							Notifications font.
--me.notification_bg 							Notifications background color.
--me.notification_fg 							Notifications foreground color.
--me.notification_border_width 					Notifications border width.
--me.notification_border_color					Notifications border color.
--me.notification_shape 						Notifications shape.
--me.notification_opacity 						Notifications opacity.
--me.notification_margin 						Notifications margin.
--me.notification_width 						Notifications width.
--me.notification_height 						Notifications height.

-- https://awesomewm.org/doc/api/classes/awful.widget.taglist.html
me.taglist_bg_focus 							= "#000000"
me.taglist_fg_focus 							= "#EEEE00"
me.taglist_bg_urgent 							= "#000000"
me.taglist_fg_urgent 							= "#EE0000"
me.taglist_bg_occupied 							= "#000000"
me.taglist_fg_occupied 							= "#EEEEEE"
me.taglist_bg_empty 							= "#000000"
me.taglist_fg_empty 							= "#999999"
me.taglist_bg_volatile 							= "#EE0000"
me.taglist_fg_volatile 							= "#FFFFFF"
me.taglist_squares_sel							= me.icon_path .. "square_sel.png"
me.taglist_squares_unsel						= me.icon_path .. "square_unsel.png"
--me.taglist_squares_sel_empty 					The selected empty elements background image.
--me.taglist_squares_unsel_empty 				The unselected empty elements background image.
--me.taglist_squares_resize 					If the background images can be resized.
--me.taglist_disable_icon 						Do not display the tag icons, even if they are set.
--me.taglist_font 								The taglist font.
me.taglist_spacing								= 1
--me.taglist_shape 								The main shape used for the elements.
--me.taglist_shape_border_width 				The shape elements border width.
--me.taglist_shape_border_color 				The elements shape border color.
--me.taglist_shape_empty 						The shape used for the empty elements.
--me.taglist_shape_border_width_empty 			The shape used for the empty elements border width.
--me.taglist_shape_border_color_empty 			The empty elements shape border color.
--me.taglist_shape_focus 						The shape used for the selected elements.
--me.taglist_shape_border_width_focus 			The shape used for the selected elements border width.
--me.taglist_shape_border_color_focus 			The selected elements shape border color.
--me.taglist_shape_urgent 						The shape used for the urgent elements.
--me.taglist_shape_border_width_urgent 			The shape used for the urgent elements border width.
--me.taglist_shape_border_color_urgent 			The urgents elements shape border color.
--me.taglist_shape_volatile 					The shape used for the volatile elements.
--me.taglist_shape_border_width_volatile 		The shape used for the volatile elements border width.
--me.taglist_shape_border_color_volatile 		The volatile elements shape border color.

-- https://awesomewm.org/doc/api/classes/awful.widget.tasklist.html
me.tasklist_fg_normal							= "#000000"
me.tasklist_bg_normal							= "#CCCCCC"
me.tasklist_fg_focus							= "#EEEEEE"
me.tasklist_bg_focus							= "#666666"
--me.tasklist_fg_urgent
--me.tasklist_bg_urgent
me.tasklist_fg_minimize							= "#CCCCCC"
me.tasklist_bg_minimize							= "#000000"
--me.tasklist_bg_image_normal
--me.tasklist_bg_image_focus
--me.tasklist_bg_image_urgent
--me.tasklist_bg_image_minimize
me.tasklist_disable_icon						= true
--me.tasklist_disable_task_name
me.tasklist_plain_task_name						= true
--me.tasklist_font
--me.tasklist_align
--me.tasklist_font_focus
--me.tasklist_font_minimized
--me.tasklist_font_urgent
me.tasklist_spacing								= 1
me.tasklist_shape								= gears.shape.octogon
me.tasklist_shape_border_width					= 3
me.tasklist_shape_border_color					= "#DDDDDD"
me.tasklist_shape_focus							= gears.shape.octogon -- gears.shape.partially_rounded_rect
me.tasklist_shape_border_width_focus			= 3
me.tasklist_shape_border_color_focus			= "#EEEE00"
--me.tasklist_shape_minimized
--me.tasklist_shape_border_width_minimized
--me.tasklist_shape_border_color_minimized
--me.tasklist_shape_urgent
--me.tasklist_shape_border_width_urgent
--me.tasklist_shape_border_color_urgent

-- https://awesomewm.org/doc/api/libraries/awful.titlebar.html
me.titlebar_bg_normal							= me.bg_normal
--me.titlebar_bgimage_normal
--me.titlebar_fg
--me.titlebar_bg
--me.titlebar_bgimage
me.titlebar_fg_focus							= "#EEEE00"
me.titlebar_bg_focus							= me.bg_focus
--me.titlebar_bgimage_focus
--me.titlebar_floating_button_normal
--me.titlebar_maximized_button_normal
--me.titlebar_minimize_button_normal
--me.titlebar_minimize_button_normal_hover
--me.titlebar_minimize_button_normal_press
--me.titlebar_close_button_normal
--me.titlebar_close_button_normal_hover
--me.titlebar_close_button_normal_press
--me.titlebar_ontop_button_normal
--me.titlebar_sticky_button_normal
--me.titlebar_floating_button_focus
--me.titlebar_maximized_button_focus
--me.titlebar_minimize_button_focus
--me.titlebar_minimize_button_focus_hover
--me.titlebar_minimize_button_focus_press
--me.titlebar_close_button_focus
--me.titlebar_close_button_focus_hover
--me.titlebar_close_button_focus_press
--me.titlebar_ontop_button_focus
--me.titlebar_sticky_button_focus
--me.titlebar_floating_button_normal_active
--me.titlebar_floating_button_normal_active_hover
--me.titlebar_floating_button_normal_active_press
--me.titlebar_maximized_button_normal_active
me.titlebar_close_button_focus					= me.icon_path .. "close_focus.png"
me.titlebar_close_button_normal					= me.icon_path .. "close_normal.png"
me.titlebar_ontop_button_focus_active			= me.icon_path .. "ontop_focus_active.png"
me.titlebar_ontop_button_normal_active			= me.icon_path .. "ontop_normal_active.png"
me.titlebar_ontop_button_focus_inactive			= me.icon_path .. "ontop_focus_inactive.png"
me.titlebar_ontop_button_normal_inactive		= me.icon_path .. "ontop_normal_inactive.png"
me.titlebar_sticky_button_focus_active			= me.icon_path .. "sticky_focus_active.png"
me.titlebar_sticky_button_normal_active			= me.icon_path .. "sticky_normal_active.png"
me.titlebar_sticky_button_focus_inactive		= me.icon_path .. "sticky_focus_inactive.png"
me.titlebar_sticky_button_normal_inactive		= me.icon_path .. "sticky_normal_inactive.png"
me.titlebar_floating_button_focus_active		= me.icon_path .. "floating_focus_active.png"
me.titlebar_floating_button_normal_active		= me.icon_path .. "floating_normal_active.png"
me.titlebar_floating_button_focus_inactive		= me.icon_path .. "floating_focus_inactive.png"
me.titlebar_floating_button_normal_inactive		= me.icon_path .. "floating_normal_inactive.png"
me.titlebar_maximized_button_focus_active		= me.icon_path .. "maximized_focus_active.png"
me.titlebar_maximized_button_normal_active		= me.icon_path .. "maximized_normal_active.png"
me.titlebar_maximized_button_focus_inactive		= me.icon_path .. "maximized_focus_inactive.png"
me.titlebar_maximized_button_normal_inactive	= me.icon_path .. "maximized_normal_inactive.png"
me.titlebar_minimize_button_normal				= me.icon_path .. "minimize_normal.png"
me.titlebar_minimize_button_focus				= me.icon_path .. "minimize_focus.png"

-- https://awesomewm.org/apidoc/libraries/awful.hotkeys_popup.widget.html
--me.hotkeys_bg = nil
--me.hotkeys_fg = nil
--me.hotkeys_border_width = nil
--me.hotkeys_border_color = nil
--me.hotkeys_shape = nil
me.hotkeys_modifiers_fg							= "#CCCC00"
--me.hotkeys_label_bg = nil
--me.hotkeys_label_fg = nil
me.hotkeys_font									= "Monospace Regular 10"
me.hotkeys_description_font						= "Monospace Regular 10"
me.hotkeys_group_margin							= 10

-- https://awesomewm.org/doc/api/classes/awful.tooltip.html
--me.tooltip_border_color 						The tooltip border color.
me.tooltip_bg									= "#DDDDFF"
me.tooltip_fg									= "#1A1A1A"
me.tooltip_font									= "Monospace Regular 10"
--me.tooltip_border_width 						The tooltip border width.
--me.tooltip_opacity 							The tooltip opacity.
--me.tooltip_shape 								The default tooltip shape.
--me.tooltip_align 								The default tooltip alignment.

-- https://awesomewm.org/doc/api/classes/awful.wibar.html
--me.wibar_stretch 								If the wibar needs to be stretched to fill the screen.
--me.wibar_border_width 						The wibar border width.
--me.wibar_border_color 						The wibar border color.
me.wibar_ontop									= false
--me.wibar_cursor 								The wibar's mouse cursor.
--me.wibar_opacity 								The wibar opacity, between 0 and 1.
--me.wibar_type 								The window type (desktop, normal, dock, …).
--me.wibar_width 								The wibar's width.
me.wibar_height									= 23
--me.wibar_bg 									The wibar's background color.
--me.wibar_bgimage 								The wibar's background image.
--me.wibar_fg 									The wibar's foreground (text) color.
--me.wibar_shape 								The wibar's shape.

-- Completion
return me

-- arcchart
--me.arcchart_border_color = nil
--me.arcchart_color = nil
--me.arcchart_border_width = nil
--me.arcchart_paddings = nil
--me.arcchart_thickness = nil

-- checkbox
--me.checkbox_border_width = nil
--me.checkbox_bg = nil
--me.checkbox_border_color = nil
--me.checkbox_check_border_color = nil
--me.checkbox_check_border_width = nil
--me.checkbox_check_color = nil
--me.checkbox_shape = nil
--me.checkbox_check_shape = nil
--me.checkbox_paddings = nil
--me.checkbox_color = nil

-- column
--me.column_count = nil

-- cursor
--me.cursor_mouse_resize = nil
--me.cursor_mouse_move = nil

-- enable
--me.enable_spawn_cursor = nil

-- fullscreen
--me.fullscreen_hide_border = nil

-- gap
--me.gap_single_client = nil

-- graph
--me.graph_bg = nil
--me.graph_fg = nil
--me.graph_border_color = nil

-- icon
--me.icon_theme = nil

-- master
--me.master_width_factor = nil
--me.master_fill_policy = nil
--me.master_count = nil

-- maximized
--me.maximized_honor_padding = nil

-- piechart
--me.piechart_border_color = nil
--me.piechart_border_width = nil
--me.piechart_colors = nil

-- progressbar
--me.progressbar_bg = nil
--me.progressbar_fg = nil
--me.progressbar_shape = nil
--me.progressbar_border_color = nil
--me.progressbar_border_width = nil
--me.progressbar_bar_shape = nil
--me.progressbar_bar_border_width = nil
--me.progressbar_bar_border_color = nil
--me.progressbar_margins = nil
--me.progressbar_paddings = nil

-- prompt
--me.prompt_fg = nil
--me.prompt_bg = nil
--me.prompt_fg_cursor = nil
--me.prompt_bg_cursor = nil
--me.prompt_font = nil

-- radialprogressbar
--me.radialprogressbar_border_color = nil
--me.radialprogressbar_color = nil
--me.radialprogressbar_border_width = nil
--me.radialprogressbar_paddings = nil

-- slider
--me.slider_bar_border_width = nil
--me.slider_bar_border_color = nil
--me.slider_handle_border_color = nil
--me.slider_handle_border_width = nil
--me.slider_handle_width = nil
--me.slider_handle_color = nil
--me.slider_handle_shape = nil
--me.slider_bar_shape = nil
--me.slider_bar_height = nil
--me.slider_bar_margins = nil
--me.slider_handle_margins = nil
--me.slider_bar_color = nil

-- snap
--me.snap_bg = nil
--me.snap_border_width = nil
--me.snap_shape = nil

-- systray
--me.systray_icon_spacing = nil
