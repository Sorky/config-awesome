-- --------
-- test.lua
-- --------
-- Learning
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

local function private()
    return( "in private function" )
end

local function foo()
    return( "Hello World!" )
end

local function bar()
    x = private()
    y = foo()
	return x .. " : " .. y
end

return {  foo = foo,
		  bar = bar		}
