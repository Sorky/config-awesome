-- --------------------
-- _get_random_file.lua
-- --------------------
-- Given a directory of files, the function returns the name of a random file
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local lgi	= require( "lgi" )
local os	= { clock = os.clock }
local math	= { random = math.random			,
				randomseed = math.randomseed	}

-- Seed the random number generator the get randomness
math.randomseed( os.clock() % 1 * 1e6 )

-- The code
local function creator( path, extensions ) 
	local files_in_path = {}
	local valid_extensions = {}

	-- Transforms "jpg" or { "jpg", ... } into { ["jpg"] = 1, ... }
	if type( extensions ) == "string"	then extensions = { extensions } end
	if type( extensions ) == "table"	then for i, j in ipairs( extensions ) do valid_extensions[ j ] = i end end

	local file_list = lgi.Gio.File.new_for_path( path ):enumerate_children( "standard::name", 0 )

	for file in function() return file_list:next_file() end do
		local file_name = file:get_attribute_as_string( "standard::name" )

		if not extensions or valid_extensions[ file_name:lower():match( "%.(.*)$" ) ] then table.insert( files_in_path, file_name ) end
	end

	return #files_in_path > 0 and files_in_path[ math.random( #files_in_path ) ] or nil
end

return creator
