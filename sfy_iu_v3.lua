-- Full feature demonstration
local SfyUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Scripforyou/sfy_ui/refs/heads/main/sfy_ui_v3.lua"))()
local menu = SfyUI:new()

-- Demonstrate all features
menu:addTab("Player", {
    {type = "button", text = "Heal Player", callback = function() print("Healed!") end},
    {type = "slider", text = "Health", value = 100, min = 0, max = 200, callback = function(v) print("Health:", v) end},
    {type = "slider", text = "Armor", value = 100, min = 0, max = 200, callback = function(v) print("Armor:", v) end},
    {type = "slider", text = "Speed", value = 16, min = 0, max = 100, callback = function(v) print("Speed:", v) end},
    {type = "label", text = "Advanced Settings"},
    {type = "button", text = "God Mode", callback = function() print("God mode toggled!") end},
    {type = "button", text = "Infinite Jump", callback = function() print("Infinite jump!") end}
})

menu:addTab("Weapons", {
    {type = "button", text = "Give All Weapons", callback = function() print("Weapons given!") end},
    {type = "slider", text = "Damage", value = 1, min = 0.1, max = 10, callback = function(v) print("Damage:", v) end},
    {type = "slider", text = "Fire Rate", value = 100, min = 50, max = 200, callback = function(v) print("Fire rate:", v) end}
})

-- Add many tabs to test scrolling
for i = 1, 10 do
    menu:addTab("Tab " .. i, {
        {type = "label", text = "This is tab " .. i},
        {type = "button", text = "Button " .. i, callback = function() print("Tab", i, "button") end}
    })
end

-- Customize UI appearance
menu.config.menu.position = {x = 150, y = 100}
menu.config.menu.width = 650
menu.config.menu.height = 450
menu.config.menu.tabWidth = 120

-- Show menu
menu.state.visible = true

print("🚀 SfyUI v3 Loaded Successfully!")
print("📊 Features enabled:")
print("   • Left-side tabs")
print("   • Scrollable tabs")
print("   • Scrollable content") 
print("   • Buttons, sliders, labels")
print("   • Mouse wheel support")
