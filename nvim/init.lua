local init_file = debug.getinfo(1, "S").source:sub(2)
local real_init_file = vim.loop.fs_realpath(init_file) or init_file
local config_dir = vim.fn.fnamemodify(real_init_file, ":p:h")
vim.opt.runtimepath:prepend(config_dir)

require("config.options").setup()
require("config.java_lsp").setup()
require("config.format").setup()
