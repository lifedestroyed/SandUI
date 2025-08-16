return {
    Elements = {
        Paragraph   = require("./Paragraph"),
        Button      = require("./Button"),
        Toggle      = require("./Toggle"),
        Slider      = require("./Slider"),
        Keybind     = require("./Keybind"),
        Input       = require("./Input"),
        Dropdown    = require("./Dropdown"),
        Code        = require("./Code"),
        Colorpicker = require("./Colorpicker"),
        Section     = require("./Section"),
        Divider     = require("./Divider"),
    },
    Load = function(tbl, Container, Elements, Window, WindUI, OnElementCreateFunction, ElementsModule, UIScale)
        for name, module in pairs(Elements) do
            tbl[name] = function(self, config)
                config = config or {}
                config.Parent = Container
                config.Window = Window
                config.WindUI = WindUI
                config.UIScale = UIScale
                config.ElementsModule = ElementsModule
        
                local elementInstance, content = module:New(config)
                table.insert(tbl.Elements, content)
        
                local frame
                for key, value in pairs(content) do
                    if typeof(value) == "table" and key:match("Frame$") then
                        frame = value
                        break
                    end
                end
                
                if frame then
                    function content:SetTitle(title)
                        frame:SetTitle(title)
                    end
                    function content:SetDesc(desc)
                        frame:SetDesc(desc)
                    end
                    function content:Destroy()
                        frame:Destroy()
                    end
                end
                
                if OnElementCreateFunction then
                    OnElementCreateFunction()
                end
                return content
            end
        end

    end
}