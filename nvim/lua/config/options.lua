local M = {}

function M.setup()
    local options = {
        number = true,
        relativenumber = true,
        expandtab = true,
        shiftwidth = 4,
        tabstop = 4,
        smartindent = true,
        ignorecase = true,
        smartcase = true,
        clipboard = "unnamedplus",
        completeopt = { "menu", "menuone", "noselect" },
    }

    for key, value in pairs(options) do
        vim.opt[key] = value
    end
end

return M
