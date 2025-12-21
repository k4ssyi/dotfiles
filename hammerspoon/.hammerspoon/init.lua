hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({})
hs.hotkey.bind({"alt"}, "space", function()
  local ghostty = hs.application.find('Ghostty')
  if ghostty:isFrontmost() then
    ghostty:hide()
  else
    hs.application.launchOrFocus("/Applications/Ghostty.app")
  end
end)
