-- --------
-- init.lua
-- --------
-- Include all my widgets
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

return {	backup_power	= require( "widgets.backup_power" )		,
			clock_calendar	= require( "widgets.clock_calendar" )	,
			ram				= require( "widgets.ram" )				,
			system			= require( "widgets.system" )			,
			updates			= require( "widgets.updates" )			,
			volume_bar		= require( "widgets.volume_bar" )		,
			weather			= require( "widgets.weather" )			}
