local WindUI = require("./src/init")


-- */  Window  /* --
local Window = WindUI:CreateWindow({
    Title = ".ftgs hub",
    Author = "by .ftgs",
    NewElements = true,
})

--Window:SetTitle(Window.Title .. " | " .. WindUI.Version)


-- */  Configuring OpenButton  /* --
Window:EditOpenButton({
    Title = "Open .ftgs hub UI", -- can be changed
    CornerRadius = UDim.new(1,0), -- fully rounded
    StrokeThickness = 0, -- removing outline
    Enabled = true, -- enable or disable openbutton
    Draggable = true,
    
    
    -- Icon = "monitor",
    -- Color = ColorSequence.new( -- gradient
    --     Color3.fromHex("FF0F7B"), 
    --     Color3.fromHex("F89B29")
    -- ),
    -- OnlyMobile = false,
})


-- */  Elements Section  /* --
local ElementsSection = Window:Section({
    Title = "Elements",
})


-- */  Toggle Tab  /* --
do
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
end


-- */  Button Tab  /* --
do
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
end


-- */  Input Tab  /* --
do
    local InputTab = ElementsSection:Tab({
        Title = "Input",
        Icon = "text-cursor-input",
    })
    
    
    InputTab:Input({
        Title = "Input",
        Icon = "mouse"
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input Textarea",
        Type = "Textarea",
        Icon = "mouse",
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input Textarea",
        Type = "Textarea",
        --Icon = "mouse",
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input",
        Desc = "Input example",
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input Textarea",
        Desc = "Input example",
        Type = "Textarea",
    })
    
    InputTab:Space()
    
    
    InputTab:Input({
        Title = "Input",
        Locked = true,
    })
    
    
    InputTab:Input({
        Title = "Input",
        Desc = "Input example",
        Locked = true,
    })
end


