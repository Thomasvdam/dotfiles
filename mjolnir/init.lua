local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"

-- ####### POSITIONING & RESIZING WINDOWS ####### --

-- Move window to the left half of the screen
hotkey.bind({"cmd", "alt", "shift"}, "LEFT", function()
	local win = window:focusedwindow()
	win:movetounit({x=0, y=0, w=0.5, h=1})
end)

-- Move window to the right half of the screen
hotkey.bind({"cmd", "alt", "shift"}, "RIGHT", function()
	local win = window:focusedwindow()
	win:movetounit({x=0.5, y=0, w=0.5, h=1})
end)

-- Move window to the top half of the screen
hotkey.bind({"cmd", "alt", "shift"}, "UP", function()
	local win = window:focusedwindow()
	win:movetounit({x=0, y=0, w=1, h=0.5})
end)

-- Move window to the bottom half of the screen
hotkey.bind({"cmd", "alt", "shift"}, "DOWN", function()
	local win = window:focusedwindow()
	win:movetounit({x=0, y=0.5, w=1, h=0.5})
end)

-- Make window fullscreen
hotkey.bind({"cmd", "alt", "shift"}, "F", function()
	local win = window:focusedwindow()
	win:maximize()
end)