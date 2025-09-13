# 1.6.5
## Changelog:
- Added `Window:UnlockAll()` `Window:LockAll()` `Window:GetLocked()` `Window:GetUnlocked()` functions
- Added New Elements. Enable by `NewElements = true` in `CreateWindow({ ... })` function (beta)
- Added `Window.Icon:Enable()` and `Window.Icon:Disable()` and `Window.Icon:SetAnonymous(true)`
- Added `HidePanelBackground = true` in `CreateWindow({ ... })` function
- Added `Window:Toggle()` to toggle the ui (close & open)
- Added `MinSize` and `MaxSize` to `Window`
- Added `Tab:Select()` to `Tab` element
- Added `Window:SetIconSize(48)`
- Added `Window:OnOpen()`
- Added `Icon` to `Button`
- Added `SearchBarEnabled = true` to `Dropdown ` element
- Fixed `pandadevelopment` in KeySystem 
- Fixed `Locked` in `Toggle` element
- Fixed `OpenButton` element (visibility)
- Fixed Config `:Save()` function
- Fixed some bugs
- Reworked themes
- Removed Default toggle key

> This doesn't work :( <br>
> `Tab:UnlockAll()` `Tab:LockAll()` `Tab:GetLocked()` `Tab:GetUnlocked()`