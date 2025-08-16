local Creator = require("../../modules/Creator")
local New = Creator.New
local NewRoundFrame = Creator.NewRoundFrame
local Tween = Creator.Tween

local UserInputService = game:GetService("UserInputService")


local function Color3ToHSB(color)
	local r, g, b = color.R, color.G, color.B
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local delta = max - min

	local h = 0
	if delta ~= 0 then
		if max == r then
			h = (g - b) / delta % 6
		elseif max == g then
			h = (b - r) / delta + 2
		else
			h = (r - g) / delta + 4
		end
		h = h * 60
	else
		h = 0
	end

	local s = (max == 0) and 0 or (delta / max)
	local v = max

	return {
		h = math.floor(h + 0.5),
		s = s,
		b = v
	}
end

local function GetPerceivedBrightness(color)
	local r = color.R
	local g = color.G
	local b = color.B
	return 0.299 * r + 0.587 * g + 0.114 * b
end

local function GetTextColorForHSB(color)
    local hsb = Color3ToHSB(color)
	local h, s, b = hsb.h, hsb.s, hsb.b
	if GetPerceivedBrightness(color) > 0.5 then
		return Color3.fromHSV(h / 360, 0, 0.05)
	else
		return Color3.fromHSV(h / 360, 0, 0.98)
	end
end

return function(Config)
    local Element = {
        Title = Config.Title,
        Desc = Config.Desc or nil,
        Hover = Config.Hover,
        Thumbnail = Config.Thumbnail,
        ThumbnailSize = Config.ThumbnailSize or 80,
        Image = Config.Image,
        IconThemed = Config.IconThemed or false,
        ImageSize = Config.ImageSize or 30,
        Color = Config.Color,
        Scalable = Config.Scalable,
        Parent = Config.Parent,
        UIPadding = 13,
        UICorner = 12,
        UIElements = {}
    }
    
    local ImageSize = Element.ImageSize
    local ThumbnailSize = Element.ThumbnailSize
    local CanHover = true
    local Hovering = false
    
    local IconOffset = 0
    
    local ThumbnailFrame
    local ImageFrame
    if Element.Thumbnail then
        ThumbnailFrame = Creator.Image(
            Element.Thumbnail, 
            Element.Title, 
            Element.UICorner-3, 
            Config.Window.Folder,
            "Thumbnail",
            false,
            Element.IconThemed
        )
        ThumbnailFrame.Size = UDim2.new(1,0,0,ThumbnailSize)
    end
    if Element.Image then
        ImageFrame = Creator.Image(
            Element.Image, 
            Element.Title, 
            Element.UICorner-3, 
            Config.Window.Folder,
            "Image",
            not Element.Color and true or false
        )
        if typeof(Element.Color) == "string" then 
            ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
        elseif typeof(Element.Color) == "Color3" then
            ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Element.Color)
        end
        
        ImageFrame.Size = UDim2.new(0,ImageSize,0,ImageSize)
        
        IconOffset = ImageSize
    end
    
    local function CreateText(Title, Type)
        local TextColor = typeof(Element.Color) == "string" 
            and GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
            or typeof(Element.Color) == "Color3" 
            and GetTextColorForHSB(Element.Color)
        
        return New("TextLabel", {
            BackgroundTransparency = 1,
            Text = Title or "",
            TextSize = Type == "Desc" and 14 or 16,
            TextXAlignment = "Left",
            ThemeTag = {
                TextColor3 = not Element.Color and "Text" or nil,
            },
            TextColor3 = Element.Color and TextColor or nil,
            TextTransparency = Type == "Desc" and .25 or 0,
            TextWrapped = true,
            Size = UDim2.new(1,0,0,0),
            AutomaticSize = "Y",
            FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium)
        })
    end
    
    local Title = CreateText(Element.Title, "Title")
    local Desc = CreateText(Element.Desc, "Desc")
    if not Element.Desc or Element.Desc == "" then
        Desc.Visible = false
    end
    
    Element.UIElements.Container = New("Frame", {
        Size = UDim2.new(1,0,0,0),
        AutomaticSize = "Y",
        BackgroundTransparency = 1,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0,Element.UIPadding),
            FillDirection = "Vertical",
            VerticalAlignment = "Top",
            HorizontalAlignment = "Left",
        }),
        ThumbnailFrame,
        New("Frame", {
            Size = UDim2.new(1,-Config.TextOffset,0,0),
            AutomaticSize = "Y",
            BackgroundTransparency = 1,
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0,Element.UIPadding),
                FillDirection = "Horizontal",
                VerticalAlignment = "Top",
                HorizontalAlignment = "Left",
            }),
            ImageFrame,
            New("Frame", {
                BackgroundTransparency = 1,
                AutomaticSize = "Y",
                Size = UDim2.new(1,-IconOffset,0,(50-(Element.UIPadding*2)))
            }, {
                New("UIListLayout", {
                    Padding = UDim.new(0,6),
                    FillDirection = "Vertical",
                    VerticalAlignment = "Center",
                    HorizontalAlignment = "Left",
                }),
                Title,
                Desc
            }),
        })
    })
    
    Element.UIElements.Locked = NewRoundFrame(Element.UICorner, "Squircle", {
        Size = UDim2.new(1,Element.UIPadding*2,1,Element.UIPadding*2),
        ImageTransparency = .4,
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.new(0.5,0,0.5,0),
        ImageColor3 = Color3.new(0,0,0),
        Visible = false,
        Active = false,
        ZIndex = 9999999,
    })
    
    Element.UIElements.Main = NewRoundFrame(Element.UICorner, "Squircle", {
        Size = UDim2.new(1,0,0,50),
        AutomaticSize = "Y",
        ImageTransparency = Element.Color and .05 or .95,
        --Text = "",
        --TextTransparency = 1,
        --AutoButtonColor = false,
        Parent = Config.Parent,
        ThemeTag = {
            ImageColor3 = not Element.Color and "Text" or nil
        },
        ImageColor3 = Element.Color and 
            ( 
                typeof(Element.Color) == "string" 
                    and Color3.fromHex(Creator.Colors[Element.Color]) 
                    or typeof(Element.Color) == "Color3" 
                    and Element.Color
            ) or nil
    }, {
        Element.UIElements.Container,
        Element.UIElements.Locked,
        New("UIPadding", {
            PaddingTop = UDim.new(0,Element.UIPadding),
            PaddingLeft = UDim.new(0,Element.UIPadding),
            PaddingRight = UDim.new(0,Element.UIPadding),
            PaddingBottom = UDim.new(0,Element.UIPadding),
        }),
    }, true)
    
    if Element.Hover then
        Creator.AddSignal(Element.UIElements.Main.MouseEnter, function()
            if CanHover then
                Tween(Element.UIElements.Main, .05, {ImageTransparency = Element.Color and .15 or .9}):Play()
            end
        end)
        Creator.AddSignal(Element.UIElements.Main.InputEnded, function()
            if CanHover then
                Tween(Element.UIElements.Main, .05, {ImageTransparency = Element.Color and .05 or .95}):Play()
            end
        end)
    end
    
    function Element:SetTitle(text)
        Title.Text = text
    end
    
    function Element:SetDesc(text)
        Desc.Text = text or ""
        if not text then
            Desc.Visible = false
        elseif not Desc.Visible then
            Desc.Visible = true
        end
    end
    
    
    -- function Element:Show()
        
    -- end
    
    function Element:Destroy()
        Element.UIElements.Main:Destroy()
    end
    
    
    function Element:Lock()
        CanHover = false
        Element.UIElements.Locked.Active = true
        Element.UIElements.Locked.Visible = true
    end
    
    function Element:Unlock()
        CanHover = true
        Element.UIElements.Locked.Active = false
        Element.UIElements.Locked.Visible = false
    end
    
    --task.wait(.015)
    
    --Element:Show()
    
    return Element
end