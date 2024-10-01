local Settings = {
	Catch = {
		onlyCatchWithUltra = true,
	},
	ServerHop = {
		updateServersAfterHops = 25,
		stayIfChestUnderT = 2,
	},
	Auto = {
		Potions = {use = true, upgrade = true},
		Fruits = {use = true},
	}
}

--[[
	to do server hop maybe simplier so it joins alts make it break chest and get huge that is from this chest dont server hop and try find one with luck
]]

local ScriptLog = "[Karwa's Auto Catch Huge]: "

local CurTime = os.time()

if not isfolder("KarwaCatch") then
	makefolder("KarwaCatch")
end
local FolderPath = "KarwaCatch/"

local TeleportService = game:GetService("TeleportService")
local Servers = {}
local RblxServerSite 
local maxPages = 2
local currentPage = 1
local nextPageCursor = ""
local PlaceIDTeleport = game.PlaceId
local PlaceID = game.PlaceId
local HttpService = game:GetService("HttpService")
if isfile(FolderPath.."NiggaScriptHopsAmmount.json") and HttpService:JSONDecode(readfile(FolderPath.."NiggaScriptHopsAmmount.json")) > Settings.ServerHop.updateServersAfterHops or not isfile(FolderPath.."NiggaScriptHopsAmmount.json") or not isfile(FolderPath.."NiggaScriptServers.json") then
	print(ScriptLog.."Getting servers from Roblox API (Page "..maxPages..")")
	local RestartedSV = pcall(function()
		if isfile(FolderPath.."NiggaScriptAntiSameServer.json") then
			writefile(FolderPath.."NiggaScriptAntiSameServer.json", HttpService:JSONEncode({}))
		end
	end)
	repeat
		local url = 'https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'
		if nextPageCursor ~= "" then
			url = url .. "&cursor=" .. nextPageCursor
		end

		local success, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(url))
		end)

		print(ScriptLog.."Getting "..currentPage.." Page")

		if not success then
			print(ScriptLog.."Failed to get page "..currentPage)
		end

		RblxServerSite = result

		if currentPage > 0 then
			if typeof(RblxServerSite.data) == "table" then
				for i, v in pairs(RblxServerSite.data) do
					table.insert(Servers, v)
				end
			end
		end


		nextPageCursor = RblxServerSite.nextPageCursor or ""
		currentPage += 1
	until nextPageCursor == "" or currentPage > maxPages
elseif isfile(FolderPath.."NiggaScriptServers.json") then
	local success = false

	while not success do
		success, Servers = pcall(function()
			return HttpService:JSONDecode(readfile(FolderPath.."NiggaScriptServers.json"))
		end)

		if success then
			print(ScriptLog.."Got servers from file saved in Workspace")
		else
			print(ScriptLog.."Failed to get servers from file, retrying")
			task.wait(1)
		end
	end
end

if Settings.ServerHop.updateServersAfterHops > 1 then
	for i = #Servers, 2, -1 do
		local j = math.random(i)
		Servers[i], Servers[j] = Servers[j], Servers[i]
	end
end

if isfile(FolderPath.."NiggaScriptHopsAmmount.json") then
	local hops = HttpService:JSONDecode(readfile(FolderPath.."NiggaScriptHopsAmmount.json"))

	if hops > Settings.ServerHop.updateServersAfterHops and #Servers > 99 then
		writefile(FolderPath.."NiggaScriptServers.json", HttpService:JSONEncode(Servers))
		writefile(FolderPath.."NiggaScriptHopsAmmount.json", HttpService:JSONEncode(0))
	end
else
	writefile(FolderPath.."NiggaScriptHopsAmmount.json", HttpService:JSONEncode(0))
end

repeat task.wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:connect(function()
	game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	task.wait(0.5)
	game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

repeat 
	local MainGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main")
	task.wait()
until MainGui.Enabled

local CountedHops = false

function ServerHop()
	local found = false
	local jobid 
	local playerplaying
	local ping
	local Filename = FolderPath.."NiggaScriptAntiSameServer.json"
	if not CountedHops then
		CountedHops = true
		if isfile(FolderPath.."NiggaScriptHopsAmmount.json") then
			local succces, kupa = pcall(function()
				local AmmountOfHops = HttpService:JSONDecode(readfile(FolderPath.."NiggaScriptHopsAmmount.json"))
				json = HttpService:JSONEncode(AmmountOfHops + 1)
				writefile(FolderPath.."NiggaScriptHopsAmmount.json", json)     
			end)
		end
	end
	if not isfile(Filename) then
		json = HttpService:JSONEncode({game.JobId})
		writefile(Filename, json)   
	end
	local BlacklistedServers
	local succces, returned = pcall(function()
		BlacklistedServers = HttpService:JSONDecode(readfile(Filename))
	end)
	local succes, shit = pcall(function()
		for i, v in ipairs(Servers) do
			jobid = v.id
			if v.playing and v.ping and not table.find(BlacklistedServers, v.id) then
				found = true
				local shittodelete = i
				jobid = v.id
				ping = v.ping
				local success, errorr = pcall(function()
					if not isfile(Filename) then
						json = HttpService:JSONEncode({jobid})
						writefile(Filename, json)   
					else
						CurrentBlacklisted = HttpService:JSONDecode(readfile(Filename))
						table.insert(CurrentBlacklisted, jobid)
						json = HttpService:JSONEncode(CurrentBlacklisted)
						writefile(Filename, json)   
					end
				end)
				table.remove(Servers, i)
				writefile(FolderPath.."NiggaScriptServers.json", HttpService:JSONEncode(Servers))
				print(ScriptLog.."Teleporting To "..jobid.." With "..ping.." Ping".." And "..v.playing.."/"..v.maxPlayers.." Players")
				TeleportService:TeleportToPlaceInstance(PlaceIDTeleport, jobid, LocalPlayer)
				task.wait(2)
			end
		end
	end)
end

local Lib = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local Lib_ = require(Lib)

local old 
old = hookmetamethod(game,"__namecall",(function(...) 
	local self,arg = ...
	if not checkcaller() then 
		if getnamecallmethod() == "FireServer" and tostring(self) == "__BLUNDER" or tostring(self) == "Idle Tracking: Update Timer" or tostring(self) == "Move Server" then return end
	end
	return old(...)
end))
game.ReplicatedStorage.Network["Idle Tracking: Stop Timer"]:FireServer()

local Client = {
	Network = require(Lib.Client.Network),
	EggCmds = require(Lib.Client.EggCmds),
	InstancingCmds = require(Lib.Client.InstancingCmds),
	HatchingCmds = require(Lib.Client.HatchingCmds),
	Save = require(Lib.Client.Save),
	WorldFX = require(Lib.Client.WorldFX),
	TypeRoamingPets = require(Lib.Types.RoamingPets)
}

local Directory = require(Lib.Directory)

local Pets = {}

local RoamingPets = getsenv(game.Players.LocalPlayer.PlayerScripts.Scripts.GUIs["Roaming Pets"])

function UpdatePets()
	Pets = {}
	while #Pets == 0 do 
		for i, v in pairs(getupvalues(RoamingPets.loadPets)[3]) do
			local pt = v.RoamingPet.Pet.pt and v.RoamingPet.Pet.pt or 0
			local sh = v.RoamingPet.Pet.sh and v.RoamingPet.Pet.sh or false
			local tbl = {RoamingId = i, id = v.RoamingPet.Pet.id, pt = pt, sh = sh, isHuge = v.CustomPet.parallelIn.petHuge}
			table.insert(Pets, tbl)
		end
		task.wait(1)
		if #Pets > 1 then break end
	end
	
end

function CatchPet(id, cubeType)
	local Cube = cubeType == 1 and "Pet Cube" or cubeType == 2 and "Ultra Pet Cube"
	return Client.Network.Invoke("RoamingPets_CatchPet", Cube, id)
end

function SendMessage(Webhook, data)
	local webhookcheck =
		is_sirhurt_closure and "Sirhurt" or pebc_execute and "ProtoSmasher" or syn and "Synapse X" or
		secure_load and "Sentinel" or
		KRNL_LOADED and "Krnl" or
		SONA_LOADED and "Sona" or
		"Kid with shit exploit"

	local url =
		Webhook
	local newdata = game:GetService("HttpService"):JSONEncode(data)

	local headers = {
		["content-type"] = "application/json"
	}
	request = http_request or request or HttpPost or syn.request
	local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
	request(abcdef)
end

function GetHugesToCatch()
	UpdatePets()
	local found = false
	local tbl = {}
	for i, v in pairs(Pets) do
		print(v.id, v.pt, v.sh, v.isHuge)
		if v.isHuge then
			found = true
			table.insert(tbl, v)
		end
	end

	return tbl, found
end

spawn(function()
	while task.wait(1) do
		local a, b = GetHugesToCatch()
		if b then
			local petid = a.id
			local tbl1 = game:GetService("HttpService"):JSONEncode(getupvalues(RoamingPets.loadPets)[3][petid])
			local data = {
				content = nil,
				embeds = { {
					title = "tbl1:",
					description = tbl1,
					color = nil
				}, {
					title = "tbl2:",
					description = tbl1,
					color = nil,
					footer = {
						text = game.JobId
					}
				} },
				attachments = { }
			}
			SendMessage("https://discord.com/api/webhooks/1123611155303235604/he0sQyBFyGfMx5YIYYKVvNqYNMyWqIdvb7pkmUZ6slxrR1B4DXusPwUo0S42GjnCjHDj", data)
		end	
	end
end)

function GetHugeNumbers()
	local a = 0
	for i, v in pairs(Client.Save.Get().Inventory.Pet) do
		if string.find(v.id, "Huge") then
			a = a + 1
		end
	end
	return a
end

function toNegative(number)
	if number > 0 then
		return -number
	else
		return number
	end
end

function formatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60

	return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

function formatNumber(number)
	if number >= 1e12 then
		return string.format("%.2fT", number / 1e12)
	elseif number >= 1e9 then
		return string.format("%.2fB", number / 1e9)
	elseif number >= 1e6 then
		return string.format("%.2fM", number / 1e6)
	elseif number >= 1e3 then
		return string.format("%.2fK", number / 1e3)
	else
		return tostring(number)
	end
end

function GetAmountOfItem(id)
	local Am = 0
	for i, v in pairs(Client.Save.Get().Inventory.Misc) do
		if v.id == id then
			if v._am then 
				Am = v._am 
			end
		end
	end
	return Am
end

function GetAmountOfLootbox(id)
	local Am = 0
	for i, v in pairs(Client.Save.Get().Inventory.Lootbox) do
		if v.id == id then
			if v._am then 
				Am = v._am 
			end
		end
	end
	return Am
end


local G2L = {};

-- StarterGui.pokemonshit
G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
G2L["1"]["IgnoreGuiInset"] = true;
G2L["1"]["Name"] = [[pokemonshit]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

-- StarterGui.pokemonshit.Frame
G2L["2"] = Instance.new("Frame", G2L["1"]);
G2L["2"]["ZIndex"] = 10;
G2L["2"]["BorderSizePixel"] = 0;
G2L["2"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);

-- StarterGui.pokemonshit.Frame.Name
G2L["3"] = Instance.new("TextLabel", G2L["2"]);
G2L["3"]["TextWrapped"] = true;
G2L["3"]["BorderSizePixel"] = 0;
G2L["3"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
G2L["3"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
G2L["3"]["TextSize"] = 45;
G2L["3"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["3"]["Size"] = UDim2.new(0, 200, 0, 50);
G2L["3"]["BorderColor3"] = Color3.fromRGB(221, 95, 255);
G2L["3"]["Text"] = game.Players.LocalPlayer.Name;
G2L["3"]["Name"] = [[Name]];
G2L["3"]["Font"] = Enum.Font.FredokaOne;
G2L["3"]["BackgroundTransparency"] = 1;
G2L["3"]["Position"] = UDim2.new(0.5, toNegative(G2L["3"].AbsoluteSize.X/2), 0.1, 0);

-- StarterGui.pokemonshit.Frame.ElementalGift
G2L["4"] = Instance.new("TextLabel", G2L["2"]);
G2L["4"]["TextWrapped"] = true;
G2L["4"]["BorderSizePixel"] = 0;
G2L["4"]["RichText"] = true;
G2L["4"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["4"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
G2L["4"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
G2L["4"]["TextSize"] = 45;
G2L["4"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["4"]["AutomaticSize"] = Enum.AutomaticSize.X;
G2L["4"]["Size"] = UDim2.new(0, 0, 0, 50);
G2L["4"]["ClipsDescendants"] = true;
G2L["4"]["BorderColor3"] = Color3.fromRGB(221, 95, 255);
G2L["4"]["Text"] = [[Elemental Gifts: <font color="rgb(232,69,229)">123</font>]];
G2L["4"]["Name"] = [[ElementalGift]];
G2L["4"]["Font"] = Enum.Font.FredokaOne;
G2L["4"]["BackgroundTransparency"] = 1;
G2L["4"]["Position"] = UDim2.new(0.5, toNegative(G2L["4"].AbsoluteSize.X/2), 0.1, 150);

-- StarterGui.pokemonshit.Frame.Time
G2L["5"] = Instance.new("TextLabel", G2L["2"]);
G2L["5"]["TextWrapped"] = true;
G2L["5"]["BorderSizePixel"] = 0;
G2L["5"]["RichText"] = true;
G2L["5"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["5"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5"]["TextSize"] = 45;
G2L["5"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5"]["AutomaticSize"] = Enum.AutomaticSize.X;
G2L["5"]["Size"] = UDim2.new(0, 0, 0, 50);
G2L["5"]["ClipsDescendants"] = true;
G2L["5"]["BorderColor3"] = Color3.fromRGB(221, 95, 255);
G2L["5"]["Text"] = [[Time: <font color="rgb(232,69,229)">12:34:56</font>]];
G2L["5"]["Name"] = [[Time]];
G2L["5"]["Font"] = Enum.Font.FredokaOne;
G2L["5"]["BackgroundTransparency"] = 1;
G2L["5"]["Position"] = UDim2.new(0.5, toNegative(G2L["5"].AbsoluteSize.X/2), 0.1, 50);

-- StarterGui.pokemonshit.Frame.Huges
G2L["6"] = Instance.new("TextLabel", G2L["2"]);
G2L["6"]["TextWrapped"] = true;
G2L["6"]["BorderSizePixel"] = 0;
G2L["6"]["RichText"] = true;
G2L["6"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["6"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
G2L["6"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
G2L["6"]["TextSize"] = 45;
G2L["6"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["6"]["AutomaticSize"] = Enum.AutomaticSize.X;
G2L["6"]["Size"] = UDim2.new(0, 0, 0, 50);
G2L["6"]["ClipsDescendants"] = true;
G2L["6"]["BorderColor3"] = Color3.fromRGB(221, 95, 255);
G2L["6"]["Text"] = [[Huges: <font color="rgb(232,69,229)">123</font>]];
G2L["6"]["Name"] = [[Huges]];
G2L["6"]["Font"] = Enum.Font.FredokaOne;
G2L["6"]["BackgroundTransparency"] = 1;
G2L["6"]["Position"] = UDim2.new(0.5, toNegative(G2L["6"].AbsoluteSize.X/2), 0.1, 100);

-- StarterGui.pokemonshit.Frame.Cubes
G2L["7"] = Instance.new("TextLabel", G2L["2"]);
G2L["7"]["TextWrapped"] = true;
G2L["7"]["BorderSizePixel"] = 0;
G2L["7"]["RichText"] = true;
G2L["7"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["7"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
G2L["7"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
G2L["7"]["TextSize"] = 45;
G2L["7"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["7"]["AutomaticSize"] = Enum.AutomaticSize.X;
G2L["7"]["Size"] = UDim2.new(0, 0, 0, 50);
G2L["7"]["ClipsDescendants"] = true;
G2L["7"]["BorderColor3"] = Color3.fromRGB(221, 95, 255);
G2L["7"]["Text"] = [[Cubes: <font color="rgb(232,69,229)">1 | 100</font>]];
G2L["7"]["Name"] = [[Cubes]];
G2L["7"]["Font"] = Enum.Font.FredokaOne;
G2L["7"]["BackgroundTransparency"] = 1;
G2L["7"]["Position"] = UDim2.new(0.5, toNegative(G2L["7"].AbsoluteSize.X/2), 0.1, 200);


spawn(function()
	while task.wait(0.1) do
		local ElementalGifts = tostring(formatNumber(GetAmountOfLootbox("Elemental Gift")))
		local Time = formatTime(os.time() - CurTime)
		local Huges = tostring(GetHugeNumbers())
		local CubesUltra = tostring(formatNumber(GetAmountOfItem("Ultra Pet Cube")))
		local CubesNormal = tostring(formatNumber(GetAmountOfItem("Pet Cube")))
		G2L["4"]["Text"] = [[Elemental Gifts: <font color="rgb(232,69,229)">]]..ElementalGifts..[[</font>]];
		G2L["5"]["Text"] = [[Time: <font color="rgb(232,69,229)">]]..Time..[[</font>]];
		G2L["6"]["Text"] = [[Huges: <font color="rgb(232,69,229)">]]..Huges..[[</font>]];
		G2L["7"]["Text"] = [[Cubes: <font color="rgb(232,69,229)">]]..CubesUltra..[[ | ]]..CubesNormal..[[</font>]];
	end
end)

return G2L["1"], require;
