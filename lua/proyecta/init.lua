local Project = require "proyecta/project"
local h       = require "proyecta/helpers"

local proyecta = {}

proyecta.start = function()
  local p, err = Project.New()
  if err then
    h.perrfln("Unable to start project: %s", err)
    return
  end
  p:init()
end

return proyecta
