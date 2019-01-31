-- ------------
-- _add_key.lua
-- ------------
-- Description
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local lgi	= require( "lgi" )
local awful	= {	key		= require( "awful.key" ) }
local gears	= {	table	= require( "gears.table" ) }

local root = { keys = root.keys }

-- The code
local function creator( mod, key, press, release, data ) 
	lgi.GLib.idle_add(	lgi.GLib.PRIORITY_DEFAULT_IDLE,
						function()
							if key ~= "" then
								root.keys( gears.table.join( root.keys(), awful.key( mod, key, press, release, data ) ) )
							end
							return false
						end )
end

return creator
