-- Default modifier keys
local mash = {"cmd", "alt", "shift"}

-- Quick config reload
hs.hotkey.bind(mash, "R", function ()
  hs.reload()
end)

----------------------
-- Helper Functions --
----------------------
-- Wrapper for the native OSX notification
local function notify(title, text)
  hs.notify.new({title = title, informativeText = text}):send()
end

----------------------------
-- Caffeine functionality --
----------------------------
local caffeine = hs.menubar.new()
function setCaffeineIcon(state)
    if state then
        caffeine:setIcon("emblemFull.png")
        notify("Caffeinated")
    else
        caffeine:setIcon("emblemEmpty.png")
        notify("Decaffeinated")
    end
end

function caffeineClicked()
    setCaffeineIcon(hs.caffeinate.toggle("displayIdle"))
end

-- Initally set the icon silently
if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    caffeine:setIcon("emblemEmpty.png")
end

hs.hotkey.bind(mash, "/", function() caffeineClicked() end)

-----------------------
-- Window Management --
-----------------------
-- Move and resize window "Right", "Left", "Up", "Down", or "Full"
local function moveWindow(pos)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  -- Set x position
  if pos == "Right" then
    f.x = max.x + (max.w / 2)
  else
    f.x = max.x
  end

  -- Set y position
  if pos == "Down" then
    f.y = max.y / 2 + (max.h / 2)
  else
    f.y = max.y
  end

  -- Set height
  if pos == "Up" or pos == "Down" then
    f.h = max.h / 2
  else
    f.h = max.h
  end

  -- Set width
  if pos == "Left" or pos == "Right" then
    f.w = max.w / 2
  else
    f.w = max.w
  end

  win:setFrame(f)
end

hs.hotkey.bind(mash, "Right", function () moveWindow("Right") end)
hs.hotkey.bind(mash, "Left", function() moveWindow("Left") end)
hs.hotkey.bind(mash, "Up", function() moveWindow("Up") end)
hs.hotkey.bind(mash, "Down", function() moveWindow("Down") end)
hs.hotkey.bind(mash, "F", function() moveWindow("Full") end)

-- Indicate config is loaded
hs.alert("Config loaded")