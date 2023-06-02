-- Hacky script inspired by resources online to get an indication of
-- the active layer on my Atreus keyboard.
-- Relies on a custom Kaleidoscope plugin that sends unused function keys
-- when the layer changes, which we then map to hardcoded names here.
-- Would be nice to send the layer name from the keyboard somehow...
 
local layer_info = hs.menubar.new()
layer_info:setTooltip("Active Keyboard Layer")

local function setTitle(layer_name, description)
    layer_info:setTitle(layer_name)
    layer_info:setTooltip("Active Layer: "..description)
end

-- Base layer
function setBaseActive()
    setTitle("⌨", 'Base')
end

-- Function layer (active when fun key is held)
function setNumeralsActive()
    setTitle("ƛ", 'Numerals')
end

-- Controls layer (toggled with fun+esc)
function setControlsActive()
    setTitle("⚙︎", 'Function Keys')
end

-- macOS layer (active when esc is held)
function setMacOSActive()
    setTitle("⌘", 'macOS')
end

hs.hotkey.bind({}, 'f13', setBaseActive)
hs.hotkey.bind({}, 'f16', setNumeralsActive)
hs.hotkey.bind({}, 'f17', setControlsActive)
hs.hotkey.bind({}, 'f18', setMacOSActive)

-- Reasonable to assume we start in the base layer
setBaseActive()
