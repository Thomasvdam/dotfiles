-- Taken from https://github.com/victorso/.hammerspoon/blob/master/tools/clipboard.lua
-- Clipboard management in Hammerspoon.

-- Times per second to poll clipboard
local frequency = 0.8
local hist_size = 25
-- Max no. of characters to display. Longer gets cut off with ...
local label_length = 40
-- Should a app clear the pasteboard, do the same
local honour_clear_content = false
local paste_on_select = true

local clipboard = hs.menubar.new()
clipboard:setTooltip("Clipboard Management")
local pasteboard = require("hs.pasteboard")
local settings = require("hs.settings")
local last_change = pasteboard.changeCount()

local clipboard_history = settings.get("com.tvd.clipboard") or {}

function setTitle()
    if (#clipboard_history == 0) then
        clipboard:setTitle("✂")
    else
        clipboard:setTitle("✂  ("..#clipboard_history..")")
    end
end

function putOnPaste(string, key)
    if (paste_on_select) then
        hs.eventtap.keyStrokes(string)
        pasteboard.setContents(string)
        last_change = pasteboard.changeCount()
    else
        if (key.alt == true) then
            hs.eventtap.keyStrokes(string)
        else
            pasteboard.setContents(string)
            last_change = pasteboard.changeCount()
        end
    end
end

function clearAll()
    pasteboard.clearContents()
    clipboard_history = {}
    settings.set("com.tvd.clipboard", clipboard_history)
    now = pasteboard.changeCount()
end

function clearLastItem()
    table.remove(clipboard_history, #clipboard_history)
    settings.set("com.tvd.clipboard", clipboard_history)
    now = pasteboard.changeCount()
    setTitle()
end

function pasteboardToClipboard(item)
    while (#clipboard_history >= hist_size) do
        table.remove(clipboard_history, 1)
    end
    table.insert(clipboard_history, item)
    settings.set("com.tvd.clipboard", clipboard_history)
    setTitle()
end

populateMenu = function(key)
    setTitle()
    menu_data = {}
    if (#clipboard_history == 0) then
        table.insert(menu_data, {title = "None", disabled = true})
    else
        for k,v in pairs(clipboard_history) do
            if (string.len(v) > label_length) then
                table.insert(menu_data, 1, {title = string.sub(v, 0, label_length).. "…", fn = function() putOnPaste(v, key) end })
            else
                table.insert(menu_data, 1, {title = v, fn = function() putOnPaste(v, key) end })
            end
        end
    end

    table.insert(menu_data, {title = "-"})
    table.insert(menu_data, {title = "Clear All", fn = function() clearAll() end })
    if (key.alt == true or paste_on_select) then
        table.insert(menu_data, {title = "Direct Paste Mode ✍", disabled=true})
    end

    return menu_data
end

function storeCopy()
    now = pasteboard.changeCount()
    if (now > last_change) then
        current_clipboard = pasteboard.getContents()
        if (current_clipboard == nil and honour_clear_content) then
            clearLastItem()
        else
            pasteboardToClipboard(current_clipboard)
        end

        last_change = now
    end
end

timer = hs.timer.new(frequency, storeCopy)
timer:start()

setTitle()
clipboard:setMenu(populateMenu)

