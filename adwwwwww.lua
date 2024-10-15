script_key="asANGqeQiRPsaSAWlCKYcbjdWFqYeEZr";
loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/b22aae7d03041699ada62f6a4fb519fd.lua"))()
local UiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/KarwaBloxPrivate/UiLib/refs/heads/main/ui.lua"))()

local HttpService = game:GetService("HttpService")

local Lib = game:GetService("ReplicatedStorage"):WaitForChild("Library")
local Lib_ = require(Lib)

local Client = {
	Network = require(Lib.Client.Network),
	PetCmds = require(Lib.Client.PetCmds),
	Save = require(Lib.Client.Save),
	EggsFrontend = require(Lib.Client.EggsFrontend),
	FruitCmds = require(Lib.Client.FruitCmds)
}


local Directory = require(Lib.Directory)

local Breakable = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game["Breakables Frontend"])

function BreakableToId(breakable)
	if breakable == "Crate" then return getgenv().SmallCPriority or 4 end
	if breakable == "Present" then return getgenv().SmallCPriority or 3 end
	if breakable == "Large Coins" then return getgenv().SmallCPriority or 3 end
	if breakable == "Small Coins" then return getgenv().SmallCPriority or 3 end
	if breakable == "Coin Minichest" then return getgenv().SmallCPriority or 2 end
	if breakable == "Coin Chest" then return getgenv().SmallCPriority or 1 end
	return 99
end


function GetBreakableTable()
	local Breakables = {}
	for i, v in pairs(workspace:WaitForChild("__THINGS").Breakables:GetChildren()) do
		if v.ClassName == "Model" then
			local x = Breakable.getBreakable(tonumber(v.Name))
			if x and x.uid then
				local Info = {uid = x.uid, SortId = BreakableToId(x.id), name = x.id}
				table.insert(Breakables, Info)
			end
		end
	end
	table.sort(Breakables, function(a, b)
		return a.SortId < b.SortId
	end)
	return Breakables
end

spawn(function()
	while task.wait(0.01) do
		if getgenv().AutoFarm then
			local Breakables = GetBreakableTable()
			for i, v in pairs(Breakables) do
				if v.uid then
					for ii, vv in pairs(Client.Save.Get().EquippedPets) do
						Client.Network.Fire("Breakables_JoinPetBulk", {[ii] = v.uid})
					end
					Client.Network.Fire("Breakables_PlayerDealDamage", v.uid)
					local uid = v.uid
					if getgenv().WaitUntilBroke then
						while task.wait(0.01) do
							Breakables = GetBreakableTable()
							Client.Network.Fire("Breakables_PlayerDealDamage", v.uid)
							local x = false
							for I, V in pairs(Breakables) do 
								if V.uid == uid then
									x = true
								end
							end
							if not x then
								break
							end
						end
					end
					break
				end
			end
		end
	end
end)

spawn(function()
	while task.wait(0.1) do
		if getgenv().AutoVending then
			Client.Network.Invoke("VendingMachines_Purchase", "PotionVendingMachine")
		end
	end
end)

spawn(function()
	while task.wait(0.1) do
		if getgenv().CollectDrops then
			local tbl = {}
			for i, v in pairs(workspace:WaitForChild("__THINGS").Orbs:GetChildren()) do
				table.insert(tbl, tonumber(v.Name))
			end
			Client.Network.Fire("Orbs: Collect", tbl)
			for i, v in pairs(workspace:WaitForChild("__THINGS").Orbs:GetChildren()) do
				if not table.find(tbl, tonumber(v.Name)) then
					Client.Network.Fire("Orbs: Collect", {tonumber(v.Name)})
				end 
				v:Destroy()
			end
		end
	end
end)

spawn(function()
	while task.wait(0.01) do
		if getgenv().AutoRoll then
			Client.Network.Invoke("Eggs_Roll")
		end
	end
end)

if not isfolder("KarwaScripts") then
	makefolder("KarwaScripts")
end

local FolderPath = "KarwaScripts/"

local Main = UiLib:CreateWindow({Text = "Karwa's Scripts", GameText = "PETS GO!", GUICloseBind = "RightShift", GUIDragSpeed = 0.15})

local Home = Main:CreateTab({name = "Home"})
local Farm = Main:CreateTab({name = "Farm", icon = "rbxassetid://91193744397147"})

local Settings = Home:Section({name = "Config"})
local Optimization = Home:Section({name = "Optimization"})
local Server = Home:Section({name = "Server"})
local Misc = Home:Section({name = "Misc"})

local Rolls = Farm:Section({name = "Rolls"})
local Breakables = Farm:Section({name = "Breakables"})
local Items = Farm:Section({name = "Items"})

local function FormatTimeDifference(timeDiff)
	local weeks = math.floor(timeDiff / (7 * 24 * 60 * 60))
	timeDiff = timeDiff % (7 * 24 * 60 * 60)

	local days = math.floor(timeDiff / (24 * 60 * 60))
	timeDiff = timeDiff % (24 * 60 * 60)

	local hours = math.floor(timeDiff / (60 * 60))
	timeDiff = timeDiff % (60 * 60)

	local minutes = math.floor(timeDiff / 60)
	local seconds = timeDiff % 60

	local formatted = ""

	if weeks > 0 then
		formatted = formatted .. weeks .. " week" .. (weeks > 1 and "s" or "") .. ", "
	end
	if days > 0 then
		formatted = formatted .. days .. " day" .. (days > 1 and "s" or "") .. ", "
	end
	if hours > 0 then
		formatted = formatted .. hours .. " hour" .. (hours > 1 and "s" or "") .. ", "
	end
	if minutes > 0 then
		formatted = formatted .. minutes .. " minute" .. (minutes > 1 and "s" or "") .. ", "
	end
	if seconds > 0 then
		formatted = formatted .. seconds .. " second" .. (seconds > 1 and "s" or "")
	end

	formatted = formatted:gsub(", $", "")

	return formatted
end

function GetLastSaved()
	local Time 
	local Return 
	if isfile(FolderPath.."LastSaved.json") then
		Time = HttpService:JSONDecode(readfile(FolderPath.."LastSaved.json"))
		local currentTime = os.time()
		local timeDifference = currentTime - Time
		if timeDifference < 0 then
			return "In the future"
		elseif timeDifference == 0 then
			return "Just now"
		else
			return FormatTimeDifference(timeDifference) .. " ago"
		end
	else
		return "Never"
	end
end
local LastSavedLabel = Settings:Label({name = "Last Saved: "..GetLastSaved()})
spawn(function()
	while task.wait(0.5) do
		LastSavedLabel:SetText("Last Saved: "..GetLastSaved())
	end
end)
local SaveButton = Settings:Button({
	name = "Save Config",
	callback = function() 
		Main:SaveConfig()
		writefile(FolderPath.."LastSaved.json", HttpService:JSONEncode(os.time()))
		writefile(FolderPath.."PetGoSAVE.json", HttpService:JSONEncode(UiLib.Config))
		LastSavedLabel:SetText("Last Saved: "..GetLastSaved())
		Main:SendConsoleMessage("print", "Settings Saved!")
	end
})

function ReadSettings(name)
	local value
	if isfile(FolderPath.."PetGoSAVE.json") then
		local Config = HttpService:JSONDecode(readfile(FolderPath.."PetGoSAVE.json"))
		if Config[name] then
			return Config[name]
		else
			return UiLib.Config[name]
		end
	else
		return UiLib.Config[name]
	end
end

local Rendering3d = Optimization:Toggle({
	name = "Disable 3d Rendering",
	deafult = ReadSettings("Disable 3d Rendering"),
	callback = function(v)
		game:GetService("RunService"):Set3dRenderingEnabled(not v)
		local text = not v and "Enabled" or "Disabled"
		Main:SendConsoleMessage("print", "3d Rendering "..text)
	end,
})

local function ShuffleServers(servers)
	local shuffled = servers
	for i = #shuffled, 2, -1 do
		local j = math.random(1, i)
		shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
	end
	return shuffled
end

local HopServers = Server:Button({
	name = "Server Hop",
	callback = function()
		local Servers = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
		Servers.data = ShuffleServers(Servers.data)
		for i,v in pairs(Servers.data) do
			if tonumber(v.maxPlayers) > tonumber(v.playing) then
				Main:SendConsoleMessage("print", "Server Hopping: "..v.id)
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
			end
		end
	end,
})

local Rejoin = Server:Button({
	name = "Rejoin",
	callback = function()
		Main:SendConsoleMessage("print", "Rejoing Server")
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	end,
})

local Executor = Misc:Executor({name = "Executor"})

local AutoFarm = Breakables:Toggle({
	name = "Auto Farm",
	deafult = ReadSettings("Auto Farm"),
	callback = function(v) 
		getgenv().AutoFarm = v  
		local text = v and "Enabled" or "Disabled"
		Main:SendConsoleMessage("print", "Auto Farm "..text)
	end
})

local WaitUntilBroke = Breakables:Toggle({
	name = "Wait Until Broke",
	deafult = ReadSettings("Wait Until Broke"),
	callback = function(v) 
		getgenv().WaitUntilBroke = v  
		local text = v and "Enabled" or "Disabled"
		Main:SendConsoleMessage("print", "Wait Until Broke "..text)
	end
})
game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Eggs_Roll"):InvokeServer()
local args = {
	[1] = 157089
}

game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Eggs_AnimationComplete"):FireServer(unpack(args))

local CollectDrops = Items:Toggle({
	name = "Collect Drops",
	deafult = ReadSettings("Collect Drops"),
	callback = function(v) 
		getgenv().CollectDrops = v  
		local text = v and "Enabled" or "Disabled"
		Main:SendConsoleMessage("print", "Collect Drops "..text)
	end
})

local AutoVendingMachine = Items:Toggle({
	name = "Buy Vending Machine",
	deafult = ReadSettings("Buy Vending Machine"),
	callback = function(v) 
		getgenv().AutoVending = v  
		local text = v and "Enabled" or "Disabled"
		Main:SendConsoleMessage("print", "Buy Vending Machine "..text)
	end
})

local UseFruits = Items:Toggle({
	name = "Eat Fruits",
	deafult = ReadSettings("Eat Fruits"),
	callback = function(v) 
		getgenv().AutoEatFruits = v  
		local text = v and "Enabled" or "Disabled"
		Main:SendConsoleMessage("print", "Eat Fruits "..text)
	end
})

local FruitsTbl = {}
for i, v in pairs(Directory.Fruits) do
	table.insert(FruitsTbl, i)
end

local Fruits = Items:MultiDropdown({
	name = "Select Fruits",
	values = FruitsTbl,
	deafult = ReadSettings("Select Fruits"),
	callback = function(v) getgenv().SelectedFruits = v end
})

local RollDice = Rolls:Toggle({
	name = "Roll Dice",
	deafult = ReadSettings("Roll Dice"),
	callback = function(v) 
		getgenv().AutoRoll = v
		local text = v and "Enabled" or "Disabled"
		Main:SendConsoleMessage("print", "Roll Dice "..text)
	end
})
