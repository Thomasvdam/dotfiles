# Kaleidoscope

Don't really know where else to put it as it's a quick and dirty hack. Maybe I'll spend time making it proper at some point, but for now this will do.

This is a custom plugin I hacked together to send keycodes on Layer changes for my keyboard. This allows me to have a hammerspoon script listening to these keystrokes and act on them. For now it's a glyph in the menu bar, but I could make it more fancy.

At the moment it's also all hardcoded magic variables that just need to be aligned, there is nothing dynamic in it at all. Would like to look into fixing that, perhaps by using the USB serial connection to send data from the keyboard.

## Installation

First off follow the instructions for setting up the Arduino IDE to build the kaleidoscope firmware and upload it to the keyboard.  
Open the Atreus spec in the Arduino IDE, create 2 new files `LayerIndicator.cpp` and `LayerIndicator.h` and paste the contents of the files here. Include the header file in the `Atreus.ino` file and add the plugin to the `KALEIDOSCOPE_INIT_PLUGINS` arguments. Don't forget to add an additional `,` after what was previously the last argument.  
Verify everything builds, and then upload it to your keyboard.
