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

-- Global table to track processed logs
local processedLogs = {}
local stackPosition = nil -- Central stacking position

-- Function to scan and mark all logs in the map
local function scanAllLogs()
    processedLogs = {} -- Reset tracking table
    
    local itemsFolder = workspace:FindFirstChild("Items") or workspace:FindFirstChild("Map") or workspace
    local foundLogs = {}
    
    -- Scan for all Log items
    for _, obj in ipairs(itemsFolder:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "Log" and obj:FindFirstChild("PrimaryPart") then
            local primaryPart = obj.PrimaryPart
            
            -- Create unique identifier for this log
            local logId = tostring(primaryPart.Position.X) .. "_" .. tostring(primaryPart.Position.Y) .. "_" .. tostring(primaryPart.Position.Z)
            
            if not processedLogs[logId] then
                table.insert(foundLogs, {
                    model = obj,
                    primaryPart = primaryPart,
                    id = logId,
                    position = primaryPart.Position
                })
                processedLogs[logId] = false -- Mark as not processed yet
            end
        end
    end
    
    print("🔍 Scanned and found " .. #foundLogs .. " unique logs in the map")
    return foundLogs
end

-- Function to set stacking position (uses player's current position)
local function setStackPosition()
    local playerChar = Player.Character or Player.CharacterAdded:Wait()
    local hrp = playerChar:WaitForChild("HumanoidRootPart")
    stackPosition = hrp.Position + Vector3.new(0, 2, 0) -- Start stacking 2 studs above ground
    print("📍 Stack position set to: X:" .. math.floor(stackPosition.X) .. " Y:" .. math.floor(stackPosition.Y) .. " Z:" .. math.floor(stackPosition.Z))
    return stackPosition
end

-- Enhanced Quick TP method that stacks all logs in one place
local function bringAllLogsStacked()
    local playerChar = Player.Character or Player.CharacterAdded:Wait()
    local hrp = playerChar:WaitForChild("HumanoidRootPart")
    local originalPos = hrp.Position
    
    -- Set stack position if not already set
    if not stackPosition then
        setStackPosition()
    end
    
    -- Step 1: Scan and mark all logs first
    print("🔄 Scanning for all logs...")
    local allLogs = scanAllLogs()
    
    if #allLogs == 0 then
        print("❌ No logs found in the map!")
        return
    end
    
    print("🚀 Starting to bring " .. #allLogs .. " logs to stack position...")
    print("📦 Stacking at: X:" .. math.floor(stackPosition.X) .. " Y:" .. math.floor(stackPosition.Y) .. " Z:" .. math.floor(stackPosition.Z))
    
    local successfullyBrought = 0
    local failedBrought = 0
    
    -- Step 2: Process each log in sequence
    for index, logData in ipairs(allLogs) do
        if not processedLogs[logData.id] then
            local success, errorMsg = pcall(function()
                -- Mark as processing
                processedLogs[logData.id] = true
                
                -- Calculate stack height (each log adds 2 studs height)
                local stackHeight = stackPosition.Y + (index * 2)
                local stackOffset = Vector3.new(stackPosition.X, stackHeight, stackPosition.Z)
                
                -- Visual feedback
                print("📦 [" .. index .. "/" .. #allLogs .. "] Stacking log at height: " .. math.floor(stackHeight))
                
                -- Quick TP method for this log
                hrp.CFrame = CFrame.new(logData.primaryPart.Position + Vector3.new(0, 5, 0))
                wait(0.03) -- Very brief pause
                
                -- Attach log to player
                logData.primaryPart.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                
                -- TP back to original position with log
                hrp.CFrame = CFrame.new(originalPos)
                
                -- Place log in the stack with increasing height
                logData.primaryPart.CFrame = CFrame.new(stackOffset)
                
                -- Brief pause between logs
                wait(0.05)
                
                successfullyBrought += 1
                
                -- Progress update with height info
                local percent = math.floor((index / #allLogs) * 100)
                print("📊 Progress: " .. percent .. "% | Height: +" .. (index * 2) .. " studs")
            end)
            
            if not success then
                processedLogs[logData.id] = false -- Mark as failed
                failedBrought += 1
                warn("❌ Failed to bring log " .. index .. ": " .. errorMsg)
            end
        else
            print("⏭️  Skipping already processed log " .. index)
        end
    end
    
    -- Final report
    local totalHeight = #allLogs * 2
    print("🎉 Bring All Logs Complete!")
    print("✅ Successfully stacked: " .. successfullyBrought .. " logs")
    print("📏 Total stack height: " .. totalHeight .. " studs")
    print("❌ Failed to bring: " .. failedBrought .. " logs")
end

-- Function to bring logs with neat vertical stacking
local function bringAllLogsNeatStack()
    local playerChar = Player.Character or Player.CharacterAdded:Wait()
    local hrp = playerChar:WaitForChild("HumanoidRootPart")
    local originalPos = hrp.Position
    
    -- Set stack position
    if not stackPosition then
        setStackPosition()
    end
    
    -- Scan first
    print("🔍 Scanning for logs...")
    local allLogs = scanAllLogs()
    
    if #allLogs == 0 then
        print("❌ No logs found!")
        return
    end
    
    print("🎯 Found " .. #allLogs .. " logs. Starting vertical stacking...")
    
    local successCount = 0
    
    for index, logData in ipairs(allLogs) do
        if not processedLogs[logData.id] then
            local success = pcall(function()
                processedLogs[logData.id] = true
                
                -- Calculate precise stack position
                local stackHeight = stackPosition.Y + ((index - 1) * 2.5) -- 2.5 studs between logs
                local finalPosition = Vector3.new(stackPosition.X, stackHeight, stackPosition.Z)
                
                -- Visual feedback
                print("🏗️  [" .. index .. "/" .. #allLogs .. "] Stacking at height: " .. math.floor(stackHeight))
                
                -- TP to log
                hrp.CFrame = CFrame.new(logData.primaryPart.Position + Vector3.new(0, 6, 0))
                RunService.Heartbeat:Wait()
                
                -- Pick up log
                logData.primaryPart.CFrame = hrp.CFrame + Vector3.new(0, 4, 0)
                
                -- Return to player position
                hrp.CFrame = CFrame.new(originalPos)
                
                -- Place in vertical stack
                logData.primaryPart.CFrame = CFrame.new(finalPosition)
                
                successCount += 1
                
                -- Progress with visual stacking info
                local percent = math.floor((index / #allLogs) * 100)
                local currentHeight = math.floor(stackHeight - stackPosition.Y)
                print("📊 " .. percent .. "% complete | Stack height: +" .. currentHeight .. " studs")
            end)
            
            if not success then
                processedLogs[logData.id] = false
                print("❌ Failed to stack log " .. index)
            end
            
            wait(0.06) -- Smooth delay
        end
    end
    
    local totalStackHeight = #allLogs * 2.5
    print("🎊 Stacking Complete!")
    print("✅ Successfully stacked: " .. successCount .. " logs")
    print("🗼 Total stack height: " .. math.floor(totalStackHeight) .. " studs")
end

-- Function to create a pyramid stack (more stable looking)
local function bringAllLogsPyramidStack()
    local playerChar = Player.Character or Player.CharacterAdded:Wait()
    local hrp = playerChar:WaitForChild("HumanoidRootPart")
    local originalPos = hrp.Position
    
    -- Set stack position
    if not stackPosition then
        setStackPosition()
    end
    
    -- Scan first
    print("🔍 Scanning for logs...")
    local allLogs = scanAllLogs()
    
    if #allLogs == 0 then
        print("❌ No logs found!")
        return
    end
    
    print("🏔️  Building pyramid stack with " .. #allLogs .. " logs...")
    
    local successCount = 0
    local layer = 1
    local logsInCurrentLayer = 0
    local maxLogsPerLayer = 5 -- Base layer width
    
    for index, logData in ipairs(allLogs) do
        if not processedLogs[logData.id] then
            local success = pcall(function()
                processedLogs[logData.id] = true
                
                -- Pyramid stacking logic
                logsInCurrentLayer += 1
                if logsInCurrentLayer > maxLogsPerLayer then
                    layer += 1
                    logsInCurrentLayer = 1
                    maxLogsPerLayer = math.max(3, maxLogsPerLayer - 1) -- Reduce layer size
                end
                
                -- Calculate position in pyramid
                local layerHeight = (layer - 1) * 2.5
                local layerRadius = (maxLogsPerLayer - 1) * 1.5
                local angle = (logsInCurrentLayer / maxLogsPerLayer) * math.pi * 2
                
                local xOffset = math.cos(angle) * layerRadius
                local zOffset = math.sin(angle) * layerRadius
                local yOffset = layerHeight
                
                local finalPosition = Vector3.new(
                    stackPosition.X + xOffset,
                    stackPosition.Y + yOffset,
                    stackPosition.Z + zOffset
                )
                
                -- Visual feedback
                print("🔺 [" .. index .. "/" .. #allLogs .. "] Layer " .. layer .. ", Position " .. logsInCurrentLayer)
                
                -- TP sequence
                hrp.CFrame = CFrame.new(logData.primaryPart.Position + Vector3.new(0, 6, 0))
                RunService.Heartbeat:Wait()
                
                logData.primaryPart.CFrame = hrp.CFrame + Vector3.new(0, 4, 0)
                hrp.CFrame = CFrame.new(originalPos)
                logData.primaryPart.CFrame = CFrame.new(finalPosition)
                
                successCount += 1
                
                -- Progress
                local percent = math.floor((index / #allLogs) * 100)
                print("📊 " .. percent .. "% | Layer: " .. layer .. " | Height: +" .. math.floor(layerHeight) .. " studs")
            end)
            
            if not success then
                processedLogs[logData.id] = false
                print("❌ Failed to place log in pyramid")
            end
            
            wait(0.07)
        end
    end
    
    print("🗻 Pyramid Stack Complete!")
    print("✅ Successfully placed: " .. successCount .. " logs")
    print("🏔️  Total layers: " .. layer)
end

-- Function to just scan and show log locations
local function scanAndShowLogs()
    local allLogs = scanAllLogs()
    
    if #allLogs == 0 then
        print("❌ No logs found in the map!")
        return
    end
    
    print("📋 Log Locations Found:")
    for i, logData in ipairs(allLogs) do
        local pos = logData.position
        print("   " .. i .. ". Log at X:" .. math.floor(pos.X) .. " Y:" .. math.floor(pos.Y) .. " Z:" .. math.floor(pos.Z))
    end
    print("📍 Total: " .. #allLogs .. " logs available")
end

-- Function to reset processed logs and stack position
local function resetProcessedLogs()
    processedLogs = {}
    stackPosition = nil
    print("🔄 Reset log tracking and stack position")
end

-- Function to update stack position to current player position
local function updateStackPosition()
    setStackPosition()
    print("📍 Stack position updated to current player location")
end

-- Create buttons in the Bring Tab
menu:CreateSeparator(BringTab, "Log Stacking System")

menu:CreateButton(BringTab, "🔍 Scan All Logs", function()
    scanAndShowLogs()
end)

menu:CreateButton(BringTab, "📍 Set Stack Position", function()
    setStackPosition()
end)

menu:CreateButton(BringTab, "🔄 Update Stack Position", function()
    updateStackPosition()
end)

menu:CreateButton(BringTab, "🗃️ Bring All Logs (Vertical Stack)", function()
    bringAllLogsStacked()
end)

menu:CreateButton(BringTab, "🏗️ Bring All Logs (Neat Stack)", function()
    bringAllLogsNeatStack()
end)

menu:CreateButton(BringTab, "🔺 Bring All Logs (Pyramid)", function()
    bringAllLogsPyramidStack()
end)

menu:CreateButton(BringTab, "🔄 Reset Tracking", function()
    resetProcessedLogs()
end)

menu:CreateSeparator(BringTab, "Single Log")

menu:CreateButton(BringTab, "📦 Bring Single Log to Stack", function()
    if not stackPosition then
        setStackPosition()
    end
    
    local playerChar = Player.Character or Player.CharacterAdded:Wait()
    local hrp = playerChar:WaitForChild("HumanoidRootPart")
    local originalPos = hrp.Position
    
    local logItem = workspace.Items:FindFirstChild("Log")
    if logItem and logItem:FindFirstChild("PrimaryPart") then
        local primaryPart = logItem.PrimaryPart
        
        hrp.CFrame = CFrame.new(primaryPart.Position + Vector3.new(0, 5, 0))
        wait(0.1)
        primaryPart.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
        hrp.CFrame = CFrame.new(originalPos)
        primaryPart.CFrame = CFrame.new(stackPosition)
        
        print("✅ Single log added to stack!")
    else
        print("❌ No log found")
    end
end)

print("✅ Enhanced Log Stacking System Loaded!")
