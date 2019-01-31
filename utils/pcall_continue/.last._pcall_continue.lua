-- -------------------
-- _pcall_continue.lua
-- -------------------
-- Description
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local naughty = require( "naughty" )
local gears	= { debug = require( "gears.debug" ) }

-- The code
local function creator( path, file, fallback_path, fallback_file )
	local code = nil
	local fullname = ( path or "" ) .. file

	local state, err = pcall( function() code = dofile( fullname ) end )
	if not state then
		local preset = naughty.config.presets.critical
		local title = "Problem found in " .. fullname
		local text = "\nError = " .. tostring( err )

		naughty.notify( { preset = preset, title = title, text = text } )
		gears.debug.print_error( "pcall_continue: error: " .. tostring( err ) )
	end
	return code
end

return creator
