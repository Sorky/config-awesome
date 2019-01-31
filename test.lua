-- --------
-- test.lua
-- --------
-- Test lua and shell code without restarting				-- Called with: <mod> + t or from the menu
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Debug libraries
local inspect = require("utils.inspect")

-- Load libraries your code will need						-- Remember to make sure they are in your final code!

-- Derived constants

-- Tests
local t1 = { a = "b" }

print( "Test 1>", inspect( t1 ) )
