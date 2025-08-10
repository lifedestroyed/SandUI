return {
    platoboost = {
        Name = "Platoboost",
        Icon = "rbxassetid://75920162824531",
        Args = {"ServiceId", "Secret"},
        
        
        New = require("./Platoboost").New
    },
    pandadevelopment = {
        Name = "Panda Development",
        Icon = "panda",
        Args = {"ServiceId"},
        
        
        New = require("./PandaDevelopment").New
    },
    -- other Services...
}