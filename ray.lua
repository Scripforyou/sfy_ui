-- SimpleUI Library
local SimpleUI = {}
SimpleUI.__index = SimpleUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create main window
function SimpleUI:CreateWindow(options)
    options = options or {}
    local self = setmetatable({}, SimpleUI)
    
    self.WindowName = options.Name or "SimpleUI"
    self.ThemeColor = options.ThemeColor or Color3.fromRGB(0, 85, 255)
    self.Elements = {}
    self.Tabs = {}
    
    -- Create screen GUI
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SimpleUI"
    self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 500, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = self.ThemeColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = self.MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.WindowName
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.Parent = TitleBar
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.Parent = TitleBar
    
    CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Tab buttons container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, 0, 0, 40)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 30)
    self.TabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.MainFrame
    
    -- Content frame
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Size = UDim2.new(1, 0, 1, -70)
    self.ContentFrame.Position = UDim2.new(0, 0, 0, 70)
    self.ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Parent = self.MainFrame
    
    -- Make draggable
    self:Draggify(TitleBar)
    
    return self
end

-- Make window draggable
function SimpleUI:Draggify(frame)
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = self.MainFrame.Position
            
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

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            self.MainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- Create tab
function SimpleUI:CreateTab(name, icon)
    local tab = {
        Name = name,
        Elements = {}
    }
    
    -- Tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 100, 1, 0)
    TabButton.Position = UDim2.new(0, (#self.Tabs * 100), 0, 0)
    TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabButton.BorderSizePixel = 0
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 12
    TabButton.Parent = self.TabContainer
    
    -- Tab content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 3
    TabContent.ScrollBarImageColor3 = self.ThemeColor
    TabContent.Visible = #self.Tabs == 0
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Parent = self.ContentFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = TabContent
    
    tab.Button = TabButton
    tab.Content = TabContent
    
    TabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    return tab
end

-- Switch tabs
function SimpleUI:SwitchTab(selectedTab)
    for _, tab in pairs(self.Tabs) do
        tab.Content.Visible = (tab == selectedTab)
        tab.Button.BackgroundColor3 = (tab == selectedTab) and self.ThemeColor or Color3.fromRGB(50, 50, 50)
    end
end

-- Create section
function SimpleUI:CreateSection(tab, name)
    local section = {}
    
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Size = UDim2.new(1, -20, 0, 30)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SectionFrame.BorderSizePixel = 0
    SectionFrame.Parent = tab.Content
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(1, -10, 1, 0)
    SectionLabel.Position = UDim2.new(0, 10, 0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = name
    SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextSize = 12
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    SectionLabel.Parent = SectionFrame
    
    section.Frame = SectionFrame
    section.Content = tab.Content
    return section
end

-- Create button
function SimpleUI:CreateButton(tab, name, callback)
    local button = {}
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.BorderSizePixel = 0
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 12
    Button.Parent = tab.Content
    
    Button.MouseButton1Click:Connect(function()
        callback()
    end)
    
    -- Hover effects
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = self.ThemeColor}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
    end)
    
    button.Button = Button
    table.insert(self.Elements, button)
    return button
end

-- Create toggle
function SimpleUI:CreateToggle(tab, name, default, callback)
    local toggle = {
        Value = default or false
    }
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = tab.Content
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextSize = 12
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(0.8, 0, 0.5, -10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Size = UDim2.new(0, 16, 1, -4)
    ToggleIndicator.Position = UDim2.new(0, 2, 0, 2)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleIndicator.BorderSizePixel = 0
    ToggleIndicator.Parent = ToggleButton
    
    function toggle:Set(value)
        toggle.Value = value
        if value then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = self.ThemeColor}):Play()
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0, 2)}):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
        end
        callback(value)
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggle:Set(not toggle.Value)
    end)
    
    -- Set initial state
    toggle:Set(default or false)
    
    table.insert(self.Elements, toggle)
    return toggle
end

-- Create slider
function SimpleUI:CreateSlider(tab, name, min, max, default, callback)
    local slider = {
        Value = default or min
    }
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -20, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = tab.Content
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -10, 0, 20)
    SliderLabel.Position = UDim2.new(0, 10, 0, 0)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name .. ": " .. tostring(default or min)
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextSize = 12
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, -20, 0, 4)
    SliderTrack.Position = UDim2.new(0, 10, 0, 30)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    SliderTrack.BorderSizePixel = 0
    SliderTrack.Parent = SliderFrame
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = self.ThemeColor
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderTrack
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Position = UDim2.new(0, -8, 0.5, -8)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.Parent = SliderTrack
    
    local dragging = false
    
    local function updateSlider(xPos)
        local relativeX = math.clamp(xPos - SliderTrack.AbsolutePosition.X, 0, SliderTrack.AbsoluteSize.X)
        local percentage = relativeX / SliderTrack.AbsoluteSize.X
        local value = math.floor(min + (max - min) * percentage)
        
        slider.Value = value
        SliderLabel.Text = name .. ": " .. tostring(value)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        SliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
        
        callback(value)
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)
    
    SliderTrack.MouseButton1Down:Connect(function(x, y)
        updateSlider(x)
    end)
    
    -- Set initial value
    updateSlider(SliderTrack.AbsolutePosition.X + ((default or min) - min) / (max - min) * SliderTrack.AbsoluteSize.X)
    
    table.insert(self.Elements, slider)
    return slider
end

-- Create label
function SimpleUI:CreateLabel(tab, text)
    local label = {}
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = tab.Content
    
    function label:Set(newText)
        Label.Text = newText
    end
    
    table.insert(self.Elements, label)
    return label
end

-- Create dropdown
function SimpleUI:CreateDropdown(tab, name, options, default, callback)
    local dropdown = {
        Value = default or options[1],
        Open = false
    }
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, -20, 0, 30)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = tab.Content
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 30)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Text = name .. ": " .. tostring(dropdown.Value)
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.TextSize = 12
    DropdownButton.Parent = DropdownFrame
    
    local OptionsFrame = Instance.new("Frame")
    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 0, 0, 30)
    OptionsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Parent = DropdownFrame
    
    local OptionsList = Instance.new("UIListLayout")
    OptionsList.Parent = OptionsFrame
    
    function dropdown:Toggle()
        dropdown.Open = not dropdown.Open
        if dropdown.Open then
            DropdownFrame.Size = UDim2.new(1, -20, 0, 30 + (#options * 25))
            OptionsFrame.Size = UDim2.new(1, 0, 0, #options * 25)
        else
            DropdownFrame.Size = UDim2.new(1, -20, 0, 30)
            OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
        end
    end
    
    function dropdown:Set(value)
        dropdown.Value = value
        DropdownButton.Text = name .. ": " .. tostring(value)
        callback(value)
        dropdown:Toggle()
    end
    
    -- Create option buttons
    for _, option in pairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 25)
        OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = tostring(option)
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.TextSize = 12
        OptionButton.Parent = OptionsFrame
        
        OptionButton.MouseButton1Click:Connect(function()
            dropdown:Set(option)
        end)
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        dropdown:Toggle()
    end)
    
    table.insert(self.Elements, dropdown)
    return dropdown
end

-- Toggle UI visibility
function SimpleUI:Toggle()
    self.MainFrame.Visible = not self.MainFrame.Visible
end

-- Destroy UI
function SimpleUI:Destroy()
    self.ScreenGui:Destroy()
end

return SimpleUI
