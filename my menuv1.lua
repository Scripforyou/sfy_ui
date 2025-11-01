--// Tabbed Menu with Window Controls + Scrollable Pages //--

-- Services (declare once at the top)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
--== CONFIG ==--
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")

local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hungerPath = workspace:WaitForChild("PlayerCharacter"):WaitForChild(player.Name):WaitForChild("Status"):WaitForChild("Hunger")

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "TabbedMenuGUI"
gui.ResetOnSpawn = false
gui.Parent = gethui() or game:GetService("CoreGui")


-- Main Frame (window)
local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = UDim2.new(0, 520, 0, 340)
main.Position = UDim2.new(0.5, -260, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 8)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(35,35,35)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Size = UDim2.new(1, -120, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "My Script Menu"
titleText.TextColor3 = Color3.new(1,1,1)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.Parent = titleBar

-- Controls container
local controls = Instance.new("Frame")
controls.Name = "WindowControls"
controls.Size = UDim2.new(0, 120, 1, 0)
controls.Position = UDim2.new(1, -120, 0, 0)
controls.BackgroundTransparency = 1
controls.Parent = titleBar

local function makeTitleButton(name, text, xOffset)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 36, 1, 0)
	btn.Position = UDim2.new(0, xOffset, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 20
	btn.TextColor3 = Color3.new(1,1,1)
	btn.AutoButtonColor = true
	btn.Parent = controls

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0,6)
	return btn
end


local minBtn = makeTitleButton("MinimizeBtn", "–", 0)
local fullBtn = makeTitleButton("FullscreenBtn", "□", 40)
local closeBtn = makeTitleButton("CloseBtn", "×", 80)

-- Hover effects
local function setHover(btn, normal, hover)
	btn.MouseEnter:Connect(function() btn.BackgroundColor3 = hover end)
	btn.MouseLeave:Connect(function() btn.BackgroundColor3 = normal end)
end


setHover(minBtn, Color3.fromRGB(40,40,40), Color3.fromRGB(90,90,90))
setHover(fullBtn, Color3.fromRGB(40,40,40), Color3.fromRGB(90,90,90))
setHover(closeBtn, Color3.fromRGB(40,40,40), Color3.fromRGB(255,0,0))

-- Left tabs column
local tabs = Instance.new("Frame")
tabs.Name = "Tabs"
tabs.Size = UDim2.new(0, 140, 1, -36)
tabs.Position = UDim2.new(0, 0, 0, 36)
tabs.BackgroundColor3 = Color3.fromRGB(28,28,28)
tabs.BorderSizePixel = 0
tabs.Parent = main

local tabsCorner = Instance.new("UICorner", tabs)
tabsCorner.CornerRadius = UDim.new(0,6)

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.Padding = UDim.new(0,6)
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Parent = tabs
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Content area (right)
local contentArea = Instance.new("Frame")
contentArea.Name = "Content"
contentArea.Size = UDim2.new(1, -140, 1, -36)
contentArea.Position = UDim2.new(0, 140, 0, 36)
contentArea.BackgroundColor3 = Color3.fromRGB(40,40,40)
contentArea.BorderSizePixel = 0
contentArea.Parent = main

local contentCorner = Instance.new("UICorner", contentArea)
contentCorner.CornerRadius = UDim.new(0,6)

-- Pages table (name -> ScrollingFrame)
local pages = {}

-- function to create a tab button (sidebar)
local function createTabButton(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -16, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.BorderSizePixel = 0
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	btn.TextColor3 = Color3.new(1,1,1)
	btn.LayoutOrder = #tabs:GetChildren() + 1
	btn.Parent = tabs
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0,6)
	return btn
end

-- create scrollable page (auto-size canvas with UIListLayout)
local function createScrollablePage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name .. "Page"
	page.Size = UDim2.new(1, -12, 1, -12)
	page.Position = UDim2.new(0, 6, 0, 6)
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.ScrollBarThickness = 6
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = contentArea

	local layout = Instance.new("UIListLayout")
	layout.Parent = page
	layout.Padding = UDim.new(0,8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	-- update canvas size when content changes
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
	end)

	pages[name] = page
	return page
end

-- create tabs + pages
local mainTabBtn = createTabButton("Main")
local bringTabBtn = createTabButton("Bring")
local playerTabBtn = createTabButton("Player")
local visualTabBtn = createTabButton("Visuals")
local teleportTabBtn = createTabButton("Teleport")


local mainPage = createScrollablePage("Main")
local bringPage = createScrollablePage("Bring")
local playerPage = createScrollablePage("Player")
local visualPage = createScrollablePage("Visuals")
local teleportPage = createScrollablePage("Teleport")


-- helper to show one page
local function switchPage(name)
	for n, p in pairs(pages) do
		p.Visible = (n == name)
	end
end


-- connect sidebar buttons
mainTabBtn.MouseButton1Click:Connect(function() switchPage("Main") end)
bringTabBtn.MouseButton1Click:Connect(function() switchPage("Bring") end)
playerTabBtn.MouseButton1Click:Connect(function() switchPage("Player") end)
visualTabBtn.MouseButton1Click:Connect(function() switchPage("Visuals") end)
teleportTabBtn.MouseButton1Click:Connect(function() switchPage("Teleport") end)  -- Fixed this line

-- default
switchPage("Main")


--// 🧩 createSep(title, parent)
-- Creates a horizontal line separator with optional centered label

function createSep(title, parent)
	local sepFrame = Instance.new("Frame")
	sepFrame.Name = "Separator"
	sepFrame.Size = UDim2.new(1, -20, 0, 20)
	sepFrame.BackgroundTransparency = 1
	sepFrame.Parent = parent

	-- Line
	local line = Instance.new("Frame")
	line.Name = "Line"
	line.AnchorPoint = Vector2.new(0.5, 0.5)
	line.Position = UDim2.new(0.5, 0, 0.5, 0)
	line.Size = UDim2.new(1, -10, 0, 1)
	line.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	line.BorderSizePixel = 0
	line.Parent = sepFrame

	-- Optional Title
	if title and title ~= "" then
		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.AnchorPoint = Vector2.new(0.5, 0.5)
		label.Position = UDim2.new(0.5, 0, 0.5, 0)
		label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		label.Text = "  " .. title .. "  "
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.Font = Enum.Font.GothamBold
		label.TextSize = 12
		label.Parent = sepFrame

		-- Rounded edge for label
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = label
	end

	return sepFrame
end


--// createButton Function (Missing from your code)
local function createButton(text, parent, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 36)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.Text = text
    button.AutoButtonColor = true
    button.Parent = parent
    
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 8)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    
    -- Click event
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

-- Also need the createDropdownSelection function for the bring page to work:
local function createDropdownSelection(title, parent, items, defaultSelections, callback)
    local selectedItems = {}
    
    -- Set default selections
    for itemName, data in pairs(items) do
        selectedItems[itemName] = defaultSelections and defaultSelections[itemName] or true
    end
    
    local dropdownOpen = false
    local dropdownHeight = 35
    local itemHeight = 25
    
    -- === MAIN CONTAINER ===
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -10, 0, dropdownHeight)
    container.BackgroundTransparency = 1
    container.ZIndex = 6
    
    -- === DROPDOWN BUTTON ===
    local dropdownButton = Instance.new("TextButton", container)
    dropdownButton.Size = UDim2.new(1, 0, 0, dropdownHeight)
    dropdownButton.Position = UDim2.new(0, 0, 0, 0)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    dropdownButton.TextColor3 = Color3.new(1, 1, 1)
    dropdownButton.Font = Enum.Font.GothamBold
    dropdownButton.TextSize = 14
    dropdownButton.Text = title .. " ▼"
    dropdownButton.ZIndex = 6
    local corner = Instance.new("UICorner", dropdownButton)
    corner.CornerRadius = UDim.new(0, 6)
    
    -- === SCROLLABLE DROPDOWN FRAME ===
    local dropdownFrame = Instance.new("ScrollingFrame", parent)
    dropdownFrame.Size = UDim2.new(1, -10, 0, 0)
    dropdownFrame.Position = UDim2.new(0, 5, 0, container.Position.Y.Offset + dropdownHeight + 5)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    dropdownFrame.ScrollBarThickness = 6
    dropdownFrame.Visible = false
    dropdownFrame.ZIndex = 7
    dropdownFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local dropdownCorner = Instance.new("UICorner", dropdownFrame)
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    
    local layout = Instance.new("UIListLayout", dropdownFrame)
    layout.Padding = UDim.new(0, 2)
    
    -- === CREATE ITEM SELECTION BUTTONS ===
    local itemButtons = {}
    for itemName, data in pairs(items) do
        local itemBtn = Instance.new("TextButton", dropdownFrame)
        itemBtn.Size = UDim2.new(1, -10, 0, itemHeight)
        itemBtn.Position = UDim2.new(0, 5, 0, 0)
        itemBtn.BackgroundColor3 = selectedItems[itemName] and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(120, 120, 120)
        itemBtn.TextColor3 = Color3.new(1, 1, 1)
        itemBtn.Font = Enum.Font.Gotham
        itemBtn.TextSize = 12
        itemBtn.Text = (selectedItems[itemName] and "[✔] " or "[ ] ") .. itemName
        itemBtn.AutoButtonColor = false
        itemBtn.ZIndex = 8
        
        itemBtn.MouseButton1Click:Connect(function()
            selectedItems[itemName] = not selectedItems[itemName]
            itemBtn.BackgroundColor3 = selectedItems[itemName] and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(120, 120, 120)
            itemBtn.Text = (selectedItems[itemName] and "[✔] " or "[ ] ") .. itemName
            
            -- Call callback when selection changes
            if callback then
                callback(selectedItems)
            end
        end)
        
        itemButtons[itemName] = itemBtn
    end
    
    -- === TOGGLE DROPDOWN ===
    dropdownButton.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        dropdownFrame.Visible = dropdownOpen
        
        if dropdownOpen then
            local maxHeight = math.min(#itemButtons * (itemHeight + 2) + 10, 150)
            dropdownFrame.Size = UDim2.new(1, -10, 0, maxHeight)
            dropdownButton.Text = title .. " ▲"
        else
            dropdownFrame.Size = UDim2.new(1, -10, 0, 0)
            dropdownButton.Text = title .. " ▼"
        end
    end)
    
    -- Update dropdown position when container moves
    container:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        if dropdownOpen then
            local containerPos = container.AbsolutePosition
            local parentPos = parent.AbsolutePosition
            dropdownFrame.Position = UDim2.new(0, 5, 0, containerPos.Y - parentPos.Y + dropdownHeight + 5)
        end
    end)
    
    -- === PUBLIC METHODS ===
    local function getSelectedItems()
        return selectedItems
    end
    
    local function setSelectedItems(newSelections)
        for itemName, isSelected in pairs(newSelections) do
            if selectedItems[itemName] ~= nil then
                selectedItems[itemName] = isSelected
                if itemButtons[itemName] then
                    itemButtons[itemName].BackgroundColor3 = isSelected and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(120, 120, 120)
                    itemButtons[itemName].Text = (isSelected and "[✔] " or "[ ] ") .. itemName
                end
            end
        end
        if callback then
            callback(selectedItems)
        end
    end
    
    return {
        container = container,
        getSelectedItems = getSelectedItems,
        setSelectedItems = setSelectedItems
    }
end


-- Fancy switch-style toggle (slide on/off)
local function createSwitch(text, parent, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 320, 0, 36)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Parent = frame

	local switch = Instance.new("Frame")
	switch.Size = UDim2.new(0, 50, 0, 24)
	switch.Position = UDim2.new(1, -70, 0.5, -12)
	switch.BackgroundColor3 = default and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(100, 100, 100)
	switch.BorderSizePixel = 0
	switch.Parent = frame

	local switchCorner = Instance.new("UICorner", switch)
	switchCorner.CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 20, 0, 20)
	knob.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = switch

	local knobCorner = Instance.new("UICorner", knob)
	knobCorner.CornerRadius = UDim.new(1, 0)

	local button = Instance.new("TextButton")
	button.Size = switch.Size
	button.Position = switch.Position
	button.AnchorPoint = Vector2.new(0, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.Parent = frame

	local state = default

	local function updateVisuals()
		local goalPos = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
		local goalColor = state and Color3.fromRGB(50, 200, 100) or Color3.fromRGB(100, 100, 100)
		game:GetService("TweenService"):Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = goalPos}):Play()
		game:GetService("TweenService"):Create(switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = goalColor}):Play()
	end

	button.MouseButton1Click:Connect(function()
		state = not state
		updateVisuals()
		if callback then pcall(callback, state) end
	end)

	return frame
end


--// Modern Slider Component //--
local TweenService = game:GetService("TweenService")

local function createSlider(labelText, parent, minValue, maxValue, defaultValue, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 200, 0, 50)
	frame.BackgroundTransparency = 1
	frame.Parent = parent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 0.5, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.new(1,1,1)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.Parent = frame

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0.4, -10, 0.5, 0)
	valueLabel.Position = UDim2.new(0.6, 0, 0, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(defaultValue)
	valueLabel.TextColor3 = Color3.fromRGB(180,180,180)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Font = Enum.Font.Gotham
	valueLabel.TextSize = 14
	valueLabel.Parent = frame

	local barBg = Instance.new("Frame")
	barBg.Size = UDim2.new(1, -20, 0, 8)
	barBg.Position = UDim2.new(0, 10, 0, 32)
	barBg.BackgroundColor3 = Color3.fromRGB(60,60,60)
	barBg.BorderSizePixel = 0
	barBg.Parent = frame
	local barCorner = Instance.new("UICorner", barBg)
	barCorner.CornerRadius = UDim.new(1,0)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((defaultValue - minValue)/(maxValue - minValue), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(70,130,255)
	fill.BorderSizePixel = 0
	fill.Parent = barBg
	local fillCorner = Instance.new("UICorner", fill)
	fillCorner.CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(fill.Size.X.Scale, -7, 0.5, -7)
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	knob.BorderSizePixel = 0
	knob.Parent = barBg
	local knobCorner = Instance.new("UICorner", knob)
	knobCorner.CornerRadius = UDim.new(1,0)

	local dragging = false
	local currentValue = defaultValue

	local function updateSlider(x)
		local relative = math.clamp((x - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
		local value = math.floor(minValue + (maxValue - minValue) * relative)
		currentValue = value
		valueLabel.Text = tostring(value)

		TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(relative,0,1,0)}):Play()
		TweenService:Create(knob, TweenInfo.new(0.1), {Position = UDim2.new(relative, -7, 0.5, -7)}):Play()

		if callback then pcall(callback, value) end
	end

	barBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateSlider(input.Position.X)
		end
	end)

	barBg.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input.Position.X)
		end
	end)

	return frame
end



--// Auto Eat Integration (Dropdown Food Selector)
--// Author: ChatGPT (Anito Tech Integration)
--// Works with your createSwitch + createSlider system

local VirtualInputManager = game:GetService("VirtualInputManager")
local hrp = char:WaitForChild("HumanoidRootPart")
local hungerPath = workspace:WaitForChild("PlayerCharacter"):WaitForChild(player.Name):WaitForChild("Status"):WaitForChild("Hunger")

--== FOOD LIST ==--
local foodList = {
	"Cooked Meat",
	"Raw Meat",
	"Raw Steak",
	"Snowberry",
	"Goldberry",
	"Frostshroom",
	"Camp Soup",
	"Banana",
}

-- Default selected
local selectedFoods = {
	["Cooked Meat"] = true,
	["Snowberry"] = true,
	["Goldberry"] = true,
	["Banana"] = true,
	["Frostshroom"] = true,
}

--== HELPERS ==--
local function pressE()
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
	task.wait(0.03)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function getFoodPart(foodName)
	local folder = workspace.Items:FindFirstChild(foodName)
	if not folder then return end

	local found
	for _, v in ipairs(folder:GetDescendants()) do
		if v:IsA("BasePart") then
			found = v
			break
		end
	end
	return found
end

local function teleportTo(part)
	if part and hrp then
		hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
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

-- Complete createDropdownMulti function
local function createDropdownMulti(title, parent, options, selectedTable)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 30)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local corner = Instance.new("UICorner", container)
    corner.CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", container)
    label.Text = title
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14

    local dropdown = Instance.new("ScrollingFrame", parent)
    dropdown.Size = UDim2.new(1, -10, 0, 0)
    dropdown.Position = UDim2.new(0, 5, 0, container.AbsolutePosition.Y - parent.AbsolutePosition.Y + 35)
    dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    dropdown.ScrollBarThickness = 6
    dropdown.Visible = false
    dropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local dropdownCorner = Instance.new("UICorner", dropdown)
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    
    local layout = Instance.new("UIListLayout", dropdown)
    layout.Padding = UDim.new(0, 2)

    local open = false
    
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            open = not open
            dropdown.Visible = open
            
            if open then
                local maxHeight = math.min(#options * 24 + 10, 150)
                dropdown.Size = UDim2.new(1, -10, 0, maxHeight)
                label.Text = title .. " ▲"
            else
                dropdown.Size = UDim2.new(1, -10, 0, 0)
                label.Text = title .. " ▼"
            end
        end
    end)

    for _, opt in ipairs(options) do
        local btn = Instance.new("TextButton", dropdown)
        btn.Size = UDim2.new(1, -10, 0, 22)
        btn.Position = UDim2.new(0, 5, 0, 0)
        btn.Text = opt
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.BackgroundColor3 = selectedTable[opt] and Color3.fromRGB(0, 140, 0) or Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.AutoButtonColor = false
        
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 4)
        
        btn.MouseButton1Click:Connect(function()
            selectedTable[opt] = not selectedTable[opt]
            btn.BackgroundColor3 = selectedTable[opt] and Color3.fromRGB(0, 140, 0) or Color3.fromRGB(50, 50, 50)
        end)
    end

    return container
end

---------------------------------------------#0Function button design -----------------------------------



-------------------------------------#1Main page or tab--------------------------------------
--// ===============================
--// AUTO CHOP TREE SYSTEM (WORKING)
--// ===============================
createSep("Auto Chop Tree", mainPage)

-- Variables
local isAutoChopEnabled = false
local treesData = {}
local selectedTreeType = "Small"
local autoChopConnection = nil
local currentTargetTree = nil
local autoClick = false
local clickDelay = 0.1

-- Enemy detection variables
local enemyDetectionRange = 10
local campfireLocation = Vector3.new(0, 369.5, 0)
local lastEnemyCheck = 0
local enemyCheckInterval = 0.5


-- Dynamic safety height based on tree size
local function getSafetyHeight(treeSizeNumber)
    if treeSizeNumber >= 0 and treeSizeNumber <= 4 then
        return 4  -- Lower height for small trees T0-T4
    elseif treeSizeNumber >= 5 and treeSizeNumber <= 6 then
        return 6  -- Medium height for medium trees T5-T6
    else
        return 7  -- Higher height for big trees T7-T8
    end
end

-- Function to get ground position below a point
local function getGroundPosition(position)
    local rayOrigin = Vector3.new(position.X, position.Y + 50, position.Z)
    local rayDirection = Vector3.new(0, -100, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if raycastResult then
        return raycastResult.Position
    else
        return Vector3.new(position.X, position.Y - 10, position.Z)
    end
end

-- Function to check for nearby enemies
local function checkForNearbyEnemies()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local playerPos = character.HumanoidRootPart.Position
    
    -- Check for Yeti in workspace.Live
    local liveFolder = workspace:FindFirstChild("Live")
    if liveFolder then
        local yeti = liveFolder:FindFirstChild("Yeti")
        if yeti then
            local bodyLow = yeti:FindFirstChild("Body_low")
            if bodyLow and bodyLow:IsA("BasePart") then
                local distance = (bodyLow.Position - playerPos).Magnitude
                if distance <= enemyDetectionRange then
                    return true, "Yeti", distance
                end
            end
        end
        
        -- Check for other enemies in Live folder
        for _, enemy in pairs(liveFolder:GetChildren()) do
            if enemy:IsA("Model") and enemy ~= player.Character then
                local humanoid = enemy:FindFirstChild("Humanoid")
                local rootPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso") or enemy:FindFirstChild("UpperTorso")
                
                if humanoid and rootPart and humanoid.Health > 0 then
                    local distance = (rootPart.Position - playerPos).Magnitude
                    if distance <= enemyDetectionRange then
                        return true, enemy.Name, distance
                    end
                end
            end
        end
    end
    
    return false
end

-- Function to teleport to campfire safely
local function teleportToCampfire()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    
    -- Get ground position at campfire and add safety height
    local groundPos = getGroundPosition(campfireLocation)
    local safeYPosition = groundPos.Y + 7
    
    -- Create safe position at campfire
    local safeCampfirePos = Vector3.new(campfireLocation.X, safeYPosition, campfireLocation.Z)
    
    -- Teleport player to campfire
    humanoidRootPart.CFrame = CFrame.new(safeCampfirePos)
    
    print("Enemy detected! Teleported to campfire for safety")
    
    return true
end

-- Function to send virtual mouse click
local function sendVirtualClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, false)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, false)
end

-- Function to scan all trees and their base parts
local function scanTrees()
    treesData = {}
    
    local treesFolder = workspace:FindFirstChild("Map")
    treesFolder = treesFolder and treesFolder:FindFirstChild("Trees")
    
    if not treesFolder then
        return false
    end
    
    for _, sizeFolder in pairs(treesFolder:GetChildren()) do
        if sizeFolder.Name:match("^T%d+$") then
            local treeModel = sizeFolder:FindFirstChild("Tree")
            if treeModel and treeModel:IsA("Model") then
                -- Find the base part (lowest Y position)
                local basePart = nil
                local lowestY = math.huge
                
                for _, part in pairs(treeModel:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local partY = part.Position.Y
                        if partY < lowestY then
                            lowestY = partY
                            basePart = part
                        end
                    end
                end
                
                if basePart then
                    local sizeNumber = tonumber(sizeFolder.Name:sub(2)) or 0
                    table.insert(treesData, {
                        size = sizeFolder.Name,
                        model = treeModel,
                        basePart = basePart,
                        position = basePart.Position,
                        sizeNumber = sizeNumber,
                        folder = sizeFolder
                    })
                end
            end
        end
    end
    
    return #treesData > 0
end

-- Function to get trees based on selected type
local function getTreesByType(treeType)
    local filteredTrees = {}
    
    for _, tree in pairs(treesData) do
        if treeType == "Small" then
            if tree.sizeNumber >= 0 and tree.sizeNumber <= 6 then
                table.insert(filteredTrees, tree)
            end
        elseif treeType == "Big" then
            if tree.sizeNumber >= 7 and tree.sizeNumber <= 8 then
                table.insert(filteredTrees, tree)
            end
        end
    end
    
    return filteredTrees
end

-- Function to check if tree still exists
local function isTreeValid(tree)
    if not tree then return false end
    if not tree.folder or not tree.folder.Parent then return false end
    if not tree.model or not tree.model.Parent then return false end
    if not tree.basePart or not tree.basePart.Parent then return false end
    return true
end

-- Function to teleport to nearest tree of selected type with dynamic safety height
local function teleportToNearestTree()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    -- Get distance settings
    local smallDistance = 5
    local bigDistance = 9
    
    local humanoidRootPart = character.HumanoidRootPart
    local currentPos = humanoidRootPart.Position
    
    local targetTrees = getTreesByType(selectedTreeType)
    if #targetTrees == 0 then
        return nil
    end
    
    local nearestTree = nil
    local nearestDistance = math.huge
    
    -- Find nearest valid tree of selected type
    for _, tree in pairs(targetTrees) do
        if isTreeValid(tree) then
            local distance = (tree.position - currentPos).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestTree = tree
            end
        end
    end
    
    if not nearestTree then
        return nil
    end
    
    -- Determine distance based on tree type
    local teleportDistance = selectedTreeType == "Small" and smallDistance or bigDistance
    
    -- Calculate teleport position
    local treePos = nearestTree.position
    local direction = (currentPos - treePos).Unit
    direction = Vector3.new(direction.X, 0, direction.Z) -- Flatten Y
    
    if direction.Magnitude < 0.1 then
        direction = Vector3.new(1, 0, 0) -- Default direction if too close
    else
        direction = direction.Unit
    end
    
    local teleportPos = treePos + (direction * teleportDistance)
    
    -- Get dynamic safety height based on tree size
    local dynamicSafetyHeight = getSafetyHeight(nearestTree.sizeNumber)
    
    -- Get ground position and add dynamic safety height
    local groundPos = getGroundPosition(teleportPos)
    local safeYPosition = groundPos.Y + dynamicSafetyHeight
    
    -- Use safe Y position
    teleportPos = Vector3.new(teleportPos.X, safeYPosition, teleportPos.Z)
    
    -- Teleport player facing the tree
    humanoidRootPart.CFrame = CFrame.new(teleportPos, Vector3.new(treePos.X, safeYPosition, treePos.Z))
    
    print(string.format("Auto TP to %s (%s) at distance: %d, height: %d", nearestTree.size, selectedTreeType, teleportDistance, dynamicSafetyHeight))
    return nearestTree
end

-- Function to check if player is near a tree
local function isPlayerNearTree()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local currentPos = character.HumanoidRootPart.Position
    local targetTrees = getTreesByType(selectedTreeType)
    
    for _, tree in pairs(targetTrees) do
        if isTreeValid(tree) then
            local distance = (tree.position - currentPos).Magnitude
            if distance < 20 then
                return true
            end
        end
    end
    
    return false
end

-- Function to maintain safe height while auto chopping
local function maintainSafeHeight()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    local currentPos = humanoidRootPart.Position
    
    -- Get ground position below player
    local groundPos = getGroundPosition(currentPos)
    
    -- Use dynamic safety height based on current target tree
    local currentSafetyHeight = 7 -- Default
    if currentTargetTree then
        currentSafetyHeight = getSafetyHeight(currentTargetTree.sizeNumber)
    end
    
    local safeYPosition = groundPos.Y + currentSafetyHeight
    
    -- If player is too low, lift them up
    if currentPos.Y < safeYPosition - 2 then
        local newPos = Vector3.new(currentPos.X, safeYPosition, currentPos.Z)
        humanoidRootPart.CFrame = CFrame.new(newPos, newPos + humanoidRootPart.CFrame.LookVector)
    end
end
--// ===============================
--// AUTO CHOP TREE SYSTEM (BUTTON VERSION)
--// ===============================

-- Function to start/stop auto chop
local function toggleAutoChop(state)
    if state then
        -- Start auto chop
        if #treesData == 0 then
            if not scanTrees() then
                print("No trees found. Cannot start auto chop")
                return false
            end
        end
        
        isAutoChopEnabled = true
        autoClick = true
        
        -- Auto chop loop
        autoChopConnection = RunService.Heartbeat:Connect(function()
            if isAutoChopEnabled then
                -- Check for enemies first (priority)
                local currentTime = tick()
                if currentTime - lastEnemyCheck >= enemyCheckInterval then
                    local enemyDetected, enemyName, distance = checkForNearbyEnemies()
                    lastEnemyCheck = currentTime
                    
                    if enemyDetected then
                        print(string.format("⚠️ %s detected! Distance: %.1f studs", enemyName, distance))
                        
                        -- Stop auto chop and teleport to campfire
                        toggleAutoChop(false)
                        teleportToCampfire()
                        return
                    end
                end
                
                -- Send virtual click if auto click is enabled
                if autoClick then
                    sendVirtualClick()
                end
                
                -- Maintain safe height
                maintainSafeHeight()
                
                -- Check if we need to find a new tree
                if not currentTargetTree or not isTreeValid(currentTargetTree) or not isPlayerNearTree() then
                    currentTargetTree = teleportToNearestTree()
                    if not currentTargetTree then
                        -- If no trees found, stop auto chop
                        toggleAutoChop(false)
                        print("No trees found. Auto Chop stopped")
                    end
                end
                
                task.wait(clickDelay)
            end
        end)
        
        print("Auto Chop started for " .. selectedTreeType .. " trees with dynamic safety height")
        return true
    else
        -- Stop auto chop
        if autoChopConnection then
            autoChopConnection:Disconnect()
            autoChopConnection = nil
        end
        autoClick = false
        isAutoChopEnabled = false
        currentTargetTree = nil
        print("Auto Chop stopped")
        return true
    end
end

-- Tree Type Selection
createButton("Small Trees", mainPage, function()
    selectedTreeType = "Small"
    print("Selected Small Trees")
    if isAutoChopEnabled then
        toggleAutoChop(false)
        task.wait(0.5)
        toggleAutoChop(true)
    end
end)

createButton("Big Trees", mainPage, function()
    selectedTreeType = "Big"
    print("Selected Big Trees")
    if isAutoChopEnabled then
        toggleAutoChop(false)
        task.wait(0.5)
        toggleAutoChop(true)
    end
end)

-- Auto Chop Button (Press to Start)
createButton("Auto Chop Tree (Press 'P' to Stop)", mainPage, function()
    if not isAutoChopEnabled then
        toggleAutoChop(true)
    else
        print("Auto Chop is already running! Press 'P' to stop.")
    end
end)

-- Stop Key (P key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.P then
        if isAutoChopEnabled then
            print("P key pressed - Stopping Auto Chop")
            toggleAutoChop(false)
        else
            print("Auto Chop is not running. Press the button to start.")
        end
    end
end)

-- Initial scan
scanTrees()
print("Auto Chop Tree system loaded!")

-- Auto-rescan trees periodically
task.spawn(function()
    while true do
        task.wait(10)
        if isAutoChopEnabled then
            scanTrees()
        end
    end
end)



-- Simple Center-Bottom Stop Button
local stopButtonGui = nil

local function createStopButton()
    if stopButtonGui then return end
    
    stopButtonGui = Instance.new("ScreenGui")
    stopButtonGui.Name = "AutoChopStopButton"
    stopButtonGui.ResetOnSpawn = false
    stopButtonGui.Parent = gethui() or game:GetService("CoreGui")
    
    local stopButton = Instance.new("TextButton")
    stopButton.Size = UDim2.new(0, 100, 0, 40)
    stopButton.Position = UDim2.new(0.5, -50, 1, -50) -- Center-bottom (50 pixels from bottom)
    stopButton.AnchorPoint = Vector2.new(0.5, 0) -- Anchor to center-bottom
    stopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    stopButton.Text = "STOP (P)"
    stopButton.TextColor3 = Color3.new(1, 1, 1)
    stopButton.TextSize = 14
    stopButton.Font = Enum.Font.GothamBold
    stopButton.Parent = stopButtonGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = stopButton
    
    stopButton.MouseButton1Click:Connect(function()
        if isAutoChopEnabled then
            toggleAutoChop(false)
        end
    end)
end

local function removeStopButton()
    if stopButtonGui then
        stopButtonGui:Destroy()
        stopButtonGui = nil
    end
end

-- Then modify your toggleAutoChop function:
local function toggleAutoChop(state)
    if state then
        -- ... your start code ...
        createStopButton() -- Show button when starting
    else
        -- ... your stop code ...
        removeStopButton() -- Hide button when stopping
    end
end







----------------------------------------------== AUTO EAT CORE ==--------------------
local autoEatEnabled = false
local hungerThreshold = 60

local function autoEatLoop()
	while autoEatEnabled do
		local hunger = hungerPath.Value
		if hunger < hungerThreshold then
			local lastPos = hrp.CFrame
			for _, foodName in ipairs(foodList) do
				if selectedFoods[foodName] then
					local part = getFoodPart(foodName)
					if part then
						local sel = highlight(part)
						teleportTo(part)
						task.wait(0.15)
						local start = os.clock()
						while hungerPath.Value < 100 and os.clock() - start < 5 and autoEatEnabled and part and part.Parent do
							pressE()
							task.wait(0.25)
						end
						if sel then sel:Destroy() end
						hrp.CFrame = lastPos
						task.wait(0.1)
					end
				end
			end
		end
		task.wait(0.5)
	end
end

--== UI ELEMENTS ==--
createSep("Auto Eat", mainPage)
-- Slider for hunger %
createSlider("Set Hunger %", mainPage, 1, 100, hungerThreshold, function(value)
	hungerThreshold = value
end)


createDropdownMulti("Food Selection", mainPage, foodList, selectedFoods)

-- Auto Eat Toggle
createSwitch("Auto Eat", mainPage, false, function(on)
	autoEatEnabled = on
	if on then
		task.spawn(autoEatLoop)
	end
end)
createSep("Not dying in cold again", mainPage)

-- Example usage in your GUI
--createSep("Player Settings", mainPage)



----------------------------

--// 🔥 Auto Teleport to Campfire When Temperature Is Low //-- 
-- Works with: createSwitch(name, parent, default, callback)
-- and createSlider(name, parent, min, max, default, callback)

local Workspace = game:GetService("Workspace")

-- 🌡️ Get current player temperature
local function getTemperature()
	local playerChar = Workspace:FindFirstChild("PlayerCharacter")
	if not playerChar then return nil end

	local playerData = playerChar:FindFirstChild(player.Name)
	if not playerData then return nil end

	local status = playerData:FindFirstChild("Status")
	if not status then return nil end

	local temp = status:FindFirstChild("Temperature")
	if not temp then return nil end

	return temp.Value
end

-- 🔥 Get Campfire Hitbox (exact path)
local function getCampfire()
	local baseCampfire = Workspace:FindFirstChild("Map")
	if not baseCampfire then return nil end

	baseCampfire = baseCampfire:FindFirstChild("BaseCampfire")
	if not baseCampfire then return nil end

	local hitbox = baseCampfire:FindFirstChild("BaseCampfire")
	if hitbox and hitbox:FindFirstChild("Hitbox") then
		return hitbox.Hitbox
	end

	return nil
end

-- Variables
local autoCampfireEnabled = false
local tempThreshold = 25

-- GUI Elements
createSlider("Temperature Threshold", mainPage, 0, 100, tempThreshold, function(value)
	tempThreshold = value
end)

createSwitch("Auto TP Campfire when cold", mainPage, false, function(on)
	autoCampfireEnabled = on

	if on then
		task.spawn(function()
			while autoCampfireEnabled do
				task.wait(2)
				local temp = getTemperature()

				if temp and temp < tempThreshold then
					local campfire = getCampfire()
					if campfire and campfire:IsA("BasePart") then
						char:PivotTo(campfire.CFrame + Vector3.new(0, 5, 0))
						print(("[🔥] Teleported to Campfire - Temp: %.1f"):format(temp))
					else
						warn("[AutoCampfire] Campfire Hitbox not found.")
					end
				end
			end
		end)
	else
		print("[AutoCampfire] Disabled")
	end
end)




--------------------------------------------#2Bring stuff --------------------------------------
-- ✅ Bring Item System - Logic Only
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer


-- === CATEGORY DATA ===
local categories = {
    Fuel = {"Log", "Frostling", "Coal", "Ashwood", "Gas Can", "Hot Core"},
    Food = {"Cooked Meat", "Raw Meat", "Raw Steak", "Bandage", "Snowberry", "Goldberry", "Camp Soup"},
    Weapon = {"Iron Axe", "Sniper Ammo", "Boomerang", "Wooden Club", "Pistol", "Spear", "Heavy Ammo", "LMG", "Rocket Launcher", "Rocket Ammo", "Frost Axe"},
    Item = {"Rabbit Pelt", "Side Bag", "Wolf Pelt", "Good Sack", "Better Flashlight", "Frostcore", "Old Flashlight", "Chainsaw", "Old Bag", "Dark Gem", "Mega Flashlight","Money"},
    Gear = {"Rusty Nail", "Scrap Bundle", "Beast Den Item", "Rusty Pipe", "Metal Beam","Rusty Sheet"},
    Armor = {"Wood Armor", "Iron Armor"}
}

-- === ITEM PART MAPPING ===
local itemParts = {
    ["Log"] = "PrimaryPart", ["Frostling"] = "Hitbox", ["Coal"] = "PrimaryPart", ["Ashwood"] = "PrimaryPart", ["Gas Can"] = "PrimaryPart", ["Hot Core"] = "PrimaryPart",
    ["Cooked Meat"] = "Hitbox", ["Raw Meat"] = "Hitbox", ["Raw Steak"] = "PrimaryPart", ["Bandage"] = "meds", ["Snowberry"] = "PrimaryPart", ["Goldberry"] = "PrimaryPart", ["Camp Soup"] = "Part",
    ["Iron Axe"] = "Iron Axe.001", ["Sniper Ammo"] = "PrimaryPart", ["Boomerang"] = "Handle", ["Wooden Club"] = "Handle", ["Pistol"] = "Handle", ["Spear"] = "Circle.003", ["Heavy Ammo"] = "PrimaryPart", ["LMG"] = "LMG.002", ["Rocket Launcher"] = "Cube.002", ["Rocket Ammo"] = "Top", ["Frost Axe"] = "Handle",
    ["Rabbit Pelt"] = "Part", ["Side Bag"] = "Handle", ["Wolf Pelt"] = "Part", ["Good Sack"] = "Handle", ["Better Flashlight"] = "Part", ["Frostcore"] = "PrimaryPart", ["Old Flashlight"] = "Circle.003", ["Chainsaw"] = "Circle.005", ["Old Bag"] = "Handle", ["Dark Gem"] = "PrimaryPart", ["Mega Flashlight"] = "Handle",["Money"] = "Part",
    ["Rusty Nail"] = "Hitbox", ["Scrap Bundle"] = "PrimaryPart", ["Beast Den Item"] = "ItemSpawnPoint", ["Rusty Pipe"] = "Hitbox", ["Metal Beam"] = "PrimaryPart", ["Rusty Sheet"] = "PrimaryPart",
    ["Wood Armor"] = "Part", ["Iron Armor"] = "PrimaryPart"
}

-- === BRING ITEMS FUNCTION ===
local function bringSelectedItems(selectedItems)
    local playerChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = playerChar:WaitForChild("HumanoidRootPart")
    local itemsFolder = Workspace:FindFirstChild("Items") or Workspace:FindFirstChild("Map")
    
    if not itemsFolder then 
        warn("❌ Items folder not found!") 
        return 0
    end

    local moved = 0
    
    for itemName, isSelected in pairs(selectedItems) do
        if isSelected and itemParts[itemName] then
            local partName = itemParts[itemName]
            for _, obj in ipairs(itemsFolder:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == partName and obj.Parent.Name == itemName then
                    obj.CFrame = hrp.CFrame + Vector3.new(0, 3 + moved * 0.3, 0)
                    moved += 1
                end
            end
        end
    end
    
    return moved
end
-- === SETUP BRING ITEM SYSTEM ===
local function setupBringItemSystem(parentPage)
    createSep("📦 Bring Items", parentPage)
    
    local selectedItems = {}
    
    -- Define default items you want selected
    local defaultItems = {
        "Log", "Coal", "Gas Can","Ashwood","Hot Core",           -- Fuel defaults
        "Raw Steak", "Raw Meat", "Bandage","Snowberry", "Goldberry",         -- Food defaults  
        "Iron Axe", "Sniper Ammo", "Boomerang", "Wooden Club", "Pistol", "Spear", "Heavy Ammo", "LMG", "Rocket Launcher", "Rocket Ammo", "Frost Axe",               -- Weapon defaults
        "Rabbit Pelt", "Side Bag", "Wolf Pelt","Good Sack","Better Flashlight","Frostcore","Old Flashlight","Chainsaw","Old Bag","Dark Gem","Mega Flashlight","Money",   -- Item defaults
        "Rusty Nail", "Scrap Bundle", "Beast Den Item", "Rusty Pipe","Rusty Sheet", "Metal Beam"
    }
    
    for categoryName, items in pairs(categories) do
        selectedItems[categoryName] = {}
        
        -- Pre-select default items for this category
        for _, itemName in ipairs(items) do
            if table.find(defaultItems, itemName) then
                selectedItems[categoryName][itemName] = true
            end
        end
        
        createDropdownMulti(
            "🎯 " .. categoryName,
            parentPage,
            items,
            selectedItems[categoryName]
        )
        
        createButton("⚡ Bring " .. categoryName, parentPage, function()
            local count = bringSelectedItems(selectedItems[categoryName])
            print("✅ Teleported " .. count .. " " .. categoryName .. " items!")
        end)
    end
    
    createButton("🚀 Bring All Selected Items", parentPage, function()
        local totalMoved = 0
        for categoryName, itemsTable in pairs(selectedItems) do
            local count = bringSelectedItems(itemsTable)
            totalMoved = totalMoved + count
        end
        print("✅ Teleported " .. totalMoved .. " total items!")
    end)
end

-- === USAGE ===
setupBringItemSystem(bringPage)
print("✅ Bring Item System Logic Loaded!")

---------------------------------------------------------------------------



---------------------------------#6Teleport page -----------------------------------


local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Function to teleport to BaseCampfire with custom height
local function teleportToCamp(height)
    local character = player.Character or player.CharacterAdded:Wait()
    local campfire = game:GetService("Workspace").Map.BaseCampfire.BaseCampfire.Center
    local targetCFrame = campfire.CFrame + Vector3.new(15, height, 0)
    character:WaitForChild("HumanoidRootPart").CFrame = targetCFrame
end

local function teleportToCraft(height)
    local character = player.Character or player.CharacterAdded:Wait()
    local craft = game:GetService("Workspace").Map.Crafting.CraftingRadius
    local targetCFrame = craft.CFrame + Vector3.new(0,height,0)
    character:WaitForChild("HumanoidRootPart").CFrame = targetCFrame
end

local function tpToSaddleWorkshop(height)
    local character = player.Character or player.CharacterAdded:Wait()
    local SaddleWorkshop = game:GetService("Workspace").Map.Events["Saddle Workshop"].Center
    local targetCFrame = SaddleWorkshop.CFrame + Vector3.new(0,height,0)
    character:WaitForChild("HumanoidRootPart").CFrame = targetCFrame
end


createButton("TP to Camp",teleportPage,function()
    print("tp to camp")
    teleportToCamp(15)
end)

createButton("TP to Craft", teleportPage,function()
    print("tp to craft successfull")
    teleportToCraft(10)
end)

createButton("TP to Saddle WorkShop",teleportPage, function()
    tpToSaddleWorkshop(5)
end)

-------------------------------#5Player Tab or Player page------------------------------


--// FOV Control (Slider + Switch) //--

local fovEnabled = false      -- whether FOV effect is active
local currentFov = 70         -- last slider value (default)
createSep("Player FOV Settings", playerPage)
-- Create the FOV Slider
createSlider("FOV", playerPage, 16, 120, currentFov, function(value)
	currentFov = value
	if fovEnabled then
		local camera = workspace.CurrentCamera
		if camera then
			camera.FieldOfView = value
		end
	end
end)

-- Create the FOV Switch
createSwitch("FOV", playerPage, false, function(on)
	fovEnabled = on
	local camera = workspace.CurrentCamera
	if camera then
		if on then
			-- Apply current FOV immediately when toggled ON
			camera.FieldOfView = currentFov
		else
			-- Reset to default when OFF (optional)
			camera.FieldOfView = 70
		end
	end
end)

--// Walk Speed Control (Slider + Switch) //--

local speedEnabled = false
local currentSpeed = 16 -- default walk speed
createSep("",playerPage)
-- Create Speed Slider
createSlider("Walk Speed", playerPage, 16, 100, currentSpeed, function(value)
	currentSpeed = value
	if speedEnabled then
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = value
		end
	end
end)


-- Create Speed Switch
createSwitch("Walk Speed", playerPage, false, function(on)
	speedEnabled = on
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		if on then
			-- Apply the slider value immediately
			hum.WalkSpeed = currentSpeed
		else
			-- Reset to normal when off
			hum.WalkSpeed = 16
		end
	end
end)



--// Teleport Walk with Adjustable Distance //--
createSep("TP walk", playerPage)
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local hrp = char:WaitForChild("HumanoidRootPart")

--== SETTINGS ==--
local tpWalkEnabled = false
local tpStep = 2 -- default teleport distance per step

--== UI CONTROLS ==--
createSwitch("TP Walk", playerPage, false, function(on)
	tpWalkEnabled = on
end)

createSlider("TP Walk Distance", playerPage, 1, 10, tpStep, function(value)
	tpStep = value
end)

--== UPDATE CHARACTER REF ON RESPAWN ==--
player.CharacterAdded:Connect(function(newChar)
	char = newChar
	hrp = newChar:WaitForChild("HumanoidRootPart")
end)

--== MAIN LOOP ==--
RunService.RenderStepped:Connect(function()
	if not tpWalkEnabled or not hrp then return end

	local moveDir = Vector3.zero
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.MoveDirection.Magnitude == 0 then return end

	moveDir = humanoid.MoveDirection * tpStep
	hrp.CFrame = hrp.CFrame + moveDir
end)


--// Night Vision / Full Bright //--

local Lighting = game:GetService("Lighting")
local nightVisionEnabled = false

-- Store original lighting values
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient
local originalOutdoorAmbient = Lighting.OutdoorAmbient
local originalColorShiftTop = Lighting.ColorShift_Top
local originalColorShiftBottom = Lighting.ColorShift_Bottom
local originalFogEnd = Lighting.FogEnd

createSep("Usefull", playerPage)
createSwitch("Night Vision (example)", playerPage, false, function(on)
	nightVisionEnabled = on

	if on then
		-- Enable full bright / night vision
		Lighting.Brightness = 5
		Lighting.Ambient = Color3.new(1, 1, 1)
		Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
		Lighting.ColorShift_Top = Color3.new(1, 1, 1)
		Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
		Lighting.FogEnd = 100000
	else
		-- Restore original lighting
		Lighting.Brightness = originalBrightness
		Lighting.Ambient = originalAmbient
		Lighting.OutdoorAmbient = originalOutdoorAmbient
		Lighting.ColorShift_Top = originalColorShiftTop
		Lighting.ColorShift_Bottom = originalColorShiftBottom
		Lighting.FogEnd = originalFogEnd
	end
end)


--// NoClip Toggle (Off by Default) //--

local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local noclipConnection = nil
local noclipEnabled = false

createSwitch("NoClip", playerPage, false, function(on)
	noclipEnabled = on

	if on then
		-- Start noclip loop
		noclipConnection = RunService.Stepped:Connect(function()
			local character = LocalPlayer.Character
			if character then
				for _, part in ipairs(character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		-- Stop noclip and restore collisions
		if noclipConnection then
			noclipConnection:Disconnect()
			noclipConnection = nil
		end

		local character = LocalPlayer.Character
		if character then
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end)



--// Infinite Jump Toggle (Off by Default) //--
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local infiniteJumpEnabled = false

createSwitch("Infinite Jump", playerPage, false, function(on)
	infiniteJumpEnabled = on
end)

--// Jump Handler //--
UserInputService.JumpRequest:Connect(function()
	if infiniteJumpEnabled then
		local character = LocalPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

--// Anti-AFK //--

-- Toggle switch in menu
createSwitch("Anti-AFK", playerPage, true, function(on)
	if on then
		-- Disconnect any previous connection
		if LocalPlayer.AntiAFKConnection then
			LocalPlayer.AntiAFKConnection:Disconnect()
			LocalPlayer.AntiAFKConnection = nil
		end

		-- Simulate input every 60 seconds
		LocalPlayer.AntiAFKConnection = LocalPlayer.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	else
		-- Turn off
		if LocalPlayer.AntiAFKConnection then
			LocalPlayer.AntiAFKConnection:Disconnect()
			LocalPlayer.AntiAFKConnection = nil
		end
	end
end)

---------------------------------------------------------------------------

-----------------------------#3Visual Page or Tab--------------------------

--// Legit teammate / character highlight system //-- 

local localPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

createSwitch("ESP Player", visualPage, false, function(on)
	if on then
		-- Enable highlights for other players (e.g., teammates)
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= localPlayer and plr.Character then
				local char = plr.Character
				if not char:FindFirstChild("TeamHighlight") then
					-- Highlight
					local hl = Instance.new("Highlight")
					hl.Name = "TeamHighlight"
					hl.FillColor = Color3.fromRGB(0, 255, 0)
					hl.OutlineColor = Color3.fromRGB(255, 255, 255)
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					hl.Parent = char

					-- Billboard name tag
					local gui = Instance.new("BillboardGui")
					gui.Name = "NameTag"
					gui.Size = UDim2.new(0, 100, 0, 20)
					gui.AlwaysOnTop = true
					gui.StudsOffset = Vector3.new(0, 3, 0)
					gui.Parent = char:WaitForChild("HumanoidRootPart")

					local label = Instance.new("TextLabel")
					label.Size = UDim2.new(1, 0, 1, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = Color3.new(0, 1, 0)
					label.TextScaled = true
					label.Font = Enum.Font.SourceSansBold
					label.TextStrokeTransparency = 0.5
					label.Text = plr.Name
					label.Parent = gui

					-- Update distance
					RunService.RenderStepped:Connect(function()
						if char:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
							local dist = (char.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
							label.Text = string.format("%s\n[%dm]", plr.Name, math.floor(dist))
						end
					end)
				end
			end
		end
	else
		-- Turn off all highlights
		for _, plr in pairs(Players:GetPlayers()) do
			if plr.Character then
				local h = plr.Character:FindFirstChild("TeamHighlight")
				local g = plr.Character:FindFirstChild("NameTag")
				if h then h:Destroy() end
				if g then g:Destroy() end
			end
		end
	end
end)

--// Legit item highlighting system //-- 

local Lighting = game:GetService("Lighting")

-- Table of allowed item paths (for your own game items)
local itemPaths = {
	"Workspace.Items.Rabbit Pelt.Part",
	"Workspace.Items.Side Bag.Handle",
	"Workspace.Items.Wolf Pelt.Part",
	"Workspace.Items.Good Sack.Handle",
	"Workspace.Items.Better Flashlight.Part",
	"Workspace.Items.Frostcore.PrimaryPart",
	"Workspace.Items.Old Flashlight.Circle.003",
	"Workspace.Items.Chainsaw.Circle.005",
	"Workspace.Items.Old Bag.Handle",
	"Workspace.Items.Dark Gem.PrimaryPart",
	"Workspace.Items.Mega Flashlight.Handle"
}

-- Function to safely get an instance from a path string
local function getInstanceFromPath(path)
	local parts = string.split(path, ".")
	local current = game
	for _, p in ipairs(parts) do
		current = current:FindFirstChild(p)
		if not current then
			return nil
		end
	end
	return current
end

-- Toggle logic
createSwitch("Item Highlights", visualPage, false, function(on)
	if on then
		for _, path in ipairs(itemPaths) do
			local item = getInstanceFromPath(path)
			if item and not item:FindFirstChild("ItemHighlight") then
				local hl = Instance.new("Highlight")
				hl.Name = "ItemHighlight"
				hl.FillColor = Color3.fromRGB(0, 255, 255)
				hl.OutlineColor = Color3.fromRGB(255, 255, 255)
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = item
			end
		end
	else
		for _, path in ipairs(itemPaths) do
			local item = getInstanceFromPath(path)
			if item then
				local hl = item:FindFirstChild("ItemHighlight")
				if hl then hl:Destroy() end
			end
		end
	end
end)

--// Legit fuel item highlight system //-- 

local Workspace = game:GetService("Workspace")

-- Table of your fuel item paths
local fuelPaths = {
	"Workspace.Items.Log.PrimaryPart",
	"Workspace.Items.Frostling.Hitbox",
	"Workspace.Items.Coal.PrimaryPart",
	"Workspace.Items.Ashwood.PrimaryPart",
	"Workspace.Items.Gas Can.PrimaryPart",
	"Workspace.Items.Hot Core.PrimaryPart"
}

-- Function to safely get an instance from a string path
local function getInstanceFromPath(path)
	local parts = string.split(path, ".")
	local current = game
	for _, p in ipairs(parts) do
		current = current:FindFirstChild(p)
		if not current then
			return nil
		end
	end
	return current
end

-- Attach to your UI switch
createSwitch("Fuel Highlights", visualPage, false, function(on)
	if on then
		for _, path in ipairs(fuelPaths) do
			local item = getInstanceFromPath(path)
			if item and not item:FindFirstChild("FuelHighlight") then
				local hl = Instance.new("Highlight")
				hl.Name = "FuelHighlight"
				hl.FillColor = Color3.fromRGB(255, 170, 0)  -- warm orange/yellow
				hl.OutlineColor = Color3.fromRGB(255, 255, 255)
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = item
			end
		end
	else
		for _, path in ipairs(fuelPaths) do
			local item = getInstanceFromPath(path)
			if item then
				local hl = item:FindFirstChild("FuelHighlight")
				if hl then hl:Destroy() end
			end
		end
	end
end)

--// Legit food item highlight system //--

local Workspace = game:GetService("Workspace")

local foodPaths = {
	"Workspace.Items.Cooked Meat.Hitbox",
	"Workspace.Items.Raw Meat.Hitbox",
	"Workspace.Items.Raw Steak.PrimaryPart",
	"Workspace.Items.Bandage.meds",
	"Workspace.Items.Snowberry.PrimaryPart",
	"Workspace.Items.Goldberry.PrimaryPart",
	"Workspace.Items.Camp Soup.Part"
}

local function getInstanceFromPath(path)
	local parts = string.split(path, ".")
	local current = game
	for _, p in ipairs(parts) do
		current = current:FindFirstChild(p)
		if not current then
			return nil
		end
	end
	return current
end

createSwitch("Food Highlights", visualPage, false, function(on)
	if on then
		for _, path in ipairs(foodPaths) do
			local item = getInstanceFromPath(path)
			if item and not item:FindFirstChild("FoodHighlight") then
				local hl = Instance.new("Highlight")
				hl.Name = "FoodHighlight"
				hl.FillColor = Color3.fromRGB(255, 100, 100) -- red tone
				hl.OutlineColor = Color3.fromRGB(255, 255, 255)
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = item
			end
		end
	else
		for _, path in ipairs(foodPaths) do
			local item = getInstanceFromPath(path)
			if item then
				local hl = item:FindFirstChild("FoodHighlight")
				if hl then hl:Destroy() end
			end
		end
	end
end)

--// Legit weapon item highlight system //--

local Workspace = game:GetService("Workspace")

local weaponPaths = {
	"Workspace.Items.Iron Axe.Iron Axe.001",
	"Workspace.Items.Sniper Ammo.PrimaryPart",
	"Workspace.Items.Boomerang.Handle",
	"Workspace.Items.Wooden Club.Handle",
	"Workspace.Items.Pistol.Handle",
	"Workspace.Items.Spear.Circle.003",
	"Workspace.Items.Heavy Ammo.PrimaryPart",
	"Workspace.Items.LMG.LMG.002",
	"Workspace.Items.Rocket Launcher.Cube.002",
	"Workspace.Items.Rocket Ammo.Top",
	"Workspace.Items.Frost Axe.Handle"
}

local function getInstanceFromPath(path)
	local parts = string.split(path, ".")
	local current = game
	for _, p in ipairs(parts) do
		current = current:FindFirstChild(p)
		if not current then
			return nil
		end
	end
	return current
end

createSwitch("Weapon Highlights", visualPage, false, function(on)
	if on then
		for _, path in ipairs(weaponPaths) do
			local item = getInstanceFromPath(path)
			if item and not item:FindFirstChild("WeaponHighlight") then
				local hl = Instance.new("Highlight")
				hl.Name = "WeaponHighlight"
				hl.FillColor = Color3.fromRGB(100, 255, 100) -- green tone
				hl.OutlineColor = Color3.fromRGB(255, 255, 255)
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = item
			end
		end
	else
		for _, path in ipairs(weaponPaths) do
			local item = getInstanceFromPath(path)
			if item then
				local hl = item:FindFirstChild("WeaponHighlight")
				if hl then hl:Destroy() end
			end
		end
	end
end)

--// Legit gear item highlight system //--

local Workspace = game:GetService("Workspace")

local gearPaths = {
	"Workspace.Items.Rusty Nail.Hitbox",
	"Workspace.Items.Scrap Bundle.PrimaryPart",
	"Workspace.Map.Events.Beast Den.ItemSpawnPoint",
	"Workspace.Items.Rusty Pipe.Hitbox",
	"Workspace.Items.Metal Beam.PrimaryPart",
	"Workspace.Items.Rusty Sheet.PrimaryPart"
}

local function getInstanceFromPath(path)
	local parts = string.split(path, ".")
	local current = game
	for _, p in ipairs(parts) do
		current = current:FindFirstChild(p)
		if not current then
			return nil
		end
	end
	return current
end

createSwitch("Gear Highlights", visualPage, false, function(on)
	if on then
		for _, path in ipairs(gearPaths) do
			local item = getInstanceFromPath(path)
			if item and not item:FindFirstChild("GearHighlight") then
				local hl = Instance.new("Highlight")
				hl.Name = "GearHighlight"
				hl.FillColor = Color3.fromRGB(100, 200, 255) -- blue tone
				hl.OutlineColor = Color3.fromRGB(255, 255, 255)
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = item
			end
		end
	else
		for _, path in ipairs(gearPaths) do
			local item = getInstanceFromPath(path)
			if item then
				local hl = item:FindFirstChild("GearHighlight")
				if hl then hl:Destroy() end
			end
		end
	end
end)









---------------------------------------------------------------
-- sample static label inside visual page
local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 320, 0, 28)
label.BackgroundTransparency = 1
label.Text = "ESP Settings Coming Soon..."
label.Font = Enum.Font.Gotham
label.TextSize = 15
label.TextColor3 = Color3.new(1,1,1)
label.Parent = visualPage

-- Controls behavior ----------------------------------------------------------------

local minimized = false
local fullscreen = false
local originalSize = main.Size
local originalPos = main.Position

-- Close
closeBtn.MouseButton1Click:Connect(function()
	main.Visible = false
end)


-- Minimize
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		-- hide side & content, shrink to title height
		for _, child in ipairs(contentArea:GetChildren()) do
			if child:IsA("GuiObject") then child.Visible = false end
		end
		tabs.Visible = false
		main.Size = UDim2.new(main.Size.X.Scale, main.Size.X.Offset, 0, 36)
	else
		-- restore visibility & size
		for _, child in ipairs(contentArea:GetChildren()) do
			if child:IsA("GuiObject") then child.Visible = true end
		end
		tabs.Visible = true
		main.Size = originalSize
	end
end)

-- Make only the title bar draggable (works for PC & Mobile)
local dragging = false
local dragStart, startPos
local UserInputService = game:GetService("UserInputService")

local function update(input)
	if dragging then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position

		-- Listen for movement while dragging
		local moveConn, endConn
		moveConn = UserInputService.InputChanged:Connect(function(moveInput)
			if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
				update(moveInput)
			end
		end)

		endConn = UserInputService.InputEnded:Connect(function(endInput)
			if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
				dragging = false
				moveConn:Disconnect()
				endConn:Disconnect()
			end
		end)
	end
end)

-- Fullscreen (smooth tween)
fullBtn.MouseButton1Click:Connect(function()
	fullscreen = not fullscreen
	if fullscreen then
		dragging = false -- stop dragging if switching
		main:TweenSizeAndPosition(
			UDim2.new(1, -16, 1, -16),
			UDim2.new(0, 8, 0, 8),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.28,
			true
		)
	else
		main:TweenSizeAndPosition(
			originalSize,
			originalPos,
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quad,
			0.28,
			true
		)
	end
end)


-- Toggle visibility / reopen with F2 key
local UIS = game:GetService("UserInputService")
local visible = true
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.M then
		visible = not visible
		main.Visible = visible
	end
end)

