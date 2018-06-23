local api = vim.api

local MOD = "after.neoterm"
local PLUGIN_LOCK = "neoterm_loaded"

local function exists_var(var)
  return api.nvim_call_function("exists", {var}) == 1
end

local function repl_send_register()
  api.nvim_call_function("inputsave", {})
  local reg = api.nvim_call_function("input", {"Register to send into repl: "})
  api.nvim_call_function("inputrestore", {})
  -- let reg_contents = getreg(a:register)
  -- call g:neoterm.repl.exec(split(reg_contents), "\n")
end

local function repl_run()
  local ft = api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "filetype")
  local args = {}
  if ft ~= "" then
    local v = "proyecta#repl_arguments_" .. ft
    if exists_var(v) then
      local ft_args = api.nvim_get_var("proyecta#repl_arguments_" .. ft)
      args = ft_args or {}
    end
  end
  api.nvim_call_dict_function("neoterm.repl", "exec", {args})
end

local function do_map(map_left, map_right, with_leader)
  local left
  if with_leader then
    left = string.format("<leader>%s", map_left)
  else
    left = map_left
  end
  local map
  if type(map_right) == "function" then
    return
  elseif type(map_right) == "string" then
    map = string.format("nnoremap %s %s<CR>", left, map_right)
  else
    api.nvim_err_writeln("Mapping error in neoterm.lua")
    return
  end
  api.nvim_command(map)
end

local variables = {
  neoterm_position = "vertical"
}

local maps = {
  tr  = [[:lua require("after.neoterm").repl_run()]],
  tpr = [[:lua require("after.neoterm").repl_send_register()]],
  tl  = ":TREPLSendLine",
  tf  = ":TREPLSendFile",
  tp  = ":TREPLSendSelection",
}

local function after()
  if api.nvim_call_function("exists", {PLUGIN_LOCK}) == 0 then
    return 
  end
  
  -- set variables
  for k, v in pairs(variables) do
    api.nvim_set_var(k, v)
  end
  
  -- set maps
  for m, v in pairs(maps) do
    do_map(m, v, true) 
  end
end

return {
  after = after,
  repl_run = repl_run,
  repl_send_register = repl_send_register,
}
