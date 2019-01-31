-- ------
-- rc.lua
-- ------
-- AwesomeWM setup/configuration shell
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local utils		= { pcall_fallback	= require( "utils.pcall_fallback" ) }

-- Derived constants
local config_path = awesome.conffile:match(".*/")

-- Allow library overrides
package.path = config_path .. "_overrides/?.lua;" .. config_path .. "_overrides/?/init.lua;" .. package.path:match("/usr.*")
print( "Overrides added: ", package.path )

-- Error handling
utils.pcall_fallback( config_path, "debug.lua" )

-- Start applications at startup
utils.pcall_fallback( config_path, "startup.lua" )

-- Configure the theme and other defaults
utils.pcall_fallback( config_path, "config.lua" )

-- System keys
utils.pcall_fallback( config_path, "keys.lua" )

-- System menu
utils.pcall_fallback( config_path, "menu.lua" )

-- Screen layout
utils.pcall_fallback( config_path, "screens.lua" )

-- Client behaviours
utils.pcall_fallback( config_path, "clients.lua" )
