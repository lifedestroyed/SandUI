local KeySystem = {}
local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween
local CreateButton = require("./ui/Button").New
local CreateInput = require("./ui/Input").New

function KeySystem.new(Config, Filename, func)
    local KeyDialogInit = require("./window/Dialog").Init(nil, Config.WindUI.ScreenGui.KeySystem)
    local KeyDialog = KeyDialogInit.Create(true)

    local Services = {}

    local EnteredKey

    local ThumbnailSize = (Config.KeySystem.Thumbnail and Config.KeySystem.Thumbnail.Width) or 200

    local UISize = 430
    if Config.KeySystem.Thumbnail and Config.KeySystem.Thumbnail.Image then
        UISize = 430 + (ThumbnailSize / 2)
    end

    KeyDialog.UIElements.Main.AutomaticSize = "Y"
    KeyDialog.UIElements.Main.Size = UDim2.new(0, UISize, 0, 0)

    -- Остальной код интерфейса остается без изменений

    local function handleSuccess(key)
        KeyDialog:Close()()
        writefile((Config.Folder or Config.Title) .. "/" .. Filename .. ".key", tostring(key))
        task.wait(.4)
        func(true)
    end

    local SubmitButton = CreateButton("Submit", "arrow-right", function()
        local key = tostring(EnteredKey or "empty")
        local folder = Config.Folder or Config.Title

        if Config.KeySystem.API then
            -- Логика для API сервисов
            local isSuccess, result
            for _, service in next, Services do
                if service.Type == "keydecryptor" then
                    local success, decryptedKeys = service.GetKeys()
                    if success then
                        -- Проверяем, есть ли введенный ключ в расшифрованных ключах
                        local isValid = false
                        for _, decryptedKey in ipairs(decryptedKeys) do
                            if decryptedKey == key then
                                isValid = true
                                break
                            end
                        end
                        if isValid then
                            handleSuccess(key)
                            return
                        else
                            result = "Invalid key."
                        end
                    else
                        result = decryptedKeys
                    end
                else
                    local success, res = service.Verify(key)
                    if success then
                        isSuccess, result = true, res
                        break
                    end
                    result = res
                end
            end

            if isSuccess then
                handleSuccess(key)
            else
                Config.WindUI:Notify({
                    Title = "Key System. Error",
                    Content = result,
                    Icon = "triangle-alert",
                })
            end
        else
            -- Логика для обычных ключей
            local isKey = type(Config.KeySystem.Key) == "table" and table.find(Config.KeySystem.Key, key) or Config.KeySystem.Key == key
            if isKey then
                if Config.KeySystem.SaveKey then
                    handleSuccess(key)
                else
                    KeyDialog:Close()()
                    task.wait(.4)
                    func(true)
                end
            end
        end
    end, "Primary", ButtonsContainer)

    SubmitButton.AnchorPoint = Vector2.new(1, 0.5)
    SubmitButton.Position = UDim2.new(1, 0, 0.5, 0)

    KeyDialog:Open()
end

return KeySystem
