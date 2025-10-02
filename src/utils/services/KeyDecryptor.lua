local KeyDecryptor = {}

function KeyDecryptor.New(githubRawUrl)
    local fixedXORKey = 42

    local function decodeBase64(data)
        local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        data = string.gsub(data, '[^'..b..'=]', '')
        return (data:gsub('.', function(x)
            if (x == '=') then return '' end
            local r,f='',(b:find(x)-1)
            for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
            return r;
        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
            if (#x ~= 8) then return '' end
            local c=0
            for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
            return string.char(c)
        end))
    end

    local function xorDecrypt(encrypted)
        local decoded = decodeBase64(encrypted)
        local result = {}
        for i = 1, #decoded do
            local charCode = string.byte(decoded, i)
            result[i] = string.char(charCode ~ fixedXORKey)
        end
        return table.concat(result)
    end

    function GetKeys()
        local success, encryptedText = pcall(function()
            return game:HttpGet(githubRawUrl)
        end)

        if not success then
            return false, "Key Decrypt Error: " .. encryptedText
        end

        local encryptedKeys = {}
        for line in encryptedText:gmatch("[^\r\n]+") do
            table.insert(encryptedKeys, line)
        end

        local decryptedKeys = {}
        for _, encryptedKey in ipairs(encryptedKeys) do
            table.insert(decryptedKeys, xorDecrypt(encryptedKey))
        end

        return true, decryptedKeys
    end

    return {
        GetKeys = GetKeys
    }
end

return KeyDecryptor
