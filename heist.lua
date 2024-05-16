local Settings = {
	Run = true,
	Webhook = {
		Tgl = true,
		url = "https://discord.com/api/webhooks/1221519634226745484/nwQLNn-Xs4r1uDRWxMfFBqOPZTxsrJofABrApPzJ4jeJro-SNjqO7YfUD1p5Fy1aiqb0",
	},
	AmmountOfHopsToUpdateServers = 25,
	Optimization = {
		FpsCap = 60,
		Disable3dRendering = true,
		FpsBoost = true,
	},
	Mailbox = {
		Send = true,
		Usernames = {"Nig1r11"}, --you can have multiple storage accs in case some of them gets banned script will randomly pick out of these
		Messages = {"Thanks bro", "thx", "yoo", "gl man", "your doing crazy bro", "thats fire", "aha", "ok", "word", "thats a message", "okay", "lol", "xdd", "lmao"},
		SendAtGems = 35000000
	},
	TimeToKick = 60*2
}

if not Settings.Run then return end

local ScriptLog = "[Karwa's Scripts Auto Heist]: "

local StartTimeJoin = os.time()

if not isfolder("KarwaHeist") then
	makefolder("KarwaHeist")
end
local FolderPath = "KarwaHeist/"

local TeleportService = game:GetService("TeleportService")
local Servers = {}
local RblxServerSite 
local maxPages = 15
local currentPage = 1
local nextPageCursor = ""
local PlaceIDTeleport = game.PlaceId
local PlaceID = game.PlaceId
local HttpService = game:GetService("HttpService")
getgenv().GettingServers = false

if isfile(FolderPath.."NiggaScriptHopsAmmount.json") and HttpService:JSONDecode(readfile(FolderPath.."NiggaScriptHopsAmmount.json")) > Settings.AmmountOfHopsToUpdateServers or not isfile(FolderPath.."NiggaScriptHopsAmmount.json") then
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
				task.wait(1.8)
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
	return tostring(math.round(game:GetService("Players").LocalPlayer:GetNetworkPing() * 1000 * 2))
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

local JoinedTime = os.time()

print(ScriptLog.."Loaded in "..FormatTime(Loading))

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


local Lib = require(game:GetService("ReplicatedStorage"):WaitForChild("Library").Client)
local Lib_ = require(game:GetService("ReplicatedStorage"):WaitForChild("Library"))


if Settings.Optimization.FpsBoost then
	local x, y = pcall(function() 
		for i, v in pairs(game.Workspace:GetChildren()) do
			if v.Name ~= game:GetService("Players").LocalPlayer.Name and v.Name ~= "__THINGS" and v.Name ~= "Terrain" and v.Name ~= "Camera" then
				v:Destroy()
			end
		end
		for i, v in pairs(game.Workspace:WaitForChild("__THINGS"):GetChildren()) do
			if v.Name == "Breakables" then
				v:Destroy()
			end
		end
		game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game["Random Events"]["Random Event Manager"].Enabled = false
		--Skidded
		local decalsyeeted = true
		local g = game
		local w = g.Workspace
		local l = g.Lighting
		local t = w.Terrain
		t.WaterWaveSize = 0
		t.WaterWaveSpeed = 0
		t.WaterReflectance = 0
		t.WaterTransparency = 0
		l.GlobalShadows = false
		l.FogEnd = 9e9
		l.Brightness = 0
		settings().Rendering.QualityLevel = "Level01"
		for i, v in pairs(g:GetDescendants()) do
			if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
				v.Material = "Plastic"
				v.Reflectance = 0
			elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
				v.Transparency = 1
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Lifetime = NumberRange.new(0)
			elseif v:IsA("Explosion") then
				v.BlastPressure = 1
				v.BlastRadius = 1
			elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
				v.Enabled = false
			elseif v:IsA("MeshPart") then
				v.Material = "Plastic"
				v.Reflectance = 0
				v.TextureID = 10385902758728957
			end
		end
		for i, e in pairs(l:GetChildren()) do
			if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
				e.Enabled = false
			end
		end

		function xTab(TABLE)
			for i,v in pairs(TABLE) do
				if type(v) == "function" then
					TABLE[i] = function(...) return end
				end
				if type(v) == "table" then
					xTab(v)
				end
			end
		end
		xTab(Lib.WorldFX)

		for i,v in pairs(game:GetDescendants()) do
			if v:IsA("MeshPart") then
				v.MeshId = ""
			end
			if v:IsA("BasePart") or v:IsA("MeshPart") then
				v.Transparency = 1
			end
			if v:IsA("Texture") or v:IsA("Decal") then
				v.Texture = ""
			end
			if v:IsA("ParticleEmitter") then
				v.Lifetime = NumberRange.new(0)
				v.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,0)})
				v.Enabled = false
			end
			if v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("Trail") or v:IsA("Beam") then
				v.Enabled = false
			end
			if v:IsA("Highlight") then
				v.OutlineTransparency = 1
				v.FillTransparency = 1
			end
		end
		--Skidded
	end)
end

if game.PlaceId ~= 8737899170 then
	Lib.Network.Invoke("World1Teleport")
end

function Teleport(Cframe)
	game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = Cframe
end

local Instances = {}

function Instances.Leave()
	return Lib.InstancingCmds.Leave()
end

function Instances.Enter(InstanceID)
	if not InstanceID then return "No Instance ID" end
	if Lib.InstancingCmds.PlayerIsInInstance() then
		if Lib.InstancingCmds.GetInstanceID() == InstanceID then
			return false
		else
			Instances.Leave()
			task.wait(1)
			for i, v in pairs(workspace.__THINGS.Instances:WaitForChild("Backrooms").Teleports:GetChildren()) do
				if v.Name == "Enter" then
					Teleport(v.CFrame)
				end
			end
			return true
		end
	end
	for i, v in pairs(workspace.__THINGS.Instances:WaitForChild("Backrooms").Teleports:GetChildren()) do
		if v.Name == "Enter" then
			Teleport(v.CFrame)
		end
	end
	return true
end 

repeat Instances.Enter("Backrooms") task.wait(0.5) until Lib.InstancingCmds.PlayerIsInInstance()

repeat task.wait() until workspace:WaitForChild("__THINGS").__INSTANCE_CONTAINER.Active.Backrooms:FindFirstChild("GeneratedBackrooms")

local LastCheck = os.time()
local LastCheckSize = #workspace:WaitForChild("__THINGS").__INSTANCE_CONTAINER.Active.Backrooms.GeneratedBackrooms:GetChildren()
while task.wait() do
	local TblSize = #workspace:WaitForChild("__THINGS").__INSTANCE_CONTAINER.Active.Backrooms.GeneratedBackrooms:GetChildren()
	if TblSize ~= LastCheckSize then
		LastCheck = os.time()
		LastCheckSize = #workspace:WaitForChild("__THINGS").__INSTANCE_CONTAINER.Active.Backrooms.GeneratedBackrooms:GetChildren()
		print(LastCheckSize)
	end
	if os.time() - LastCheck > 2 and TblSize > 0 then
		break
	end
end

print(ScriptLog.."Ended waiting for rooms to load")

spawn(function()
	while task.wait(1) do
		if os.time() - JoinedTime > Settings.TimeToKick then
			game:GetService("Players").LocalPlayer:Kick("kicked by auto heist script")
		end
	end
end)

local CurrentGems = Lib.CurrencyCmds.Get("Diamonds")
local AmOfBank = 0

if workspace:WaitForChild("__THINGS").__INSTANCE_CONTAINER.Active.Backrooms.GeneratedBackrooms:FindFirstChild("BankHeistRoom") then
	print(ScriptLog.."Bank Heist room found")
	for i, v in pairs( workspace:WaitForChild("__THINGS").__INSTANCE_CONTAINER.Active.Backrooms.GeneratedBackrooms:GetChildren()) do
		if v.Name == "BankHeistRoom" then
			AmOfBank = AmOfBank + 1
			Teleport(v.Bank.Pad.CFrame)
			task.wait(1)
		end
	end
	repeat task.wait() until Lib.CurrencyCmds.Get("Diamonds") ~= CurrentGems
	local LastServerHop = 0
	if isfile(FolderPath.."LastServerHop.json") then
		LastServerHop = HttpService:JSONDecode(readfile(FolderPath.."LastServerHop.json"))
	end
	writefile(FolderPath.."LastServerHop.json", HttpService:JSONEncode(os.time()))
	local ServerHopTime = FormatTime(os.time() - LastServerHop)
	local data = {
		content = nil,
		embeds = { {
			title = "Stole "..(tostring(Lib.CurrencyCmds.Get("Diamonds") - CurrentGems)).." Diamonds 💎 ("..tostring(AmOfBank)..") Banks",
			description = "It took "..(FormatTime(os.time() - StartTimeJoin)).." to steal from bank\nIt took "..ServerHopTime.." to server hop and steal",
			color = 5814783,
			footer = {
				text = game:GetService("Players").LocalPlayer.Name.." | "..BeatufyGems(Lib.CurrencyCmds.Get("Diamonds")).." | "..GetServerPing().."ms"
			}
		} },
		username = game:GetService("Players").LocalPlayer.Name,
		attachments = { }
	}
	if Settings.Webhook.Tgl then
		SendMessage(Settings.Webhook.url, data)
	end
	writefile(FolderPath.."BankServer.json", game:GetService("HttpService"):JSONEncode(game.JobId))
	local s, e = pcall(function()
		return game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end)
	if not s then
		task.wait(5)
		ServerHop()
	end
else
	local JobId
	if isfile("BankServer.json") then
		JobId = game:GetService("HttpService"):JSONDecode(readfile("BankServer.json"))
		if JobId == game.JobId then 
			delfile("BankServer.json") 
		end
	end
	print(ScriptLog.."Bank Heist room not found")
	if JobId then
		print(ScriptLog.."Bank Heist room server found in workspace")
		local s, e = pcall(function()
			return game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, JobId, LocalPlayer)
		end)
		if not s then
			print(ScriptLog.."Bank Heist room server failed to join deleting")
			delfile("BankServer.json") 
			task.wait(5)
			ServerHop()
		end
	else
		ServerHop()
	end
end
