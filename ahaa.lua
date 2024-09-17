local Settings = {
	AutoHatch = true,
	EggSettings = {
		ChargedEggs = false,
		GoldenEggs = false
	},
	CraftSettings = {
		CraftColorGifts = {bool = true, min = 75},
		CraftGraffitiGifts = {bool = true},
		StayOnTeam = {bool = true, onlyWinningTeam = true}
	},
	AutoMiniGame = true,
	Webhook = {
		Send = true,
		UserId = "750423178240721007",
		Url = "https://discord.com/api/webhooks/1123611155303235604/he0sQyBFyGfMx5YIYYKVvNqYNMyWqIdvb7pkmUZ6slxrR1B4DXusPwUo0S42GjnCjHDj",
	},
	Mailbox = {
		Send = true,
		Usernames = {"maciekstock99"}, -- will randomly send to one of selected accs
		RandomTexts = {"Enjoy this gift!","Surprise delivery!","Something special just for you!","Hope this helps!","Sending some good vibes your way!","Here's a little something for you!","Hope you like it!","Thought you might need this!","Just what you were looking for!","Happy to share this with you!","Another one for your collection!","Time for a surprise!","May this brighten your day!","Couldn't resist sending you this!","Found something you might enjoy!","This should come in handy!","A little surprise for your mailbox!","Hope this makes your day better!","A gift, just because!","Here's a treat for you!","Good things come in small packages!","Thought this would be useful!","Something fun is on the way!","Take this, it's yours now!","A special delivery for you!","Open up! There's a surprise inside!","Just passing along a gift!","This one’s for you!","Enjoy the surprise!","Found this and thought of you!","Consider this a token of appreciation!","This will come in handy!","Something cool, just for you!","Here’s a little gift!","Hope you can use this!","Surprise! You’ve got something!","Sending this your way!","Because you deserve it!","A little something from me to you!","This should be helpful!","Guess what? You’ve got mail!","Hope you enjoy this surprise!","Couldn’t resist sending this your way!","Take it, it’s yours now!","A nice little surprise for you!","Something useful has arrived!","This one’s just for you!","A little pick-me-up for you!","Mail call! Here's something special!","Hope this brings a smile!","Enjoy your special delivery!"},
	},
	StatUi = true,
	Optimization = true, 
}

local ScriptLog = "[Karwa's Scripts Color War]: "

repeat task.wait() until game:IsLoaded()

local CurTime = os.time()
local Hatches = 0

game:GetService("Players").LocalPlayer.Idled:connect(function()
	game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	task.wait(0.5)
	game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

getgenv().noclip = true

function Noclip()
	for i, v in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		if v:IsA("BasePart") and v.CanCollide == true then
			v.CanCollide = false
		end
	end
end
game:GetService("RunService").Stepped:Connect(function()
	if getgenv().noclip then
		if game.Players.LocalPlayer.Character ~= nil then
			Noclip()
		end
	end
end)

spawn(function() 
	while wait() do
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
	ColorEventCmds = require(Lib.Client.ColorEventCmds),
	HatchingCmds = require(Lib.Client.HatchingCmds),
	Save = require(Lib.Client.Save),
	WorldFX = require(Lib.Client.WorldFX)
}

local Directory = require(Lib.Directory)

local a = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game.Breakables["Breakables Frontend"])
local HttpService = game:GetService("HttpService")

--[[
	loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))()
			
]]


function Teleport(CFramee) 
	local Character = game.Players.LocalPlayer.Character
	Character:SetPrimaryPartCFrame(CFramee)
end

function teleportPlayer(position)
	local player = game.Players.LocalPlayer
	if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
	end
end

function GetFirstCoin()
	for I, V in pairs(game.Workspace:WaitForChild("__THINGS"):WaitForChild("Breakables"):GetChildren()) do
		if V.ClassName == "Model" then
			local Breakable = a.getBreakable(V.Name) 
			if Breakable then
				local targetPosition = Breakable.position + Vector3.new(0, 5, 0)
				teleportPlayer(targetPosition)
				return V.Name
			end
			break
		end
	end
	return false
end

function EnterEvent()
	Teleport(game.Workspace:WaitForChild("__THINGS").Instances.ColorsInstance.Teleports.Enter.CFrame)
end

function IsInInstance(instance)
	return Client.InstancingCmds.IsInInstance(instance)
end

EnterEvent()

function GetMaxEggs()
	return Client.EggCmds.GetMaxHatch()
end

function GetClosestCustomEgg()
	local CustomEggs = game.Workspace:WaitForChild("__THINGS"):WaitForChild("CustomEggs"):GetChildren()
	local ClosestEgg = nil
	local ShortestDistance = math.huge

	local LocalPlayerPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

	for i, v in pairs(CustomEggs) do
		if v:IsA("Model") and v:FindFirstChild("Egg") then
			local EggPosition = v.Egg.Position

			local distance = (LocalPlayerPosition - EggPosition).Magnitude

			if distance < ShortestDistance then
				ShortestDistance = distance
				ClosestEgg = v.Name
			end
		end
	end

	return ClosestEgg
end

function DisableEggAnimation()
	pcall(function() 
		local EggOpeningFrontend = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game["Egg Opening Frontend"])
		hookfunction(EggOpeningFrontend.PlayEggAnimation, function(...) return end)
	end)
end

DisableEggAnimation()

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

function ColorToTeam(Color)
	local Tbl = {
		["Blue"] = 1,
		["Purple"] = 2,
		["Red"] = 3,
		["Orange"] = 4,
		["Yellow"] = 5,
		["Green"] = 6,
	}
	return Tbl[Color]
end

function GetTeam(typee)
	local Team = nil
	local a, b = pcall(function() 
		if typee == "Current" then
			Team = Client.Save.Get().ColorEvent.Team
		end
		if typee == "Winning" then
			local Colors = {"Blue", "Purple", "Red", "Orange", "Yellow", "Green"}
			local text = game.Workspace:WaitForChild("__THINGS").__INSTANCE_CONTAINER.Active:WaitForChild("ColorsInstance").INTERACT.END_BOARD.Main.SurfaceGui.Top.Winning.Text
			for i, v in pairs(Colors) do
				if string.find(text, v) then
					Team = ColorToTeam(v)
				end
			end
		end
	end)
	return Team
end

function IsEventAvailable()
	if string.find(workspace.__THINGS.__INSTANCE_CONTAINER:WaitForChild("Active"):WaitForChild("ColorsInstance").INTERACT.GameSign.SurfaceGui.Frame.TextLabel.Text, "left") then
		return true
	else
		return false
	end
end

spawn(function()
	if Settings.Optimization then
		while task.wait(10) do
			local decalsyeeted = true -- Leaving this on makes games look shitty but the fps goes up by at least 20.
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
					v.TextureID = 0
				end
			end
			for i, e in pairs(l:GetChildren()) do
				if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
					e.Enabled = false
				end
			end

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
			pcall(function()
				for _, v in pairs(game:GetService("Workspace"):FindFirstChild("__THINGS"):GetChildren()) do
					if table.find({"ShinyRelics", "Ornaments", "Ski Chairs"}, v.Name) then
						v:Destroy()
					end
				end
				game:GetService("Workspace"):WaitForChild("ALWAYS_RENDERING"):Destroy()
			end)

			local Workspace = game:GetService("Workspace")
			local Terrain = Workspace:WaitForChild("Terrain")
			Terrain.WaterReflectance = 0
			Terrain.WaterTransparency = 1
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveSpeed = 0

			local Lighting = game:GetService("Lighting")
			Lighting.Brightness = 0
			Lighting.GlobalShadows = false
			Lighting.FogEnd = 9e100
			Lighting.FogStart = 0

			sethiddenproperty(Lighting, "Technology", 2)
			sethiddenproperty(Terrain, "Decoration", false)

			game:GetService("Lighting"):ClearAllChildren()
		
			for i, v in pairs(workspace.__THINGS.__INSTANCE_CONTAINER:WaitForChild("Active"):WaitForChild("ColorsInstance"):GetChildren()) do
				if not table.find({"INTERACT", "ClientModule", "Common", "SAFETY_NET", "BREAK_ZONE"}, v.Name) then
					v:Destroy()
				end
			end
			for i, v in pairs(workspace.__THINGS.__INSTANCE_CONTAINER:WaitForChild("Active"):WaitForChild("ColorsInstance").INTERACT:GetChildren()) do
				if not table.find({"END_BOARD", "GameSign"}, v.Name) then
					v:Destroy()
				end
			end
		end
		for _, v in pairs(game.Players:GetChildren()) do
			if v.Name ~= game.Players.LocalPlayer.Name then
				v.Character:Destroy()
			end
		end

		game.Players.PlayerAdded:Connect(function(player)
			player.CharacterAdded:Connect(function(character)
				if player.Name ~= game.Players.LocalPlayer.Name then
					character:Destroy()
				end
			end)
		end)
			
		for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game["Breakable VFX (Enchants, etc.)"]:GetChildren()) do
			v.Disabled = true
		end
		for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game.Enchants:GetChildren()) do
			v.Disabled = true
		end
		for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game.Items:GetChildren()) do
			v.Disabled = true
		end
		for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game["Machine Animations"]:GetChildren()) do
			v.Disabled = true
		end
		game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game.Misc.Tutorial.Disabled = true
		game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game.Misc["Prison HQ Door"].Disabled = true
		game:GetService("RunService"):Set3dRenderingEnabled(false)
	end
end)

spawn(function()
	while task.wait(2) do
		print(ScriptLog.."Colors Instance:", IsInInstance("ColorsInstance"))
		print(ScriptLog.."Minigame Instance:", IsInInstance("ColorMinigame"))
		if IsInInstance("ColorsInstance") and not getgenv().Joining and not IsEventAvailable() then
			Teleport(CFrame.new(3673.59692, 16.2394962, -9332.9043, 0.923276544, 1.24007995e-08, 0.384135962, -1.2840597e-08, 1, -1.41975087e-09, -0.384135962, -3.62171249e-09, 0.923276544))
		end
		local isinminigame = IsInInstance("ColorMinigame")
		if isinminigame then
			repeat task.wait(0.1) isinminigame = IsInInstance("ColorMinigame") until not isinminigame
			task.wait(6)
			if not IsInInstance("ColorsInstance") then
				local try = 1
				EnterEvent()
				repeat 
					task.wait(1) 
					try = try + 1 
					if try >= 10 then
						EnterEvent()
						task.wait(5)
					end
				until 
				IsInInstance("ColorsInstance") or try > 10
			end
			if IsInInstance("ColorsInstance") then
				Teleport(CFrame.new(3673.59692, 16.2394962, -9332.9043, 0.923276544, 1.24007995e-08, 0.384135962, -1.2840597e-08, 1, -1.41975087e-09, -0.384135962, -3.62171249e-09, 0.923276544))
			end
		end
		if not IsInInstance("ColorsInstance") and not IsInInstance("ColorMinigame") and not getgenv().Joining then
			EnterEvent()
			getgenv().Joining = true
			repeat task.wait(1) until IsInInstance("ColorsInstance") 
			getgenv().Joining = false
			Teleport(CFrame.new(3673.59692, 16.2394962, -9332.9043, 0.923276544, 1.24007995e-08, 0.384135962, -1.2840597e-08, 1, -1.41975087e-09, -0.384135962, -3.62171249e-09, 0.923276544))
		end
	end
end)

spawn(function()
	while task.wait(1) do
		if getgenv().Joining then
			local try = 1
			repeat 
				task.wait(1) 
				try = try + 1 
				if try >= 10 then
					getgenv().Joining = false
				end
			until not getgenv().Joining
		end
	end
end)

local Time1 = tick()
local Time2
getgenv().timediff = 0
if Settings.AutoHatch then
	Client.Network.Fire("ChargedHatch_Toggle", Settings.EggSettings.ChargedEggs)
	Client.Network.Fire("GoldenHatch_Toggle", Settings.EggSettings.GoldenEggs)
	spawn(function()
		Time1 = tick()
		while task.wait(0.01) do
			if getgenv().stop1 then return end
			local a = Client.Network.Invoke("CustomEggs_Hatch", GetClosestCustomEgg(), GetMaxEggs())
			if a then
				Time2 = tick() - Time1
				getgenv().timediff = Time2
				Time1 = tick()
				print("Egg Opened:",Time2)
				Hatches = Hatches + 1
			end
		end 
	end)
end

spawn(function()
	while task.wait(1) do
		if Settings.CraftSettings.CraftColorGifts.bool and GetAmountOfItem("Bucket O' Paint") > Settings.CraftSettings.CraftColorGifts.min then
			local ToCraft1 = GetAmountOfItem("Bucket O' Paint") - Settings.CraftSettings.CraftColorGifts.min
			Client.Network.Invoke("ColorCrafting_Craft", "Gifts", ToCraft1)
		end
		if Settings.CraftSettings.CraftGraffitiGifts.bool and GetAmountOfItem("Graffiti Can") > 0 then
			Client.Network.Invoke("ColorCrafting_Craft", "Graffiti", 1)
		end
		if Settings.CraftSettings.StayOnTeam.bool then
			if not Settings.CraftSettings.StayOnTeam.onlyWinningTeam then
				Client.Network.Invoke("ColorCrafting_Craft", "Stay", 1)
			else
				if GetTeam("Current") ~= nil and GetTeam("Current") == GetTeam("Winning") then
					Client.Network.Invoke("ColorCrafting_Craft", "Stay", 1)
				end
			end
		end
	end
end)

spawn(function()
	if Settings.AutoMiniGame then
		while task.wait(1) do
			if IsEventAvailable() then
				if not IsInInstance("ColorMinigame") and IsInInstance("ColorsInstance") then
					print(ScriptLog.."Joining Mini game instance")
					task.wait(1)
					Teleport(game.Workspace:WaitForChild("__THINGS").Instances:WaitForChild("ColorMinigame").Teleports.Enter.CFrame)
					getgenv().Joining = true
					repeat task.wait(1) until IsInInstance("ColorMinigame")
					print(ScriptLog.."Joined mini game instance")
					getgenv().Joining = false
				end
			end
		end
	end
end)

function TeleportNearRandomly(cframe)
	local randomOffsetX = math.random(-5, 5)
	local randomOffsetY = math.random(1, 5) 
	local randomOffsetZ = math.random(-5, 5)

	local randomPosition = cframe.Position + Vector3.new(randomOffsetX, randomOffsetY, randomOffsetZ)

	teleportPlayer(randomPosition)
end

spawn(function()
	while task.wait(0.1) do
		if IsInInstance("ColorMinigame") then
			local Coin = GetFirstCoin()

			if Coin then
				local a, b = Client.Network.Fire("Breakables_PlayerDealDamage", Coin)
			end	
			
		end
	end
end)

spawn(function()
	while task.wait(3) do
		for i, v in pairs(workspace.__THINGS.Orbs:GetChildren()) do
			local randomOffsetX = math.random(-5, 5)
			local randomOffsetY = math.random(1, 5) 
			local randomOffsetZ = math.random(-5, 5)
			local randomPosition = v.Position + Vector3.new(randomOffsetX, randomOffsetY, randomOffsetZ)
			v.CFrame = CFrame.new(randomPosition)
		end
	end
end)

spawn(function()
	while task.wait(0.1) do
		local Tbl = {}
		if #workspace.__THINGS.Orbs:GetChildren() > 0 then
			for i, v in pairs(workspace.__THINGS.Orbs:GetChildren()) do
				table.insert(Tbl, v.Name)
			end
			Client.Network.Fire("Orbs: Collect", Tbl)
			for i, v in pairs(workspace.__THINGS.Orbs:GetChildren()) do
				if not table.find(Tbl, v.Name) then
					Client.Network.Fire("Orbs: Collect", {v.Name})
				end
			end
		end
	end
end)

function FindNewHuge(tbl1, tbl2)
	local Huge = {}

	for i, v in pairs(tbl2) do
		if tbl1[i] == nil then
			print("Key", i, "is not in tbl1. Adding value:", v)
			Huge[i] = v
		end
	end

	return Huge
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


local Saved = {}
function GetHugeImage(Name, isGolden)
	print(#Saved)
	local Asset = nil
	if #Saved == 0 then
		Saved = HttpService:JSONDecode(game:HttpGet("https://biggamesapi.io/api/collection/Pets"))
	end
	local Pets = Saved
	for i, v in pairs(Pets.data) do
		if v.configData.name == Name then
			Asset = isGolden and v.configData.goldenThumbnail or not isGolden and v.configData.thumbnail
			break
		end
	end
	Asset = string.gsub(Asset, "rbxassetid://", "")
	return "https://biggamesapi.io/image/"..Asset
end

local function getISO8601Timestamp()
	local now = os.time(os.date("!*t"))

	local isoTime = os.date("%Y-%m-%dT%H:%M:%S", now) .. ".000Z"

	return isoTime
end

function roundToTwoDecimalPlaces(number)
	return (math.floor(number * 100 + 0.5) / 100) or (0)
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

function GetRapOfHuge(Huge, Variant, shiny)
	local RapTable = HttpService:JSONDecode(game:HttpGet("https://biggamesapi.io/api/rap"))
	local rap 
	for i, v in pairs(RapTable.data) do
		if v.configData.id == Huge then
			if Variant == "" and not v.configData.pt or Variant == "Golden" and v.configData.pt == 1 or Variant == "Rainbow" and v.configData.pt == 2 then
				if shiny and v.configData.sh or not shiny and not v.configData.sh then
					rap = v.value
				end
			end 
		end
	end
	if not rap then rap = 0 end
	return rap
end

function GetPetExistence(id, pt, sh)
	local ExistTable = HttpService:JSONDecode(game:HttpGet("https://biggamesapi.io/api/exists"))

	local Exist 

	for i, v in pairs(ExistTable.data) do
		if v.configData.id == id then
			print(v.configData.id)
			local ptCompare = v.configData.pt or 0
			local shCompare = v.configData.sh and true or false

			if pt == ptCompare and sh == shCompare then
				Exist = v.value
			end
		end
	end

	if not Exist then Exist = 0 end
	return Exist
end

spawn(function()
	local CurrentHuges = {}
	local CurHugeAm = 0

	for i, v in pairs(Client.Save.Get().Inventory.Pet) do
		if string.find(v.id, "Huge") then
			print(ScriptLog.."Getting Current Huges")
			CurrentHuges[i] = v
		end 
	end

	print(ScriptLog.."Got Current Huges")
	for i, v in pairs(CurrentHuges) do
		CurHugeAm = CurHugeAm + 1
	end
	print(ScriptLog.. " ", CurHugeAm)

	local notifiedHuges = {} 

	while task.wait(1) do
		if Settings.Webhook.Send then
			local CurrentHuges2 = {}
			local CurHugeAm2 = 0

			for i, v in pairs(Client.Save.Get().Inventory.Pet) do
				if string.find(v.id, "Huge") then
					print(ScriptLog.."Getting Current Huges 2")
					CurrentHuges2[i] = v
					CurHugeAm2 = CurHugeAm2 + 1
				end 
			end

			print(ScriptLog.."Got Current Huges 2")
			print(ScriptLog.. " ", CurHugeAm2, CurHugeAm)

			if CurHugeAm2 > CurHugeAm then
				print(ScriptLog.."Found new huge")
				local tbl = FindNewHuge(CurrentHuges, CurrentHuges2)

				for i, v in pairs(tbl) do
					if not notifiedHuges[i] then 
						local isShiny = v.sh and "Shiny " or not v.sh and ""
						local isShiny2 = v.sh and true or not v.sh and false
						local Variant = not v.pt and "" or v.pt == 1 and "Golden " or v.pt == 2 and "Rainbow "
						local Variant2 = not v.pt and "" or v.pt == 1 and "Golden" or v.pt == 2 and "Rainbow"
						local pt = v.pt or 0
						local isGolden = pt == 1 and true or false
						local Exist = formatNumber(GetPetExistence(v.id, pt, isShiny2))
						local PetName = isShiny..Variant..v.id
						local OpenedTotal = tostring(formatNumber(Client.Save.Get().EggsHatched))
						local Rap = formatNumber(GetRapOfHuge(v.id, Variant2, isShiny2))
						print(PetName, Rap, OpenedTotal, Exist, getISO8601Timestamp(), GetHugeImage(v.id, isGolden))

						local data = {
							content = "<@"..Settings.Webhook.UserId..">",
							embeds = { {
								title = PetName,
								description = "** :gem: Rap: "..Rap.." **\n**:egg: Hatched: "..OpenedTotal.."**\n**:package: Exist: "..Exist.."**\n** :bust_in_silhouette: ||"..game.Players.LocalPlayer.Name.."||**",
								color = 13913087,
								footer = {
									text = "Karwa's Scripts",
									icon_url = "https://tr.rbxcdn.com/b16eb213e2450443df1c0b740ec8cea8/768/432/Image/Webp"
								},
								timestamp = getISO8601Timestamp(),
								image = {
									url = GetHugeImage(v.id, isGolden)
								}
							} },
							attachments = { }
						}
						setclipboard(HttpService:JSONEncode(data))
						print(SendMessage(Settings.Webhook.Url, data))
						print(ScriptLog.."send webhook")
						notifiedHuges[i] = true 
					end
				end

				CurrentHuges = CurrentHuges2
				CurHugeAm = CurHugeAm2
			end

			local HugeAm = 0
			for i, v in pairs(Client.Save.Get().Inventory.Pet) do
				if string.find(v.id, "Huge") then
					HugeAm = HugeAm + 1
				end
			end

			if HugeAm < CurHugeAm then
				CurrentHuges = CurrentHuges2
			end

			CurHugeAm2 = 0
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

function MailboxSend(User, Message, Type, ItemId, Am)
	return Client.Network.Invoke("Mailbox: Send", User, Message, Type, ItemId, Am)
end

spawn(function()
	while task.wait(60) do
		print("in loop")
		if Settings.Mailbox.Send then
			if not table.find(Settings.Mailbox.Usernames, game.Players.LocalPlayer.Name) then
				local id = ""
				for i, v in pairs(Client.Save.Get().Inventory.Pet) do
					if string.find(v.id, "Huge") then
						print("Found huge to send in email", v.id)
						print(v._lk)
						if v._lk then
							print("unlocking "..v.id)
							Client.Network.Invoke("Locking_SetLocked", i, false)
						end
						id = i
						local Username = Settings.Mailbox.Usernames[math.random(1, #Settings.Mailbox.Usernames)]
						local Message = Settings.Mailbox.RandomTexts[math.random(1, #Settings.Mailbox.RandomTexts)]
						local send = MailboxSend(Username, Message, "Pet", id, 1)
						local message = "Senfing mail to "..Username.." with message: "..Message.." data: "..v.id.." "..id.." "..send
						local data = {
							content = "awdawdawdawdawdw",
							embeds = nil,
							attachments = { }
						}
						SendMessage(Settings.Webhook.Url, data)
						task.wait(3)
					end
				end
			end
		end
	end
end)


if Settings.StatUi then
	local G2L = {};

	-- StarterGui.ScreenGui
	G2L["1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
	G2L["1"]["IgnoreGuiInset"] = true;
	G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

	-- StarterGui.ScreenGui.Frame
	G2L["2"] = Instance.new("Frame", G2L["1"]);
	G2L["2"]["ZIndex"] = 10;
	G2L["2"]["BorderSizePixel"] = 0;
	G2L["2"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
	G2L["2"]["Size"] = UDim2.new(1, 0, 1, 0);
	G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);

	-- StarterGui.ScreenGui.Frame.Name
	G2L["3"] = Instance.new("TextLabel", G2L["2"]);
	G2L["3"]["TextWrapped"] = false;
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
	local pos3 = toNegative(G2L["3"].Size.X.Offset/2)
	G2L["3"]["Position"] = UDim2.new(0.5, pos3, 0.1, 0);

	-- StarterGui.ScreenGui.Frame.Huges
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
	G2L["4"]["Text"] = [[Huges: <font color="rgb(232,69,229)">123</font>]];
	G2L["4"]["Name"] = [[Huges]];
	G2L["4"]["Font"] = Enum.Font.FredokaOne;
	G2L["4"]["BackgroundTransparency"] = 1;
	local pos4 = toNegative(G2L["4"].AbsoluteSize.X/2)
	G2L["4"]["Position"] = UDim2.new(0.5, pos4, 0.1, 100);

	-- StarterGui.ScreenGui.Frame.Time
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
	G2L["5"]["Text"] = [[Time: <font color="rgb(232,69,229)">12:34</font>]];
	G2L["5"]["Name"] = [[Time]];
	G2L["5"]["Font"] = Enum.Font.FredokaOne;
	G2L["5"]["BackgroundTransparency"] = 1;
	local pos5 = toNegative(G2L["5"].AbsoluteSize.X/2)
	G2L["5"]["Position"] = UDim2.new(0.5, pos5, 0.1, 50);

	-- StarterGui.ScreenGui.Frame.Gifts
	G2L["6"] = Instance.new("TextLabel", G2L["2"]);
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
	G2L["6"]["Text"] = [[Gifts: <font color="rgb(232,69,229)">Color: 500 | Graffiti: 150</font>]];
	G2L["6"]["Name"] = [[Gifts]];
	G2L["6"]["Font"] = Enum.Font.FredokaOne;
	G2L["6"]["BackgroundTransparency"] = 1;
	local pos6 = toNegative(G2L["6"].AbsoluteSize.X/2)
	G2L["6"]["Position"] = UDim2.new(0.5, pos6, 0.1, 150);

	-- StarterGui.ScreenGui.Frame.Hatch
	G2L["7"] = Instance.new("TextLabel", G2L["2"]);
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
	G2L["7"]["Text"] = [[Hatch: <font color="rgb(232,69,229)">2.14s | 10k | 5.5m</font>]];
	G2L["7"]["Name"] = [[Hatch]];
	G2L["7"]["Font"] = Enum.Font.FredokaOne;
	G2L["7"]["BackgroundTransparency"] = 1;
	local pos7 = toNegative(G2L["7"].AbsoluteSize.X/2)
	G2L["7"]["Position"] = UDim2.new(0.5, pos7, 0.1, 200);

	-- StarterGui.ScreenGui.Frame.Resources
	G2L["8"] = Instance.new("TextLabel", G2L["2"]);
	G2L["8"]["BorderSizePixel"] = 0;
	G2L["8"]["RichText"] = true;
	G2L["8"]["TextXAlignment"] = Enum.TextXAlignment.Left;
	G2L["8"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
	G2L["8"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
	G2L["8"]["TextSize"] = 45;
	G2L["8"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
	G2L["8"]["AutomaticSize"] = Enum.AutomaticSize.X;
	G2L["8"]["Size"] = UDim2.new(0, 0, 0, 50);
	G2L["8"]["ClipsDescendants"] = true;
	G2L["8"]["BorderColor3"] = Color3.fromRGB(221, 95, 255);
	G2L["8"]["Text"] = [[Coins: <font color="rgb(232,69,229)">99b</font>]];
	G2L["8"]["Name"] = [[Resources]];
	G2L["8"]["Font"] = Enum.Font.FredokaOne;
	G2L["8"]["BackgroundTransparency"] = 1;
	local pos8 = toNegative(G2L["8"].AbsoluteSize.X/2)
	G2L["8"]["Position"] = UDim2.new(0.5, pos8, 0.1, 250);

	-- StarterGui.ScreenGui.Frame.bucket
	G2L["9"] = Instance.new("TextLabel", G2L["2"]);
	G2L["9"]["BorderSizePixel"] = 0;
	G2L["9"]["RichText"] = true;
	G2L["9"]["TextXAlignment"] = Enum.TextXAlignment.Left;
	G2L["9"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
	G2L["9"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
	G2L["9"]["TextSize"] = 45;
	G2L["9"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
	G2L["9"]["AutomaticSize"] = Enum.AutomaticSize.X;
	G2L["9"]["Size"] = UDim2.new(0, 0, 0, 50);
	G2L["9"]["ClipsDescendants"] = true;
	G2L["9"]["BorderColor3"] = Color3.fromRGB(221, 95, 255);
	G2L["9"]["Text"] = [[Bucket/Graffiti: <font color="rgb(232,69,229)">50/1150</font>]];
	G2L["9"]["Name"] = [[bucket]];
	G2L["9"]["Font"] = Enum.Font.FredokaOne;
	G2L["9"]["BackgroundTransparency"] = 1;
	local pos9 = toNegative(G2L["9"].AbsoluteSize.X/2)
	G2L["9"]["Position"] = UDim2.new(0.5, pos9, 0.1, 300);

	function GetCoins()
		for i, v in pairs(Client.Save.Get().Inventory.Currency) do
			if v.id == "ColorCoins" then
				return v._am or 0
			end
		end
		return 0
	end

	spawn(function()
		while task.wait(0.1) do
			local timee = formatTime(os.time() - CurTime)
			local OpenedNow = tostring(formatNumber(Hatches * GetMaxEggs()))
			local OpenedTotal = tostring(formatNumber(Client.Save.Get().EggsHatched))
			local Coins = tostring(formatNumber(GetCoins()))
			local Buckets = tostring(formatNumber(GetAmountOfItem("Bucket O' Paint")))
			local Graffiti = tostring(formatNumber(GetAmountOfItem("Graffiti Can")))
			G2L["4"]["Text"] = [[Huges: <font color="rgb(232,69,229)">]]..tostring(GetHugeNumbers())..[[</font>]];
			G2L["5"]["Text"] = [[Time: <font color="rgb(232,69,229)">]]..timee..[[</font>]];
			G2L["6"]["Text"] = [[Gifts: <font color="rgb(232,69,229)">Color: ]]..tostring(GetAmountOfLootbox("Color Gift"))..[[ | Graffiti: ]]..tostring(GetAmountOfLootbox("Graffiti Gift"))..[[</font>]];
			G2L["7"]["Text"] = [[Hatch: <font color="rgb(232,69,229)">]]..tostring(roundToTwoDecimalPlaces(getgenv().timediff))..[[s | ]]..OpenedNow..[[ | ]]..OpenedTotal..[[</font>]];
			G2L["8"]["Text"] = [[Coins: <font color="rgb(232,69,229)">]]..Coins..[[</font>]];
			G2L["9"]["Text"] = [[Bucket/Graffiti: <font color="rgb(232,69,229)">]]..Buckets..[[/]]..Graffiti..[[</font>]];
		end

	end)

	return G2L["1"], require;

end
