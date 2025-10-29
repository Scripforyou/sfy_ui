--[[
    SpaceLabs UI Library
    Author: SpaceLabs
    Description: Advanced Roblox UI library with space theme, responsive design, and mobile support
    GitHub: https://github.com/spacelabs/ui-library
    Example Usage:
        local SpaceLabs = loadstring(game:HttpGet("https://raw.githubusercontent.com/spacelabs/ui-library/main/main.lua"))()
        local window = SpaceLabs:CreateWindow("My Menu")
        local tab = window:CreateTab("Main")
        tab:CreateToggle("Enable Feature", false, function(state) print("Toggle:", state) end)
]]

local SpaceLabs = {}
SpaceLabs.__index = SpaceLabs

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Theme
local COLOR_PALETTE = {
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

-- Utility Functions
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

local function createRoundedFrame(cornerRadius)
    local frame = Instance.new("Frame")
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius)
    corner.Parent = frame
    return frame
end

local function createStroke(target, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = color or COLOR_PALETTE.PRIMARY
    stroke.Parent = target
    return stroke
end

-- Window Class
local Window = {}
Window.__index = Window

function Window:Minimize()
    if self.Minimized then return end
    
    self.Minimized = true
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if isMobile() then
        self.MainFrame.Visible = false
        self.MobileIcon.Visible = true
    else
        TweenService:Create(self.MainFrame, tweenInfo, {
            Size = UDim2.new(0, self.MainFrame.Size.X.Offset, 0, self.TitleBar.Size.Y.Offset)
        }):Play()
        self.MinimizeButton.Text = "+"
    end
end

function Window:Maximize()
    if not self.Minimized then return end
    
    self.Minimized = false
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if isMobile() then
        self.MainFrame.Visible = true
        self.MobileIcon.Visible = false
    else
        TweenService:Create(self.MainFrame, tweenInfo, {
            Size = self.OriginalSize
        }):Play()
        self.MinimizeButton.Text = "-"
    end
end

function Window:CreateTab(name, icon)
    local Tab = {}
    Tab.Name = name
    Tab.Icon = icon or "📄"
    
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Tab_" .. name
    tabButton.Size = UDim2.new(1, -10, 0, isMobile() and 50 or 40)
    tabButton.Position = UDim2.new(0, 5, 0, (#self.Tabs * (isMobile() and 55 or 45)) + 5)
    tabButton.BackgroundColor3 = COLOR_PALETTE.SURFACE_LIGHT
    tabButton.BorderSizePixel = 0
    tabButton.Text = " " .. icon .. " " .. name
    tabButton.TextColor3 = COLOR_PALETTE.TEXT_SECONDARY
    tabButton.TextSize = isMobile() and 14 or 12
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    tabButton.Font = Enum.Font.Gotham
    tabButton.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = tabButton
    
    -- Create tab page
    local tabPage = Instance.new("ScrollingFrame")
    tabPage.Name = "Page_" .. name
    tabPage.Size = UDim2.new(1, 0, 1, 0)
    tabPage.Position = UDim2.new(0, 0, 0, 0)
    tabPage.BackgroundTransparency = 1
    tabPage.ScrollBarThickness = 6
    tabPage.ScrollBarImageColor3 = COLOR_PALETTE.PRIMARY
    tabPage.Visible = false
    tabPage.ZIndex = 2
    tabPage.Parent = self.PagesContainer
    
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, isMobile() and 15 or 10)
    pageLayout.Parent = tabPage
    
    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingTop = UDim.new(0, isMobile() and 15 or 10)
    pagePadding.PaddingLeft = UDim.new(0, isMobile() and 15 or 10)
    pagePadding.PaddingRight = UDim.new(0, isMobile() and 15 or 10)
    pagePadding.Parent = tabPage
    
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabPage.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + (isMobile() and 20 or 15))
    end)
    
    tabButton.Parent = self.TabsContainer
    tabPage.Parent = self.PagesContainer
    
    -- Tab selection logic
    tabButton.MouseButton1Click:Connect(function()
        if self.CurrentTab then
            self.CurrentTab.Button.BackgroundColor3 = COLOR_PALETTE.SURFACE_LIGHT
            self.CurrentTab.Button.TextColor3 = COLOR_PALETTE.TEXT_SECONDARY
            self.CurrentTab.Page.Visible = false
        end
        
        self.CurrentTab = {Button = tabButton, Page = tabPage}
        tabButton.BackgroundColor3 = COLOR_PALETTE.PRIMARY
        tabButton.TextColor3 = COLOR_PALETTE.TEXT
        tabPage.Visible = true
    end)
    
    if isMobile() then
        tabButton.TouchTap:Connect(function()
            tabButton.MouseButton1Click:Fire()
        end)
    end
    
    -- UI Element Methods
    function Tab:CreateButton(text, callback)
        local button = Instance.new("TextButton")
        button.Name = "Button_" .. text
        button.Size = UDim2.new(1, -20, 0, isMobile() and 45 or 35)
        button.Position = UDim2.new(0, 10, 0, 0)
        button.BackgroundColor3 = COLOR_PALETTE.SURFACE_LIGHT
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = COLOR_PALETTE.TEXT
        button.TextSize = isMobile() and 16 or 14
        button.Font = Enum.Font.Gotham
        button.AutoButtonColor = false
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = button
        
        -- Hover effects
        if not isMobile() then
            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = COLOR_PALETTE.PRIMARY}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = COLOR_PALETTE.SURFACE_LIGHT}):Play()
            end)
        end
        
        -- Click handler
        local function onActivate()
            TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = COLOR_PALETTE.PRIMARY_DARK}):Play()
            wait(0.1)
            TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = COLOR_PALETTE.SURFACE_LIGHT}):Play()
            callback()
        end
        
        button.MouseButton1Click:Connect(onActivate)
        if isMobile() then
            button.TouchTap:Connect(onActivate)
        end
        
        button.Parent = tabPage
        return button
    end
    
    function Tab:CreateToggle(text, defaultValue, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle_" .. text
        toggleFrame.Size = UDim2.new(1, -20, 0, isMobile() and 35 or 25)
        toggleFrame.BackgroundTransparency = 1
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Name = "Label"
        toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        toggleLabel.Position = UDim2.new(0, 0, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = text
        toggleLabel.TextColor3 = COLOR_PALETTE.TEXT
        toggleLabel.TextSize = isMobile() and 16 or 14
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, isMobile() and 50 or 40, 0, isMobile() and 25 or 20)
        toggleButton.Position = UDim2.new(1, isMobile() and -50 or -40, 0, 0)
        toggleButton.BackgroundColor3 = defaultValue and COLOR_PALETTE.SUCCESS or COLOR_PALETTE.SURFACE_LIGHT
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = ""
        toggleButton.AutoButtonColor = false
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = toggleButton
        
        local toggleKnob = Instance.new("Frame")
        toggleKnob.Name = "Knob"
        toggleKnob.Size = UDim2.new(0, isMobile() and 21 or 16, 0, isMobile() and 21 or 16)
        toggleKnob.Position = defaultValue and UDim2.new(1, isMobile() and -23 or -18, 0, 2) or UDim2.new(0, 2, 0, 2)
        toggleKnob.BackgroundColor3 = COLOR_PALETTE.TEXT
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
                local tween1 = TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = COLOR_PALETTE.SUCCESS})
                local tween2 = TweenService:Create(toggleKnob, tweenInfo, {Position = UDim2.new(1, isMobile() and -23 or -18, 0, 2)})
                tween1:Play()
                tween2:Play()
            else
                local tween1 = TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = COLOR_PALETTE.SURFACE_LIGHT})
                local tween2 = TweenService:Create(toggleKnob, tweenInfo, {Position = UDim2.new(0, 2, 0, 2)})
                tween1:Play()
                tween2:Play()
            end
            
            callback(isToggled)
        end
        
        toggleButton.MouseButton1Click:Connect(toggleState)
        if isMobile() then
            toggleButton.TouchTap:Connect(toggleState)
        end
        
        toggleFrame.Parent = tabPage
        return toggleFrame
    end
    
    function Tab:CreateSlider(text, minValue, maxValue, defaultValue, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "Slider_" .. text
        sliderFrame.Size = UDim2.new(1, -20, 0, isMobile() and 70 or 50)
        sliderFrame.BackgroundTransparency = 1
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Size = UDim2.new(1, 0, 0, isMobile() and 25 or 20)
        sliderLabel.Position = UDim2.new(0, 0, 0, 0)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = text .. ": " .. defaultValue
        sliderLabel.TextColor3 = COLOR_PALETTE.TEXT
        sliderLabel.TextSize = isMobile() and 16 or 14
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.Parent = sliderFrame
        
        local track = Instance.new("Frame")
        track.Name = "Track"
        track.Size = UDim2.new(1, 0, 0, isMobile() and 8 or 6)
        track.Position = UDim2.new(0, 0, 0, isMobile() and 30 or 25)
        track.BackgroundColor3 = COLOR_PALETTE.SURFACE_LIGHT
        track.BorderSizePixel = 0
        
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(0, 3)
        trackCorner.Parent = track
        
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
        fill.BackgroundColor3 = COLOR_PALETTE.PRIMARY
        fill.BorderSizePixel = 0
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 3)
        fillCorner.Parent = fill
        
        fill.Parent = track
        
        local knob = Instance.new("TextButton")
        knob.Name = "Knob"
        knob.Size = UDim2.new(0, isMobile() and 20 or 16, 0, isMobile() and 20 or 16)
        knob.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), isMobile() and -10 or -8, 0, isMobile() and -6 or -5)
        knob.BackgroundColor3 = COLOR_PALETTE.TEXT
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
            knob.Position = UDim2.new(normalized, isMobile() and -10 or -8, 0, isMobile() and -6 or -5)
            currentValue = math.floor(value)
            sliderLabel.Text = text .. ": " .. currentValue
            callback(currentValue)
        end
        
        local function beginDrag()
            isDragging = true
            if isMobile() then
                knob.BackgroundColor3 = COLOR_PALETTE.PRIMARY
            end
        end
        
        local function endDrag()
            isDragging = false
            if isMobile() then
                knob.BackgroundColor3 = COLOR_PALETTE.TEXT
            end
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
        if isMobile() then
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
        
        sliderFrame.Parent = tabPage
        return sliderFrame
    end
    
    function Tab:CreateDropdown(text, options, multiSelect, callback)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Name = "Dropdown_" .. text
        dropdownFrame.Size = UDim2.new(1, -20, 0, isMobile() and 40 or 30)
        dropdownFrame.BackgroundTransparency = 1
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Name = "DropdownButton"
        dropdownButton.Size = UDim2.new(1, 0, 0, isMobile() and 40 or 30)
        dropdownButton.BackgroundColor3 = COLOR_PALETTE.SURFACE_LIGHT
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
        buttonText.TextColor3 = COLOR_PALETTE.TEXT
        buttonText.TextSize = isMobile() and 16 or 14
        buttonText.TextXAlignment = Enum.TextXAlignment.Left
        buttonText.Font = Enum.Font.Gotham
        buttonText.Parent = dropdownButton
        
        local arrow = Instance.new("TextLabel")
        arrow.Name = "Arrow"
        arrow.Size = UDim2.new(0, 20, 1, 0)
        arrow.Position = UDim2.new(1, -25, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "▼"
        arrow.TextColor3 = COLOR_PALETTE.TEXT_SECONDARY
        arrow.TextSize = isMobile() and 14 or 12
        arrow.Parent = dropdownButton
        
        dropdownButton.Parent = dropdownFrame
        
        local optionsFrame = Instance.new("ScrollingFrame")
        optionsFrame.Name = "OptionsFrame"
        optionsFrame.Size = UDim2.new(1, 0, 0, 0)
        optionsFrame.Position = UDim2.new(0, 0, 0, isMobile() and 45 or 35)
        optionsFrame.BackgroundColor3 = COLOR_PALETTE.SURFACE
        optionsFrame.BorderSizePixel = 0
        optionsFrame.ClipsDescendants = true
        optionsFrame.Visible = false
        optionsFrame.ScrollBarThickness = 4
        optionsFrame.ScrollBarImageColor3 = COLOR_PALETTE.PRIMARY
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
        
        local function updateButtonText()
            if multiSelect then
                local selectedCount = 0
                for _, selected in pairs(selectedOptions) do
                    if selected then
                        selectedCount = selectedCount + 1
                    end
                end
                buttonText.Text = selectedCount > 0 and (text .. " (" .. selectedCount .. ")") or text
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
            optionButton.Size = UDim2.new(1, -10, 0, isMobile() and 35 or 25)
            optionButton.Position = UDim2.new(0, 5, 0, 0)
            optionButton.BackgroundColor3 = COLOR_PALETTE.SURFACE
            optionButton.BorderSizePixel = 0
            optionButton.Text = ""
            optionButton.AutoButtonColor = false
            
            local optionText = Instance.new("TextLabel")
            optionText.Name = "OptionText"
            optionText.Size = UDim2.new(0.8, 0, 1, 0)
            optionText.Position = UDim2.new(0, 10, 0, 0)
            optionText.BackgroundTransparency = 1
            optionText.Text = optionName
            optionText.TextColor3 = COLOR_PALETTE.TEXT
            optionText.TextSize = isMobile() and 14 or 12
            optionText.TextXAlignment = Enum.TextXAlignment.Left
            optionText.Font = Enum.Font.Gotham
            optionText.Parent = optionButton
            
            if multiSelect then
                local checkBox = Instance.new("Frame")
                checkBox.Name = "CheckBox"
                checkBox.Size = UDim2.new(0, isMobile() and 18 or 15, 0, isMobile() and 18 or 15)
                checkBox.Position = UDim2.new(1, isMobile() and -25 or -20, 0, isMobile() and 10 or 5)
                checkBox.BackgroundColor3 = COLOR_PALETTE.SURFACE_LIGHT
                checkBox.BorderSizePixel = 0
                
                local checkCorner = Instance.new("UICorner")
                checkCorner.CornerRadius = UDim.new(0, 3)
                checkCorner.Parent = checkBox
                
                local checkMark = Instance.new("ImageLabel")
                checkMark.Name = "CheckMark"
                checkMark.Size = UDim2.new(0, isMobile() and 12 or 10, 0, isMobile() and 12 or 10)
                checkMark.Position = UDim2.new(0, isMobile() and 3 or 2, 0, isMobile() and 3 or 2)
                checkMark.BackgroundTransparency = 1
                checkMark.Image = "rbxassetid://10734951880"
                checkMark.ImageColor3 = COLOR_PALETTE.SUCCESS
                checkMark.Visible = false
                checkMark.Parent = checkBox
                
                checkBox.Parent = optionButton
            else
                local radioDot = Instance.new("Frame")
                radioDot.Name = "RadioDot"
                radioDot.Size = UDim2.new(0, isMobile() and 12 or 10, 0, isMobile() and 12 or 10)
                radioDot.Position = UDim2.new(1, isMobile() and -25 or -20, 0, isMobile() and 12 or 8)
                radioDot.BackgroundColor3 = COLOR_PALETTE.SURFACE_LIGHT
                radioDot.BorderSizePixel = 0
                
                local radioCorner = Instance.new("UICorner")
                radioCorner.CornerRadius = UDim.new(0, 6)
                radioCorner.Parent = radioDot
                
                local innerDot = Instance.new("Frame")
                innerDot.Name = "InnerDot"
                innerDot.Size = UDim2.new(0, isMobile() and 6 or 4, 0, isMobile() and 6 or 4)
                innerDot.Position = UDim2.new(0, isMobile() and 3 or 3, 0, isMobile() and 3 or 3)
                innerDot.BackgroundColor3 = COLOR_PALETTE.PRIMARY
                innerDot.BorderSizePixel = 0
                innerDot.Visible = false
                
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
                    if checkMark then
                        checkMark.Visible = selectedOptions[optionName]
                    end
                    optionButton.BackgroundColor3 = selectedOptions[optionName] and COLOR_PALETTE.SURFACE_LIGHT or COLOR_PALETTE.SURFACE
                else
                    for name, _ in pairs(selectedOptions) do
                        selectedOptions[name] = false
                        local otherOption = optionsFrame:FindFirstChild("Option_" .. name)
                        if otherOption then
                            otherOption.BackgroundColor3 = COLOR_PALETTE.SURFACE
                            local radioDot = otherOption:FindFirstChild("RadioDot")
                            if radioDot then
                                radioDot.InnerDot.Visible = false
                            end
                        end
                    end
                    selectedOptions[optionName] = true
                    optionButton.BackgroundColor3 = COLOR_PALETTE.SURFACE_LIGHT
                    local radioDot = optionButton:FindFirstChild("RadioDot")
                    if radioDot then
                        radioDot.InnerDot.Visible = true
                    end
                    
                    isOpen = false
                    optionsFrame.Visible = false
                    arrow.Text = "▼"
                end
                
                updateButtonText()
                callback(selectedOptions)
            end)
            
            if isMobile() then
                optionButton.TouchTap:Connect(function()
                    optionButton.MouseButton1Click:Fire()
                end)
            end
            
            return optionButton
        end
        
        -- Initialize options
        for _, option in ipairs(options) do
            selectedOptions[option] = false
            local optionButton = createOption(option)
            optionButton.Parent = optionsFrame
        end
        
        optionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            local contentSize = optionsLayout.AbsoluteContentSize
            optionsFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y)
            if isOpen then
                local maxHeight = isMobile() and 200 or 150
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
                local maxHeight = isMobile() and 200 or 150
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
        if isMobile() then
            dropdownButton.TouchTap:Connect(toggleDropdown)
        end
        
        updateButtonText()
        dropdownFrame.Parent = tabPage
        return dropdownFrame
    end
    
    -- Add to window tabs
    table.insert(self.Tabs, Tab)
    
    -- Select first tab automatically
    if #self.Tabs == 1 then
        tabButton.MouseButton1Click:Fire()
    end
    
    return Tab
end

function SpaceLabs:CreateWindow(title)
    local player = Players.LocalPlayer
    local window = setmetatable({}, Window)
    window.Tabs = {}
    window.Minimized = false
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SpaceLabsUI"
    screenGui.Parent = player.PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Mobile Icon
    local mobileIcon = Instance.new("ImageButton")
    mobileIcon.Name = "MobileIcon"
    mobileIcon.Size = UDim2.new(0, 50, 0, 50)
    mobileIcon.Position = UDim2.new(0, 20, 0, 20)
    mobileIcon.BackgroundColor3 = COLOR_PALETTE.PRIMARY
    mobileIcon.BorderSizePixel = 0
    mobileIcon.Visible = isMobile()
    mobileIcon.Image = "rbxassetid://10734951880"
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
    
    mobileIcon.Parent = screenGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = isMobile() and UDim2.new(0, 350, 0, 500) or UDim2.new(0, 500, 0, 550)
    mainFrame.Position = isMobile() and UDim2.new(0.5, -175, 0.5, -250) or UDim2.new(0, 50, 0, 50)
    mainFrame.BackgroundColor3 = COLOR_PALETTE.BACKGROUND
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = not isMobile()
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Glow Effect
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 40, 1, 40)
    glow.Position = UDim2.new(0, -20, 0, -20)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://4996891970"
    glow.ImageColor3 = COLOR_PALETTE.PRIMARY
    glow.ImageTransparency = 0.8
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(20, 20, 280, 280)
    glow.ZIndex = -1
    glow.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, isMobile() and 40 or 35)
    titleBar.BackgroundColor3 = COLOR_PALETTE.SURFACE
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 2
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(0, 200, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "⚡ " .. title
    titleText.TextColor3 = COLOR_PALETTE.TEXT
    titleText.TextSize = isMobile() and 16 or 14
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.ZIndex = 2
    titleText.Parent = titleBar
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Size = UDim2.new(0, isMobile() and 40 or 30, 0, isMobile() and 40 or 30)
    minimizeBtn.Position = UDim2.new(1, isMobile() and -40 or -30, 0, 0)
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Text = isMobile() and "🗕" or "-"
    minimizeBtn.TextColor3 = COLOR_PALETTE.TEXT
    minimizeBtn.TextSize = isMobile() and 18 or 16
    minimizeBtn.Font = Enum.Font.Gotham
    minimizeBtn.ZIndex = 2
    minimizeBtn.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -80, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = COLOR_PALETTE.TEXT
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.ZIndex = 2
    closeBtn.Visible = isMobile()
    closeBtn.Parent = titleBar
    
    titleBar.Parent = mainFrame
    
    -- Content Area
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, -titleBar.Size.Y.Offset)
    contentFrame.Position = UDim2.new(0, 0, 0, titleBar.Size.Y.Offset)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2
    contentFrame.Parent = mainFrame
    
    -- Left Side Tabs Container
    local tabsContainer = Instance.new("ScrollingFrame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Size = UDim2.new(0, isMobile() and 80 or 120, 1, 0)
    tabsContainer.Position = UDim2.new(0, 0, 0, 0)
    tabsContainer.BackgroundColor3 = COLOR_PALETTE.SURFACE_LIGHT
    tabsContainer.BorderSizePixel = 0
    tabsContainer.ScrollBarThickness = 4
    tabsContainer.ScrollBarImageColor3 = COLOR_PALETTE.PRIMARY
    tabsContainer.ZIndex = 2
    
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.Padding = UDim.new(0, 5)
    tabsLayout.Parent = tabsContainer
    
    local tabsPadding = Instance.new("UIPadding")
    tabsPadding.PaddingTop = UDim.new(0, 5)
    tabsPadding.Parent = tabsContainer
    
    tabsContainer.Parent = contentFrame
    
    -- Pages Container
    local pagesContainer = Instance.new("Frame")
    pagesContainer.Name = "PagesContainer"
    pagesContainer.Size = UDim2.new(1, -tabsContainer.Size.X.Offset, 1, 0)
    pagesContainer.Position = UDim2.new(0, tabsContainer.Size.X.Offset, 0, 0)
    pagesContainer.BackgroundTransparency = 1
    pagesContainer.ClipsDescendants = true
    pagesContainer.ZIndex = 2
    pagesContainer.Parent = contentFrame
    
    mainFrame.Parent = screenGui
    
    -- Store references
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.MobileIcon = mobileIcon
    window.TitleBar = titleBar
    window.MinimizeButton = minimizeBtn
    window.CloseButton = closeBtn
    window.TabsContainer = tabsContainer
    window.PagesContainer = pagesContainer
    window.OriginalSize = mainFrame.Size
    
    -- Mobile Icon Functionality
    if isMobile() then
        mobileIcon.MouseButton1Click:Connect(function()
            window:Maximize()
        end)
        
        mobileIcon.TouchTap:Connect(function()
            window:Maximize()
        end)
        
        -- Make mobile icon draggable
        local draggingIcon = false
        local dragStartIcon, startPosIcon
        
        local function updateIcon(input)
            local delta = input.Position - dragStartIcon
            mobileIcon.Position = UDim2.new(0, startPosIcon.X.Offset + delta.X, 0, startPosIcon.Y.Offset + delta.Y)
        end
        
        mobileIcon.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                draggingIcon = true
                dragStartIcon = input.Position
                startPosIcon = mobileIcon.Position
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if draggingIcon and input.UserInputType == Enum.UserInputType.Touch then
                updateIcon(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                draggingIcon = false
            end
        end)
    end
    
    -- Close Button (Mobile)
    if isMobile() then
        closeBtn.MouseButton1Click:Connect(function()
            window:Minimize()
        end)
        
        closeBtn.TouchTap:Connect(function()
            window:Minimize()
        end)
    end
    
    -- Minimize Button
    minimizeBtn.MouseButton1Click:Connect(function()
        if window.Minimized then
            window:Maximize()
        else
            window:Minimize()
        end
    end)
    
    if isMobile() then
        minimizeBtn.TouchTap:Connect(function()
            minimizeBtn.MouseButton1Click:Fire()
        end)
    end
    
    -- Make Window Draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or (isMobile() and input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return window
end

return SpaceLabs
