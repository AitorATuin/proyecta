
local h = require("proyecta/helpers")

local Project   = {}
Project.__index = Project

local function do_after_plugin(plugin, centinel)
  -- Run only if plugin is loaded
  local loaded = true
  if centinel and not h.exists(centinel) then
    loaded = false
  end
  return function ()
    if not loaded then
      return
    end
    require(h.fmt("proyecta.after.%s", plugin)).after()
  end
end

local after_plugins = {
  neoterm = do_after_plugin("neoterm", "neoterm_loaded")
}

local function find_project_file()
  local project_file = vim.api.nvim_call_function("findfile", {".proyecta.lua", ".;~"})
  if project_file == "" then
    return nil
  end
  return project_file
end

local function load_project_file(file_path)
  local f, err = loadfile(file_path)
  if not f then
    return nil, err
  end
  local status, p_or_err = pcall(f)
  if not status then
    return nil, p_or_err
  end
  return p_or_err
end

local function new_project()
  local project_file = find_project_file()
  if not project_file then return nil, "Unable to find project file" end
  local root = project_file:match("/([^/]+)$")
  if not root then return nil, "Unable to find root project" end
  local p, err = load_project_file(project_file)
  if not p then return nil, err end
  local project = {
    source      = p.source,
    tests       = p.tests,
    repl_lines  = p.repl_lines or {},
    root        = project_file
  }
  h.poutf("project root: %s\n", project.root)
  return setmetatable(project, Project)
end

Project.init = function(p)
  vim.api.nvim_set_var("proyecta#repl_arguments_lua", p.repl_lines)

  -- run after plugins
  for _, f in pairs(after_plugins) do f() end
end

return {
  New = new_project
}
