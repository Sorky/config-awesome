-- --------
-- init.lua
-- --------
-- _pcall_fallback loader
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

local gears = { debug = require( "gears.debug" ) }

local code = nil
local state, err = pcall( function() code = dofile( debug.getinfo( 1, "S" ).source:match( "/.*/" ) .. "_pcall_fallback.lua" ) end )
if not state then gears.debug.print_error( "pcall_fallback loader: error: " .. tostring( err ) ) end

return code
