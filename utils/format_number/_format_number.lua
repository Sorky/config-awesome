-- ------------------
-- _format_number.lua
-- ------------------
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

-- The code
function creator( number )
	local left, num, right = string.match( number, "^([^%d]*%d)(%d*)(.-)$" )
	return left .. ( num:reverse():gsub( "(%d%d%d)", "%1," ):reverse() ) .. right
end

return creator
