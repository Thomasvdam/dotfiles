#pragma once

#include "kaleidoscope/event_handler_result.h"  // for EventHandlerResult
#include "kaleidoscope/plugin.h"                // for Plugin

namespace kaleidoscope {
namespace plugin {

class LayerIndicator : public kaleidoscope::Plugin {
public:
  EventHandlerResult onLayerChange();
};

}
}

extern kaleidoscope::plugin::LayerIndicator LayerIndicator;
