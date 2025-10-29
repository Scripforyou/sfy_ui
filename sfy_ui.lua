-- Roblox UI Menu System - Space Theme
-- Library-style implementation with mobile/desktop support

local SpaceLabs = {}
SpaceLabs.__index = SpaceLabs

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Local variables
local player = Players.LocalPlayer
local gui = nil

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

-- Configuration
SpaceLabs.Config = {
    DefaultSize = isMobile and UDim2.new(0, 350, 0, 500) or UDim2.new(0, 400, 0, 550),
    MinimizedSize = UDim2.new(0, 50, 0, 50),
    TitleBarHeight = isMobile and 40 or 35,
    TabBarHeight = isMobile and 50 or 40
}

-- Create new instance
function SpaceLabs.new()
    local self = setmetatable({}, SpaceLabs)
    self.Enabled = false
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsMinimized = false
    self.Elements = {}
    
    return self
end

-- Initialize the menu
function SpaceLabs:Init()
    if self.Enabled then return end
    
    self:CreateGUI()
    self:SetupConnections()
    self.Enabled = true
    
    print("🚀 Space Labs Menu initialized!")
    print("📱 Mobile Optimized:", isMobile)
    print("🖥️  Desktop Optimized:", isDesktop)
    
    return self
end

-- Create main GUI
function SpaceLabs:CreateGUI()
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SpaceLabsMenu"
    screenGui.Parent = player.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    self.ScreenGui = screenGui
    
    -- Mobile minimized icon (always visible on mobile)
    local mobileIcon = Instance.new("ImageButton")
    mobileIcon.Name = "MobileIcon"
    mobileIcon.Size = self.Config.MinimizedSize
    mobileIcon.Position = UDim2.new(0, 20, 0, 20)
    mobileIcon.BackgroundColor3 = self.COLOR_PALETTE.PRIMARY
    mobileIcon.BorderSizePixel = 0
    mobileIcon.Visible = isMobile
    mobileIcon.Image = "rbxassetid://10734951880" -- Star icon
    mobileIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 12)
    iconCorner.Parent = mobileIcon
    
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
    iconShadow.Parent = mobileIcon
    
    self.MobileIcon = mobileIcon
    mobileIcon.Parent = screenGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = self.Config.DefaultSize
    mainFrame.Position = isMobile and UDim2.new(0.5, -175, 0.5, -250) or UDim2.new(0, 50, 0, 50)
    mainFrame.BackgroundColor3 = self.COLOR_PALETTE.BACKGROUND
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = not isMobile -- Hidden on mobile by default
    
    -- Space background effect
    local spaceBg = Instance.new("Frame")
    spaceBg.Name = "SpaceBackground"
    spaceBg.Size = UDim2.new(1, 0, 1, 0)
    spaceBg.BackgroundColor3 = self.COLOR_PALETTE.BACKGROUND
    spaceBg.BorderSizePixel = 0
    spaceBg.ZIndex = 0
    
    -- Add some star effects
    for i = 1, 20 do
        local star = Instance.new("Frame")
        star.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
        star.Position = UDim2.new(0, math.random(0, 400), 0, math.random(0, 550))
        star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        star.BorderSizePixel = 0
        star.BackgroundTransparency = math.random(5, 8) / 10
        star.ZIndex = 1
        
        -- Animate stars
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
    
    -- Title Text with space theme
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
    
    -- Close Button (mobile only)
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
    
    -- Content Area
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, -titleBar.Size.Y.Offset)
    contentFrame.Position = UDim2.new(0, 0, 0, titleBar.Size.Y.Offset)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2
    contentFrame.Parent = mainFrame
    
    -- Tabs Container
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Size = UDim2.new(1, 0, 0, self.Config.TabBarHeight)
    tabsContainer.BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT
    tabsContainer.BorderSizePixel = 0
    tabsContainer.ZIndex = 2
    tabsContainer.Parent = contentFrame
    
    -- Pages Container
    local pagesContainer = Instance.new("Frame")
    pagesContainer.Name = "PagesContainer"
    pagesContainer.Size = UDim2.new(1, 0, 1, -tabsContainer.Size.Y.Offset)
    pagesContainer.Position = UDim2.new(0, 0, 0, tabsContainer.Size.Y.Offset)
    pagesContainer.BackgroundTransparency = 1
    pagesContainer.ClipsDescendants = true
    pagesContainer.ZIndex = 2
    pagesContainer.Parent = contentFrame
    
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
    -- Mobile icon functionality
    if isMobile then
        self.MobileIcon.MouseButton1Click:Connect(function()
            self:ToggleMobileMenu()
        end)
        
        self.MobileIcon.TouchTap:Connect(function()
            self:ToggleMobileMenu()
        end)
        
        -- Make mobile icon draggable
        self:MakeDraggable(self.MobileIcon)
    end
    
    -- Close button functionality (mobile)
    if isMobile then
        self.CloseBtn.MouseButton1Click:Connect(function()
            self:ToggleMobileMenu()
        end)
        
        self.CloseBtn.TouchTap:Connect(function()
            self:ToggleMobileMenu()
        end)
    end
    
    -- Minimize functionality
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    if isMobile then
        self.MinimizeBtn.TouchTap:Connect(function()
            self:ToggleMinimize()
        end)
    end
    
    -- Make window draggable
    self:MakeDraggable(self.TitleBar)
end

-- Toggle mobile menu visibility
function SpaceLabs:ToggleMobileMenu()
    if self.IsMinimized then
        self:ToggleMinimize() -- Unminimize first if minimized
    end
    
    local isVisible = self.MainFrame.Visible
    self.MainFrame.Visible = not isVisible
    self.MobileIcon.Visible = isVisible
end

-- Toggle minimize state
function SpaceLabs:ToggleMinimize()
    self.IsMinimized = not self.IsMinimized
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if self.IsMinimized then
        -- Store current position and size
        self.OriginalPosition = self.MainFrame.Position
        self.OriginalSize = self.MainFrame.Size
        
        -- Tween to mobile icon position and size
        local targetPosition = self.MobileIcon.Position
        local targetSize = self.Config.MinimizedSize
        
        local tween1 = TweenService:Create(self.MainFrame, tweenInfo, {Position = targetPosition})
        local tween2 = TweenService:Create(self.MainFrame, tweenInfo, {Size = targetSize})
        
        tween1:Play()
        tween2:Play()
        
        self.MinimizeBtn.Text = "🗖"
        
        -- Hide content
        self.ContentFrame.Visible = false
        
    else
        -- Restore original position and size
        local tween1 = TweenService:Create(self.MainFrame, tweenInfo, {Position = self.OriginalPosition or UDim2.new(0, 50, 0, 50)})
        local tween2 = TweenService:Create(self.MainFrame, tweenInfo, {Size = self.OriginalSize or self.Config.DefaultSize})
        
        tween1:Play()
        tween2:Play()
        
        self.MinimizeBtn.Text = "🗕"
        
        -- Show content
        self.ContentFrame.Visible = true
    end
end

-- Make element draggable
function SpaceLabs:MakeDraggable(element)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        element.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    element.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (isMobile and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = element.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    element.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Create a new tab
function SpaceLabs:CreateTab(tabName, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Tab_" .. tabName
    tabButton.Size = UDim2.new(0, isMobile and 70 or 80, 1, 0)
    tabButton.Position = UDim2.new(0, (#self.Tabs * (isMobile and 70 or 80)), 0, 0)
    tabButton.BackgroundColor3 = self.COLOR_PALETTE.SURFACE_LIGHT
    tabButton.BorderSizePixel = 0
    tabButton.Text = (icon or "") .. " " .. tabName
    tabButton.TextColor3 = self.COLOR_PALETTE.TEXT_SECONDARY
    tabButton.TextSize = isMobile and 12 or 11
    tabButton.Font = Enum.Font.Gotham
    tabButton.AutoButtonColor = false
    tabButton.ZIndex = 2
    tabButton.Parent = self.TabsContainer
    
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
    
    return tab
end

-- Select a tab
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
end

-- UI Element Factory Methods
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

-- Show/Hide methods
function SpaceLabs:Show()
    if self.MainFrame then
        self.MainFrame.Visible = true
        if isMobile then
            self.MobileIcon.Visible = false
        end
    end
end

function SpaceLabs:Hide()
    if self.MainFrame then
        self.MainFrame.Visible = false
        if isMobile then
            self.MobileIcon.Visible = true
        end
    end
end

function SpaceLabs:Toggle()
    if self.MainFrame.Visible then
        self:Hide()
    else
        self:Show()
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
