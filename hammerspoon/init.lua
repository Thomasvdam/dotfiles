---------------
-- Constants --
---------------
local cmnd_alt_shift = {"cmd", "alt", "shift"}
local cmnd_alt = {"cmd", "alt"}
local cmnd_shift = {"cmd", "shift"}

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

---------------------------------
-- Window Management Functions --
---------------------------------
-- Adapted from https://github.com/rtoshiro/hammerspoon-init by rtoshiro
function hs.screen.copyFrame(refScreen)
    local frame = refScreen:frame()
    return {
        x = frame.x,
        y = frame.y,
        w = frame.w,
        h = frame.h
    }
end

-- +-----------------+
-- |        |        |
-- |        |  HERE  |
-- |        |        |
-- +-----------------+
function hs.window.right(win)
  local targetFrame = hs.screen.copyFrame(win:screen())
  targetFrame.x = targetFrame.x + (targetFrame.w/2)
  targetFrame.w = targetFrame.w/2
  win:setFrame(targetFrame)
end

-- +-----------------+
-- |        |        |
-- |  HERE  |        |
-- |        |        |
-- +-----------------+
function hs.window.left(win)
  local targetFrame = hs.screen.copyFrame(win:screen(), false)
  targetFrame.w = targetFrame.w/2
  win:setFrame(targetFrame)
end

-- +-----------------+
-- |      HERE       |
-- +-----------------+
-- |                 |
-- +-----------------+
function hs.window.up(win)
  local targetFrame = hs.screen.copyFrame(win:screen(), false)
  targetFrame.h = targetFrame.h/2
  win:setFrame(targetFrame)
end

-- +-----------------+
-- |                 |
-- +-----------------+
-- |      HERE       |
-- +-----------------+
function hs.window.down(win)
  local targetFrame = hs.screen.copyFrame(win:screen(), false)
  targetFrame.y = targetFrame.y + targetFrame.h/2
  targetFrame.h = targetFrame.h/2
  win:setFrame(targetFrame)
end

-- +-----------------+
-- |  HERE  |        |
-- +--------+        |
-- |                 |
-- +-----------------+
function hs.window.upLeft(win)
  local targetFrame = hs.screen.copyFrame(win:screen(), false)
  targetFrame.w = targetFrame.w/2
  targetFrame.h = targetFrame.h/2
  win:setFrame(targetFrame)
end

-- +-----------------+
-- |                 |
-- +--------+        |
-- |  HERE  |        |
-- +-----------------+
function hs.window.downLeft(win)
  local targetFrame = hs.screen.copyFrame(win:screen(), false)
  win:setFrame({
    x = targetFrame.x,
    y = targetFrame.y + targetFrame.h/2,
    w = targetFrame.w/2,
    h = targetFrame.h/2
  })
end

-- +-----------------+
-- |                 |
-- |        +--------|
-- |        |  HERE  |
-- +-----------------+
function hs.window.downRight(win)
  local targetFrame = hs.screen.copyFrame(win:screen(), false)
  win:setFrame({
    x = targetFrame.x + targetFrame.w/2,
    y = targetFrame.y + targetFrame.h/2,
    w = targetFrame.w/2,
    h = targetFrame.h/2
  })
end

-- +-----------------+
-- |        |  HERE  |
-- |        +--------|
-- |                 |
-- +-----------------+
function hs.window.upRight(win)
  local targetFrame = hs.screen.copyFrame(win:screen(), false)
  win:setFrame({
    x = targetFrame.x + targetFrame.w/2,
    y = targetFrame.y,
    w = targetFrame.w/2,
    h = targetFrame.h/2
  })
end

-- +-----------------+
-- |                 |
-- |       HERE      |
-- |                 |
-- +-----------------+
function hs.window.fullscreen(win)
  local targetFrame = hs.screen.copyFrame(win:screen(), false)
  win:setFrame(targetFrame)
end
-- End adapted from

---------------------
-- Hotkey Bindings --
---------------------
hs.hotkey.bind(cmnd_alt_shift, "Right", function ()
    local win = hs.window.focusedWindow()
    win:right()
end)

hs.hotkey.bind(cmnd_alt_shift, "Left", function ()
    local win = hs.window.focusedWindow()
    win:left()
end)

hs.hotkey.bind(cmnd_alt_shift, "Up", function ()
    local win = hs.window.focusedWindow()
    win:up()
end)

hs.hotkey.bind(cmnd_alt_shift, "Down", function ()
    local win = hs.window.focusedWindow()
    win:down()
end)

hs.hotkey.bind(cmnd_alt, "Right", function ()
    local win = hs.window.focusedWindow()
    win:downRight()
end)

hs.hotkey.bind(cmnd_alt, "Left", function ()
    local win = hs.window.focusedWindow()
    win:upLeft()
end)

hs.hotkey.bind(cmnd_alt, "Up", function ()
    local win = hs.window.focusedWindow()
    win:upRight()
end)

hs.hotkey.bind(cmnd_alt, "Down", function ()
    local win = hs.window.focusedWindow()
    win:downLeft()
end)

hs.hotkey.bind(cmnd_alt_shift, "F", function ()
    local win = hs.window.focusedWindow()
    win:fullscreen()
end)

-- Move focused window a monitor to the left.
hs.hotkey.bind(cmnd_shift, "A", function ()
  local win = hs.window.focusedWindow()
  win:moveToScreen(hs.screen({x=-1,y=0}));
end)

-- Move focused window a monitor to the right.
hs.hotkey.bind(cmnd_shift, "D", function ()
  local win = hs.window.focusedWindow()
  win:moveToScreen(hs.screen({x=1,y=0}));
end)

-- Indicate config is loaded
hs.alert("Config loaded")
