-- Kavo UI Library Updated Version
-- Added MultipleDropdownSelection, fixed button functionality, updated to LootLabs Space theme

local Kavo = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

function Kavo:CreateLib(Name, Color)
	
	local CurrentTheme = "LootLabs Space"
	local Debounce = false
	
	local Kavo = {}
	
	local Main = Instance.new("ScreenGui")
	local MainFrame = Instance.new("Frame")
	local Top = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local Close = Instance.new("TextButton")
	local TabHold = Instance.new("Frame")
	local TabHoldLayout = Instance.new("UIListLayout")
	local TabPadding = Instance.new("UIPadding")
	local ContainerHold = Instance.new("Frame")
	local ContainerHoldLayout = Instance.new("UIListLayout")
	
	if gethui then
		Main.Parent = gethui()
	elseif syn and syn.protect_gui then
		syn.protect_gui(Main)
		Main.Parent = game.CoreGui
	else
		Main.Parent = game.CoreGui
	end
	
	Main.Name = Name
	Main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Main
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
	MainFrame.BorderSizePixel = 0
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(0, 550, 0, 400)
	MainFrame.ZIndex = 2
	
	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(0, 6)
	UICorner.Parent = MainFrame
	
	Top.Name = "Top"
	Top.Parent = MainFrame
	Top.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
	Top.BorderSizePixel = 0
	Top.Size = UDim2.new(1, 0, 0, 40)
	Top.ZIndex = 3
	
	local UICorner2 = Instance.new("UICorner")
	UICorner2.CornerRadius = UDim.new(0, 6)
	UICorner2.Parent = Top
	
	Title.Name = "Title"
	Title.Parent = Top
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0, 15, 0, 0)
	Title.Size = UDim2.new(0, 200, 1, 0)
	Title.Font = Enum.Font.GothamBold
	Title.Text = Name
	Title.TextColor3 = Color3.fromRGB(220, 220, 255)
	Title.TextSize = 16.000
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.ZIndex = 3
	
	Close.Name = "Close"
	Close.Parent = Top
	Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Close.BackgroundTransparency = 1.000
	Close.Position = UDim2.new(1, -35, 0, 10)
	Close.Size = UDim2.new(0, 25, 0, 20)
	Close.Font = Enum.Font.GothamBold
	Close.Text = "X"
	Close.TextColor3 = Color3.fromRGB(220, 220, 255)
	Close.TextSize = 16.000
	Close.ZIndex = 3
	
	TabHold.Name = "TabHold"
	TabHold.Parent = MainFrame
	TabHold.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	TabHold.BorderSizePixel = 0
	TabHold.Position = UDim2.new(0, 0, 0, 40)
	TabHold.Size = UDim2.new(0, 150, 0, 360)
	TabHold.ZIndex = 2
	
	TabHoldLayout.Name = "TabHoldLayout"
	TabHoldLayout.Parent = TabHold
	TabHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabHoldLayout.Padding = UDim.new(0, 5)
	
	TabPadding.Name = "TabPadding"
	TabPadding.Parent = TabHold
	TabPadding.PaddingLeft = UDim.new(0, 10)
	TabPadding.PaddingTop = UDim.new(0, 10)
	
	ContainerHold.Name = "ContainerHold"
	ContainerHold.Parent = MainFrame
	ContainerHold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ContainerHold.BackgroundTransparency = 1.000
	ContainerHold.BorderSizePixel = 0
	ContainerHold.Position = UDim2.new(0, 160, 0, 50)
	ContainerHold.Size = UDim2.new(0, 380, 0, 340)
	ContainerHold.ZIndex = 2
	
	ContainerHoldLayout.Name = "ContainerHoldLayout"
	ContainerHoldLayout.Parent = ContainerHold
	ContainerHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ContainerHoldLayout.Padding = UDim.new(0, 10)
	
	local CloseFrame = Instance.new("TextButton")
	CloseFrame.Name = "CloseFrame"
	CloseFrame.Parent = Main
	CloseFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	CloseFrame.BackgroundTransparency = 0.500
	CloseFrame.BorderSizePixel = 0
	CloseFrame.Size = UDim2.new(1, 0, 1, 0)
	CloseFrame.Text = ""
	CloseFrame.TextColor3 = Color3.fromRGB(0, 0, 0)
	CloseFrame.TextSize = 14.000
	CloseFrame.ZIndex = 1
	
	CloseFrame.MouseButton1Click:Connect(function()
		Main.Enabled = false
	end)
	
	Close.MouseButton1Click:Connect(function()
		Main.Enabled = false
	end)
	
	local Tabs = {}
	
	function Kavo:CreateTab(Title)
		
		local Tab = {}
		
		local TabButton = Instance.new("TextButton")
		local TabButtonCorner = Instance.new("UICorner")
		local Container = Instance.new("ScrollingFrame")
		local ContainerLayout = Instance.new("UIListLayout")
		local ContainerPadding = Instance.new("UIPadding")
		
		TabButton.Name = "TabButton"
		TabButton.Parent = TabHold
		TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(0, 130, 0, 30)
		TabButton.AutoButtonColor = false
		TabButton.Font = Enum.Font.Gotham
		TabButton.Text = Title
		TabButton.TextColor3 = Color3.fromRGB(220, 220, 255)
		TabButton.TextSize = 14.000
		TabButton.ZIndex = 2
		
		TabButtonCorner.CornerRadius = UDim.new(0, 6)
		TabButtonCorner.Parent = TabButton
		
		Container.Name = "Container"
		Container.Parent = ContainerHold
		Container.Active = true
		Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Container.BackgroundTransparency = 1.000
		Container.BorderSizePixel = 0
		Container.Size = UDim2.new(1, 0, 1, 0)
		Container.ScrollBarThickness = 3
		Container.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)
		Container.Visible = false
		Container.ZIndex = 2
		
		ContainerLayout.Name = "ContainerLayout"
		ContainerLayout.Parent = Container
		ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ContainerLayout.Padding = UDim.new(0, 10)
		
		ContainerPadding.Name = "ContainerPadding"
		ContainerPadding.Parent = Container
		ContainerPadding.PaddingLeft = UDim.new(0, 10)
		ContainerPadding.PaddingTop = UDim.new(0, 10)
		
		if #Tabs == 0 then
			TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 75)
			Container.Visible = true
		end
		
		TabButton.MouseButton1Click:Connect(function()
			for i, v in next, Tabs do
				v.TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
				v.Container.Visible = false
			end
			TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 75)
			Container.Visible = true
		end)
		
		function Tab:CreateButton(Config)
			Config = Config or {}
			Config.Name = Config.Name or "Button"
			Config.Callback = Config.Callback or function() end
			
			local Button = {}
			
			local ButtonFrame = Instance.new("Frame")
			local ButtonFrameCorner = Instance.new("UICorner")
			local ButtonTitle = Instance.new("TextLabel")
			local ButtonBtn = Instance.new("TextButton")
			local ButtonBtnCorner = Instance.new("UICorner")
			
			ButtonFrame.Name = "ButtonFrame"
			ButtonFrame.Parent = Container
			ButtonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
			ButtonFrame.Size = UDim2.new(0, 360, 0, 40)
			ButtonFrame.ZIndex = 2
			
			ButtonFrameCorner.CornerRadius = UDim.new(0, 6)
			ButtonFrameCorner.Parent = ButtonFrame
			
			ButtonTitle.Name = "ButtonTitle"
			ButtonTitle.Parent = ButtonFrame
			ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ButtonTitle.BackgroundTransparency = 1.000
			ButtonTitle.Position = UDim2.new(0, 15, 0, 0)
			ButtonTitle.Size = UDim2.new(0, 200, 1, 0)
			ButtonTitle.Font = Enum.Font.Gotham
			ButtonTitle.Text = Config.Name
			ButtonTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
			ButtonTitle.TextSize = 14.000
			ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
			ButtonTitle.ZIndex = 2
			
			ButtonBtn.Name = "ButtonBtn"
			ButtonBtn.Parent = ButtonFrame
			ButtonBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
			ButtonBtn.Position = UDim2.new(1, -85, 0, 5)
			ButtonBtn.Size = UDim2.new(0, 70, 0, 30)
			ButtonBtn.AutoButtonColor = false
			ButtonBtn.Font = Enum.Font.Gotham
			ButtonBtn.Text = "Execute"
			ButtonBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
			ButtonBtn.TextSize = 14.000
			ButtonBtn.ZIndex = 2
			
			ButtonBtnCorner.CornerRadius = UDim.new(0, 6)
			ButtonBtnCorner.Parent = ButtonBtn
			
			local Hover = false
			
			ButtonBtn.MouseEnter:Connect(function()
				if not Hover then
					Hover = true
					TweenService:Create(ButtonBtn, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						BackgroundColor3 = Color3.fromRGB(60, 60, 100)
					}):Play()
				end
			end)
			
			ButtonBtn.MouseLeave:Connect(function()
				if Hover then
					Hover = false
					TweenService:Create(ButtonBtn, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						BackgroundColor3 = Color3.fromRGB(50, 50, 80)
					}):Play()
				end
			end)
			
			ButtonBtn.MouseButton1Click:Connect(function()
				Config.Callback()
			end)
			
			function Button:UpdateButton(NewConfig)
				NewConfig = NewConfig or {}
				Config.Name = NewConfig.Name or Config.Name
				Config.Callback = NewConfig.Callback or Config.Callback
				
				ButtonTitle.Text = Config.Name
			end
			
			return Button
		end
		
		function Tab:CreateToggle(Config)
			Config = Config or {}
			Config.Name = Config.Name or "Toggle"
			Config.Default = Config.Default or false
			Config.Callback = Config.Callback or function() end
			
			local Toggle = {}
			local Toggled = Config.Default
			
			local ToggleFrame = Instance.new("Frame")
			local ToggleFrameCorner = Instance.new("UICorner")
			local ToggleTitle = Instance.new("TextLabel")
			local ToggleBtn = Instance.new("TextButton")
			local ToggleBtnCorner = Instance.new("UICorner")
			local ToggleCircle = Instance.new("Frame")
			local ToggleCircleCorner = Instance.new("UICorner")
			
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.Parent = Container
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
			ToggleFrame.Size = UDim2.new(0, 360, 0, 40)
			ToggleFrame.ZIndex = 2
			
			ToggleFrameCorner.CornerRadius = UDim.new(0, 6)
			ToggleFrameCorner.Parent = ToggleFrame
			
			ToggleTitle.Name = "ToggleTitle"
			ToggleTitle.Parent = ToggleFrame
			ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			ToggleTitle.BackgroundTransparency = 1.000
			ToggleTitle.Position = UDim2.new(0, 15, 0, 0)
			ToggleTitle.Size = UDim2.new(0, 200, 1, 0)
			ToggleTitle.Font = Enum.Font.Gotham
			ToggleTitle.Text = Config.Name
			ToggleTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
			ToggleTitle.TextSize = 14.000
			ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
			ToggleTitle.ZIndex = 2
			
			ToggleBtn.Name = "ToggleBtn"
			ToggleBtn.Parent = ToggleFrame
			ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
			ToggleBtn.Position = UDim2.new(1, -65, 0, 10)
			ToggleBtn.Size = UDim2.new(0, 50, 0, 20)
			ToggleBtn.AutoButtonColor = false
			ToggleBtn.Font = Enum.Font.Gotham
			ToggleBtn.Text = ""
			ToggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
			ToggleBtn.TextSize = 14.000
			ToggleBtn.ZIndex = 2
			
			ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
			ToggleBtnCorner.Parent = ToggleBtn
			
			ToggleCircle.Name = "ToggleCircle"
			ToggleCircle.Parent = ToggleBtn
			ToggleCircle.BackgroundColor3 = Color3.fromRGB(220, 220, 255)
			ToggleCircle.Position = UDim2.new(0, 2, 0, 2)
			ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
			ToggleCircle.ZIndex = 3
			
			ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
			ToggleCircleCorner.Parent = ToggleCircle
			
			local function UpdateToggle()
				if Toggled then
					TweenService:Create(ToggleCircle, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Position = UDim2.new(0, 32, 0, 2),
						BackgroundColor3 = Color3.fromRGB(100, 150, 255)
					}):Play()
					TweenService:Create(ToggleBtn, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						BackgroundColor3 = Color3.fromRGB(40, 70, 140)
					}):Play()
				else
					TweenService:Create(ToggleCircle, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Position = UDim2.new(0, 2, 0, 2),
						BackgroundColor3 = Color3.fromRGB(220, 220, 255)
					}):Play()
					TweenService:Create(ToggleBtn, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						BackgroundColor3 = Color3.fromRGB(50, 50, 80)
					}):Play()
				end
				Config.Callback(Toggled)
			end
			
			if Toggled then
				ToggleCircle.Position = UDim2.new(0, 32, 0, 2)
				ToggleCircle.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
				ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 70, 140)
			end
			
			ToggleBtn.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				UpdateToggle()
			end)
			
			function Toggle:UpdateToggle(NewConfig)
				NewConfig = NewConfig or {}
				Config.Name = NewConfig.Name or Config.Name
				Config.Callback = NewConfig.Callback or Config.Callback
				
				ToggleTitle.Text = Config.Name
			end
			
			function Toggle:SetValue(Value)
				Toggled = Value
				UpdateToggle()
			end
			
			return Toggle
		end
		
		function Tab:CreateSlider(Config)
			Config = Config or {}
			Config.Name = Config.Name or "Slider"
			Config.Min = Config.Min or 0
			Config.Max = Config.Max or 100
			Config.Default = Config.Default or Config.Min
			Config.Callback = Config.Callback or function() end
			
			local Slider = {}
			local Dragging = false
			local Value = Config.Default
			
			local SliderFrame = Instance.new("Frame")
			local SliderFrameCorner = Instance.new("UICorner")
			local SliderTitle = Instance.new("TextLabel")
			local SliderValue = Instance.new("TextLabel")
			local SliderBtn = Instance.new("TextButton")
			local SliderBtnCorner = Instance.new("UICorner")
			local SliderInner = Instance.new("Frame")
			local SliderInnerCorner = Instance.new("UICorner")
			
			SliderFrame.Name = "SliderFrame"
			SliderFrame.Parent = Container
			SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
			SliderFrame.Size = UDim2.new(0, 360, 0, 50)
			SliderFrame.ZIndex = 2
			
			SliderFrameCorner.CornerRadius = UDim.new(0, 6)
			SliderFrameCorner.Parent = SliderFrame
			
			SliderTitle.Name = "SliderTitle"
			SliderTitle.Parent = SliderFrame
			SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SliderTitle.BackgroundTransparency = 1.000
			SliderTitle.Position = UDim2.new(0, 15, 0, 5)
			SliderTitle.Size = UDim2.new(0, 200, 0, 20)
			SliderTitle.Font = Enum.Font.Gotham
			SliderTitle.Text = Config.Name
			SliderTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
			SliderTitle.TextSize = 14.000
			SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
			SliderTitle.ZIndex = 2
			
			SliderValue.Name = "SliderValue"
			SliderValue.Parent = SliderFrame
			SliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SliderValue.BackgroundTransparency = 1.000
			SliderValue.Position = UDim2.new(1, -60, 0, 5)
			SliderValue.Size = UDim2.new(0, 45, 0, 20)
			SliderValue.Font = Enum.Font.Gotham
			SliderValue.Text = tostring(Value)
			SliderValue.TextColor3 = Color3.fromRGB(220, 220, 255)
			SliderValue.TextSize = 14.000
			SliderValue.TextXAlignment = Enum.TextXAlignment.Right
			SliderValue.ZIndex = 2
			
			SliderBtn.Name = "SliderBtn"
			SliderBtn.Parent = SliderFrame
			SliderBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
			SliderBtn.Position = UDim2.new(0, 15, 0, 30)
			SliderBtn.Size = UDim2.new(1, -30, 0, 10)
			SliderBtn.AutoButtonColor = false
			SliderBtn.Font = Enum.Font.Gotham
			SliderBtn.Text = ""
			SliderBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
			SliderBtn.TextSize = 14.000
			SliderBtn.ZIndex = 2
			
			SliderBtnCorner.CornerRadius = UDim.new(1, 0)
			SliderBtnCorner.Parent = SliderBtn
			
			SliderInner.Name = "SliderInner"
			SliderInner.Parent = SliderBtn
			SliderInner.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
			SliderInner.Size = UDim2.new((Value - Config.Min) / (Config.Max - Config.Min), 0, 1, 0)
			SliderInner.ZIndex = 3
			
			SliderInnerCorner.CornerRadius = UDim.new(1, 0)
			SliderInnerCorner.Parent = SliderInner
			
			local function UpdateSlider(Input)
				local Pos = UDim2.new(math.clamp((Input.Position.X - SliderBtn.AbsolutePosition.X) / SliderBtn.AbsoluteSize.X, 0, 1), 0, 1, 0)
				TweenService:Create(SliderInner, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
					Size = Pos
				}):Play()
				
				local Val = math.floor(((Pos.X.Scale * Config.Max) / Config.Max) * (Config.Max - Config.Min) + Config.Min)
				Value = Val
				SliderValue.Text = tostring(Val)
				Config.Callback(Val)
			end
			
			SliderBtn.MouseButton1Down:Connect(function()
				Dragging = true
				UpdateSlider({Position = UserInputService:GetMouseLocation()})
			end)
			
			UserInputService.InputChanged:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
					UpdateSlider(Input)
				end
			end)
			
			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Dragging = false
				end
			end)
			
			function Slider:UpdateSlider(NewConfig)
				NewConfig = NewConfig or {}
				Config.Name = NewConfig.Name or Config.Name
				Config.Callback = NewConfig.Callback or Config.Callback
				
				SliderTitle.Text = Config.Name
			end
			
			function Slider:SetValue(NewValue)
				Value = math.clamp(NewValue, Config.Min, Config.Max)
				local Pos = UDim2.new((Value - Config.Min) / (Config.Max - Config.Min), 0, 1, 0)
				TweenService:Create(SliderInner, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
					Size = Pos
				}):Play()
				SliderValue.Text = tostring(Value)
				Config.Callback(Value)
			end
			
			return Slider
		end
		
		function Tab:CreateDropdown(Config)
			Config = Config or {}
			Config.Name = Config.Name or "Dropdown"
			Config.List = Config.List or {}
			Config.Default = Config.Default or Config.List[1] or ""
			Config.Callback = Config.Callback or function() end
			
			local Dropdown = {}
			local Toggled = false
			local Selected = Config.Default
			
			local DropdownFrame = Instance.new("Frame")
			local DropdownFrameCorner = Instance.new("UICorner")
			local DropdownTitle = Instance.new("TextLabel")
			local DropdownBtn = Instance.new("TextButton")
			local DropdownBtnCorner = Instance.new("UICorner")
			local DropdownSelected = Instance.new("TextLabel")
			local DropdownArrow = Instance.new("ImageLabel")
			local DropdownHold = Instance.new("ScrollingFrame")
			local DropdownHoldLayout = Instance.new("UIListLayout")
			local DropdownHoldPadding = Instance.new("UIPadding")
			
			DropdownFrame.Name = "DropdownFrame"
			DropdownFrame.Parent = Container
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.Size = UDim2.new(0, 360, 0, 40)
			DropdownFrame.ZIndex = 2
			
			DropdownFrameCorner.CornerRadius = UDim.new(0, 6)
			DropdownFrameCorner.Parent = DropdownFrame
			
			DropdownTitle.Name = "DropdownTitle"
			DropdownTitle.Parent = DropdownFrame
			DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownTitle.BackgroundTransparency = 1.000
			DropdownTitle.Position = UDim2.new(0, 15, 0, 0)
			DropdownTitle.Size = UDim2.new(0, 200, 0, 40)
			DropdownTitle.Font = Enum.Font.Gotham
			DropdownTitle.Text = Config.Name
			DropdownTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
			DropdownTitle.TextSize = 14.000
			DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
			DropdownTitle.ZIndex = 2
			
			DropdownBtn.Name = "DropdownBtn"
			DropdownBtn.Parent = DropdownFrame
			DropdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
			DropdownBtn.Position = UDim2.new(1, -125, 0, 5)
			DropdownBtn.Size = UDim2.new(0, 110, 0, 30)
			DropdownBtn.AutoButtonColor = false
			DropdownBtn.Font = Enum.Font.Gotham
			DropdownBtn.Text = ""
			DropdownBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
			DropdownBtn.TextSize = 14.000
			DropdownBtn.ZIndex = 2
			
			DropdownBtnCorner.CornerRadius = UDim.new(0, 6)
			DropdownBtnCorner.Parent = DropdownBtn
			
			DropdownSelected.Name = "DropdownSelected"
			DropdownSelected.Parent = DropdownBtn
			DropdownSelected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownSelected.BackgroundTransparency = 1.000
			DropdownSelected.Size = UDim2.new(1, -25, 1, 0)
			DropdownSelected.Font = Enum.Font.Gotham
			DropdownSelected.Text = Selected
			DropdownSelected.TextColor3 = Color3.fromRGB(220, 220, 255)
			DropdownSelected.TextSize = 14.000
			DropdownSelected.ZIndex = 2
			
			DropdownArrow.Name = "DropdownArrow"
			DropdownArrow.Parent = DropdownBtn
			DropdownArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownArrow.BackgroundTransparency = 1.000
			DropdownArrow.Position = UDim2.new(1, -20, 0, 5)
			DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
			DropdownArrow.Image = "rbxassetid://6031090990"
			DropdownArrow.ImageColor3 = Color3.fromRGB(220, 220, 255)
			DropdownArrow.ZIndex = 2
			
			DropdownHold.Name = "DropdownHold"
			DropdownHold.Parent = DropdownFrame
			DropdownHold.Active = true
			DropdownHold.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
			DropdownHold.BorderSizePixel = 0
			DropdownHold.Position = UDim2.new(0, 0, 1, 5)
			DropdownHold.Size = UDim2.new(1, 0, 0, 0)
			DropdownHold.ScrollBarThickness = 3
			DropdownHold.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)
			DropdownHold.CanvasSize = UDim2.new(0, 0, 0, 0)
			DropdownHold.ZIndex = 4
			
			DropdownHoldLayout.Name = "DropdownHoldLayout"
			DropdownHoldLayout.Parent = DropdownHold
			DropdownHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
			DropdownHoldLayout.Padding = UDim.new(0, 5)
			
			DropdownHoldPadding.Name = "DropdownHoldPadding"
			DropdownHoldPadding.Parent = DropdownHold
			DropdownHoldPadding.PaddingLeft = UDim.new(0, 5)
			DropdownHoldPadding.PaddingTop = UDim.new(0, 5)
			
			local function UpdateDropdown()
				if Toggled then
					TweenService:Create(DropdownFrame, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Size = UDim2.new(0, 360, 0, 40 + math.min(#Config.List * 35, 140))
					}):Play()
					TweenService:Create(DropdownHold, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Size = UDim2.new(1, 0, 0, math.min(#Config.List * 35, 140))
					}):Play()
					TweenService:Create(DropdownArrow, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Rotation = 180
					}):Play()
				else
					TweenService:Create(DropdownFrame, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Size = UDim2.new(0, 360, 0, 40)
					}):Play()
					TweenService:Create(DropdownHold, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Size = UDim2.new(1, 0, 0, 0)
					}):Play()
					TweenService:Create(DropdownArrow, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Rotation = 0
					}):Play()
				end
			end
			
			DropdownBtn.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				UpdateDropdown()
			end)
			
			for i, v in next, Config.List do
				local OptionBtn = Instance.new("TextButton")
				local OptionBtnCorner = Instance.new("UICorner")
				
				OptionBtn.Name = "OptionBtn"
				OptionBtn.Parent = DropdownHold
				OptionBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
				OptionBtn.Size = UDim2.new(1, -10, 0, 30)
				OptionBtn.AutoButtonColor = false
				OptionBtn.Font = Enum.Font.Gotham
				OptionBtn.Text = v
				OptionBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
				OptionBtn.TextSize = 14.000
				OptionBtn.ZIndex = 4
				
				OptionBtnCorner.CornerRadius = UDim.new(0, 6)
				OptionBtnCorner.Parent = OptionBtn
				
				OptionBtn.MouseButton1Click:Connect(function()
					Selected = v
					DropdownSelected.Text = Selected
					Toggled = false
					UpdateDropdown()
					Config.Callback(Selected)
				end)
			end
			
			DropdownHold.CanvasSize = UDim2.new(0, 0, 0, DropdownHoldLayout.AbsoluteContentSize.Y)
			
			DropdownHoldLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				DropdownHold.CanvasSize = UDim2.new(0, 0, 0, DropdownHoldLayout.AbsoluteContentSize.Y)
			end)
			
			function Dropdown:UpdateDropdown(NewConfig)
				NewConfig = NewConfig or {}
				Config.Name = NewConfig.Name or Config.Name
				Config.List = NewConfig.List or Config.List
				Config.Callback = NewConfig.Callback or Config.Callback
				
				DropdownTitle.Text = Config.Name
				
				for i, v in next, DropdownHold:GetChildren() do
					if v:IsA("TextButton") then
						v:Destroy()
					end
				end
				
				for i, v in next, Config.List do
					local OptionBtn = Instance.new("TextButton")
					local OptionBtnCorner = Instance.new("UICorner")
					
					OptionBtn.Name = "OptionBtn"
					OptionBtn.Parent = DropdownHold
					OptionBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
					OptionBtn.Size = UDim2.new(1, -10, 0, 30)
					OptionBtn.AutoButtonColor = false
					OptionBtn.Font = Enum.Font.Gotham
					OptionBtn.Text = v
					OptionBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
					OptionBtn.TextSize = 14.000
					OptionBtn.ZIndex = 4
					
					OptionBtnCorner.CornerRadius = UDim.new(0, 6)
					OptionBtnCorner.Parent = OptionBtn
					
					OptionBtn.MouseButton1Click:Connect(function()
						Selected = v
						DropdownSelected.Text = Selected
						Toggled = false
						UpdateDropdown()
						Config.Callback(Selected)
					end)
				end
			end
			
			function Dropdown:SetValue(NewValue)
				if table.find(Config.List, NewValue) then
					Selected = NewValue
					DropdownSelected.Text = Selected
					Config.Callback(Selected)
				end
			end
			
			return Dropdown
		end
		
		-- NEW: Multiple Dropdown Selection
		function Tab:CreateMultipleDropdown(Config)
			Config = Config or {}
			Config.Name = Config.Name or "Multiple Dropdown"
			Config.List = Config.List or {}
			Config.Default = Config.Default or {}
			Config.Callback = Config.Callback or function() end
			
			local MultipleDropdown = {}
			local Toggled = false
			local Selected = Config.Default or {}
			
			local DropdownFrame = Instance.new("Frame")
			local DropdownFrameCorner = Instance.new("UICorner")
			local DropdownTitle = Instance.new("TextLabel")
			local DropdownBtn = Instance.new("TextButton")
			local DropdownBtnCorner = Instance.new("UICorner")
			local DropdownSelected = Instance.new("TextLabel")
			local DropdownArrow = Instance.new("ImageLabel")
			local DropdownHold = Instance.new("ScrollingFrame")
			local DropdownHoldLayout = Instance.new("UIListLayout")
			local DropdownHoldPadding = Instance.new("UIPadding")
			
			DropdownFrame.Name = "MultipleDropdownFrame"
			DropdownFrame.Parent = Container
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
			DropdownFrame.ClipsDescendants = true
			DropdownFrame.Size = UDim2.new(0, 360, 0, 40)
			DropdownFrame.ZIndex = 2
			
			DropdownFrameCorner.CornerRadius = UDim.new(0, 6)
			DropdownFrameCorner.Parent = DropdownFrame
			
			DropdownTitle.Name = "DropdownTitle"
			DropdownTitle.Parent = DropdownFrame
			DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownTitle.BackgroundTransparency = 1.000
			DropdownTitle.Position = UDim2.new(0, 15, 0, 0)
			DropdownTitle.Size = UDim2.new(0, 200, 0, 40)
			DropdownTitle.Font = Enum.Font.Gotham
			DropdownTitle.Text = Config.Name
			DropdownTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
			DropdownTitle.TextSize = 14.000
			DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
			DropdownTitle.ZIndex = 2
			
			DropdownBtn.Name = "DropdownBtn"
			DropdownBtn.Parent = DropdownFrame
			DropdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
			DropdownBtn.Position = UDim2.new(1, -125, 0, 5)
			DropdownBtn.Size = UDim2.new(0, 110, 0, 30)
			DropdownBtn.AutoButtonColor = false
			DropdownBtn.Font = Enum.Font.Gotham
			DropdownBtn.Text = ""
			DropdownBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
			DropdownBtn.TextSize = 14.000
			DropdownBtn.ZIndex = 2
			
			DropdownBtnCorner.CornerRadius = UDim.new(0, 6)
			DropdownBtnCorner.Parent = DropdownBtn
			
			DropdownSelected.Name = "DropdownSelected"
			DropdownSelected.Parent = DropdownBtn
			DropdownSelected.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownSelected.BackgroundTransparency = 1.000
			DropdownSelected.Size = UDim2.new(1, -25, 1, 0)
			DropdownSelected.Font = Enum.Font.Gotham
			DropdownSelected.Text = #Selected > 0 and table.concat(Selected, ", ") or "None"
			DropdownSelected.TextColor3 = Color3.fromRGB(220, 220, 255)
			DropdownSelected.TextSize = 12.000
			DropdownSelected.TextTruncate = Enum.TextTruncate.AtEnd
			DropdownSelected.ZIndex = 2
			
			DropdownArrow.Name = "DropdownArrow"
			DropdownArrow.Parent = DropdownBtn
			DropdownArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownArrow.BackgroundTransparency = 1.000
			DropdownArrow.Position = UDim2.new(1, -20, 0, 5)
			DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
			DropdownArrow.Image = "rbxassetid://6031090990"
			DropdownArrow.ImageColor3 = Color3.fromRGB(220, 220, 255)
			DropdownArrow.ZIndex = 2
			
			DropdownHold.Name = "DropdownHold"
			DropdownHold.Parent = DropdownFrame
			DropdownHold.Active = true
			DropdownHold.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
			DropdownHold.BorderSizePixel = 0
			DropdownHold.Position = UDim2.new(0, 0, 1, 5)
			DropdownHold.Size = UDim2.new(1, 0, 0, 0)
			DropdownHold.ScrollBarThickness = 3
			DropdownHold.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)
			DropdownHold.CanvasSize = UDim2.new(0, 0, 0, 0)
			DropdownHold.ZIndex = 4
			
			DropdownHoldLayout.Name = "DropdownHoldLayout"
			DropdownHoldLayout.Parent = DropdownHold
			DropdownHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
			DropdownHoldLayout.Padding = UDim.new(0, 5)
			
			DropdownHoldPadding.Name = "DropdownHoldPadding"
			DropdownHoldPadding.Parent = DropdownHold
			DropdownHoldPadding.PaddingLeft = UDim.new(0, 5)
			DropdownHoldPadding.PaddingTop = UDim.new(0, 5)
			
			local function UpdateSelectedText()
				DropdownSelected.Text = #Selected > 0 and table.concat(Selected, ", ") or "None"
			end
			
			local function UpdateDropdown()
				if Toggled then
					TweenService:Create(DropdownFrame, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Size = UDim2.new(0, 360, 0, 40 + math.min(#Config.List * 35, 140))
					}):Play()
					TweenService:Create(DropdownHold, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Size = UDim2.new(1, 0, 0, math.min(#Config.List * 35, 140))
					}):Play()
					TweenService:Create(DropdownArrow, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Rotation = 180
					}):Play()
				else
					TweenService:Create(DropdownFrame, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Size = UDim2.new(0, 360, 0, 40)
					}):Play()
					TweenService:Create(DropdownHold, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Size = UDim2.new(1, 0, 0, 0)
					}):Play()
					TweenService:Create(DropdownArrow, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						Rotation = 0
					}):Play()
				end
			end
			
			DropdownBtn.MouseButton1Click:Connect(function()
				Toggled = not Toggled
				UpdateDropdown()
			end)
			
			local OptionButtons = {}
			
			for i, v in next, Config.List do
				local OptionFrame = Instance.new("Frame")
				local OptionBtn = Instance.new("TextButton")
				local OptionBtnCorner = Instance.new("UICorner")
				local Checkbox = Instance.new("Frame")
				local CheckboxCorner = Instance.new("UICorner")
				local Checkmark = Instance.new("ImageLabel")
				
				OptionFrame.Name = "OptionFrame"
				OptionFrame.Parent = DropdownHold
				OptionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				OptionFrame.BackgroundTransparency = 1.000
				OptionFrame.Size = UDim2.new(1, -10, 0, 30)
				OptionFrame.ZIndex = 4
				
				OptionBtn.Name = "OptionBtn"
				OptionBtn.Parent = OptionFrame
				OptionBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
				OptionBtn.Size = UDim2.new(1, -30, 1, 0)
				OptionBtn.Position = UDim2.new(0, 30, 0, 0)
				OptionBtn.AutoButtonColor = false
				OptionBtn.Font = Enum.Font.Gotham
				OptionBtn.Text = v
				OptionBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
				OptionBtn.TextSize = 14.000
				OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
				OptionBtn.ZIndex = 4
				
				OptionBtnCorner.CornerRadius = UDim.new(0, 6)
				OptionBtnCorner.Parent = OptionBtn
				
				Checkbox.Name = "Checkbox"
				Checkbox.Parent = OptionFrame
				Checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
				Checkbox.Position = UDim2.new(0, 5, 0, 5)
				Checkbox.Size = UDim2.new(0, 20, 0, 20)
				Checkbox.ZIndex = 4
				
				CheckboxCorner.CornerRadius = UDim.new(0, 4)
				CheckboxCorner.Parent = Checkbox
				
				Checkmark.Name = "Checkmark"
				Checkmark.Parent = Checkbox
				Checkmark.AnchorPoint = Vector2.new(0.5, 0.5)
				Checkmark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Checkmark.BackgroundTransparency = 1.000
				Checkmark.Position = UDim2.new(0.5, 0, 0.5, 0)
				Checkmark.Size = UDim2.new(0, 14, 0, 14)
				Checkmark.Image = "rbxassetid://6031090990"
				Checkmark.ImageColor3 = Color3.fromRGB(100, 150, 255)
				Checkmark.Visible = table.find(Selected, v) ~= nil
				Checkmark.ZIndex = 5
				
				local function UpdateCheckmark()
					Checkmark.Visible = table.find(Selected, v) ~= nil
					if Checkmark.Visible then
						TweenService:Create(Checkbox, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
							BackgroundColor3 = Color3.fromRGB(40, 70, 140)
						}):Play()
					else
						TweenService:Create(Checkbox, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
							BackgroundColor3 = Color3.fromRGB(50, 50, 80)
						}):Play()
					end
				end
				
				OptionBtn.MouseButton1Click:Connect(function()
					if table.find(Selected, v) then
						table.remove(Selected, table.find(Selected, v))
					else
						table.insert(Selected, v)
					end
					UpdateCheckmark()
					UpdateSelectedText()
					Config.Callback(Selected)
				end)
				
				Checkbox.MouseButton1Click:Connect(function()
					if table.find(Selected, v) then
						table.remove(Selected, table.find(Selected, v))
					else
						table.insert(Selected, v)
					end
					UpdateCheckmark()
					UpdateSelectedText()
					Config.Callback(Selected)
				end)
				
				OptionButtons[v] = {Frame = OptionFrame, Checkmark = Checkmark, Update = UpdateCheckmark}
				UpdateCheckmark()
			end
			
			DropdownHold.CanvasSize = UDim2.new(0, 0, 0, DropdownHoldLayout.AbsoluteContentSize.Y)
			
			DropdownHoldLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				DropdownHold.CanvasSize = UDim2.new(0, 0, 0, DropdownHoldLayout.AbsoluteContentSize.Y)
			end)
			
			function MultipleDropdown:UpdateMultipleDropdown(NewConfig)
				NewConfig = NewConfig or {}
				Config.Name = NewConfig.Name or Config.Name
				Config.List = NewConfig.List or Config.List
				Config.Callback = NewConfig.Callback or Config.Callback
				
				DropdownTitle.Text = Config.Name
				
				for i, v in next, OptionButtons do
					v.Frame:Destroy()
				end
				OptionButtons = {}
				
				for i, v in next, Config.List do
					local OptionFrame = Instance.new("Frame")
					local OptionBtn = Instance.new("TextButton")
					local OptionBtnCorner = Instance.new("UICorner")
					local Checkbox = Instance.new("Frame")
					local CheckboxCorner = Instance.new("UICorner")
					local Checkmark = Instance.new("ImageLabel")
					
					OptionFrame.Name = "OptionFrame"
					OptionFrame.Parent = DropdownHold
					OptionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					OptionFrame.BackgroundTransparency = 1.000
					OptionFrame.Size = UDim2.new(1, -10, 0, 30)
					OptionFrame.ZIndex = 4
					
					OptionBtn.Name = "OptionBtn"
					OptionBtn.Parent = OptionFrame
					OptionBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
					OptionBtn.Size = UDim2.new(1, -30, 1, 0)
					OptionBtn.Position = UDim2.new(0, 30, 0, 0)
					OptionBtn.AutoButtonColor = false
					OptionBtn.Font = Enum.Font.Gotham
					OptionBtn.Text = v
					OptionBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
					OptionBtn.TextSize = 14.000
					OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
					OptionBtn.ZIndex = 4
					
					OptionBtnCorner.CornerRadius = UDim.new(0, 6)
					OptionBtnCorner.Parent = OptionBtn
					
					Checkbox.Name = "Checkbox"
					Checkbox.Parent = OptionFrame
					Checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
					Checkbox.Position = UDim2.new(0, 5, 0, 5)
					Checkbox.Size = UDim2.new(0, 20, 0, 20)
					Checkbox.ZIndex = 4
					
					CheckboxCorner.CornerRadius = UDim.new(0, 4)
					CheckboxCorner.Parent = Checkbox
					
					Checkmark.Name = "Checkmark"
					Checkmark.Parent = Checkbox
					Checkmark.AnchorPoint = Vector2.new(0.5, 0.5)
					Checkmark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Checkmark.BackgroundTransparency = 1.000
					Checkmark.Position = UDim2.new(0.5, 0, 0.5, 0)
					Checkmark.Size = UDim2.new(0, 14, 0, 14)
					Checkmark.Image = "rbxassetid://6031090990"
					Checkmark.ImageColor3 = Color3.fromRGB(100, 150, 255)
					Checkmark.Visible = table.find(Selected, v) ~= nil
					Checkmark.ZIndex = 5
					
					local function UpdateCheckmark()
						Checkmark.Visible = table.find(Selected, v) ~= nil
						if Checkmark.Visible then
							TweenService:Create(Checkbox, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
								BackgroundColor3 = Color3.fromRGB(40, 70, 140)
							}):Play()
						else
							TweenService:Create(Checkbox, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
								BackgroundColor3 = Color3.fromRGB(50, 50, 80)
							}):Play()
						end
					end
					
					OptionBtn.MouseButton1Click:Connect(function()
						if table.find(Selected, v) then
							table.remove(Selected, table.find(Selected, v))
						else
							table.insert(Selected, v)
						end
						UpdateCheckmark()
						UpdateSelectedText()
						Config.Callback(Selected)
					end)
					
					Checkbox.MouseButton1Click:Connect(function()
						if table.find(Selected, v) then
							table.remove(Selected, table.find(Selected, v))
						else
							table.insert(Selected, v)
						end
						UpdateCheckmark()
						UpdateSelectedText()
						Config.Callback(Selected)
					end)
					
					OptionButtons[v] = {Frame = OptionFrame, Checkmark = Checkmark, Update = UpdateCheckmark}
					UpdateCheckmark()
				end
			end
			
			function MultipleDropdown:SetValue(NewValues)
				Selected = NewValues or {}
				for option, data in pairs(OptionButtons) do
					data.Update()
				end
				UpdateSelectedText()
				Config.Callback(Selected)
			end
			
			function MultipleDropdown:GetValue()
				return Selected
			end
			
			return MultipleDropdown
		end
		
		function Tab:CreateTextBox(Config)
			Config = Config or {}
			Config.Name = Config.Name or "Text Box"
			Config.Placeholder = Config.Placeholder or "Enter text..."
			Config.Default = Config.Default or ""
			Config.Callback = Config.Callback or function() end
			
			local TextBox = {}
			local Text = Config.Default
			
			local TextBoxFrame = Instance.new("Frame")
			local TextBoxFrameCorner = Instance.new("UICorner")
			local TextBoxTitle = Instance.new("TextLabel")
			local TextBoxInner = Instance.new("TextBox")
			local TextBoxInnerCorner = Instance.new("UICorner")
			
			TextBoxFrame.Name = "TextBoxFrame"
			TextBoxFrame.Parent = Container
			TextBoxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
			TextBoxFrame.Size = UDim2.new(0, 360, 0, 40)
			TextBoxFrame.ZIndex = 2
			
			TextBoxFrameCorner.CornerRadius = UDim.new(0, 6)
			TextBoxFrameCorner.Parent = TextBoxFrame
			
			TextBoxTitle.Name = "TextBoxTitle"
			TextBoxTitle.Parent = TextBoxFrame
			TextBoxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextBoxTitle.BackgroundTransparency = 1.000
			TextBoxTitle.Position = UDim2.new(0, 15, 0, 0)
			TextBoxTitle.Size = UDim2.new(0, 200, 1, 0)
			TextBoxTitle.Font = Enum.Font.Gotham
			TextBoxTitle.Text = Config.Name
			TextBoxTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
			TextBoxTitle.TextSize = 14.000
			TextBoxTitle.TextXAlignment = Enum.TextXAlignment.Left
			TextBoxTitle.ZIndex = 2
			
			TextBoxInner.Name = "TextBoxInner"
			TextBoxInner.Parent = TextBoxFrame
			TextBoxInner.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
			TextBoxInner.Position = UDim2.new(1, -125, 0, 5)
			TextBoxInner.Size = UDim2.new(0, 110, 0, 30)
			TextBoxInner.Font = Enum.Font.Gotham
			TextBoxInner.PlaceholderText = Config.Placeholder
			TextBoxInner.Text = Text
			TextBoxInner.TextColor3 = Color3.fromRGB(220, 220, 255)
			TextBoxInner.TextSize = 14.000
			TextBoxInner.ZIndex = 2
			
			TextBoxInnerCorner.CornerRadius = UDim.new(0, 6)
			TextBoxInnerCorner.Parent = TextBoxInner
			
			TextBoxInner.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					Text = TextBoxInner.Text
					Config.Callback(Text)
				end
			end)
			
			function TextBox:UpdateTextBox(NewConfig)
				NewConfig = NewConfig or {}
				Config.Name = NewConfig.Name or Config.Name
				Config.Placeholder = NewConfig.Placeholder or Config.Placeholder
				Config.Callback = NewConfig.Callback or Config.Callback
				
				TextBoxTitle.Text = Config.Name
				TextBoxInner.PlaceholderText = Config.Placeholder
			end
			
			function TextBox:SetValue(NewValue)
				Text = NewValue
				TextBoxInner.Text = Text
				Config.Callback(Text)
			end
			
			return TextBox
		end
		
		function Tab:CreateLabel(Config)
			Config = Config or {}
			Config.Name = Config.Name or "Label"
			Config.Text = Config.Text or "Label Text"
			
			local Label = {}
			
			local LabelFrame = Instance.new("Frame")
			local LabelFrameCorner = Instance.new("UICorner")
			local LabelTitle = Instance.new("TextLabel")
			local LabelText = Instance.new("TextLabel")
			
			LabelFrame.Name = "LabelFrame"
			LabelFrame.Parent = Container
			LabelFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
			LabelFrame.Size = UDim2.new(0, 360, 0, 40)
			LabelFrame.ZIndex = 2
			
			LabelFrameCorner.CornerRadius = UDim.new(0, 6)
			LabelFrameCorner.Parent = LabelFrame
			
			LabelTitle.Name = "LabelTitle"
			LabelTitle.Parent = LabelFrame
			LabelTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			LabelTitle.BackgroundTransparency = 1.000
			LabelTitle.Position = UDim2.new(0, 15, 0, 0)
			LabelTitle.Size = UDim2.new(0, 200, 1, 0)
			LabelTitle.Font = Enum.Font.Gotham
			LabelTitle.Text = Config.Name
			LabelTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
			LabelTitle.TextSize = 14.000
			LabelTitle.TextXAlignment = Enum.TextXAlignment.Left
			LabelTitle.ZIndex = 2
			
			LabelText.Name = "LabelText"
			LabelText.Parent = LabelFrame
			LabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			LabelText.BackgroundTransparency = 1.000
			LabelText.Position = UDim2.new(1, -125, 0, 0)
			LabelText.Size = UDim2.new(0, 110, 1, 0)
			LabelText.Font = Enum.Font.Gotham
			LabelText.Text = Config.Text
			LabelText.TextColor3 = Color3.fromRGB(220, 220, 255)
			LabelText.TextSize = 14.000
			LabelText.TextXAlignment = Enum.TextXAlignment.Right
			LabelText.ZIndex = 2
			
			function Label:UpdateLabel(NewConfig)
				NewConfig = NewConfig or {}
				Config.Name = NewConfig.Name or Config.Name
				Config.Text = NewConfig.Text or Config.Text
				
				LabelTitle.Text = Config.Name
				LabelText.Text = Config.Text
			end
			
			return Label
		end
		
		table.insert(Tabs, Tab)
		return Tab
	end
	
	function Kavo:ToggleUI()
		Main.Enabled = not Main.Enabled
	end
	
	return Kavo
end

return Kavo
