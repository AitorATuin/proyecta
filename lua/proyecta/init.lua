local Project = require "proyecta/project"
local h       = require "proyecta/helpers"
local perror  = vim.api.nvim_err_write
local inspect = require "inspect"

local proyecta = {}

proyecta.start = function()
  local p, err = Project.New()
  if err then
    h.perrfln("Unable to start project: %s", err)
  end
  p:init()
end

return proyecta
