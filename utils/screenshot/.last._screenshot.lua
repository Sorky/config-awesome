-- ---------------
-- _screenshot.lua
-- ---------------
-- Screenshot function (needs apt: import)
--
-- https://github.com/Sorky/config-awesome
--
-- (c) GNU General Public License v3.0
--

-- Required code libraries
local beautiful	= require( "beautiful" )
local awful		= {	spawn	= require( "awful.spawn" )	,
					screen	= require( "awful.screen" )	}

-- Screenshot function (needs apt: import)
local function creator( mouse_screen )
	local filename = os.date( "%Y-%m-%d %H:%M:%S" ) .. ".png"
	local command = "import -silent -window root "

	if mouse_screen then
		local screen = tostring( awful.screen.focused().index )
		filename = "HDMI_" .. screen .. " " .. filename
		command = command .. "-crop 1920x1080" .. (screen == "1" and "+1920+0 " or "+0+0 ")
	else
		filename = "SYSTEM " .. filename
	end

	awful.spawn( command .. "'" .. beautiful.screenshot_path .. filename .. "'" )
end

return creator
