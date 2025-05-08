if not game:IsLoaded() then
    game.Loaded:Wait()
end


if EnabledScript ~= true then return end
repeat task.wait() until game.Players.LocalPlayer 
print("game loaded")


if not getgenv().BondFarmSetting then 
	getgenv().BondFarmSetting = {
		tweenDuration = 18,
		AutoExecute = false,
		CheckMissedBonds = true,
		WebhookUrl = "none"
	}
end

local SavedSettings
if isfile and writefile and readfile then
	SavedSettings = isfile("DonjoSx's Bondfarm Settings.txt") and readfile("DonjoSx's Bondfarm Settings.txt")
	if SavedSettings then 
		if SaveNewSettings and SaveNewSettings == true then
			local fileContent = string.format("{%s, %s}", tostring(getgenv().BondFarmSetting.tweenDuration), getgenv().BondFarmSetting.WebhookUrl)
			writefile("DonjoSx's Bondfarm Settings.txt", fileContent)
			SavedSettings = {getgenv().BondFarmSetting.tweenDuration, getgenv().BondFarmSetting.WebhookUrl}
			print("Saved new settings")
		end
	else 
		local fileContent = string.format("{%s, %s}", tostring(getgenv().BondFarmSetting.tweenDuration), getgenv().BondFarmSetting.WebhookUrl)
		writefile("DonjoSx's Bondfarm Settings.txt", fileContent)
		SavedSettings = {getgenv().BondFarmSetting.tweenDuration, getgenv().BondFarmSetting.WebhookUrl}
	end
	print("Tween Duration Applied: ".. SavedSettings[1])
	print("Webhook url Applied: ".. SavedSettings[2])
else
	SavedSettings = {getgenv().BondFarmSetting.tweenDuration, getgenv().BondFarmSetting.WebhookUrl}
end

request = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)
local function CheckWebhook(url)
    local success, response = pcall(function()
    local url = tostring(url) or ""
    local abcdef = {Url = url}
    request(abcdef)
    end)
    if success then
        return true
    else
        return false
    end
end

if CheckWebhook(SavedSettings[2]) then
	print("Webhook Exists!")
end

local queue = queueonteleport or queue_on_teleport


if getgenv().BondFarmSetting and getgenv().BondFarmSetting.AutoExecute == true then 
	if queue then
	    queue([[
			if not game:IsLoaded() then
			    game.Loaded:Wait()
			end
			wait(.1)
			if _G.StoppedReExecute then print("breaked re-execute") return end
			print("re-executed")
			repeat task.wait() until game.Players.LocalPlayer
			getgenv().BondFarmSetting = {
				tweenDuration = 18,
				AutoExecute = true,
				CheckMissedBonds = true,
				WebhookUrl = "none"
			}
			EnabledScript = true
			wait(.1)
			print("ran script")
			loadstring(game:HttpGet("https://raw.githubusercontent.com/DonjoScripts/Public-Scripts/refs/heads/Slap-Battles/Deadrails_Obfucasted_19839292790.lua"))()
	    ]])
	else
		game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = "Your executor doesn't support QueueOnTeleport, can't auto execute",Icon = "rbxassetid://7733658504",Duration = 5})
	end
end

local collectedbonds, TimeEnlapsedNotify = 0, ""
local function TPBack()
	spawn(function()
		if SavedSettings and SavedSettings[2] and CheckWebhook(SavedSettings[2]) then
			local sendwebhook = loadstring(game:HttpGet('https://pastefy.app/DG2tzpaH/raw'))()
			sendwebhook(SavedSettings[2], collectedbonds, TimeEnlapsedNotify)
		end
		wait(.1)
		while wait() do
			game:GetService("TeleportService"):Teleport(116495829188952)
		end
	end)
end

if getgenv().BondFarmSetting and getgenv().BondFarmSetting.AutoExecute == true then 
	game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Notification",Text = "Fast auto excute ran!",Icon = "rbxassetid://7733658504",Duration = 5})
end

if game.PlaceId ~= 70876832253163 then
	httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
	local function SHOP()
	    if httprequest then
	        local servers = {}
	        local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)})
	        local body = game:GetService("HttpService"):JSONDecode(req.Body)
	
	        if body and body.data then
	            for i, v in next, body.data do
	                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
	                    table.insert(servers, 1, v.id)
	                end
	            end
	        end
	
	        if #servers > 0 then
	            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
			else
				game:GetService("TeleportService"):Teleport(game.PlaceId)
	        end
	    end
	end
	
	local messageWarn = Instance.new("Message")
    messageWarn.Parent = game.CoreGui
    messageWarn.Text = [[
We're getting you into main game
Automatically server hop after 50 seconds if you're still in lobby to avoid stuck
V4 Update logs: 
1. Improved bonds collector, better detector, much faster collection,
2. Added auto server hop after 2 min in main game to avoid being stuck by bug,
3. Now Automatically server hop for you in lobby after 50 seconds to avoid Teleporter doesn't teleport you,
4. Added webhook.
Enjoy ;)
]]
    local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local LocalPlayer = Players.LocalPlayer
	local TeleportZones = game:GetService("Workspace").PartyZones
	
	spawn(function()
		wait(48)
		messageWarn:Destroy()
		local shopmess = Instance.new("Message")
	    shopmess.Parent = game.CoreGui
		shopmess.Text = "Server hopping"
		wait(2)
		while wait() do
			pcall(SHOP)
		end
	end)
	local function findAvailableZone()
	    for i, v in pairs(TeleportZones:GetChildren()) do
	        if v.Name == "PartyZone" .. i then
	            local plrCountText = v.BillboardGui.PlayerCount.Text
	            if plrCountText == "0/4" then
	                return v
	            end
	        end
	    end
	    return nil
	end
	
	local function moveToZoneContinuously(zone)
	    if not zone then return false end
	    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	    if not humanoid then return false end
		local TPCFrameBypass = 0
	    while true do
	        local plrCountText = zone.BillboardGui.PlayerCount.Text
	        local partyGui = LocalPlayer.PlayerGui:FindFirstChild("PartyCreation")
	        local partyEnabled = partyGui and partyGui.Enabled
	
	        if partyEnabled then
	            return "party_created"
	        end
	
	        if plrCountText ~= "0/4" then
	            return "slot_taken"
	        end
			if TPCFrameBypass <= 5 then
				pcall(function() humanoid.Parent.HumanoidRootPart.CFrame = zone.WorldPivot end)
				TPCFrameBypass = TPCFrameBypass + 1
			end
	        humanoid:MoveTo(zone.WorldPivot.Position)
	        task.wait()
	    end
	end
	
	local function main()
	    while true do
	        local zone = findAvailableZone()
			local args = {
			    [1] = {
			        ["trainId"] = "default",
			        ["maxMembers"] = 1,
			        ["gameMode"] = "Normal"
			    }
			}
		
			game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.CreateParty:FireServer(unpack(args))

	        if zone then
	            local result = moveToZoneContinuously(zone)
	            if result == "party_created" then
	                break -- Đã tạo party, thoát vòng lặp chính
	            elseif result == "slot_taken" then
	                print("target slot is taken")
	            end
	        else
	            -- Không tìm thấy zone phù hợp, đợi 1 giây rồi thử lại
	            task.wait()
	        end
	        task.wait() -- Giữ cho vòng lặp không chạy quá nhanh gây lag
	    end
		spawn(function()
			while wait() do
				local args = {
				    [1] = {
				        ["trainId"] = "default",
				        ["maxMembers"] = 1,
				        ["gameMode"] = "Normal"
				    }
				}
				
				game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.CreateParty:FireServer(unpack(args))
			end
		end)
	end
	
	main()
	return
end

spawn(function()
	wait(120)
	TPBack()
end)

if getgenv().AlreadyExecutedBondFarm and getgenv().AlreadyExecutedBondFarm == true then print("Script already ran, stopped script") return end
getgenv().AlreadyExecutedBondFarm = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character.HumanoidRootPart
local OriginPos = HumanoidRootPart.CFrame
local Humanoid = Character.Humanoid
local RunService = game:GetService("RunService")
local TweenService = game: GetService("TweenService")

local function createUICorner(parent, cornerRadius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = cornerRadius
    uiCorner.Parent = parent
    return uiCorner
end

local gui = Instance.new("ScreenGui")
gui.Name = "InfoBondCollectedDonjoSx"
gui.Parent = LocalPlayer.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1,0,1,0)
mainFrame.Position = UDim2.new(0.02, 0, -0.15, 0)
mainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui
createUICorner(mainFrame, UDim.new(0, 10))

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.9, 0, 0.15, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0.03, 0)
titleLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
titleLabel.Text = "Dead rails • Bond auto farm GUI V4"
titleLabel.TextScaled = true
titleLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
titleLabel.Font = Enum.Font.Arcade
titleLabel.Parent = mainFrame
createUICorner(titleLabel, UDim.new(0, 5))

local authorLabel = Instance.new("TextLabel")
authorLabel.Size = UDim2.new(0.9, 0, 0.08, 0)
authorLabel.Position = UDim2.new(0.05, 0, 0.9, 0)
authorLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
authorLabel.Text = "Script made by DonjoSyntax(DonjoSX)"
authorLabel.TextScaled = true
authorLabel.TextColor3 = Color3.new(0.5, 0.5, 0.5)
authorLabel.Font = Enum.Font.Arcade
authorLabel.Parent = mainFrame
createUICorner(authorLabel, UDim.new(0, 5))

local runtimeLabel = Instance.new("TextLabel")
runtimeLabel.Size = UDim2.new(0.8, 0, 0.08, 0)
runtimeLabel.Position = UDim2.new(0.1, 0, 0.3, 0)
runtimeLabel.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
runtimeLabel.Text = "Run time: 0 Second(s)"
runtimeLabel.TextScaled = true
runtimeLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
runtimeLabel.Font = Enum.Font.Arcade
runtimeLabel.Parent = mainFrame
createUICorner(runtimeLabel, UDim.new(0, 5))

local executetimeLabel = Instance.new("TextLabel")
executetimeLabel.Size = UDim2.new(0.8, 0, 0.08, 0)
executetimeLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
executetimeLabel.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
executetimeLabel.Text = "Elapsed time: 0 Second(s)"
executetimeLabel.TextScaled = true
executetimeLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
executetimeLabel.Font = Enum.Font.Arcade
executetimeLabel.Parent = mainFrame
createUICorner(executetimeLabel, UDim.new(0, 5))

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0.08, 0)
statusLabel.Position = UDim2.new(0.1, 0, 0.2, 0)
statusLabel.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
statusLabel.Text = "Status: None (if it stuck, it's a bug so please report this to me)"
statusLabel.TextScaled = true
statusLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
statusLabel.Font = Enum.Font.Arcade
statusLabel.Parent = mainFrame
createUICorner(statusLabel, UDim.new(0, 5))

local collectedLabel = Instance.new("TextLabel")
collectedLabel.Size = UDim2.new(0.7, 0, 0.2, 0)
collectedLabel.Position = UDim2.new(0.15, 0, 0.5, 0)
collectedLabel.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
collectedLabel.Text = "Bond(s) Collected: 0"
collectedLabel.TextScaled = true
collectedLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
collectedLabel.Font = Enum.Font.Arcade
collectedLabel.Parent = mainFrame
createUICorner(collectedLabel, UDim.new(0, 5))

local ToLobby = Instance.new("TextButton")
ToLobby.Size = UDim2.new(0.1, 0, 0.15, 0)
ToLobby.Position = UDim2.new(0.15, 0, 0.725, 0)
ToLobby.BackgroundColor3 = Color3.new(0,0,0)
ToLobby.Text = "Return to lobby"
ToLobby.TextScaled = true
ToLobby.BorderColor3 = Color3.new(1,1,1)
ToLobby.TextColor3 = Color3.new(0.8, 0.8, 0.8)
ToLobby.Font = Enum.Font.Arcade
ToLobby.Parent = mainFrame

ToLobby.MouseButton1Click:Connect(function()
	if queue then
	    queue([[
			if not game:IsLoaded() then
			    game.Loaded:Wait()
			end
			print("queue_on_teleport re-execute breaker ran")
			_G.StoppedReExecute = true
	    ]])
	end
	game:GetService("TeleportService"):Teleport(116495829188952)
end)

if getgenv().BondFarmSetting and getgenv().BondFarmSetting.AutoExecute == true then
	local StopScript = Instance.new("TextButton")
	StopScript.Size = UDim2.new(0.1, 0, 0.15, 0)
	StopScript.Position = UDim2.new(0.275, 0, 0.725, 0)
	StopScript.BackgroundColor3 = Color3.new(0,0,0)
	StopScript.Text = "Break re-executor"
	StopScript.TextScaled = true
	StopScript.BorderColor3 = Color3.new(1,1,1)
	StopScript.BackgroundTransparency = 0
	StopScript.TextColor3 = Color3.new(0.8, 0.8, 0.8)
	StopScript.Font = Enum.Font.Arcade
	StopScript.Parent = mainFrame
	
	StopScript.MouseButton1Click:Connect(function()
		if queue then
			game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Notification!",Text = "Stopped in-script auto executor (does not stop the auto executor of your executor)",Icon = "rbxassetid://7733658504",Duration = 5})
			StopScript:Destroy()
		    queue([[
				if not game:IsLoaded() then
				    game.Loaded:Wait()
				end
				game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = "Queue_on_teleport breaker ran! now the script doesn't automatically re-execute next round",Icon = "rbxassetid://7733658504",Duration = 5})
				_G.StoppedReExecute = true
		    ]])
		else
			game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = "Your executor doesn't support QueueOnTeleport, can't auto execute",Icon = "rbxassetid://7733658504",Duration = 5})
		end
	end)
end

local startElapTime = os.time()
spawn(function()
	while wait() do
		if not gui or gui.Enabled == false then while true do end end
		if not mainFrame or mainFrame.Visible == false then while true do end end
		if not authorLabel or authorLabel.Text ~= "Script made by DonjoSyntax(DonjoSX)" then while true do end end
		local seconds = math.floor(workspace.DistributedGameTime)
		local minutes = math.floor(workspace.DistributedGameTime / 60)
		local hours = math.floor(workspace.DistributedGameTime / 60 / 60)
		local seconds = seconds - (minutes * 60)
		local minutes = minutes - (hours * 60)
		if hours < 1 then if minutes < 1 then
				runtimeLabel.Text = "Run time: " .. seconds .. " Second(s)" else
				runtimeLabel.Text = "Run time: " .. minutes .. " Minute(s), " .. seconds .. " Second(s)"
			end
		else
			runtimeLabel.Text = "Run time: " ..hours .. " Hour(s), " .. minutes .. " Minute(s), " .. seconds .. " Second(s)"
		end
	end
end)

spawn(function() 
	while true do
	    local elapsed = os.time() - startElapTime
	    local hours = math.floor(elapsed / 3600)
	    local minutes = math.floor((elapsed % 3600) / 60)
	    local seconds = elapsed % 60
	
	    if hours > 0 then
	        executetimeLabel.Text = "Elapsed time: " .. hours .. " Hour(s), " .. minutes .. " Minute(s), " .. seconds .. " Second(s)"
			TimeEnlapsedNotify = hours .. " Hour(s), " .. minutes .. " Minute(s), " .. seconds .. " Second(s)"
	    elseif minutes > 0 then
	        executetimeLabel.Text = "Elapsed time: " .. minutes .. " Minute(s), " .. seconds .. " Second(s)"
			TimeEnlapsedNotify = minutes .. " Minute(s), " .. seconds .. " Second(s)"
	    else
	        executetimeLabel.Text = "Elapsed time: " .. seconds .. " Second(s)"
			TimeEnlapsedNotify = seconds .. " Second(s)"
	    end
		wait()
	end
end)

workspace.DescendantRemoving:Connect(function(v)
    if v.Name == "Bond" and Humanoid.Health ~= 0 then
	    local objPosition
        if v:IsA("Model") then
            objPosition = v.WorldPivot.Position
        elseif v:IsA("BasePart") then
            objPosition = v.Position
        end

        local distance = (HumanoidRootPart.Position - objPosition).Magnitude
        if distance <= 700 then
	        collectedbonds = collectedbonds + 1
	        collectedLabel.Text = "Bond(s) Collected: ".. collectedbonds
        end
    elseif v.Name == "InfoBondCollectedDonjoSx" then
	    setclipboard("sussy activity detected!")
	    while true do end
    end
end)

local allbonds = {}
for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
    if v.Name == "Bond" and allbonds[v] then
        table.insert(allbonds, v)
    end
end

workspace.RuntimeItems.ChildAdded:Connect(function(child)
    if child.Name == "Bond" and not allbonds[child] then
        table.insert(allbonds, child)
    end
end)


local mfly1, mfly2
local unmobilefly = function()
    pcall(function()
        local root = LocalPlayer.Character.HumanoidRootPart
        root:FindFirstChild("bodyvelocityFlight"):Destroy()
        root:FindFirstChild("bodyGyroFlight"):Destroy()
        LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
        mfly1:Disconnect()
        mfly2:Disconnect()
    end)
end

local mobilefly = function(VFlyspeed, vfly)
    unmobilefly(LocalPlayer)
    LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
    local VFlyspeed = VFlyspeed or 1
    
    local root = LocalPlayer.Character.HumanoidRootPart
    local camera = workspace.CurrentCamera
    local v3none = Vector3.new()
    local v3zero = Vector3.new(0, 0, 0)
    local v3inf = Vector3.new(9e9, 9e9, 9e9)

    local controlModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
    local bv = Instance.new("BodyVelocity")
    bv.Name = "bodyvelocityFlight"
    bv.Parent = root
    bv.MaxForce = v3zero
    bv.Velocity = v3zero

    local bg = Instance.new("BodyGyro")
    bg.Name = "bodyGyroFlight"
    bg.Parent = root
    bg.MaxTorque = v3inf
    bg.P = 1000
    bg.D = 50

    mfly1 = LocalPlayer.CharacterAdded:Connect(function()
        local bv = Instance.new("BodyVelocity")
        bv.Name = "bodyvelocityFlight"
        bv.Parent = root
        bv.MaxForce = v3zero
        bv.Velocity = v3zero

        local bg = Instance.new("BodyGyro")
        bg.Name = "bodyGyroFlight"
        bg.Parent = root
        bg.MaxTorque = v3inf
        bg.P = 1000
        bg.D = 50
    end)

    mfly2 = RunService.RenderStepped:Connect(function()
        root = Character.HumanoidRootPart
        camera = workspace.CurrentCamera
        if LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild("bodyvelocityFlight") and root:FindFirstChild("bodyGyroFlight") then
            local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            local VelocityHandler = root:FindFirstChild("bodyvelocityFlight")
            local GyroHandler = root:FindFirstChild("bodyGyroFlight")

            VelocityHandler.MaxForce = v3inf
            GyroHandler.MaxTorque = v3inf
            GyroHandler.CFrame = camera.CoordinateFrame
            VelocityHandler.Velocity = v3none

            local direction = controlModule:GetMoveVector()
            if direction.X > 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * (VFlyspeed * 50))
            end
            if direction.X < 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * (VFlyspeed * 50))
            end
            if direction.Z > 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * (VFlyspeed * 50))
            end
            if direction.Z < 0 then
                VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * (VFlyspeed * 50))
            end
        end
    end)
end

local startPosition = Vector3.new(54, 3, 29970)
local endPosition = Vector3.new(-420, 10, -49040)
local tweenDuration = SavedSettings[1]

local function findBonds()
    local runtimeItems = Workspace:FindFirstChild("RuntimeItems")
    if not runtimeItems then return {} end

    local bonds = {}
    for _, item in pairs(runtimeItems:GetChildren()) do
        if item.Name == "Bond" then
	        local objPosition = item.WorldPivot.Position
            local distance = (HumanoidRootPart.Position - objPosition).Magnitude

            if distance < 10000 then
                table.insert(bonds, item)
            end
        end
    end
    return bonds
end

local function collectBonds()
    local closestBond = nil
    local closestDistance = math.huge
    local bonds = findBonds()
    local currentPosition = HumanoidRootPart.Position
    local returnCFrame = CFrame.new(currentPosition)
    for _, bond in ipairs(bonds) do
        if bond and bond.Parent and bond:IsA("Model") then
            local objPosition = bond.WorldPivot.Position
            local distance = (HumanoidRootPart.Position - objPosition).Magnitude

                closestBond = bond
            repeat
            local targetCFrame = closestBond.WorldPivot
            Character.HumanoidRootPart:PivotTo(targetCFrame)
            game:GetService("ReplicatedStorage").Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(closestBond)

            task.wait()
	        until not closestBond or not closestBond.Parent
        end
    end
    Character.HumanoidRootPart:PivotTo(returnCFrame)
end


local PlayerGui = LocalPlayer.PlayerGui

local function TGVisible(val)
    pcall(function()
        for _, v in pairs(PlayerGui:GetDescendants()) do
            if v.Name == "TouchImageLabel" and v.Parent.Name == "ButtonDisplayFrame" and v.Parent.Parent.Name == "InputFrame" then
                v.Parent.Parent.Parent.Visible = val
            elseif v.Parent.Name == "TurretGui" then
                v.Visible = val
            end
        end
    end)
end

local replicatedStorage = game:GetService("ReplicatedStorage")
local horse = replicatedStorage.Assets.Entities.Animals.Horse.Model_Horse
local seat = replicatedStorage.Assets.Entities.Animals.Horse.Model_Horse.VehicleSeat
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

seat.Parent = workspace 
seat:Sit(humanoid)
wait(.5)
seat.Parent = horse


local Backpack = LocalPlayer:WaitForChild("Backpack")
local function dropTools()
    for _, tool in pairs(Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name ~= "Sack" then
            LocalPlayer.Character.Humanoid:EquipTool(tool)
            game:GetService("ReplicatedStorage").Remotes.Tool.DropTool:FireServer(tool)
        end
    end
    for _, tool in pairs(Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name ~= "Sack" then
			game:GetService("ReplicatedStorage").Remotes.Tool.DropTool:FireServer(tool)
        end
    end
end

local STUCK = false
for i,v in pairs(game.CoreGui:GetChildren()) do if v:IsA("ScreenGui") and v.Name ~= "InfoBondCollectedDonjoSx" then v.Enabled = false end end
spawn(function()
	while wait() do Humanoid.JumpPower = 0
		pcall(function()
			spawn(function()
				for _, tool in pairs(Backpack:GetChildren()) do
			        if tool.Name == "Sack" then
			            LocalPlayer.Character.Humanoid:EquipTool(tool)
			            wait(1)
						LocalPlayer.Character.Humanoid:UnequipTools()
			        end
			    end
			end)
		end)
	end
end)
dropTools()

statusLabel.Text = "Status: Bypassed anti-cheat"
mobilefly(5,true)

local sitting = true
Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
    if not Humanoid.Sit and sitting then
        unmobilefly()
        
		Humanoid.Health = 0
		TPBack()
		game:GetService("ReplicatedStorage").Remotes.EndDecision:FireServer(false)
		sitting = false
    end
end)
Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
    if Humanoid.Health == 0 then
		statusLabel.Text = "Status: Finished collecting bonds, rejoining"
        unmobilefly()
		
		game:GetService("ReplicatedStorage").Remotes.EndDecision:FireServer(false)
    end
end)

statusLabel.Text = "Status: Starting script"
LocalPlayer.Character.HumanoidRootPart:PivotTo(CFrame.new(55, 9, 29888))
local currentPosition = startPosition
spawn(function()
	while Humanoid.Health ~= 0 do
		for i,v in pairs(workspace.RuntimeItems: GetChildren()) do
			if v.Name == "Bond" then 
				local objPosition
		        if v:IsA("Model") then
		            objPosition = v.WorldPivot.Position
		        end
		
		        local distance = (HumanoidRootPart.Position - objPosition).Magnitude
		        if distance <= 80 then
					game:GetService("ReplicatedStorage").Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(v)
				end
			end
		end
		task.wait()
	end
end)

statusLabel.Text = "Status: Collecting bonds"
for i = 1,5 do task.wait()
	LocalPlayer.Character.HumanoidRootPart:PivotTo(CFrame.new(55, 9, 29888))
end 

for _, child in pairs(LocalPlayer.Character:GetDescendants()) do
	if child:IsA("BasePart") and child.CanCollide == true then
		child.CanCollide = false
	end
end
while true do
	local Char = Character
	local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

	for i,v in next, Hum:GetPlayingAnimationTracks() do
		v:Stop()
	end
	if Humanoid.Sit == false then Humanoid.Health = 0 TPBack() STUCK = true print("stuck while bypassing teleport, reseted player") break end
	local currentPosition = HumanoidRootPart.Position
    local distance = (currentPosition - endPosition).Magnitude
    
    local bonds = findBonds()
    if #bonds <= 1 then
	    if distance <= 10 then break end
    end
    HumanoidRootPart.CFrame = CFrame.new(currentPosition)

    local distance = (endPosition - currentPosition).Magnitude
    local duration = tweenDuration * (distance / (endPosition - startPosition).Magnitude)

    local tween = TweenService:Create(
        HumanoidRootPart,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(endPosition)}
    )
	tween:Play()

    local tweenInterrupted = false

    while tween.PlaybackState == Enum.PlaybackState.Playing do
        wait()
        
        if #allbonds > 0 then
            tween:Cancel()
            tweenInterrupted = true
            collectBonds()
            break
        end
    end

    if not tweenInterrupted then
        break
    end
end
wait()
game:GetService("ReplicatedStorage").Remotes.EndDecision:FireServer(false)

Humanoid.Sit = false
Humanoid.Health = 0
TPBack()
wait()
if getgenv().BondFarmSetting.CheckMissedBonds and getgenv().BondFarmSetting.CheckMissedBonds == true then
    local bondmiss = Instance.new("Message")
    bondmiss.Parent = game.CoreGui
    if tonumber(#allbonds) - collectedbonds > 0 then 
	    bondmiss.Text = "Bonds Missed: ".. tonumber(#allbonds) - collectedbonds .. " bond(s), \n Total Bonds Detected: ".. tonumber(#allbonds).. " bond(s)."
    else
	    bondmiss.Text = "No bond were missed, \n Total Bonds Detected: ".. tonumber(#allbonds).. " bond(s)."
    end
    wait(10)
    bondmiss:Destroy()
end
