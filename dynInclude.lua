
--[[

===== DynInclude =====

Script to dynamically include libraries
libraries will auto download and install if they are not currently installed

Will try to load libaries from the following locations in this order:
1 - './lib'
2 - '/appdata/system/lib'
3 - '/system/lib'
4 - The BBS system

Dev's don't need to worry about telling their users to install libraries of bundling many files
they just need to include dynInclude.lua in their cart and dynInclude() it at the start of their main.lua

The cart must be a self installer that installs itself to '/appdata/system/lib/'

]]--


-- Wrap fetch in a co-routine
local function httpGet (url)
	local data = ""
	local c = cocreate(function()
	    data = fetch(url)
	end)

	while not (costatus(c) == "dead") do
		coresume(c)
	end

	return data
end

function dynInclude(name)

	local path = env().path
	if (path == "/")	 then path = "" end
	if (path == nil) then path = "/ram/cart" end	
	
	
	----- Look for library and include it if it exists -----

	--Check current directory (./) if dev shipped a custom lib with their cart
	if (fstat( path .. "/lib/" .. name .. ".lua" )) then
		include( path .. "/lib/" .. name .. ".lua" )
		return
	end
	
	--Check '/appdata/system/lib'
	if (fstat("/appdata/system/lib/" .. name .. ".lua" )) then
		include("/appdata/system/lib/" .. name .. ".lua" )
		return
	end
	
	--Check '/system/lib'
	if (fstat("/system/lib/" .. name .. ".lua" )) then
		include("/system/lib/" .. name .. ".lua" )
		return
	end
	

	----- All checks failed, need to download and install -----
	--Make tmp dir for downloads if it doesn't exist
	notify("Installing required lib: " .. name)
	if not (fstat("/tmp")) then
		mkdir("/tmp")
	end
	
	--Download cart
	local cart = httpGet("https://www.lexaloffle.com/bbs/get_cart.php?cat=8&lid=" .. name)		

	--save cart to temp location
	if (cart == "") then
		print("Error dynamically fetching " .. name .. " library, does it exist?")
		notify("Error dynamically fetching " .. name .. " library, does it exist?")
		exit(1)
	end
	store("/tmp/dynPng.p64.png",cart)
	mv("/tmp/dynPng.p64.png", "/tmp/dynCart")
	
	--Run installer, make sure it finishes before continuing
	create_process("/tmp/dynCart/main.lua")
	
	-- Wait until file is created
	i = 0
	while not (fstat("/appdata/system/lib/" .. name .. ".lua" )) do
		i = i + 1
		if (i == 100) then 
			print("Error: lib file creation timed out")
			notify("Error: lib file creation timed out")
			exit(1)
		end
		flip() -- Wait a cycle
	end
	
	-- Wait a little longer incase the installer does something weird after creating itself
	for i=1,5 do
		flip() -- wait a cycle
	end

	--Delete tmp cart folder
	rm("/tmp/dynCart")
	rm("/tmp/dynPng.p64.png")
	
	--Make sure lib installed correctly
	if not (fstat("/appdata/system/lib/" .. name .. ".lua")) then
		print("Error installing " .. name .. " library")
		notify("Error installing " .. name .. " library")
		exit(1)
	end
	
	print("/appdata/system/lib/" .. name .. ".lua")
	include("/appdata/system/lib/" .. name .. ".lua" )
	
end
