--[[NPC Reset 1.0 - Developed with tes3mp 0.7.0-alpha
This script will log the time the player enters a cell, and then depending on the resetTime, run the console command 'RA'

Installation
Save this file as npcReset.lua in the mp-stuff\scripts\ directory.
These edits will be made in the same directory in the eventHandler.lua file.

1) Add: npcReset = require("npcReset")
under: commandHandler = require("commandHandler") ~line 3

2) Add: npcReset.OnPlayerConnect()
under: tes3mp.StartTimer(Players[pid].loginTimerId) ~line 49

3) Add: npcReset.OnPlayerCellChange(pid)
under: local previousCellDescription = Players[pid].data.location.cell ~line 270
-------------------------------------------------------------------------]]

local jsonInterface = require("jsonInterface")
local resetMinutes = 60 --default of 60 minutes
--local whiteList = {"-2, -9", "Seyda Neen, Foryn Gilnith's Shack"} --remove the two dashes on the far left to uncomment this list. These will be the only cells that can be added to the reset list if you do this

local function SaveJSON(resetData)
	jsonInterface.save("npcReset.json", resetData)
end

local function LoadJSON()
	resetData = jsonInterface.load("npcReset.json")
end

local npcReset = {}

function npcReset.OnPlayerConnect() --create the file if necessary
	local jsonFile = io.open(os.getenv("MOD_DIR") .. "/npcReset.json", "r")
	io.close()
	
	if jsonFile ~= nil then
		LoadJSON()
	else
		local resetData = {}
		SaveJSON(resetData)
	end
end

function npcReset.OnPlayerCellChange(pid)
	local whiteListCheck = true
	
	cell = tes3mp.GetCell(pid)
	
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
		LoadJSON()
		
		if resetData == nil then
			resetData = {}
		end
		
		local timeMinutes = os.date("!%I") * 60 + os.date("!%M") --returns the UTC time minutes since midnight
		
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