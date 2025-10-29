-- Space Labs UI Menu System - FIXED ORDERING VERSION
local SpaceLabs = {}
SpaceLabs.__index = SpaceLabs

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Local variables
local player = Players.LocalPlayer

-- Detect device type
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local isDesktop = UserInputService.MouseEnabled

-- Space theme colors
SpaceLabs.COLOR_PALETTE = {
    BACKGROUND = Color3.fromRGB(13, 17, 33),
    SURFACE = Color3.fromRGB(22, 27, 49),
    SURFACE_LIGHT = Color3.fromRGB(33, 41, 69),
    PRIMARY = Color3.fromRGB(0, 162, 255),
    PRIMARY_DARK = Color3.fromRGB(0, 122, 204),
    ACCENT = Color3.fromRGB(147, 112, 255),
    TEXT = Color3.fromRGB(240, 243, 255),
    TEXT_SECONDARY = Color3.fromRGB(170, 178, 219),
    SUCCESS = Color3.fromRGB(0, 255, 163),
    WARNING = Color3.fromRGB(255, 193, 7),
    ERROR = Color3.fromRGB(255, 82, 82)
}

-- Configuration with left tab layout
SpaceLabs.Config = {
    DefaultSize = isMobile and UDim2.new(0, 350, 0, 500) or UDim2.new(0, 600, 0, 500),
    TabWidth = isMobile and 80 or 100,
    IconSize = UDim2.new(0, 50, 0, 50),
    TitleBarHeight = isMobile and 40 or 35,
    TabHeight = isMobile and 45 or 40
}

-- Create new instance
function SpaceLabs.new()
    local self = setmetatable({}, SpaceLabs)
    self.Enabled = false
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsMinimized = false
    self.Elements = {}
    self.TabScrollPosition = 0
    self.ContentScrollPositions = {}
    
    return self
end

-- Initialize the menu
function SpaceLabs:Init()
    if self.Enabled then return end
    
    self:CreateGUI()
    self:SetupConnections()
    self.Enabled = true
    
    print("🚀 Space Labs Menu initialized with Left Tabs!")
    
    return self
end

-- Create main GUI with left tab layout
function SpaceLabs:CreateGUI()
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SpaceLabsMenu"
    screenGui.Parent = player.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.ScreenGui = screenGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = self.Config.DefaultSize
    mainFrame.Position = isMobile and UDim2.new(0.5, -175, 0.5, -250) or UDim2.new(0, 50, 0, 50)
    mainFrame.BackgroundColor3 = self.COLOR_PALETTE.BACKGROUND
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = true
    
    self.OriginalSize = mainFrame.Size
    self.OriginalPosition = mainFrame.Position
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, self.Config.TitleBarHeight)
    titleBar.BackgroundColor3 = self.COLOR_PALETTE.SURFACE
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 2
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(0, 200, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "⚡ SPACE LABS"
    titleText.TextColor3 = self.COLOR_PALETTE.TEXT
    titleText.TextSize = isMobile and 16 or 14
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.ZIndex = 2
    titleText.Parent = titleBar
    
    -- Content Area with Left Tab Layout
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, -titleBar.Size.Y.Offset)
    contentFrame.Position = UDim2.new(0, 0, 0, titleBar.Size.Y.Offset)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2
    contentFrame.Parent = mainFrame
    
    self.ContentFrame = contentFrame
    
    -- Left Tabs Container
    local tabsContainer = Instance.new("ScrollingFrame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Size = UDim2.new(0, self.Config.TabWidth, 1, 0)
    tabsContainer.Position = UDim2.new(0, 0, 0, 0)
    tabsContainer.BackgroundColor3 = self.COLOR_PALETTE.SURFACE
    tabsContainer.BorderSizePixel = 0
    tabsContainer.ScrollBarThickness = 4
    tabsContainer.ScrollBarImageColor3 = self.COLOR_PALETTE.PRIMARY
    tabsContainer.ClipsDescendants = true
    tabsContainer.ZIndex = 2
    tabsContainer.Parent = contentFrame
    
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.Padding = UDim.new(0, 2)
    tabsLayout.Parent = tabsContainer
    
    -- Right Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -self.Config.TabWidth, 1, 0)
    contentArea.Position = UDim2.new(0, self.Config.TabWidth, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.ClipsDescendants = true
    contentArea.ZIndex = 2
    contentArea.Parent = contentFrame
    
    -- Pages Container
    local pagesContainer = Instance.new("Frame")
    pagesContainer.Name = "PagesContainer"
    pagesContainer.Size = UDim2.new(1, 0, 1, 0)
    pagesContainer.BackgroundTransparency = 1
    pagesContainer.ClipsDescendants = true
    pagesContainer.ZIndex = 2
    pagesContainer.Parent = contentArea
    
    self.MainFrame = mainFrame
    self.TabsContainer = tabsContainer
    self.PagesContainer = pagesContainer
    
    mainFrame.Parent = screenGui
end

-- Setup connections and events
function SpaceLabs:SetupConnections()
    -- Basic connections
end

-- Create a new tab with left-side layout
function SpaceLabs:CreateTab(tabName, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Tab_" .. tabName
    tabButton.Size = UDim2.new(1, -10, 0, self.Config.TabHeight)
    tabButton.Position = UDim2.new(0, 5, 0, (#self.Tabs * (self.Config.TabHeight + 2)))
    tabButton.BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT
    tabButton.BorderSizePixel = 0
    tabButton.Text = (icon or "•") .. " " .. tabName
    tabButton.TextColor3 = self.COLOR_PALETTE.TEXT_SECONDARY
    tabButton.TextSize = isMobile and 12 or 11
    tabButton.Font = Enum.Font.Gotham
    tabButton.AutoButtonColor = false
    tabButton.ZIndex = 2
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tabButton
    
    -- Create the tab page as a Frame with UIListLayout (NOT ScrollingFrame)
    local tabPage = Instance.new("Frame")
    tabPage.Name = "Page_" .. tabName
    tabPage.Size = UDim2.new(1, 0, 1, 0)
    tabPage.BackgroundTransparency = 1
    tabPage.Visible = false
    tabPage.ZIndex = 2
    tabPage.Parent = self.PagesContainer
    
    -- Create a ScrollingFrame INSIDE the tab page
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = self.COLOR_PALETTE.PRIMARY
    scrollFrame.Parent = tabPage
    
    -- This is the key: Use UIListLayout for proper ordering
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, isMobile and 15 or 10)
    pageLayout.Parent = scrollFrame
    
    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingTop = UDim.new(0, isMobile and 15 or 10)
    pagePadding.PaddingLeft = UDim.new(0, isMobile and 15 or 10)
    pagePadding.PaddingRight = UDim.new(0, isMobile and 15 or 10)
    pagePadding.Parent = scrollFrame
    
    -- Update canvas size when content changes
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + (isMobile and 20 or 15))
    end)
    
    local tab = {
        Name = tabName,
        Button = tabButton,
        Page = tabPage,
        ScrollFrame = scrollFrame, -- Store reference to scrolling frame
        Elements = {}
    }
    
    table.insert(self.Tabs, tab)
    
    -- Initialize scroll position for this tab
    self.ContentScrollPositions[tabName] = 0
    
    -- Select first tab by default
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    
    tabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    tabButton.Parent = self.TabsContainer
    
    -- Update tabs container canvas size
    self.TabsContainer.CanvasSize = UDim2.new(0, 0, 0, (#self.Tabs * (self.Config.TabHeight + 2)) + 10)
    
    return tab
end

-- SelectTab method
function SpaceLabs:SelectTab(tab)
    if self.CurrentTab then
        self.CurrentTab.Button.BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT
        self.CurrentTab.Button.TextColor3 = self.COLOR_PALETTE.TEXT_SECONDARY
        self.CurrentTab.Page.Visible = false
    end
    
    self.CurrentTab = tab
    tab.Button.BackgroundColor3 = self.COLOR_PALETTE.PRIMARY
    tab.Button.TextColor3 = self.COLOR_PALETTE.TEXT
    tab.Page.Visible = true
    
    -- Restore scroll position
    if self.ContentScrollPositions[tab.Name] then
        tab.ScrollFrame.CanvasPosition = Vector2.new(0, self.ContentScrollPositions[tab.Name])
    end
end

-- FIXED UI Element Methods - All elements now use proper UIListLayout ordering

function SpaceLabs:CreateButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. text
    button.Size = UDim2.new(1, -20, 0, isMobile and 45 or 35)
    button.BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = self.COLOR_PALETTE.TEXT
    button.TextSize = isMobile and 16 or 14
    button.Font = Enum.Font.Gotham
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    -- Hover effects for desktop
    if isDesktop then
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = self.COLOR_PALETTE.PRIMARY}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT}):Play()
        end)
    end
    
    -- Touch feedback
    local function onActivate()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = self.COLOR_PALETTE.PRIMARY_DARK}):Play()
        wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT}):Play()
        if callback then callback() end
    end
    
    button.MouseButton1Click:Connect(onActivate)
    
    -- Add to the SCROLL FRAME, not the page directly
    button.Parent = tab.ScrollFrame
    table.insert(tab.Elements, button)
    
    return button
end

function SpaceLabs:CreateToggle(tab, text, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "Toggle_" .. text
    toggleFrame.Size = UDim2.new(1, -20, 0, isMobile and 35 or 25)
    toggleFrame.BackgroundTransparency = 1
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "Label"
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = self.COLOR_PALETTE.TEXT
    toggleLabel.TextSize = isMobile and 16 or 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, isMobile and 50 or 40, 0, isMobile and 25 or 20)
    toggleButton.Position = UDim2.new(1, isMobile and -50 or -40, 0, 0)
    toggleButton.BackgroundColor3 = defaultValue and self.COLOR_PALETTE.SUCCESS or self.COLOR_PALETTE.SURFACE_LIGHT
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = toggleButton
    
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Name = "Knob"
    toggleKnob.Size = UDim2.new(0, isMobile and 21 or 16, 0, isMobile and 21 or 16)
    toggleKnob.Position = defaultValue and UDim2.new(1, isMobile and -23 or -18, 0, 2) or UDim2.new(0, 2, 0, 2)
    toggleKnob.BackgroundColor3 = self.COLOR_PALETTE.TEXT
    toggleKnob.BorderSizePixel = 0
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 8)
    knobCorner.Parent = toggleKnob
    
    toggleKnob.Parent = toggleButton
    toggleButton.Parent = toggleFrame
    
    local isToggled = defaultValue or false
    
    local function toggleState()
        isToggled = not isToggled
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if isToggled then
            local tween1 = TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = self.COLOR_PALETTE.SUCCESS})
            local tween2 = TweenService:Create(toggleKnob, tweenInfo, {Position = UDim2.new(1, isMobile and -23 or -18, 0, 2)})
            tween1:Play()
            tween2:Play()
        else
            local tween1 = TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT})
            local tween2 = TweenService:Create(toggleKnob, tweenInfo, {Position = UDim2.new(0, 2, 0, 2)})
            tween1:Play()
            tween2:Play()
        end
        
        if callback then callback(isToggled) end
    end
    
    toggleButton.MouseButton1Click:Connect(toggleState)
    
    toggleFrame.Parent = tab.ScrollFrame
    table.insert(tab.Elements, toggleFrame)
    
    return toggleFrame
end

function SpaceLabs:CreateSlider(tab, text, minValue, maxValue, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "Slider_" .. text
    sliderFrame.Size = UDim2.new(1, -20, 0, isMobile and 70 or 50)
    sliderFrame.BackgroundTransparency = 1
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Size = UDim2.new(1, 0, 0, isMobile and 25 or 20)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = text .. ": " .. defaultValue
    sliderLabel.TextColor3 = self.COLOR_PALETTE.TEXT
    sliderLabel.TextSize = isMobile and 16 or 14
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Parent = sliderFrame
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, isMobile and 8 or 6)
    track.Position = UDim2.new(0, 0, 0, isMobile and 30 or 25)
    track.BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT
    track.BorderSizePixel = 0
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 3)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
    fill.BackgroundColor3 = self.COLOR_PALETTE.PRIMARY
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    fill.Parent = track
    
    local knob = Instance.new("TextButton")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, isMobile and 20 or 16, 0, isMobile and 20 or 16)
    knob.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), isMobile and -10 or -8, 0, isMobile and -6 or -5)
    knob.BackgroundColor3 = self.COLOR_PALETTE.TEXT
    knob.BorderSizePixel = 0
    knob.Text = ""
    knob.AutoButtonColor = false
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 8)
    knobCorner.Parent = knob
    
    track.Parent = sliderFrame
    knob.Parent = sliderFrame
    
    local isDragging = false
    local currentValue = defaultValue or minValue
    
    local function updateSlider(value)
        local normalized = math.clamp((value - minValue) / (maxValue - minValue), 0, 1)
        fill.Size = UDim2.new(normalized, 0, 1, 0)
        knob.Position = UDim2.new(normalized, isMobile and -10 or -8, 0, isMobile and -6 or -5)
        currentValue = math.floor(value)
        sliderLabel.Text = text .. ": " .. currentValue
        if callback then callback(currentValue) end
    end
    
    local function beginDrag()
        isDragging = true
    end
    
    local function endDrag()
        isDragging = false
    end
    
    local function processInput(input)
        if isDragging then
            local trackAbsolutePos = track.AbsolutePosition
            local trackAbsoluteSize = track.AbsoluteSize
            
            local relativeX = (input.Position.X - trackAbsolutePos.X) / trackAbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            local value = minValue + (relativeX * (maxValue - minValue))
            updateSlider(value)
        end
    end
    
    knob.MouseButton1Down:Connect(beginDrag)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            processInput(input)
        end
    end)
    
    sliderFrame.Parent = tab.ScrollFrame
    table.insert(tab.Elements, sliderFrame)
    
    return sliderFrame
end

function SpaceLabs:CreateSeparator(tab, text)
    local separatorFrame = Instance.new("Frame")
    separatorFrame.Name = "Separator_" .. text
    separatorFrame.Size = UDim2.new(1, -20, 0, isMobile and 30 or 25)
    separatorFrame.BackgroundTransparency = 1
    
    -- Line
    local line = Instance.new("Frame")
    line.Name = "Line"
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT
    line.BorderSizePixel = 0
    line.Parent = separatorFrame
    
    -- Text label
    if text and text ~= "" then
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "Text"
        textLabel.Size = UDim2.new(0, 100, 0, 20)
        textLabel.Position = UDim2.new(0.5, -50, 0, 0)
        textLabel.BackgroundColor3 = self.COLOR_PALETTE.BACKGROUND
        textLabel.Text = text
        textLabel.TextColor3 = self.COLOR_PALETTE.TEXT_SECONDARY
        textLabel.TextSize = isMobile and 12 or 11
        textLabel.Font = Enum.Font.GothamBold
        textLabel.Parent = separatorFrame
    end
    
    separatorFrame.Parent = tab.ScrollFrame
    table.insert(tab.Elements, separatorFrame)
    
    return separatorFrame
end

function SpaceLabs:CreateLabel(tab, text, size)
    local label = Instance.new("TextLabel")
    label.Name = "Label_" .. text
    label.Size = UDim2.new(1, -20, 0, size or (isMobile and 25 or 20))
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.COLOR_PALETTE.TEXT
    label.TextSize = isMobile and 16 or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = tab.ScrollFrame
    table.insert(tab.Elements, label)
    
    return label
end

-- Show/Hide methods
function SpaceLabs:Show()
    self.MainFrame.Visible = true
end

function SpaceLabs:Hide()
    self.MainFrame.Visible = false
end

function SpaceLabs:Toggle()
    self.MainFrame.Visible = not self.MainFrame.Visible
end

-- Destroy method
function SpaceLabs:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    self.Enabled = false
end

-- Export the library
return SpaceLabs
