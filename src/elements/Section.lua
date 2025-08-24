local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Element = {}

function Element:New(Config)
    local Section = {
        __type = "Section",
        Title = Config.Title or "Section",
        Icon = Config.Icon,
        TextXAlignment = Config.TextXAlignment or "Left",
        TextSize = Config.TextSize or 19,
        UIElements = {},
        
        HeaderSize = 42,
        IconSize = 24,
        
        Elements = {},
        
        Expandable = false,
    }
    
    local Icon

    
    function Section:SetIcon(i)
        Section.Icon = i or nil
        if Icon then Icon:Destroy() end
        if i then
            Icon = Creator.Image(
                i,
                i .. ":" .. Section.Title,
                0,
                Config.Window.Folder,
                Section.__type,
                true
            )
            Icon.Size = UDim2.new(0,Section.IconSize,0,Section.IconSize)
        end
    end
    
    local ChevronIconFrame = New("Frame", {
        Size = UDim2.new(0,Section.IconSize,0,Section.IconSize),
        BackgroundTransparency = 1,
        Visible = false
    }, {
        New("ImageLabel", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Image = Creator.Icon("chevron-down")[1],
            ImageRectSize = Creator.Icon("chevron-down")[2].ImageRectSize,
            ImageRectOffset = Creator.Icon("chevron-down")[2].ImageRectPosition,
            ThemeTag = {
                ImageColor3 = "Icon",
            },
            ImageTransparency = .7,
        })
    })
    
    
    if Section.Icon then
        Section:SetIcon(Section.Icon)
    end
    
    local TitleFrame = New("TextLabel", {
        BackgroundTransparency = 1,
        TextXAlignment = "Left",
        AutomaticSize = "Y",
        TextSize = Section.TextSize,
        ThemeTag = {
            TextColor3 = "Text",
        },
        FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
        --Parent = Config.Parent,
        --Size = UDim2.new(1,0,0,0),
        Text = Section.Title,
        Size = UDim2.new(
            1, 
            Icon and (-Section.IconSize-8)*2
                or (-Section.IconSize-8),
                
            1,
            0
        ),
        TextWrapped = true,
    })

    local Main = New("Frame", {
        Size = UDim2.new(1,0,0,Section.HeaderSize),
        BackgroundTransparency = 1,
        --AutomaticSize = "Y",
        Parent = Config.Parent,
        ClipsDescendants = true,
    }, {
        New("TextButton", {
            Size = UDim2.new(1,0,0,Section.HeaderSize),
            BackgroundTransparency = 1,
            Text = "",
        }, {
            Icon,
            TitleFrame,
            New("UIListLayout", {
                Padding = UDim.new(0,8),
                FillDirection = "Horizontal",
                VerticalAlignment = "Center",
                HorizontalAlignment = not Icon and Section.TextXAlignment or "Left",
            }),
            New("UIPadding", {
                PaddingTop = UDim.new(0,4),
                PaddingBottom = UDim.new(0,2),
            }),
            ChevronIconFrame,
        }),
        New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = "Y",
            Name = "Content",
            Visible = true,
            Position = UDim2.new(0,0,0,Section.HeaderSize)
        }, {
            New("UIListLayout", {
                FillDirection = "Vertical",
                Padding = UDim.new(0,6),
                VerticalAlignment = "Bottom",
            }),
        })
    })

    -- Section.UIElements.Main:GetPropertyChangedSignal("TextBounds"):Connect(function()
    --     Section.UIElements.Main.Size = UDim2.new(1,0,0,Section.UIElements.Main.TextBounds.Y)
    -- end)
    
    
    
    local ElementsModule = Config.ElementsModule
    
    ElementsModule.Load(Section, Main.Content, ElementsModule.Elements, Config.Window, Config.WindUI, function()
        if not Section.Expandable then
            Section.Expandable = true
            ChevronIconFrame.Visible = true
        end
    end)
    
    
    function Section:SetTitle(Title)
        TitleFrame.Text = Title
    end
    
    function Section:Destroy()
        for _,element in next, Section.Elements do
            element:Destroy()
        end
        
        -- Section.UIElements.Main.AutomaticSize = "None"
        -- Section.UIElements.Main.Size = UDim2.new(1,0,0,Section.UIElements.Main.TextBounds.Y)
        
        -- Tween(Section.UIElements.Main, .1, {TextTransparency = 1}):Play()
        -- task.wait(.1)
        -- Tween(Section.UIElements.Main, .15, {Size = UDim2.new(1,0,0,0)}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
        
        Main:Destroy()
    end
    
    function Section:Open()
        if Section.Expandable then
            Section.Opened = true
            Tween(Main, 0.33, {
                Size = UDim2.new(1,0,0, Section.HeaderSize + (Main.Content.AbsoluteSize.Y/Config.UIScale))
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            
            Tween(ChevronIconFrame.ImageLabel, 0.1, {Rotation = 180}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end
    end
    function Section:Close()
        if Section.Expandable then
            Section.Opened = false
            Tween(Main, 0.26, {
                Size = UDim2.new(1,0,0, Section.HeaderSize)
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            Tween(ChevronIconFrame.ImageLabel, 0.1, {Rotation = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
        end
    end
    
    Creator.AddSignal(Main.TextButton.MouseButton1Click, function()
        if Section.Expandable then
            if Section.Opened then
                Section:Close()
            else
                Section:Open()
            end
        end
    end)
    
    if Section.Opened then
        task.spawn(function()
            task.wait()
            Section:Open()
        end)
    end

    
    return Section.__type, Section
end

return Element