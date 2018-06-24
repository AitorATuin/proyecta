local api = vim.api
local utils = {}

local function fmt_f(out_f, fmt, ...)
  out_f(utils.fmt(fmt, ...))
end

utils.perr = api.nvim_err_write
utils.perrln = api.nvim_err_writeln
utils.pout = api.nvim_out_write
utils.fmt = string.format
utils.perrf = function (fmt, ...) fmt_f(utils.perr, fmt, ...) end
utils.poutf = function (fmt, ...) fmt_f(utils.pout, fmt, ...) end
utils.perrfln = function (fmt, ...) fmt_f(utils.perrln, fmt, ...) end
utils.exists = function (var)
  return api.nvim_call_function("exists", {var}) == 1
end
utils.get_register = function(reg)
  return api.nvim_call_function("getreg", {reg})
end
utils.split = function(str)
  return api.nvim_call_function("split", {str})
end
utils.getcwd = function()
  return api.nvim_call_function("getcwd", {})
end

return utils
