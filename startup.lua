-- -----------
-- startup.lua
-- -----------
-- Start applications that should always be running (particularly windowless ones)
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local naughty = require( "naughty" )
local utils = { run_once = require( "utils.run_once" ) }

-- Start these if not already running
utils.run_once( "guake &> /dev/null" )
utils.run_once( "remmina -i &> /dev/null" )
utils.run_once( "skypeforlinux" )

--[[
--	naughty.config.defaults				
--	-----------------------				
--	timeout			= 5
--	text			= ""
--	screen			= nil
--	ontop			= true
--	margin			= dpi( 5 )
--	border_width	= dpi( 1 )
--	position		= "top_right"
--]]

-- Modify notification defaults
naughty.config.defaults.timeout = 0

--[[
--	naughty.config.presets
--	-----------------------
--	low			= { timeout = 5 }
--	normal		= {}
--	critical	= {	bg = "#ff0000", fg = "#ffffff", timeout = 0 }
--	ok			= { bg = "#00bb00", fg = "#ffffff", timeout = 5 }
--	info		= { bg = "#0000ff", fg = "#ffffff", timeout = 5 }
--	warn		= { bg = "#ffaa00", fg = "#000000", timeout = 10 }
--]]

-- Modify notification defaults
naughty.config.presets.low.timeout = 0
naughty.config.presets.normal = { bg = "#00bb00", fg = "#ffffff", timeout = 0 }
naughty.config.presets.ok.timeout = 0
naughty.config.presets.info.timeout = 0
naughty.config.presets.warn.timeout = 0
