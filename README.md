# TES3MP-npcReset
This script will log the time the player enters a cell, and then depending on the resetTime (default 1 hour of real time), run the console command 'RA'

# Installation
Save this file as npcReset.lua in the mp-stuff\scripts\ directory.<br />
These edits will be made in the same directory in the serverCore.lua file.

1) Add: `npcReset = require("npcReset")`<br />
under: `menuHelper = require("menuHelper")` ~line 13

2) Add: `npcReset.OnServerPostInit()`<br />
under: `ResetAdminCounter()` ~line 284

3) Add: `npcReset.OnCellLoad(pid, cellDescription)`<br />
under: `eventHandler.OnCellLoad(pid, cellDescription)` ~line 457

If you'd like to change the default 1 hour reset, you can edit the `local resetMinutes = 60` variable on line 19 of my script.

# Technical
After installing the script, when the server is started the json file will be created.

After the file is created when a player first moves to a cell, the cell and current time (in minutes since midnight, converted to UTC) are added to the json file. When the cell is later visited again, the time is checked. If the cell hasn't been visited in 1 hour (by default), the time is updated and the 'RA' console command is run.
