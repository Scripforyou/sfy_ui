-- VoidwareUI Library
-- Simplified Reyfield-inspired UI library with responsive design

local VoidwareUI = {}
VoidwareUI.__index = VoidwareUI

-- Colors
local colors = {
    background = Color3.fromRGB(25, 25, 30),
    sidebar = Color3.fromRGB(35, 35, 40),
    accent = Color3.fromRGB(0, 170, 255),
    text = Color3.fromRGB(240, 240, 240),
    button = Color3.fromRGB(45, 45, 50),
    buttonHover = Color3.fromRGB(55, 55, 60)
}

-- Utility functions
local function isMobile()
    return game:GetService("UserInputService").TouchEnabled
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createPadding(parent, padding)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, padding)
    pad.PaddingRight = UDim.new(0, padding)
    pad.PaddingTop = UDim.new(0, padding)
    pad.PaddingBottom = UDim.new(0, padding)
    pad.Parent = parent
    return pad
end

-- Main library functions
function VoidwareUI.new()
    local self = setmetatable({}, VoidwareUI)
    
    self.tabs = {}
    self.currentTab = nil
    self.isMinimized = false
    
    self:createMainUI()
    
    return self
end

function VoidwareUI:createMainUI()
    -- Main ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "VoidwareUI"
    self.screenGui.ResetOnSpawn = false
    self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main container
    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Size = isMobile() and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 400, 0, 500)
    self.mainFrame.Position = isMobile() and UDim2.new(0, 0, 0, 0) or UDim2.new(0.5, -200, 0.5, -250)
    self.mainFrame.AnchorPoint = isMobile() and Vector2.new(0, 0) or Vector2.new(0.5, 0.5)
    self.mainFrame.BackgroundColor3 = colors.background
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.Parent = self.screenGui
    
    createCorner(self.mainFrame, 12)
    createPadding(self.mainFrame, 8)
    
    -- Sidebar
    self.sidebar = Instance.new("Frame")
    self.sidebar.Size = UDim2.new(0, 60, 1, 0)
    self.sidebar.Position = UDim2.new(0, 0, 0, 0)
    self.sidebar.BackgroundColor3 = colors.sidebar
    self.sidebar.BorderSizePixel = 0
    self.sidebar.Parent = self.mainFrame
    
    createCorner(self.sidebar, 8)
    
    -- Tabs container
    self.tabsContainer = Instance.new("ScrollingFrame")
    self.tabsContainer.Size = UDim2.new(1, 0, 1, -60)
    self.tabsContainer.Position = UDim2.new(0, 0, 0, 0)
    self.tabsContainer.BackgroundTransparency = 1
    self.tabsContainer.BorderSizePixel = 0
    self.tabsContainer.ScrollBarThickness = 0
    self.tabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.tabsContainer.Parent = self.sidebar
    
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.Padding = UDim.new(0, 8)
    tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabsLayout.Parent = self.tabsContainer
    
    -- Minimize button
    self.minimizeButton = Instance.new("TextButton")
    self.minimizeButton.Size = UDim2.new(0, 44, 0, 44)
    self.minimizeButton.Position = UDim2.new(0.5, -22, 1, -52)
    self.minimizeButton.AnchorPoint = Vector2.new(0.5, 0)
    self.minimizeButton.BackgroundColor3 = colors.button
    self.minimizeButton.Text = "≡"
    self.minimizeButton.TextColor3 = colors.text
    self.minimizeButton.TextSize = 16
    self.minimizeButton.BorderSizePixel = 0
    self.minimizeButton.Parent = self.sidebar
    
    createCorner(self.minimizeButton, 22)
    
    -- Content area
    self.contentFrame = Instance.new("Frame")
    self.contentFrame.Size = UDim2.new(1, -68, 1, 0)
    self.contentFrame.Position = UDim2.new(0, 68, 0, 0)
    self.contentFrame.BackgroundTransparency = 1
    self.contentFrame.BorderSizePixel = 0
    self.contentFrame.Parent = self.mainFrame
    
    -- Content container
    self.contentContainer = Instance.new("ScrollingFrame")
    self.contentContainer.Size = UDim2.new(1, 0, 1, 0)
    self.contentContainer.Position = UDim2.new(0, 0, 0, 0)
    self.contentContainer.BackgroundTransparency = 1
    self.contentContainer.BorderSizePixel = 0
    self.contentContainer.ScrollBarThickness = 4
    self.contentContainer.ScrollBarImageColor3 = colors.accent
    self.contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.contentContainer.Parent = self.contentFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = self.contentContainer
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.contentContainer.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y)
    end)
    
    -- Make draggable (desktop only)
    if not isMobile() then
        self:makeDraggable(self.mainFrame)
    end
    
    -- Minimize functionality
    self.minimizeButton.MouseButton1Click:Connect(function()
        self:toggleMinimize()
    end)
end

function VoidwareUI:makeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function VoidwareUI:toggleMinimize()
    self.isMinimized = not self.isMinimized
    
    if self.isMinimized then
        -- Minimize to circle/icon
        self.contentFrame.Visible = false
        self.sidebar.Size = UDim2.new(0, 60, 0, 60)
        self.mainFrame.Size = isMobile() and UDim2.new(0, 60, 0, 60) or UDim2.new(0, 60, 0, 60)
        self.minimizeButton.Text = "V"
    else
        -- Restore to full size
        self.contentFrame.Visible = true
        self.sidebar.Size = UDim2.new(0, 60, 1, 0)
        self.mainFrame.Size = isMobile() and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 400, 0, 500)
        self.minimizeButton.Text = "≡"
    end
end

-- Public API
function VoidwareUI:CreateTab(name, icon)
    local tab = {}
    tab.name = name
    tab.icon = icon
    tab.buttons = {}
    
    -- Tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 44, 0, 44)
    tabButton.BackgroundColor3 = colors.button
    tabButton.Text = icon or name:sub(1, 1)
    tabButton.TextColor3 = colors.text
    tabButton.TextSize = 14
    tabButton.BorderSizePixel = 0
    tabButton.Parent = self.tabsContainer
    
    createCorner(tabButton, 22)
    
    -- Tab content
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.Visible = false
    tabContent.Parent = self.contentContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Parent = tabContent
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.Size = UDim2.new(1, 0, 0, tabLayout.AbsoluteContentSize.Y)
    end)
    
    tab.button = tabButton
    tab.content = tabContent
    
    -- Update tabs container size
    local tabsLayout = self.tabsContainer:FindFirstChildOfClass("UIListLayout")
    self.tabsContainer.CanvasSize = UDim2.new(0, 0, 0, tabsLayout.AbsoluteContentSize.Y)
    
    -- Tab selection
    tabButton.MouseButton1Click:Connect(function()
        self:selectTab(tab)
    end)
    
    -- Hover effects
    tabButton.MouseEnter:Connect(function()
        if self.currentTab ~= tab then
            tabButton.BackgroundColor3 = colors.buttonHover
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.currentTab ~= tab then
            tabButton.BackgroundColor3 = colors.button
        end
    end)
    
    table.insert(self.tabs, tab)
    
    -- Select first tab automatically
    if #self.tabs == 1 then
        self:selectTab(tab)
    end
    
    return tab
end

function VoidwareUI:selectTab(tab)
    -- Hide all tab contents
    for _, otherTab in pairs(self.tabs) do
        otherTab.content.Visible = false
        otherTab.button.BackgroundColor3 = colors.button
    end
    
    -- Show selected tab content
    tab.content.Visible = true
    tab.button.BackgroundColor3 = colors.accent
    
    self.currentTab = tab
end

function VoidwareUI:CreateButton(tab, name, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -16, 0, 40)
    button.BackgroundColor3 = colors.button
    button.Text = name
    button.TextColor3 = colors.text
    button.TextSize = 14
    button.BorderSizePixel = 0
    button.Parent = tab.content
    
    createCorner(button, 6)
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = colors.buttonHover
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = colors.button
    end)
    
    -- Click functionality
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    table.insert(tab.buttons, button)
    
    return button
end

function VoidwareUI:CreateLabel(tab, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = colors.text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BorderSizePixel = 0
    label.Parent = tab.content
    
    return label
end

function VoidwareUI:CreateToggle(tab, name, default, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -16, 0, 40)
    toggle.BackgroundColor3 = colors.button
    toggle.Text = name
    toggle.TextColor3 = colors.text
    toggle.TextSize = 14
    toggle.TextXAlignment = Enum.TextXAlignment.Left
    toggle.BorderSizePixel = 0
    toggle.Parent = tab.content
    
    createCorner(toggle, 6)
    
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Size = UDim2.new(0, 20, 0, 20)
    toggleIndicator.Position = UDim2.new(1, -30, 0.5, -10)
    toggleIndicator.AnchorPoint = Vector2.new(1, 0.5)
    toggleIndicator.BackgroundColor3 = default and colors.accent or Color3.fromRGB(80, 80, 80)
    toggleIndicator.BorderSizePixel = 0
    toggleIndicator.Parent = toggle
    
    createCorner(toggleIndicator, 10)
    
    local state = default or false
    
    local function updateToggle()
        toggleIndicator.BackgroundColor3 = state and colors.accent or Color3.fromRGB(80, 80, 80)
        if callback then
            callback(state)
        end
    end
    
    toggle.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
    end)
    
    -- Hover effects
    toggle.MouseEnter:Connect(function()
        toggle.BackgroundColor3 = colors.buttonHover
    end)
    
    toggle.MouseLeave:Connect(function()
        toggle.BackgroundColor3 = colors.button
    end)
    
    updateToggle()
    
    return toggle
end

function VoidwareUI:Destroy()
    if self.screenGui then
        self.screenGui:Destroy()
    end
end

return VoidwareUI
