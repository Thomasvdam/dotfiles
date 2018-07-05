local spaces = require("hs._asm.undocumented.spaces")

local function moveToNextSpace(direction)
  local activeSpaceId = spaces.activeSpace()
  local activeScreenId = spaces.spaceScreenUUID(activeSpaceId)
  local screenSpaces = spaces.layout()[activeScreenId]
  
  local index = {}
  local numberOfSpaces = 0
  for k, v in pairs(screenSpaces) do
    index[v] = k
    numberOfSpaces = numberOfSpaces + 1
  end

  local activeSpaceIndex = index[activeSpaceId]

  if (direction == "left" and activeSpaceIndex > 1) then
    targetSpaceId = screenSpaces[activeSpaceIndex - 1]
    spaces.changeToSpace(targetSpaceId)
  elseif (direction == "right" and activeSpaceIndex < numberOfSpaces) then
    targetSpaceId = screenSpaces[activeSpaceIndex + 1]
    spaces.changeToSpace(targetSpaceId)
  end
end

return {
    moveToNextSpace = moveToNextSpace
}
