-- ---------
-- debug.lua
-- ---------
-- Debug info and error handling
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

print( "" )
print( "version \t=",		awesome.version		)
print( "release \t=",		awesome.release		)
print( "conffile\t=",		awesome.conffile	)
print( "themes_path\t=",	awesome.themes_path	)
print( "icon_path\t=",		awesome.icon_path	)
print( "" )

-- Required code libraries
local naughty	= require( "naughty" )

-- Error handling: Error during startup will fallback to the default fallback config
if awesome.startup_errors then
	naughty.notify( {	preset = naughty.config.presets.critical			,
						title = "Oops, there were errors during startup!"	,
						text = awesome.startup_errors						} )
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal(	"debug::error",
							function( err )
								if in_error then return end
								in_error = true
								naughty.notify( {	preset	= naughty.config.presets.critical	,
													title	= "Oops, an error happened!"		,
													text	= tostring( err )					} )
								in_error = false
							end )
end
