local application = require "mjolnir.application"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"

-- ####### POSITIONING & RESIZING WINDOWS ####### --

-- Move window to the left half of the screen
hotkey.bind({"cmd", "alt", "shift"}, "LEFT", function()
	local win = window:focusedwindow()
	local newframe = win:screen():frame()
	
	newframe.w = newframe.w / 2

	win:setframe(newframe)
end)

-- Move window to the right half of the screen
hotkey.bind({"cmd", "alt", "shift"}, "RIGHT", function()
	local win = window:focusedwindow()
	local newframe = win:screen():frame()
	
	newframe.w = newframe.w / 2
	newframe.x = newframe.w

	win:setframe(newframe)
end)

-- Move window to the top half of the screen
hotkey.bind({"cmd", "alt", "shift"}, "UP", function()
	local win = window:focusedwindow()
	local newframe = win:screen():frame()
	
	newframe.h = newframe.h / 2

	win:setframe(newframe)
end)

-- Move window to the bottom half of the screen
hotkey.bind({"cmd", "alt", "shift"}, "DOWN", function()
	local win = window:focusedwindow()
	local newframe = win:screen():frame()
	
	newframe.h = newframe.h / 2
	newframe.y = newframe.h + 22

	win:setframe(newframe)
end)

-- Make window fullscreen
hotkey.bind({"cmd", "alt", "shift"}, "F", function()
	local win = window:focusedwindow()
	local newframe = win:screen():frame()

	win:setframe(newframe)
end)