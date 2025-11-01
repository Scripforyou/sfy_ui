--// 🧩 SFY GUI v6 Script with Auto Eat, Player & Visual Systems
-- Load the library
local GuiLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Scripforyou/sfy_ui/refs/heads/main/sfy_v6"))()
local menu = GuiLibrary.new("SFY GUI")

-- Tabs
local MainTab = menu:CreateTab("Main")
local BringTab = menu:CreateTab("Bring Stuff")
local PlayerTab = menu:CreateTab("Local Player")
local VisualTab = menu:CreateTab("Visual")
local SettingsTab = menu:CreateTab("Settings")

--// ⚙️ Base Variables
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

---------------------------------------------------------
--// 🧱 Safe Height
---------------------------------------------------------
local SaftyHeightEnabled = false
local SaftyHeightValue = 25

menu:CreateSeparator(MainTab,"Safe Height")

menu:CreateToggle(MainTab, "Safty Height:", false, function(state)
    SaftyHeightEnabled = state
    local humanoid = Player.Character and Player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.HipHeight = state and SaftyHeightValue or 0
    end
end)

menu:CreateSlider(MainTab, "Height Settings", 0, 100, SaftyHeightValue, function(value)
    SaftyHeightValue = value
    if SaftyHeightEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.HipHeight = value
    end
end)

---------------------------------------------------------
--// 🍗 Auto Eat System
---------------------------------------------------------
local AutoEatEnabled = false
local HungerThreshold = 60
local hungerPath = nil

-- Dynamic hunger detector
task.spawn(function()
	repeat
		task.wait(1)
		for _, folder in ipairs(workspace:GetChildren()) do
			if folder:FindFirstChild(Player.Name) then
				local status = folder[Player.Name]:FindFirstChild("Status")
				if status and status:FindFirstChild("Hunger") then
					hungerPath = status.Hunger
					break
				end
			end
		end
	until hungerPath
	print("[AutoEat] Hunger path found:", hungerPath:GetFullName())
end)

local FoodList = {
	"Cooked Meat",
    "Cooked Steak",
	"Raw Meat",
	"Raw Steak",
	"Snowberry",
	"Goldberry",
	"Frostshroom",
	"Camp Soup",
	"Banana"
}

local DefaultFoodList = {
    "Cooked Meat",
    "Cooked Steak",
    "Snowberry",
    "Goldberry",
    "Frostshroom",
    "Camp Soup",
    "Banana"
}

local SelectedFoods = {}
for _, name in ipairs(FoodList) do
	SelectedFoods[name] = true
end

-- Helper functions
local function pressE()
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
	task.wait(0.03)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function getFoodPart(foodName)
	local items = workspace:FindFirstChild("Items")
	if not items then return nil end

	for _, item in ipairs(items:GetChildren()) do
		if item.Name:lower():find(foodName:lower()) then
			local possibleParts = {"PrimaryPart", "Part", "Hitbox", "meds"}
			for _, partName in ipairs(possibleParts) do
				local part = item:FindFirstChild(partName)
				if part and part:IsA("BasePart") then
					return part
				end
			end
			for _, desc in ipairs(item:GetDescendants()) do
				if desc:IsA("BasePart") then
					return desc
				end
			end
		end
	end
	return nil
end

local function teleportTo(part)
	local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
	if part and hrp then
		hrp.CFrame = part.CFrame + Vector3.new(0, 2, 0)
	end
end

local function highlight(part)
	local sel = Instance.new("SelectionBox")
	sel.Adornee = part
	sel.LineThickness = 0.03
	sel.Color3 = Color3.fromRGB(0, 255, 0)
	sel.Parent = game:GetService("CoreGui")
	return sel
end

-- Auto eat loop
local function AutoEatLoop()
	while AutoEatEnabled do
		local hunger = hungerPath and hungerPath.Value or 100
		if hunger < HungerThreshold then
			local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then continue end

			local lastPos = hrp.CFrame
			for _, foodName in ipairs(FoodList) do
				if SelectedFoods[foodName] then
					local part = getFoodPart(foodName)
					if part then
						local sel = highlight(part)
						teleportTo(part)
						task.wait(0.15)

						local start = os.clock()
						while hungerPath and hungerPath.Value < 100 and os.clock() - start < 5 and AutoEatEnabled and part and part.Parent do
							pressE()
							task.wait(0.25)
						end

						if sel then sel:Destroy() end
						hrp.CFrame = lastPos
						task.wait(0.2)
					end
				end
			end
		end
		task.wait(0.5)
	end
end

menu:CreateSeparator(MainTab,"🍗 Auto Eat System")

menu:CreateToggle(MainTab, "Enable Auto Eat", false, function(state)
	AutoEatEnabled = state
	if state then
		task.spawn(AutoEatLoop)
	end
end)

menu:CreateSlider(MainTab, "Hunger Threshold (%)", 0, 100, HungerThreshold, function(value)
	HungerThreshold = value
end)

menu:CreateMultiDropdown(MainTab, "Select Foods", DefaultFoodList, FoodList, function(selections)
	for _, item in ipairs(FoodList) do
		SelectedFoods[item] = false
	end
	for _, v in ipairs(selections) do
		SelectedFoods[v] = true
	end
end)




---------------- #Bring Stuff -----------------
---------------------------------------------------------
--// 📦 BRING STUFF SYSTEM
---------------------------------------------------------
local selectedItems = {}

-- Category Data
local categories = {
    Fuel = {
        items = {
            ["Log"] = { partName = "PrimaryPart" },
            ["Frostling"] = { partName = "Hitbox" },
            ["Coal"] = { partName = "PrimaryPart" },
            ["Ashwood"] = { partName = "PrimaryPart" },
            ["Gas Can"] = { partName = "PrimaryPart" },
            ["Hot Core"] = { partName = "PrimaryPart" },
        }
    },
    Food = {
        items = {
            ["Cooked Meat"] = { partName = "Hitbox" },
            ["Raw Meat"] = { partName = "Hitbox" },
            ["Raw Steak"] = { partName = "PrimaryPart" },
            ["Bandage"] = { partName = "meds" },
            ["Snowberry"] = { partName = "PrimaryPart" },
            ["Goldberry"] = { partName = "PrimaryPart" },
            ["Camp Soup"] = { partName = "Part" },
        }
    },
    Weapon = {
        items = {
            ["Iron Axe"] = { partName = "Iron Axe.001" },
            ["Sniper Ammo"] = { partName = "PrimaryPart" },
            ["Boomerang"] = { partName = "Handle" },
            ["Wooden Club"] = { partName = "Handle" },
            ["Pistol"] = { partName = "Handle" },
            ["Spear"] = { partName = "Circle.003" },
            ["Heavy Ammo"] = { partName = "PrimaryPart" },
            ["LMG"] = { partName = "LMG.002" },
            ["Rocket Launcher"] = { partName = "Cube.002" },
            ["Rocket Ammo"] = { partName = "Top" },
            ["Frost Axe"] = { partName = "Handle" },
        }
    },
    Item = {
        items = {
            ["Rabbit Pelt"] = { partName = "Part" },
            ["Side Bag"] = { partName = "Handle" },
            ["Wolf Pelt"] = { partName = "Part" },
            ["Good Sack"] = { partName = "Handle" },
            ["Better Flashlight"] = { partName = "Part" },
            ["Frostcore"] = { partName = "PrimaryPart" },
            ["Old Flashlight"] = { partName = "Circle.003" },
            ["Chainsaw"] = { partName = "Circle.005" },
            ["Old Bag"] = { partName = "Handle" },
            ["Dark Gem"] = { partName = "PrimaryPart" },
            ["Mega Flashlight"] = { partName = "Handle" },
        }
    },
    Gear = {
        items = {
            ["Rusty Nail"] = { partName = "Hitbox" },
            ["Scrap Bundle"] = { partName = "PrimaryPart" },
            ["Beast Den Item"] = { partName = "ItemSpawnPoint" },
            ["Rusty Pipe"] = { partName = "Hitbox" },
            ["Metal Beam"] = { partName = "PrimaryPart" },
        }
    },
    Armor = {
        items = {
            ["Wood Armor"] = { partName = "Part" },
            ["Iron Armor"] = { partName = "PrimaryPart" },
        }
    },
}

-- Function to bring items
local function bringItems(categoryName)
    local playerChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = playerChar:WaitForChild("HumanoidRootPart")
    local itemsFolder = Workspace:FindFirstChild("Items") or Workspace:FindFirstChild("Map")
    
    if not itemsFolder then 
        warn("❌ Items folder not found!") 
        return 
    end
    
    local categoryData = categories[categoryName]
    local currentSelections = selectedItems[categoryName] or {}
    local moved = 0
    
    for _, itemName in ipairs(currentSelections) do
        local data = categoryData.items[itemName]
        if data then
            for _, obj in ipairs(itemsFolder:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == data.partName and obj.Parent.Name == itemName then
                    obj.CFrame = hrp.CFrame + Vector3.new(0, 3 + moved * 0.3, 0)
                    moved += 1
                end
            end
        end
    end
    
    print("✅ Teleported " .. moved .. " " .. categoryName .. " items!")
end

-- Create UI for each category
for categoryName, categoryData in pairs(categories) do
    menu:CreateSeparator(BringTab, categoryName)
    
    -- Get all item names for this category
    local itemNames = {}
    for itemName in pairs(categoryData.items) do
        table.insert(itemNames, itemName)
    end
    
    -- Create MultiDropdown for item selection
    menu:CreateMultiDropdown(BringTab, categoryName .. " Items", itemNames, itemNames, function(selections)
        selectedItems[categoryName] = selections
    end)
    
    -- Create Bring Button for this category
    menu:CreateButton(BringTab, "⚡ Bring " .. categoryName, function()
        bringItems(categoryName)
    end)
end

-- Add a separator and bring all button at the end
menu:CreateSeparator(BringTab, "All Categories")


--#PlayerTab

--// 🧍 Settings

local NoclipEnabled = false
local InfiniteJumpEnabled = false
local WalkSpeedEnabled = false
local WalkSpeedValue = 25
local TpWalkSpeedEnabled = false
local TpWalkSpeedValue = 20
local FOVEnabled = false
local FOVValue = Camera.FieldOfView
local FullBrightEnabled = false


menu:CreateSeparator(PlayerTab,"Player Settings")

--// 👁️‍🗨️ FOV Adjuster (toggle + slider)
menu:CreateToggle(PlayerTab, "Player FOV:", false, function(state)
    FOVEnabled = state
    if state then
        Camera.FieldOfView = FOVValue
    else
        Camera.FieldOfView = 70 -- Roblox default
    end
end)

menu:CreateSlider(PlayerTab, "FOV Value", 50, 120, FOVValue, function(value)
    FOVValue = value
    if FOVEnabled then
        Camera.FieldOfView = value
    end
end)


---------------------------------------------------------
--// ⚡ TELEPORT WALK (Fixed + Optimized)
---------------------------------------------------------
local TpWalkEnabled = false
local TpStep = 1 -- teleport distance per frame

--== UPDATE CHARACTER REF ON RESPAWN ==--
Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
end)

--== UI CONTROLS ==--
menu:CreateToggle(PlayerTab, "TP Walk:", false, function(state)
    TpWalkEnabled = state
end)

menu:CreateSlider(PlayerTab, "TP Walk Distance", 1, 10, TpStep, function(value)
    TpStep = value
end)

--== MAIN LOOP ==--
RunService.RenderStepped:Connect(function()
    if not TpWalkEnabled or not Character then return end

    local hrp = Character:FindFirstChild("HumanoidRootPart")
    local humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not hrp or not humanoid then return end
    if humanoid.MoveDirection.Magnitude <= 0 then return end

    -- move forward in the direction the player is walking
    hrp.CFrame = hrp.CFrame + humanoid.MoveDirection * TpStep
end)








menu:CreateSeparator(PlayerTab,"Usefull")
--// 🚷 NOCLIP
menu:CreateToggle(PlayerTab, "Noclip", false, function(state)
    NoclipEnabled = state
end)

RunService.Stepped:Connect(function()
    if NoclipEnabled then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

--// 🦘 INFINITE JUMP
menu:CreateToggle(PlayerTab, "Infinite Jump", false, function(state)
    InfiniteJumpEnabled = state
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--// 💡 FULL BRIGHT
menu:CreateToggle(PlayerTab, "Full Bright", false, function(state)
    FullBrightEnabled = state
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.FogEnd = 1e10
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    end
end)

















-- #VisualTab

--// 🌈 PLAYER HIGHLIGHT + TRACER SYSTEM
local ESPEnabled = false
local ShowName = false
local ShowDistance = false
local ShowType = false
local ESPColor = Color3.fromRGB(255, 255, 255)
local TracerEnabled = false

local colorOptions = {
    ["White"] = Color3.fromRGB(255, 255, 255),
    ["Cyan"] = Color3.fromRGB(0, 255, 255),
    ["Red"] = Color3.fromRGB(255, 0, 0),
    ["Green"] = Color3.fromRGB(0, 255, 0),
    ["Yellow"] = Color3.fromRGB(255, 255, 0),
    ["Purple"] = Color3.fromRGB(170, 0, 255),
    ["White"] = Color3.fromRGB(255, 255, 255)
}

local ActiveESP = {}

--// Create ESP for a player
local function createESP(plr)
    if plr == game.Players.LocalPlayer then return end

    -- Clean up old
    if ActiveESP[plr] then
        for _, v in pairs(ActiveESP[plr]) do
            if v and v.Destroy then v:Destroy() end
        end
        ActiveESP[plr] = nil
    end

    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = ESPColor
    highlight.Parent = char

    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.AlwaysOnTop = true
    billboard.Adornee = char.HumanoidRootPart
    billboard.StudsOffset = Vector3.new(0, 3, 0)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.TextStrokeTransparency = 0.3
    label.TextColor3 = ESPColor
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Parent = billboard
    billboard.Parent = char

    -- Line (Tracer)
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = ESPColor
    tracer.Thickness = 1.5
    tracer.Transparency = 1

    ActiveESP[plr] = {highlight, billboard, label, tracer}

    RunService.RenderStepped:Connect(function()
        if not ESPEnabled or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
            label.Text = ""
            tracer.Visible = false
            return
        end

        -- Update info text
        local parts = {}
        if ShowName then table.insert(parts, plr.Name) end
        if ShowType then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then table.insert(parts, hum.RigType.Name) end
        end
        if ShowDistance then
            local dist = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position -
                plr.Character.HumanoidRootPart.Position).Magnitude)
            table.insert(parts, dist .. "m")
        end
        label.Text = table.concat(parts, " | ")
        label.TextColor3 = ESPColor
        highlight.OutlineColor = ESPColor

        -- Update line (tracer)
        if TracerEnabled then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            local camera = workspace.CurrentCamera
            local rootPos, onScreen = camera:WorldToViewportPoint(root.Position)
            local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y - 10)

            if onScreen then
                tracer.Visible = true
                tracer.From = screenCenter
                tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                tracer.Color = ESPColor
            else
                tracer.Visible = false
            end
        else
            tracer.Visible = false
        end
    end)
end

--// Clear all ESPs
local function clearAllESP()
    for _, data in pairs(ActiveESP) do
        for _, obj in pairs(data) do
            if obj and obj.Destroy then
                pcall(function() obj:Destroy() end)
            end
        end
    end
    ActiveESP = {}
end

--// GUI CONTROLS
menu:CreateSeparator(VisualTab,"Player ESP")
menu:CreateToggle(VisualTab, "Player ESP", false, function(state)
    ESPEnabled = state
    if state then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer then
                createESP(plr)
            end
        end
        game.Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                task.wait(1)
                if ESPEnabled then createESP(plr) end
            end)
        end)
    else
        clearAllESP()
    end
end)

menu:CreateToggle(VisualTab, "Show Name", false, function(state)
    ShowName = state
end)

menu:CreateToggle(VisualTab, "Show Type", false, function(state)
    ShowType = state
end)

menu:CreateToggle(VisualTab, "Show Distance", false, function(state)
    ShowDistance = state
end)

menu:CreateToggle(VisualTab, "Tracer Lines", false, function(state)
    TracerEnabled = state
end)

menu:CreateDropdown(VisualTab, "ESP/Tracer Color", {"Cyan", "Red", "Green", "Yellow", "Purple", "White"}, "Cyan", function(selected)
    ESPColor = colorOptions[selected]
    for _, data in pairs(ActiveESP) do
        local highlight, billboard, label, tracer = unpack(data)
        if highlight then highlight.OutlineColor = ESPColor end
        if label then label.TextColor3 = ESPColor end
        if tracer then tracer.Color = ESPColor end
    end
end)
menu:CreateSeparator(VisualTab, "Item ESP")


--- add new here

