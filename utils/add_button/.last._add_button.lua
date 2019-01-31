-- ---------------
-- _add_button.lua
-- ---------------
-- Description
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local lgi	= require( "lgi" )
local awful	= {	button	= require( "awful.button" ) }
local gears	= {	table	= require( "gears.table" ) }

local root = { buttons = root.buttons }

-- The code
local function creator( mod, button, press, release ) 
	lgi.GLib.idle_add(	lgi.GLib.PRIORITY_DEFAULT_IDLE,
						function()
							if button ~= "" then
								root.buttons( gears.table.join( root.buttons(), awful.button( mod, button, press, release ) ) )
							end
							return false
						end )
end

return creator
