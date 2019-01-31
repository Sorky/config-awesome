-- --------
-- init.lua
-- --------
-- _format_number loader
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

local utils = { pcall_fallback = require( "utils.pcall_fallback" ) }

return utils.pcall_fallback( debug.getinfo( 1, "S" ).source:match( "/.*/" ), "_format_number.lua" )
