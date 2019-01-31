-- -------------
-- _run_once.lua
-- -------------
-- Description
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local naughty	= require( "naughty" )
local awful		= { spawn = require( "awful.spawn" ) }
local string	= {	find = string.find		,
					format = string.format	}

-- This function makes sure an already running application is not restarted when awesome is [re]loaded
local function creator( command )
	local args_start = string.find( command, " " )
	local pgrep_name = args_start and command:sub( 0, args_start - 1 ) or command

	local command = "pgrep -u $USER -x " .. pgrep_name .. " > /dev/null || (" .. command .. ")"

	awful.spawn.easy_async_with_shell( command,
		function( stdout, stderr, exitreason, exitcode )
			if exitcode ~= 0 then
				naughty.notify({	preset	= naughty.config.presets.critical															,
									text	= string.format( "%s\n\n%s\n%s\n%s\n%s", command, stdout, stderr, exitreason, exitcode )	})
			end
		end )
end

return creator
