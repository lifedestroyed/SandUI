local WindUI = require("./src/init")


local Window = WindUI:CreateWindow({
    Title = ".ftgs hub",
    Author = "by .ftgs",
    NewElements = true,
})

Window:SetTitle(Window.Title .. " | " .. WindUI.Version)

-- */  Elements Section  /* --

local ElementsSection = Window:Section({
    Title = "Elements",
})



-- */  Toggle Tab  /* --

local ToggleTab = ElementsSection:Tab({
    Title = "Toggle",
    Icon = "arrow-left-right"
})


ToggleTab:Toggle({
    Title = "Toggle",
})

ToggleTab:Space()

ToggleTab:Toggle({
    Title = "Toggle",
    Desc = "Toggle example"
})

ToggleTab:Space()


ToggleTab:Toggle({
    Title = "Toggle",
    Locked = true,
})

ToggleTab:Toggle({
    Title = "Toggle",
    Desc = "Toggle example",
    Locked = true,
})



-- */  Button Tab  /* --

local ButtonTab = ElementsSection:Tab({
    Title = "Button",
    Icon = "mouse-pointer-click",
})


ButtonTab:Button({
    Title = "Button",
    Icon = "mouse"
})

ButtonTab:Space()

ButtonTab:Button({
    Title = "Button",
    Desc = "Button example",
})

ButtonTab:Space()

ButtonTab:Button({
    Title = "Button",
    Locked = true,
})


ButtonTab:Button({
    Title = "Button",
    Desc = "Button example",
    Locked = true,
})