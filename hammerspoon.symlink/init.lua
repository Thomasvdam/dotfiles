---------------
-- Constants --
---------------
local cmnd_alt_shift = {"cmd", "alt", "shift"}
local cmnd_alt = {"cmd", "alt"}
local cmnd_shift = {"cmd", "shift"}
local ctrl_cmnd = {"ctrl", "cmd"}

-------------------
-- Configuration --
-------------------
hs.window.animationDuration = 0

hs.hints.showTitleThresh = 0
hs.hints.style = "vimperator"

---------------
-- Clipboard --
---------------
require "clipboard"

-------------------
-- Atreus Layers --
-------------------
require "atreus_layer"

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
function right(win)
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
function left(win)
  local targetFrame = hs.screen.copyFrame(win:screen(), false)
  targetFrame.w = targetFrame.w/2
  win:setFrame(targetFrame)
end

-- +-----------------+
-- |      HERE       |
-- +-----------------+
-- |                 |
-- +-----------------+
function up(win)
  local targetFrame = hs.screen.copyFrame(win:screen(), false)
  targetFrame.h = targetFrame.h/2
  win:setFrame(targetFrame)
end

-- +-----------------+
-- |                 |
-- +-----------------+
-- |      HERE       |
-- +-----------------+
function down(win)
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
function upLeft(win)
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
function downLeft(win)
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
function downRight(win)
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
function upRight(win)
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
function fullscreen(win)
  local targetFrame = hs.screen.copyFrame(win:screen(), false)
  win:setFrame(targetFrame)
end
-- End adapted from

---------------------
-- Hotkey Bindings --
---------------------
hs.hotkey.bind(cmnd_alt_shift, "Right", function ()
    local win = hs.window.focusedWindow()
    right(win)
end)

hs.hotkey.bind(cmnd_alt_shift, "Left", function ()
    local win = hs.window.focusedWindow()
    left(win)
end)

hs.hotkey.bind(cmnd_alt_shift, "Up", function ()
    local win = hs.window.focusedWindow()
    up(win)
end)

hs.hotkey.bind(cmnd_alt_shift, "Down", function ()
    local win = hs.window.focusedWindow()
    down(win)
end)

hs.hotkey.bind(cmnd_alt, "Right", function ()
    local win = hs.window.focusedWindow()
    downRight(win)
end)

hs.hotkey.bind(cmnd_alt, "Left", function ()
    local win = hs.window.focusedWindow()
    upLeft(win)
end)

hs.hotkey.bind(cmnd_alt, "Up", function ()
    local win = hs.window.focusedWindow()
    upRight(win)
end)

hs.hotkey.bind(cmnd_alt, "Down", function ()
    local win = hs.window.focusedWindow()
    downLeft(win)
end)

hs.hotkey.bind(cmnd_alt_shift, "F", function ()
    local win = hs.window.focusedWindow()
    fullscreen(win)
end)

-- -- Move focused window to the left monitor.
-- hs.hotkey.bind(ctrl_cmnd, "A", function ()
--   local win = hs.window.focusedWindow()
--   win:moveToScreen(hs.screen({x=-1,y=0}));
-- end)

-- -- Move focused window to the upper monitor.
-- hs.hotkey.bind(ctrl_cmnd, "W", function ()
--   local win = hs.window.focusedWindow()
--   win:moveToScreen(hs.screen({x=0,y=-1}));
-- end)

-- -- Move focused window to the centre monitor.
-- hs.hotkey.bind(ctrl_cmnd, "S", function ()
--   local win = hs.window.focusedWindow()
--   win:moveToScreen(hs.screen({x=0,y=0}));
-- end)

-- -- Move focused window to the right monitor.
-- hs.hotkey.bind(ctrl_cmnd, "D", function ()
--   local win = hs.window.focusedWindow()
--   win:moveToScreen(hs.screen({x=1,y=0}));
-- end)

hs.hotkey.bind(cmnd_shift, "H", function()
  hs.hints.windowHints()
end)

-- Open clipboard manager at mouse position
hs.hotkey.bind(ctrl_cmnd, "V", function()
    clipboard:popupMenu(hs.mouse.getAbsolutePosition())
end)

-- Indicate config is loaded
hs.alert("Config loaded")
