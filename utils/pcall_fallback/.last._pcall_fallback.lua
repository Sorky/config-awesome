-- -------------------
-- _pcall_fallback.lua
-- -------------------
-- Description
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
--local naughty = require( "naughty" )
local gears	= { debug = require( "gears.debug" ) }

-- The code
local function creator( path, file, fallback_path, fallback_file )
	local code = nil
	local fullname = ( path or "" ) .. file

	local state, err = pcall( function() code = dofile( fullname ) end )
	if not state then
--		local preset = naughty.config.presets.warn
--		local title = "Problem found in " .. fullname
--		local text = "\nError = " .. tostring( err ) .. "\n\n"

		-- Use the fallback (should be proven)
		fullname = ( fallback_path or path or "" ) .. ( fallback_file or ".last." .. file )
--		text = text .. "Using '" .. fullname .. "' instead"
		--naughty.notify( { preset = preset, title = title, text = text } )
		gears.debug.print_error( "pcall_fallback: error: " .. tostring( err ) )
		gears.debug.print_error( "pcall_fallback: trying: " .. tostring( fullname ) )

		state, err = pcall( function() code = dofile( fullname ) end )
		if not state then
--			preset = naughty.config.presets.critical
--			title = "Problem found in " .. fullname
--			text = "\nError = " .. tostring( err ) .. "\n\nNothing was done"

			--naughty.notify( { preset = preset, title = title, text = text } )
			gears.debug.print_error( "pcall_fallback: retry error: " .. tostring( err ) )
		end
		return state and code or nil
	end
	return code
end

return creator
