hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({})
local TERMINAL_APP = 'Ghostty'

hs.hotkey.bind({"alt"}, "space", function()
  local terminal = hs.application.find(TERMINAL_APP)
  if terminal and terminal:isFrontmost() then
    terminal:hide()
  else
    hs.application.launchOrFocus(TERMINAL_APP)
  end
end)
