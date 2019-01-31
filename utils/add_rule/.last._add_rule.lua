-- -------------
-- _add_rule.lua
-- -------------
-- PROTOTYPE - Work in progress
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local awful	= {	rules	= require( "awful.rules" ) }
local gears	= {	table	= require( "gears.table" ) }

-- The code
local function creator( rule, except, properties, callback ) 
	awful.rules.rules = gears.table.join(	awful.rules.rules, {	rule = rule						,
																	except = except					,
																	callback = callback				,
																	properties = {	properties	}	}	)

end

return creator
