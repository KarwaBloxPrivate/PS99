local Settings = {
	Run = true,
	PreventShittyGifts = {
		bool = true,
		IgnoreGiftBags = true
	},
	Webhook = {
		Tgl = true,
		url = "https://discord.com/api/webhooks/1221519634226745484/nwQLNn-Xs4r1uDRWxMfFBqOPZTxsrJofABrApPzJ4jeJro-SNjqO7YfUD1p5Fy1aiqb0",
		SendStats = {
			Tgl = true,
			url = "",
			Every = 60*10 -- send stats every amount of time (in seconds)	
		}
	},
	AmmountOfHopsToUpdateServers = 25,
	Optimization = {
		FpsCap = 60,
		Disable3dRendering = false,
		FpsBoost = false,
		CheckForCoinsDelay = 0.1
	},
	Mailbox = {
		Send = true,
		Usernames = {"maciekstock99"}, --you can have multiple storage accs in case some of them gets banned script will randomly pick out of these
		Messages = {"Thanks bro", "thx", "yoo", "gl man", "your doing crazy bro", "thats fire", "aha", "ok", "word", "thats a message", "okay", "lol", "xdd", "lmao"},
		SendAtRap = 30000000
	}
}

if not Settings.Run then return end

local StartTimeJoin = os.time()

local ScriptLog = "[Karwa's Auto Pop Balloon]: "

if not isfolder("KarwaBalloon") then
	makefolder("KarwaBalloon")
end
local FolderPath = "KarwaBalloon/"

local TeleportService = game:GetService("TeleportService")
local Servers = {}
local RblxServerSite 
local maxPages = 6
local currentPage = 1
local nextPageCursor = ""
local PlaceIDTeleport = game.PlaceId
local PlaceID = game.PlaceId
local HttpService = game:GetService("HttpService")
getgenv().GettingServers = false

if isfile(FolderPath.."NiggaScriptHopsAmmount.json") and HttpService:JSONDecode(readfile(FolderPath.."NiggaScriptHopsAmmount.json")) > Settings.AmmountOfHopsToUpdateServers or not isfile(FolderPath.."NiggaScriptHopsAmmount.json") or not isfile(FolderPath.."NiggaScriptServers.json") then
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

		getgenv().GettingServers = true
		print(ScriptLog.."Getting "..currentPage.." Page")

		if not success then
			print(ScriptLog.."Failed to get page "..currentPage)
			break
		end

		RblxServerSite = result

		if currentPage > 1 then
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
else
	if isfile(FolderPath.."NiggaScriptServers.json") then delfile(FolderPath.."NiggaScriptServers.json") end
	if isfile(FolderPath.."NiggaScriptHopsAmmount.json") then delfile(FolderPath.."NiggaScriptHopsAmmount.json") end
	if isfile(FolderPath.."NiggaScriptAntiSameServer.json") then delfile(FolderPath.."NiggaScriptAntiSameServer.json") end
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

		getgenv().GettingServers = true
		print(ScriptLog.."Getting "..currentPage.." Page")

		if not success then
			print(ScriptLog.."Failed to get page "..currentPage)
			break
		end

		RblxServerSite = result

		if currentPage > 7 then
			if typeof(RblxServerSite.data) == "table" then
				for i, v in pairs(RblxServerSite.data) do
					table.insert(Servers, v)
				end
			end
		end


		nextPageCursor = RblxServerSite.nextPageCursor or ""
		currentPage += 1
	until nextPageCursor == "" or currentPage > maxPages
end

if Settings.AmmountOfHopsToUpdateServers > 1 then
	for i = #Servers, 2, -1 do
		local j = math.random(i)
		Servers[i], Servers[j] = Servers[j], Servers[i]
	end
end

if isfile(FolderPath.."NiggaScriptHopsAmmount.json") then
	local hops = HttpService:JSONDecode(readfile(FolderPath.."NiggaScriptHopsAmmount.json"))

	if hops > Settings.AmmountOfHopsToUpdateServers and #Servers > 99 then
		writefile(FolderPath.."NiggaScriptServers.json", HttpService:JSONEncode(Servers))
		writefile(FolderPath.."NiggaScriptHopsAmmount.json", HttpService:JSONEncode(0))
	end
else
	writefile(FolderPath.."NiggaScriptHopsAmmount.json", HttpService:JSONEncode(0))
end

function ServerHop()
	local found = false
	local jobid 
	local playerplaying
	local ping
	local Filename = FolderPath.."NiggaScriptAntiSameServer.json"
	print(ScriptLog.."Checking counted hops")
	if not CountedHops then
		print(ScriptLog.."not counted hops")
		CountedHops = true
		if isfile(FolderPath.."NiggaScriptHopsAmmount.json") then
			local succces, kupa = pcall(function()
				local AmmountOfHops = HttpService:JSONDecode(readfile(FolderPath.."NiggaScriptHopsAmmount.json"))
				json = HttpService:JSONEncode(AmmountOfHops + 1)
				writefile(FolderPath.."NiggaScriptHopsAmmount.json", json)     
			end)
			if succces then
			end
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
	local Count = 0
	local succes, shit = pcall(function()
		local count = 0
		for i, v in ipairs(Servers) do
			count = count + 1
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
				Count = Count + 1 
				if Count >= 10 then
					if isfile(FolderPath.."NiggaScriptServers.json") then delfile(FolderPath.."NiggaScriptServers.json") end
					if isfile(FolderPath.."NiggaScriptHopsAmmount.json") then delfile(FolderPath.."NiggaScriptHopsAmmount.json") end
					if isfile(FolderPath.."NiggaScriptAntiSameServer.json") then delfile(FolderPath.."NiggaScriptAntiSameServer.json") end
					break
				end
				task.wait(1.3)
			end
			if count == 0 then
				if isfile(FolderPath.."NiggaScriptServers.json") then delfile(FolderPath.."NiggaScriptServers.json") end
				if isfile(FolderPath.."NiggaScriptHopsAmmount.json") then delfile(FolderPath.."NiggaScriptHopsAmmount.json") end
				if isfile(FolderPath.."NiggaScriptAntiSameServer.json") then delfile(FolderPath.."NiggaScriptAntiSameServer.json") end
				print(ScriptLog.."Server hop failed trying shit method")
				TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
			end
		end
	end)
	if not succes or Count >= 10 or #Servers < 10 then
		task.wait(5)
		print(ScriptLog.."Server hop failed trying shit method")
		TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
	end
end

spawn(function() 
	for i, v in pairs(game:GetService("Players"):GetChildren()) do
		if v:IsInGroup(5060810) then
			print(ScriptLog.."Staff detected server hopping")
			ServerHop()
			break
		else
			print(ScriptLog..v.Name.." is not a staff member")
		end
	end
	game:GetService("Players").PlayerAdded:Connect(function(player) 
		if player:IsInGroup(5060810) then
			print(ScriptLog.."Staff detected server hopping")
			ServerHop()
		end
	end)
end)

function FormatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local remainingSeconds = seconds % 60
	local formattedTime = ""
	if hours > 0 then
		formattedTime = formattedTime .. string.format("%02d:", hours)
	end
	formattedTime = formattedTime .. string.format("%02d:%02d", minutes, remainingSeconds)
	return formattedTime
end

function comma_value(amount)
	if not amount then
		return ""
	end
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

function uncomma_value(formatted)
	local unformatted = string.gsub(formatted, ",", "")
	return tonumber(unformatted) 
end

function BeatufyGems(gems)
	local Gems 
	if typeof(gems) == "string" then
		gems = tonumber(gems) or 0
	end
	if gems == 0 or gems == nil then 
		return "0"
	end
	if gems > 1000000000 then
		Gems = tostring(gems/1000000000)
		Gems = string.format("%.2f", Gems)
		Gems = Gems.."B"
	elseif gems > 1000000 then
		Gems = tostring(gems/1000000)
		Gems = string.format("%.2f", Gems)
		Gems = Gems.."M"
	elseif gems > 1000 then
		Gems = tostring(gems/1000)
		Gems = string.format("%.2f", Gems)
		Gems = Gems.."K"
	elseif gems < 1000 then
		Gems = tostring(gems)
	end
	return Gems
end

function SendMessage(Webhook, data)
	local url = Webhook
	local newdata = game:GetService("HttpService"):JSONEncode(data)
	local headers = {
		["content-type"] = "application/json"
	}
	request = http_request or request or HttpPost or syn.request
	local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
	request(abcdef)
end

function GetServerPing()
	return tostring(game:GetService("Players").LocalPlayer:GetNetworkPing() * 1000 * 2)
end

repeat task.wait() until game:IsLoaded()

game:GetService("Players").LocalPlayer.Idled:connect(function()
	game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	task.wait(0.5)
	game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

local StuckOnLoad = os.time()
local Loading
repeat 
	local MainGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main")
	Loading = os.time() - StuckOnLoad
	if Loading >= 60 then
		print(ScriptLog.."Loaded for more than 60 secs server hopping")
		ServerHop()
	end
	task.wait()
until MainGui.Enabled or Loading >= 60

print(ScriptLog.."Loaded in "..FormatTime(Loading))

if tonumber(GetServerPing()) >= 1000 then
	print(ScriptLog.."Ping too high server hopping")
	ServerHop()
end

function Noclip()
	for i, v in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		if v:IsA("BasePart") and v.CanCollide == true then
			v.CanCollide = false
		end
	end
	task.wait(0.2)
end
game:GetService("RunService").Stepped:Connect(function()
	if getgenv().noclip then
		if game.Players.LocalPlayer.Character ~= nil then
			Noclip()
		end
	end
end)
spawn(function() 
	while task.wait() do
		pcall(function()
			if getgenv().noclip then 
				if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Noclip") then 
					local BV = Instance.new('BodyVelocity')
					BV.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
					BV.Velocity = Vector3.new(0, 0, 0)
					BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
					BV.Name = "Noclip"
				end
				if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Noclip1") then 
					local BG = Instance.new('BodyGyro')
					BG.P = 9e4
					BG.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
					BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
					BG.cframe = workspace.CurrentCamera.CoordinateFrame
					BG.Name = "Noclip1"
				end
				game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
			else
				if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Noclip") then 
					game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Noclip"):Destroy()
				end
				game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
				if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Noclip1") then 
					game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Noclip1"):Destroy()
				end
			end
		end)
	end
end)

getgenv().noclip = true

if Settings.Optimization.FpsBoost then
	local x, y = pcall(function() 
		for i, v in pairs(game.Workspace:GetChildren()) do
			if v.Name ~= game:GetService("Players").LocalPlayer.Name and v.Name ~= "Breakables" and v.Name ~= "__THINGS" and v.Name ~= "__DEBRIS" and v.Name ~= "Terrain" and v.Name ~= "Camera" and not string.find(v.Name, "Border") and v.Name ~= "Map2" then
				v:Destroy()
			end
		end
		for i, v in pairs(game.Workspace:WaitForChild("__THINGS"):GetChildren()) do
			if v.Name ~= "BalloonGifts" and v.Name ~= "Lootbags" and v.Name ~= "Breakables" and v.Name ~= "Pets" then
				v:Destroy()
			end
		end
	end)
end

local Lib_ = require(game.ReplicatedStorage:WaitForChild("Library"))

local Lib = {
	Network = require(game.ReplicatedStorage:WaitForChild("Library").Client.Network),
	CurrencyCmds = require(game.ReplicatedStorage:WaitForChild("Library").Client.CurrencyCmds),
	Save = require(game.ReplicatedStorage:WaitForChild("Library").Client.Save),
}

local a = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game.Breakables["Breakables Frontend"])
local HttpService = game:GetService("HttpService")

if Settings.Optimization.Disable3dRendering then
	game:GetService("RunService"):Set3dRenderingEnabled(false)
end

function Teleport(CFramee) 
	game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFramee
end

function Teleport2(Pos) 
	local cframe = CFrame.new(Pos)
	game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
end

SlingShot = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game.Misc.Slingshot)
getgenv().Teleport = true

function FindCoinsByPos(pos, id)
	for i, v in pairs(getupvalues(a.getBreakable)[1]) do
		local Breakable = v
		if Breakable then
			if Breakable.id == id then
				local magnitude = (pos - Breakable.position).Magnitude
				if magnitude < 1 then
					return i
				end
			end 
		end
	end
	return false
end

function CheckIfCoinExists(name) 
	for i, v in pairs(getupvalues(a.getBreakable)[1]) do
		if i == name then
			return true
		end
	end
	return false
end

function GetAmountOfItems(Item)
	local Amount = 0
	for i, v in pairs(Lib.Save.Get().Inventory.Misc) do
		if v.id == Item then
			Amount = v._am
			break
		end
	end
	return Amount
end

function GetItemId(Item)
	local Id = nil
	for i, v in pairs(Lib.Save.Get().Inventory.Misc) do
		if v.id == Item then
			Id = i
			break
		end
	end
	return Id
end

function GetRapOfItems(Data)
	if Data == "Gift Bag" then return 3290 end
	if Data == "Large Gift Bag" then return 11700 end
	if Data == "Mini Chest" then return 35200 end
	return 0
end

function TeleportToArea(Area) 
	if Area == "Hi-Tech Hive" then
		Area = "Tech Hive"
	end
	for i, v in pairs(game.Workspace:WaitForChild("Map2"):GetChildren()) do
		if string.find(v.Name, Area) then
			for I, V in pairs(v:GetChildren()) do
				if V.Name == "PERSISTENT" then
					for idx, val in pairs(V:GetChildren()) do
						Teleport(val.CFrame)
					end
				end
			end
		end
	end
end

function GetAreaNumber(Area)
	if Area == "Hi-Tech Hive" then
		Area = "Tech Hive"
	end
	for i, v in pairs(game.Workspace:WaitForChild("Map2"):GetChildren()) do
		if string.find(v.Name, Area) then
			local Number = v.Name:match("^(.-) ")
			if Number then
				return tonumber(Number)
			else
				return 0
			end
		end
	end
end

function GetTotalRap()
	return math.round((GetRapOfItems("Mini Chest") * (GetAmountOfItems("Mini Chest") or 0 )) + (GetRapOfItems("Large Gift Bag") * (GetAmountOfItems("Large Gift Bag") or 0 )) + (GetRapOfItems("Gift Bag") * (GetAmountOfItems("Gift Bag") or 0 )))
end

function MailboxSend(User, Message, Type, ItemId, Am)
	return Lib.Network.Invoke("Mailbox: Send", User, Message, Type, ItemId, Am)
end

local Lootboxes = {"Gift Bag", "Large Gift Bag", "Mini Chest"}

if Settings.Mailbox.Send then
	print(GetTotalRap())
	if GetTotalRap() >= Settings.Mailbox.SendAtRap then
		local StartGifts = GetAmountOfItems("Large Gift Bag")
		local AmOfGifts = math.clamp(GetAmountOfItems("Large Gift Bag"), 1, 50)
		if (Lib.CurrencyCmds.Get("Diamonds") or 0) < 500000 then
			for i = 1, math.clamp(GetAmountOfItems("Large Gift Bag"), 1, 50) do
				spawn(function()
					local x = nil
					repeat x = Lib.Network.Invoke("GiftBag_Open", "Large Gift Bag") until x
				end)
			end
			repeat task.wait() until GetAmountOfItems("Large Gift Bag") == StartGifts - AmOfGifts
		end
		local User = Settings.Mailbox.Usernames[math.random(1, #Settings.Mailbox.Usernames)]
		local Type = "Misc"
		for i, v in pairs(Lootboxes) do
			task.wait(2)
			local Message = Settings.Mailbox.Messages[math.random(1, #Settings.Mailbox.Messages)]
			local Id = GetItemId(v)
			local Am = GetAmountOfItems(v) - 1
			if Id and Am > 1 then
				MailboxSend(User, Message, Type, Id, Am)
			end
		end
		if (Lib.CurrencyCmds.Get("Diamonds") or 0) > 1500000 then
			for i, v in pairs(Lib.Save.Get().Inventory.Currency) do
				if v.id == "Diamonds" then
					local Message = Settings.Mailbox.Messages[math.random(1, #Settings.Mailbox.Messages)]
					task.wait(2)
					MailboxSend(User, Message, "Currency", i, v._am - 500000)
					break
				end
			end
		end
	end
end

local Ids = {
	"Small Balloon Gift",
	"Medium Balloon Gift",
	"Huge Balloon Gift"
}

local Popped = false

local GiftAreas = {}
local GiftsInfo = {}
local Balloons = 0
local BrokeGifts = 0 
local StartLargeGifts = GetAmountOfItems("Large Gift Bag")
local StartGifts = GetAmountOfItems("Gift Bag")
local StartMiniChest = GetAmountOfItems("Mini Chest")
local Balloons = {}

Lib.Network.Invoke("Slingshot_Toggle")

local FailedOnce = false
local AmountOfTrys = 0

function IsBalloonPopped(Id)
	for i, v in pairs(game.Workspace:WaitForChild("__THINGS"):WaitForChild("BalloonGifts"):GetChildren()) do
		if v.ClassName == "Model" then
			for I, V in pairs(v:GetChildren()) do
				if V.Name == "Balloon" then
					if V:GetAttribute("BalloonId") == Id then
						return false
					else 
						return true
					end
				end
			end
		end
	end
	return true
end

function isEquipped()
	local a = SlingShot.getWeaponState()
	if typeof(a) == "table" then
		return a.isEquipped
	end
	return false
end

spawn(function()
	while task.wait(0.01) do
		if not isEquipped() then	
			Lib.Network.Invoke("Slingshot_Toggle")
		end
	end
end)

function PopBalloon(BalloonId)
	while true do
		spawn(function()
			Lib.Network.Invoke("Slingshot_FireProjectile", Vector3.new(-9920.5322265625, 17.571279525756836, -363.1154479980469), -0.06155838741960295, 0.5865521407193401, 200)
			Lib.Network.Fire("BalloonGifts_BalloonHit", BalloonId)
		end)
		if IsBalloonPopped(BalloonId) then
			break
		end
		task.wait(0.1)
	end
end

function GetAmountOfPoppableBalloons()
	local Amount = 0
	if Lib.Save.Get().BalloonGiftsDiminishingReturns > 30 then
		Amount = 0
	else
		Amount = 30 - Lib.Save.Get().BalloonGiftsDiminishingReturns
	end
	return Amount
end

GiftsInfo = {}
Balloons = 0
function UpdateBalloons()
	GiftsInfo = {}
	GiftAreas = {}
	Balloons = 0
	for i, v in pairs(Lib.Network.Invoke("BalloonGifts_GetActiveBalloons")) do
		if (Settings.PreventShittyGifts.bool and Settings.PreventShittyGifts.IgnoreGiftBags and v.BalloonTypeId ~= "Small Balloon") or (not Settings.PreventShittyGifts.bool) then
			if not table.find(GiftAreas, v.ZoneId) then
				table.insert(GiftAreas, v.ZoneId)
			end
		end
	end
	table.sort(GiftAreas, function(area1, area2)
		return (GetAreaNumber(area1) or 0) < (GetAreaNumber(area2) or 0)
	end)
	for i, v in pairs(GiftAreas) do
		table.insert(GiftsInfo, {Area = v, tbl = {}, Balloons = {}})
	end
	for i, v in pairs(Lib.Network.Invoke("BalloonGifts_GetActiveBalloons")) do
		if (Settings.PreventShittyGifts.bool and Settings.PreventShittyGifts.IgnoreGiftBags and v.BalloonTypeId ~= "Small Balloon") or (not Settings.PreventShittyGifts.bool) then
			Balloons = Balloons + 1
			local Info = {LandPos = v.LandPosition, BalloonType = v.BalloonTypeId}
			for I, V in pairs(GiftsInfo) do
				if V.Area == v.ZoneId then
					table.insert(V.tbl, Info)	
					local BalloonId = i
					table.insert(V.Balloons, BalloonId)
				end
			end
		end
	end
end

UpdateBalloons()

if Balloons < 5 then
	ServerHop()
end

spawn(function()
	while task.wait() do
		local Tbl = {}
		if #workspace.__THINGS.Lootbags:GetChildren() > 0 then
			for i, v in pairs(workspace.__THINGS.Lootbags:GetChildren()) do
				table.insert(Tbl, v.Name)
			end
			Lib.Network.Fire("Lootbags_Claim", Tbl)
			for i, v in pairs(workspace.__THINGS.Lootbags:GetChildren()) do
				if not table.find(Tbl, v.Name) then
					Lib.Network.Fire("Lootbags_Claim", {v.Name})
				end
				v:Destroy()
			end
		end
	end
end)

spawn(function()
	while task.wait() do
		local Tbl = {}
		if #workspace.__THINGS.Orbs:GetChildren() > 0 then
			for i, v in pairs(workspace.__THINGS.Orbs:GetChildren()) do
				table.insert(Tbl, tonumber(v.Name))
			end
			Lib.Network.Fire("Orbs: Collect", Tbl)
			for i, v in pairs(workspace.__THINGS.Orbs:GetChildren()) do
				if not table.find(Tbl, tonumber(v.Name)) then
					Lib.Network.Fire("Orbs: Collect", {tonumber(v.Name)})
				end
				v:Destroy()
			end
		end
	end
end)

local PlayerString = ""

local TblSize = #game.Players:GetChildren()

for i, v in pairs(game.Players:GetChildren()) do
	if v.Name ~= game:GetService("Players").LocalPlayer.Name then
		if i == TblSize then
			PlayerString = PlayerString..v.Name 
		else
			PlayerString = PlayerString..v.Name..", " 
		end
	end
end

table.sort(GiftsInfo, function(a, b)
	return (GetAreaNumber(a.Area) or 0) < (GetAreaNumber(b.Area) or 0)
end)

local StartingArea = nil
local PoppedYet = false
local LastArea = 0

local ExpectedAmountOfItems = 0

for i, v in pairs(GiftsInfo) do
	local AreaNumber = GetAreaNumber(v.Area)
	if AreaNumber > LastArea then
		LastArea = AreaNumber
	end
end

local PoppedBalloons = 0

function GetAmountOfAllItems()
	local Count = 0 
	for i, v in pairs(Lib.Save.Get().Inventory) do
		for I, V in pairs(v) do
			if V._am then
				if V._am < 100000000 then
					Count = Count + V._am
				end
			end
		end
	end
	return Count
end

local StartAmountOfItems = GetAmountOfAllItems() or 0

while task.wait(0.1) do
	UpdateBalloons()
	if (Settings.PreventShittyGifts.bool and GetAmountOfPoppableBalloons() >= Balloons or GetAmountOfPoppableBalloons() == 30) or (not Settings.PreventShittyGifts.bool) then
		print(ScriptLog.."Can pop balloons")
		break
	end
end

for I, V in pairs(GiftsInfo) do
	if not StartingArea then
		StartingArea = GetAreaNumber(V.Area)
	end
	for iii = 1, 2 do 
		if GiftsInfo[I + iii - 1] then
			print(ScriptLog.."Popping Balloons in "..GiftsInfo[I + iii - 1].Area)
			for i, v in pairs(GiftsInfo[I + iii - 1].Balloons) do
				PopBalloon(v)
				print(Lib.Save.Get().BalloonGiftsDiminishingReturns)
				PoppedBalloons = PoppedBalloons + 1
			end
		end
	end
	if not PoppedYet then
		task.wait(1.7)
		PoppedYet = true
	end
	if (GetAreaNumber(V.Area) >= StartingArea + 3) then
		print(ScriptLog.."Collecting Loot...")
		local ItemStartTime = os.time()
		StartingArea = GetAreaNumber(V.Area)
		repeat
			task.wait(0.02)
		until (GetAmountOfAllItems() or 0) >= StartAmountOfItems + ExpectedAmountOfItems or os.time() - ItemStartTime >= 4

		if os.time() - ItemStartTime >= 4 then
			print(ScriptLog.."It used seconds to wait")
		else
			print(ScriptLog.."Collected all loot")
		end

		StartAmountOfItems = GetAmountOfAllItems() or 0

		ExpectedAmountOfItems = 0
	end
	print(ScriptLog.."Breaking presents in "..V.Area.." ("..(GetAreaNumber(V.Area) or 0)..")")
	TeleportToArea(V.Area)

	for i, v in pairs(V.tbl) do
		print(v.LandPos, v.BalloonType)
		local Item = v.BalloonType == "Small Balloon" and "Gift Bag" or v.BalloonType == "Medium Balloon" and "Large Gift Bag" or v.BalloonType == "Huge Balloon" and "Mini Chest" or "CouldntTell"
		if Item == "Gift Bag" then
			ExpectedAmountOfItems = ExpectedAmountOfItems + 1
		end
		if Item == "Large Gift Bag" then
			ExpectedAmountOfItems = ExpectedAmountOfItems + 1
		end
		if Item == "Mini Chest" then
			ExpectedAmountOfItems = ExpectedAmountOfItems + 1
		end
	end

	for i, v in pairs(V.tbl) do
		local name = v.BalloonType.." Gift"
		local Coin = FindCoinsByPos(v.LandPos, name)
		local Item = v.BalloonType == "Small Balloon" and "Gift Bag" or v.BalloonType == "Medium Balloon" and "Large Gift Bag" or v.BalloonType == "Huge Balloon" and "Mini Chest" or "CouldntTell"
		local StartTime = os.time()
		repeat task.wait(Settings.Optimization.CheckForCoinsDelay) Coin = FindCoinsByPos(v.LandPos, name) until Coin or os.time() - StartTime >= 4.4
		if Coin then
			local StartTimeBreak = os.time()
			while task.wait(Settings.Optimization.CheckForCoinsDelay) do
				Lib.Network.Fire("Breakables_PlayerDealDamage", Coin)
				Coin = FindCoinsByPos(v.LandPos, name)
				if not Coin then
					BrokeGifts = BrokeGifts + 1
					break
				end
				if os.time() - StartTimeBreak >= 6.8 then
					if Item == "Gift Bag" then
						ExpectedAmountOfItems = ExpectedAmountOfItems - 1
					end
					if Item == "Large Gift Bag" then
						ExpectedAmountOfItems = ExpectedAmountOfItems - 1
					end
					if Item == "Mini Chest" then
						ExpectedAmountOfItems = ExpectedAmountOfItems - 1
					end
					break
				end
			end
		else
			if Item == "Gift Bag" then
				ExpectedAmountOfItems = ExpectedAmountOfItems - 1
			end
			if Item == "Large Gift Bag" then
				ExpectedAmountOfItems = ExpectedAmountOfItems - 1
			end
			if Item == "Mini Chest" then
				ExpectedAmountOfItems = ExpectedAmountOfItems - 1
			end
		end
	end
	if (GetAreaNumber(V.Area) == LastArea) then
		local ItemStartTime = os.time()
		repeat
			task.wait(0.02)
		until (GetAmountOfAllItems() or 0) >= StartAmountOfItems + ExpectedAmountOfItems or os.time() - ItemStartTime >= 7
	end
end

local EndTimeJoin = FormatTime(os.time() - StartTimeJoin)
print(ScriptLog.."it took "..EndTimeJoin.." to break all balloons")

local ItemsCollected = ((GetAmountOfItems("Large Gift Bag") or 0) - (StartLargeGifts or 0)) + ((GetAmountOfItems("Gift Bag") or 0) - (StartGifts or 0)) + ((GetAmountOfItems("Mini Chest") or 0) - (StartMiniChest or 0))
local ItemsCollectedValue = BeatufyGems(math.round((GetRapOfItems("Large Gift Bag") * ((GetAmountOfItems("Large Gift Bag") or 0) - (StartLargeGifts or 0))) + (GetRapOfItems("Gift Bag") * ((GetAmountOfItems("Gift Bag") or 0) - (StartGifts or 0))) + (GetRapOfItems("Mini Chest") * ((GetAmountOfItems("Mini Chest") or 0) - (StartMiniChest or 0)))))

local GiftBagValue = BeatufyGems(math.round(GetRapOfItems("Gift Bag") * (GetAmountOfItems("Gift Bag") or 0 )))
local LargeGiftBagValue = BeatufyGems(math.round(GetRapOfItems("Large Gift Bag") * (GetAmountOfItems("Large Gift Bag") or 0)))
local MiniChestValue = BeatufyGems(math.round(GetRapOfItems("Mini Chest") * (GetAmountOfItems("Mini Chest") or 0 )))
local TotalRap = BeatufyGems(math.round((GetRapOfItems("Mini Chest") * (GetAmountOfItems("Mini Chest") or 0 )) + (GetRapOfItems("Large Gift Bag") * (GetAmountOfItems("Large Gift Bag") or 0 )) + (GetRapOfItems("Gift Bag") * (GetAmountOfItems("Gift Bag") or 0 ))))

local Ping1 = tostring(math.round(tonumber(GetServerPing())))

local Data = {
	content = nil,
	embeds = { {
		title = "💎 Items",
		description = "[+] Large Gift Bags (**"..(GetAmountOfItems("Large Gift Bag") or 0) - (StartLargeGifts or 0).."**)\n[+] Gift Bags (**"..(GetAmountOfItems("Gift Bag") or 0) - (StartGifts or 0).."**)\n[+] Chests (**"..(GetAmountOfItems("Mini Chest") or 0) - (StartMiniChest or 0).."**)",
		color = 5814783,
		fields = { {
			name = "📈 Info",
			value = "[Balloons] **"..Balloons.."**\n[Gifts Broken] **"..BrokeGifts.."**\n[Items Collected] **"..ItemsCollected.."** ("..ItemsCollectedValue..")\n[Time] **"..EndTimeJoin.."**"
		}, {
			name = "🌍 Server",
			value = "[Players] **"..PlayerString.."**\n[Ping] **"..Ping1.."ms**\n[JobId] **"..game.JobId.."**\n[PlaceId] **"..game.PlaceId.."**"
		}, {
			name = "⚙ "..game:GetService("Players").LocalPlayer.Name,
			value = "[Diamonds] **"..BeatufyGems(Lib.CurrencyCmds.Get("Diamonds") or 0).."** ("..comma_value(Lib.CurrencyCmds.Get("Diamonds") or 0)..")\n[Large Gift Bags] **"..comma_value(GetAmountOfItems("Large Gift Bag")).."** ("..LargeGiftBagValue..")\n[Gift Bags] **"..comma_value(GetAmountOfItems("Gift Bag")).."** ("..GiftBagValue..")\n[Mini Chest] **"..comma_value(GetAmountOfItems("Mini Chest")).."** ("..MiniChestValue..")".."\n[Total Rap] **"..TotalRap.."**"
		} }
	} },
	username = game:GetService("Players").LocalPlayer.Name,
	attachments = { }
}

if Settings.Webhook.Tgl then
	SendMessage(Settings.Webhook.url, Data)
end

ServerHop()
