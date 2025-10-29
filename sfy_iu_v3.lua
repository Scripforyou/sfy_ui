-- Space Labs UI Menu System - Enhanced with Left Tabs
-- Complete library with all UI elements and left-side tab navigation

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

SpaceLabs.Config = {
    DefaultSize = isMobile and UDim2.new(0, 350, 0, 500) or UDim2.new(0, 600, 0, 500),
    TabWidth = isMobile and 80 or 100,  -- ✅ Use 'or' not ':'
    IconSize = UDim2.new(0, 50, 0, 50),
    TitleBarHeight = isMobile and 40 or 35,
    TabHeight = isMobile and 45 or 40  -- ✅ Use 'or' not ':'
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
    self.ContentScrollPositions = {} -- Store scroll position for each tab
    
    return self
end

-- Initialize the menu
function SpaceLabs:Init()
    if self.Enabled then return end
    
    self:CreateGUI()
    self:SetupConnections()
    self.Enabled = true
    
    print("🚀 Space Labs Menu initialized with Left Tabs!")
    print("📱 Mobile Optimized:", isMobile)
    print("🖥️  Desktop Optimized:", isDesktop)
    
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
    
    -- Minimized Icon
    local minimizedIcon = Instance.new("ImageButton")
    minimizedIcon.Name = "MinimizedIcon"
    minimizedIcon.Size = self.Config.IconSize
    minimizedIcon.Position = UDim2.new(0, 20, 0, 20)
    minimizedIcon.BackgroundColor3 = self.COLOR_PALETTE.PRIMARY
    minimizedIcon.BorderSizePixel = 0
    minimizedIcon.Image = "rbxassetid://10734951880"
    minimizedIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    minimizedIcon.Visible = false
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = minimizedIcon
    
    local iconShadow = Instance.new("ImageLabel")
    iconShadow.Name = "Shadow"
    iconShadow.Size = UDim2.new(1, 0, 1, 0)
    iconShadow.Position = UDim2.new(0, 0, 0, 0)
    iconShadow.BackgroundTransparency = 1
    iconShadow.Image = "rbxassetid://1316045217"
    iconShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    iconShadow.ImageTransparency = 0.8
    iconShadow.ScaleType = Enum.ScaleType.Slice
    iconShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    iconShadow.Parent = minimizedIcon
    
    self.MinimizedIcon = minimizedIcon
    minimizedIcon.Parent = screenGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = self.Config.DefaultSize
    mainFrame.Position = isMobile and UDim2.new(0.5, -175, 0.5, -250) or UDim2.new(0, 50, 0, 50)
    mainFrame.BackgroundColor3 = self.COLOR_PALETTE.BACKGROUND
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = true
    
    -- Store original properties
    self.OriginalSize = mainFrame.Size
    self.OriginalPosition = mainFrame.Position
    
    -- Space background effect
    local spaceBg = Instance.new("Frame")
    spaceBg.Name = "SpaceBackground"
    spaceBg.Size = UDim2.new(1, 0, 1, 0)
    spaceBg.BackgroundColor3 = self.COLOR_PALETTE.BACKGROUND
    spaceBg.BorderSizePixel = 0
    spaceBg.ZIndex = 0
    
    -- Add star effects
    for i = 1, 20 do
        local star = Instance.new("Frame")
        star.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
        star.Position = UDim2.new(0, math.random(0, 400), 0, math.random(0, 550))
        star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        star.BorderSizePixel = 0
        star.BackgroundTransparency = math.random(5, 8) / 10
        star.ZIndex = 1
        
        spawn(function()
            while star and star.Parent do
                local tween = TweenService:Create(star, TweenInfo.new(1), {BackgroundTransparency = math.random(3, 9) / 10})
                tween:Play()
                wait(math.random(1, 3))
            end
        end)
        
        star.Parent = spaceBg
    end
    
    spaceBg.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Glow effect
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 40, 1, 40)
    glow.Position = UDim2.new(0, -20, 0, -20)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://4996891970"
    glow.ImageColor3 = self.COLOR_PALETTE.PRIMARY
    glow.ImageTransparency = 0.8
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(20, 20, 280, 280)
    glow.ZIndex = -1
    glow.Parent = mainFrame
    
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
    
    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Size = UDim2.new(0, self.Config.TitleBarHeight, 0, self.Config.TitleBarHeight)
    minimizeBtn.Position = UDim2.new(1, -self.Config.TitleBarHeight, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = "🗕"
    minimizeBtn.TextColor3 = self.COLOR_PALETTE.TEXT
    minimizeBtn.TextSize = isMobile and 18 or 16
    minimizeBtn.Font = Enum.Font.Gotham
    minimizeBtn.ZIndex = 2
    minimizeBtn.Parent = titleBar
    
    -- Close Button for mobile
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, self.Config.TitleBarHeight, 0, self.Config.TitleBarHeight)
    closeBtn.Position = UDim2.new(1, -self.Config.TitleBarHeight * 2, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = self.COLOR_PALETTE.TEXT
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.ZIndex = 2
    closeBtn.Visible = isMobile
    closeBtn.Parent = titleBar
    
    -- Content Area with Left Tab Layout
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, -titleBar.Size.Y.Offset)
    contentFrame.Position = UDim2.new(0, 0, 0, titleBar.Size.Y.Offset)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2
    contentFrame.Parent = mainFrame
    
    self.ContentFrame = contentFrame
    
    -- Left Tabs Container (Scrollable)
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
    self.TitleBar = titleBar
    self.MinimizeBtn = minimizeBtn
    self.CloseBtn = closeBtn
    self.TabsContainer = tabsContainer
    self.PagesContainer = pagesContainer
    
    mainFrame.Parent = screenGui
end

-- Setup connections and events
function SpaceLabs:SetupConnections()
    -- Minimized icon functionality
    self.MinimizedIcon.MouseButton1Click:Connect(function()
        self:OpenFromIcon()
    end)
    
    if isMobile then
        self.MinimizedIcon.TouchTap:Connect(function()
            self:OpenFromIcon()
        end)
    end
    
    -- Close button functionality
    if isMobile then
        self.CloseBtn.MouseButton1Click:Connect(function()
            self:MinimizeToIcon()
        end)
        
        self.CloseBtn.TouchTap:Connect(function()
            self:MinimizeToIcon()
        end)
    end
    
    -- Minimize button functionality
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        self:MinimizeToIcon()
    end)
    
    if isMobile then
        self.MinimizeBtn.TouchTap:Connect(function()
            self:MinimizeToIcon()
        end)
    end
    
    -- Make ONLY the title bar draggable
    self:MakeTitleBarDraggable()
end

-- Make only the title bar draggable
function SpaceLabs:MakeTitleBarDraggable()
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Make minimized icon draggable
function SpaceLabs:MakeIconDraggable()
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        self.MinimizedIcon.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    self.MinimizedIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = self.MinimizedIcon.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.MinimizedIcon.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Minimize menu to circle icon
function SpaceLabs:MinimizeToIcon()
    if self.IsMinimized then return end
    
    self.IsMinimized = true
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- Store current position before minimizing
    self.MenuPositionBeforeMinimize = self.MainFrame.Position
    
    -- Calculate target position (current menu position)
    local targetPosition = self.MainFrame.Position
    local targetSize = self.Config.IconSize
    
    -- Tween to icon size at current position
    local tween1 = TweenService:Create(self.MainFrame, tweenInfo, {Size = targetSize})
    local tween2 = TweenService:Create(self.MainFrame, tweenInfo, {BackgroundTransparency = 1})
    
    tween1:Play()
    tween2:Play()
    
    -- Hide content during animation
    self.ContentFrame.Visible = false
    
    -- After animation, hide main frame and show icon
    delay(0.3, function()
        if self.MainFrame then
            self.MainFrame.Visible = false
            self.MinimizedIcon.Visible = true
            self.MinimizedIcon.Position = self.MainFrame.Position
            self.ContentFrame.Visible = true
            self.MainFrame.BackgroundTransparency = 0
            self.MainFrame.Size = self.OriginalSize
            
            -- Make icon draggable
            self:MakeIconDraggable()
        end
    end)
end

-- Open menu from circle icon
function SpaceLabs:OpenFromIcon()
    if not self.IsMinimized then return end
    
    self.IsMinimized = false
    
    -- Hide icon and show main frame at icon position
    self.MinimizedIcon.Visible = false
    self.MainFrame.Visible = true
    self.MainFrame.Position = self.MinimizedIcon.Position
    self.MainFrame.Size = self.Config.IconSize
    self.MainFrame.BackgroundTransparency = 1
    self.ContentFrame.Visible = false
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- Tween to original size and opacity
    local tween1 = TweenService:Create(self.MainFrame, tweenInfo, {Size = self.OriginalSize})
    local tween2 = TweenService:Create(self.MainFrame, tweenInfo, {BackgroundTransparency = 0})
    
    tween1:Play()
    tween2:Play()
    
    -- Show content after a short delay
    delay(0.2, function()
        if self.MainFrame then
            self.ContentFrame.Visible = true
        end
    end)
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
    
    local tabPage = Instance.new("ScrollingFrame")
    tabPage.Name = "Page_" .. tabName
    tabPage.Size = UDim2.new(1, 0, 1, 0)
    tabPage.Position = UDim2.new(0, 0, 0, 0)
    tabPage.BackgroundTransparency = 1
    tabPage.ScrollBarThickness = 6
    tabPage.ScrollBarImageColor3 = self.COLOR_PALETTE.PRIMARY
    tabPage.Visible = false
    tabPage.ZIndex = 2
    tabPage.Parent = self.PagesContainer
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, isMobile and 15 or 10)
    pageLayout.Parent = tabPage
    
    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingTop = UDim.new(0, isMobile and 15 or 10)
    pagePadding.PaddingLeft = UDim.new(0, isMobile and 15 or 10)
    pagePadding.PaddingRight = UDim.new(0, isMobile and 15 or 10)
    pagePadding.Parent = tabPage
    
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + (isMobile and 20 or 15))
    end)
    
    local tab = {
        Name = tabName,
        Button = tabButton,
        Page = tabPage,
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
    
    if isMobile then
        tabButton.TouchTap:Connect(function()
            self:SelectTab(tab)
        end)
    end
    
    tabButton.Parent = self.TabsContainer
    
    -- Update tabs container canvas size
    self.TabsContainer.CanvasSize = UDim2.new(0, 0, 0, (#self.Tabs * (self.Config.TabHeight + 2)) + 10)
    
    return tab
end

-- Fixed SelectTab method
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
    
    -- Restore scroll position for this tab
    if self.ContentScrollPositions[tab.Name] then
        tab.Page.CanvasPosition = Vector2.new(0, self.ContentScrollPositions[tab.Name])
    end
    
    -- Fixed: Use tab.Page instead of undefined tabPage
    tab.Page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        self.ContentScrollPositions[tab.Name] = tab.Page.CanvasPosition.Y
    end)
end

-- Enhanced UI Element Factory Methods with all original features

function SpaceLabs:CreateButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. text
    button.Size = UDim2.new(1, -20, 0, isMobile and 45 or 35)
    button.Position = UDim2.new(0, 10, 0, 0)
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
    
    -- Touch feedback for mobile
    local function onActivate()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = self.COLOR_PALETTE.PRIMARY_DARK}):Play()
        wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT}):Play()
        if callback then callback() end
    end
    
    button.MouseButton1Click:Connect(onActivate)
    if isMobile then
        button.TouchTap:Connect(onActivate)
    end
    
    button.Parent = tab.Page
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
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
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
    
    local isToggled = defaultValue
    
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
    if isMobile then
        toggleButton.TouchTap:Connect(toggleState)
    end
    
    toggleFrame.Parent = tab.Page
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
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
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
    local currentValue = defaultValue
    
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
        if isMobile then
            knob.BackgroundColor3 = self.COLOR_PALETTE.PRIMARY
        end
    end
    
    local function endDrag()
        isDragging = false
        if isMobile then
            knob.BackgroundColor3 = self.COLOR_PALETTE.TEXT
        end
    end
    
    local function processInput(input)
        if isDragging then
            local trackAbsolutePos = track.AbsolutePosition
            local trackAbsoluteSize = track.AbsoluteSize
            
            local relativeX
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                relativeX = (input.Position.X - trackAbsolutePos.X) / trackAbsoluteSize.X
            else
                relativeX = (input.Position.X - trackAbsolutePos.X) / trackAbsoluteSize.X
            end
            
            relativeX = math.clamp(relativeX, 0, 1)
            local value = minValue + (relativeX * (maxValue - minValue))
            updateSlider(value)
        end
    end
    
    knob.MouseButton1Down:Connect(beginDrag)
    if isMobile then
        knob.TouchTap:Connect(beginDrag)
    end
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            processInput(input)
        end
    end)
    
    sliderFrame.Parent = tab.Page
    table.insert(tab.Elements, sliderFrame)
    
    return sliderFrame
end

function SpaceLabs:CreateDropdown(tab, text, options, multiSelect, defaultValue, callback)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = "Dropdown_" .. text
    dropdownFrame.Size = UDim2.new(1, -20, 0, isMobile and 40 or 30)
    dropdownFrame.BackgroundTransparency = 1
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, 0, 0, isMobile and 40 or 30)
    dropdownButton.BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = ""
    dropdownButton.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = dropdownButton
    
    local buttonText = Instance.new("TextLabel")
    buttonText.Name = "ButtonText"
    buttonText.Size = UDim2.new(0.8, 0, 1, 0)
    buttonText.Position = UDim2.new(0, 10, 0, 0)
    buttonText.BackgroundTransparency = 1
    buttonText.Text = text
    buttonText.TextColor3 = self.COLOR_PALETTE.TEXT
    buttonText.TextSize = isMobile and 16 or 14
    buttonText.TextXAlignment = Enum.TextXAlignment.Left
    buttonText.Font = Enum.Font.Gotham
    buttonText.Parent = dropdownButton
    
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = self.COLOR_PALETTE.TEXT_SECONDARY
    arrow.TextSize = isMobile and 14 or 12
    arrow.Parent = dropdownButton
    
    dropdownButton.Parent = dropdownFrame
    
    local optionsFrame = Instance.new("ScrollingFrame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 0, isMobile and 45 or 35)
    optionsFrame.BackgroundColor3 = self.COLOR_PALETTE.SURFACE
    optionsFrame.BorderSizePixel = 0
    optionsFrame.ClipsDescendants = true
    optionsFrame.Visible = false
    optionsFrame.ScrollBarThickness = 4
    optionsFrame.ScrollBarImageColor3 = self.COLOR_PALETTE.PRIMARY
    optionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = UDim.new(0, 8)
    optionsCorner.Parent = optionsFrame
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.Parent = optionsFrame
    
    optionsFrame.Parent = dropdownFrame
    
    local isOpen = false
    local selectedOptions = {}
    
    -- Initialize selected options
    if multiSelect then
        for _, option in ipairs(options) do
            selectedOptions[option] = defaultValue and defaultValue[option] or false
        end
    else
        for _, option in ipairs(options) do
            selectedOptions[option] = false
        end
        if defaultValue then
            selectedOptions[defaultValue] = true
        end
    end
    
    local function updateButtonText()
        if multiSelect then
            local selectedCount = 0
            local selectedNames = {}
            for optionName, selected in pairs(selectedOptions) do
                if selected then
                    selectedCount = selectedCount + 1
                    table.insert(selectedNames, optionName)
                end
            end
            if selectedCount == 0 then
                buttonText.Text = text
            else
                buttonText.Text = text .. " (" .. table.concat(selectedNames, ", ") .. ")"
            end
        else
            for optionName, selected in pairs(selectedOptions) do
                if selected then
                    buttonText.Text = optionName
                    return
                end
            end
            buttonText.Text = text
        end
    end
    
    local function createOption(optionName)
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. optionName
        optionButton.Size = UDim2.new(1, -10, 0, isMobile and 35 or 25)
        optionButton.Position = UDim2.new(0, 5, 0, 0)
        optionButton.BackgroundColor3 = selectedOptions[optionName] and self.COLOR_PALETTE.SURFACE_LIGHT or self.COLOR_PALETTE.SURFACE
        optionButton.BorderSizePixel = 0
        optionButton.Text = ""
        optionButton.AutoButtonColor = false
        
        local optionText = Instance.new("TextLabel")
        optionText.Name = "OptionText"
        optionText.Size = UDim2.new(0.8, 0, 1, 0)
        optionText.Position = UDim2.new(0, 10, 0, 0)
        optionText.BackgroundTransparency = 1
        optionText.Text = optionName
        optionText.TextColor3 = self.COLOR_PALETTE.TEXT
        optionText.TextSize = isMobile and 14 or 12
        optionText.TextXAlignment = Enum.TextXAlignment.Left
        optionText.Font = Enum.Font.Gotham
        optionText.Parent = optionButton
        
        if multiSelect then
            local checkBox = Instance.new("Frame")
            checkBox.Name = "CheckBox"
            checkBox.Size = UDim2.new(0, isMobile and 18 or 15, 0, isMobile and 18 or 15)
            checkBox.Position = UDim2.new(1, isMobile and -25 or -20, 0, isMobile and 10 or 5)
            checkBox.BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT
            checkBox.BorderSizePixel = 0
            
            local checkCorner = Instance.new("UICorner")
            checkCorner.CornerRadius = UDim.new(0, 3)
            checkCorner.Parent = checkBox
            
            local checkMark = Instance.new("ImageLabel")
            checkMark.Name = "CheckMark"
            checkMark.Size = UDim2.new(0, isMobile and 12 or 10, 0, isMobile and 12 or 10)
            checkMark.Position = UDim2.new(0, isMobile and 3 or 2, 0, isMobile and 3 or 2)
            checkMark.BackgroundTransparency = 1
            checkMark.Image = "rbxassetid://10734951880"
            checkMark.ImageColor3 = self.COLOR_PALETTE.SUCCESS
            checkMark.Visible = selectedOptions[optionName]
            checkMark.Parent = checkBox
            
            checkBox.Parent = optionButton
        else
            local radioDot = Instance.new("Frame")
            radioDot.Name = "RadioDot"
            radioDot.Size = UDim2.new(0, isMobile and 12 or 10, 0, isMobile and 12 or 10)
            radioDot.Position = UDim2.new(1, isMobile and -25 or -20, 0, isMobile and 12 or 8)
            radioDot.BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT
            radioDot.BorderSizePixel = 0
            
            local radioCorner = Instance.new("UICorner")
            radioCorner.CornerRadius = UDim.new(0, 6)
            radioCorner.Parent = radioDot
            
            local innerDot = Instance.new("Frame")
            innerDot.Name = "InnerDot"
            innerDot.Size = UDim2.new(0, isMobile and 6 or 4, 0, isMobile and 6 or 4)
            innerDot.Position = UDim2.new(0, isMobile and 3 or 3, 0, isMobile and 3 or 3)
            innerDot.BackgroundColor3 = self.COLOR_PALETTE.PRIMARY
            innerDot.BorderSizePixel = 0
            innerDot.Visible = selectedOptions[optionName]
            
            local innerCorner = Instance.new("UICorner")
            innerCorner.CornerRadius = UDim.new(0, 3)
            innerCorner.Parent = innerDot
            
            innerDot.Parent = radioDot
            radioDot.Parent = optionButton
        end
        
        optionButton.MouseButton1Click:Connect(function()
            if multiSelect then
                selectedOptions[optionName] = not selectedOptions[optionName]
                local checkMark = optionButton:FindFirstChild("CheckBox"):FindFirstChild("CheckMark")
                checkMark.Visible = selectedOptions[optionName]
                
                if selectedOptions[optionName] then
                    optionButton.BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT
                else
                    optionButton.BackgroundColor3 = self.COLOR_PALETTE.SURFACE
                end
            else
                -- Single select - deselect all others and select this one
                for name, _ in pairs(selectedOptions) do
                    selectedOptions[name] = false
                    local otherOption = optionsFrame:FindFirstChild("Option_" .. name)
                    if otherOption then
                        otherOption.BackgroundColor3 = self.COLOR_PALETTE.SURFACE
                        local radioDot = otherOption:FindFirstChild("RadioDot")
                        if radioDot then
                            radioDot.InnerDot.Visible = false
                        end
                    end
                end
                selectedOptions[optionName] = true
                optionButton.BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT
                local radioDot = optionButton:FindFirstChild("RadioDot")
                if radioDot then
                    radioDot.InnerDot.Visible = true
                end
                
                -- Close dropdown after selection for single select
                isOpen = false
                optionsFrame.Visible = false
                arrow.Text = "▼"
                TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            end
            
            updateButtonText()
            if callback then callback(selectedOptions) end
        end)
        
        if isMobile then
            optionButton.TouchTap:Connect(function()
                optionButton.MouseButton1Click:Fire()
            end)
        end
        
        return optionButton
    end
    
    -- Populate options
    for _, option in ipairs(options) do
        local optionButton = createOption(option)
        optionButton.Parent = optionsFrame
    end
    
    optionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local contentSize = optionsLayout.AbsoluteContentSize
        optionsFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y)
        if isOpen then
            local maxHeight = isMobile and 200 or 150
            local newHeight = math.min(contentSize.Y, maxHeight)
            optionsFrame.Size = UDim2.new(1, 0, 0, newHeight)
        end
    end)
    
    local function toggleDropdown()
        isOpen = not isOpen
        
        if isOpen then
            optionsFrame.Visible = true
            arrow.Text = "▲"
            local contentSize = optionsLayout.AbsoluteContentSize
            local maxHeight = isMobile and 200 or 150
            local newHeight = math.min(contentSize.Y, maxHeight)
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, newHeight)}):Play()
        else
            arrow.Text = "▼"
            TweenService:Create(optionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.2)
            optionsFrame.Visible = false
        end
    end
    
    dropdownButton.MouseButton1Click:Connect(toggleDropdown)
    if isMobile then
        dropdownButton.TouchTap:Connect(toggleDropdown)
    end
    
    updateButtonText()
    
    dropdownFrame.Parent = tab.Page
    table.insert(tab.Elements, dropdownFrame)
    
    return dropdownFrame
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
    
    separatorFrame.Parent = tab.Page
    table.insert(tab.Elements, separatorFrame)
    
    return separatorFrame
end

function SpaceLabs:CreateLabel(tab, text, size)
    local label = Instance.new("TextLabel")
    label.Name = "Label_" .. text
    label.Size = UDim2.new(1, -20, 0, size or (isMobile and 25 or 20))
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.COLOR_PALETTE.TEXT
    label.TextSize = isMobile and 16 or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = tab.Page
    table.insert(tab.Elements, label)
    
    return label
end

-- Show/Hide methods
function SpaceLabs:Show()
    if self.IsMinimized then
        self:OpenFromIcon()
    else
        self.MainFrame.Visible = true
        self.MinimizedIcon.Visible = false
    end
end

function SpaceLabs:Hide()
    if not self.IsMinimized then
        self:MinimizeToIcon()
    else
        self.MinimizedIcon.Visible = false
    end
end

function SpaceLabs:Toggle()
    if self.IsMinimized then
        self:OpenFromIcon()
    else
        self:MinimizeToIcon()
    end
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
