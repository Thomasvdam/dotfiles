#include "./LayerIndicator.h"

#include "Kaleidoscope.h"
#include "kaleidoscope/KeyEvent.h"              // for KeyEvent
#include "kaleidoscope/Runtime.h"               // for Runtime
#include "kaleidoscope/event_handler_result.h"  // for EventHandlerResult
#include "kaleidoscope/plugin.h"                // for Plugin

namespace kaleidoscope {
namespace plugin {

EventHandlerResult LayerIndicator::onLayerChange() {
  KeyEvent new_event = KeyEvent(KeyAddr::none(), IS_PRESSED, Key_NoEvent);

  // Layers should match to what is specified in Chrysalis.
  // Function keys should match the hammerspoon script.
  // Using F13+ as these are unused by macOS.
  switch (Layer.mostRecent()) {
    case 0:
      new_event.key = Key_F13;
      break;
    case 1:
      new_event.key = Key_F16;
      break;
    case 2:
      new_event.key = Key_F17;
      break;
    case 3:
      new_event.key = Key_F18;
      break;
    default:
      return EventHandlerResult::OK;
      break;
  }

  new_event.state |= INJECTED;
  Runtime.handleKeyEvent(new_event);
  new_event.state = INJECTED | WAS_PRESSED;
  Runtime.handleKeyEvent(new_event);

  return EventHandlerResult::OK;
};

}
}

kaleidoscope::plugin::LayerIndicator LayerIndicator;
