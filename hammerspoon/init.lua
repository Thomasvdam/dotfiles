---------------
-- Constants --
---------------
local cmnd_alt_shift = {"cmd", "alt", "shift"}
local cmnd_shift = {"cmd", "shift"}
local main_monitor = "Color LCD"
local second_monitor = "DELL U2415"

-------------------
-- Configuration --
-------------------
hs.window.animationDuration = 0

------------
-- Reload --
------------

-- Quick config reload
hs.hotkey.bind(cmnd_alt_shift, "R", function ()
    hs.reload()
end)

----------------------
-- Helper Functions --
----------------------
-- Wrapper for the native OSX notification
local function notify(title, text)
  hs.notify.new({title = title, informativeText = text}):send()
end

-- Get a monitor by name
function hs.screen.get(screen_name)
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    if screen:name() == screen_name then
      return screen
    end
  end
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
    setCaffeineIcon(hs.caffeinate.toggle("systemIdle"))
end

-- Initally set the icon silently
if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    caffeine:setIcon("emblemEmpty.png")
end

hs.hotkey.bind(cmnd_alt_shift, "/", function() caffeineClicked() end)

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
    f.y = max.y + (max.h / 2)
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

hs.hotkey.bind(cmnd_alt_shift, "Right", function () moveWindow("Right") end)
hs.hotkey.bind(cmnd_alt_shift, "Left", function() moveWindow("Left") end)
hs.hotkey.bind(cmnd_alt_shift, "Up", function() moveWindow("Up") end)
hs.hotkey.bind(cmnd_alt_shift, "Down", function() moveWindow("Down") end)
hs.hotkey.bind(cmnd_alt_shift, "F", function() moveWindow("Full") end)

-- Move atom to the left monitor
hs.hotkey.bind(cmnd_shift, "A", function ()
  local win = hs.window.focusedWindow()
  win:moveToScreen(hs.screen.get(second_monitor));
end)

-- Move atom to the right monitor
hs.hotkey.bind(cmnd_shift, "D", function ()
  local win = hs.window.focusedWindow()
  win:moveToScreen(hs.screen.get(main_monitor));
end)

-- Indicate config is loaded
hs.alert("Config loaded")
