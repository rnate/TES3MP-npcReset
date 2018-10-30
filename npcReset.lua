--[[NPC Reset 1.1 - Developed with tes3mp 0.7.0-alpha
This script will log the time the player enters a cell, and then depending on the resetTime, run the console command 'RA'

Installation
Save this file as npcReset.lua in the mp-stuff\scripts\ directory.
These edits will be made in the same directory in the serverCore.lua file.

1) Add: npcReset = require("npcReset")
under: menuHelper = require("menuHelper") ~line 13

2) Add: npcReset.OnServerPostInit()
under: ResetAdminCounter() ~line 284

3) Add: npcReset.OnCellLoad(pid, cellDescription)
under: eventHandler.OnCellLoad(pid, cellDescription) ~line 457
-------------------------------------------------------------------------]]

local jsonInterface = require("jsonInterface")
local resetMinutes = 60 --default of 60 minutes
local resetData = nil
--local whiteList = {"-2, -9", "Seyda Neen, Foryn Gilnith's Shack"} --remove the two dashes on the far left to uncomment this list. These will be the only cells that can be added to the reset list if you do this

local function SaveJSON(resetData)
	jsonInterface.save("npcReset.json", resetData)
end

local npcReset = {}

function npcReset.OnServerPostInit() --create the file if necessary
	local jsonFile = io.open(os.getenv("MOD_DIR") .. "/npcReset.json", "r")
	io.close()
	
	if jsonFile ~= nil then
		resetData = jsonInterface.load("npcReset.json")
	else
		resetData = {}
		SaveJSON(resetData)
	end
end

function npcReset.OnCellLoad(pid, cell)
	local whiteListCheck = true

	if whiteList ~= nil then
		whiteListCheck = false
		
		for _, value in pairs(whiteList) do
			if value == cell then
				whiteListCheck = true
				break
			end
		end
	end
	
	if whiteListCheck then
		if resetData == nil then
			resetData = {}
		end
		
		local timeMinutes = os.date("%I") * 60 + os.date("%M") --returns server time minutes since midnight
		
		if resetData[cell] == nil then
			resetData[cell] = {}
			resetData[cell]['minutes'] = timeMinutes
			
			SaveJSON(resetData)
		elseif timeMinutes - resetData[cell]['minutes'] >= resetMinutes then
			resetData[cell]['minutes'] = timeMinutes
			logicHandler.RunConsoleCommandOnPlayer(pid, "RA")
			
			SaveJSON(resetData)
		end
	end
end

return npcReset