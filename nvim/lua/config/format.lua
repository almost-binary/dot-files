local M = {}

local java_lsp = require("config.java_lsp")

local function notify_warn(message)
    vim.notify(message, vim.log.levels.WARN)
end

local function formatter_command(bufnr)
    local ft = vim.bo[bufnr].filetype

    if ft == "nix" then
        if vim.fn.executable("nixfmt") == 1 then
            return "nixfmt"
        end
        return nil, "nixfmt is not installed or not on PATH"
    end

    if ft == "java" then
        if vim.fn.executable("google-java-format") == 1 then
            if not vim.bo[bufnr].expandtab then
                return nil, "google-java-format outputs spaces only; trying Java LSP formatting for tabs"
            end

            local width = vim.bo[bufnr].shiftwidth
            if width == 0 then
                width = vim.bo[bufnr].tabstop
            end
            if width ~= 2 and width ~= 4 then
                return nil, "google-java-format supports 2/4-space styles; trying Java LSP formatting for this indent width"
            end

            local style = width == 4 and "--aosp " or ""
            return "google-java-format " .. style .. "-"
        end
        return nil, "google-java-format is not installed; trying Java LSP formatting"
    end

    return nil, "No formatter configured for filetype: " .. ft
end

local function run_shell_formatter(bufnr, cmd)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local input = table.concat(lines, "\n")
    if vim.bo[bufnr].endofline then
        input = input .. "\n"
    end

    local output = vim.fn.system(cmd, input)
    if vim.v.shell_error ~= 0 or output == "" then
        vim.notify("Formatting failed: " .. cmd, vim.log.levels.ERROR)
        return false
    end

    local view = vim.fn.winsaveview()
    local formatted = vim.split(output, "\n", { plain = true })
    if formatted[#formatted] == "" then
        table.remove(formatted, #formatted)
    end
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
    vim.fn.winrestview(view)
    return true
end

function M.format_current_buffer()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable then
        return false
    end

    local cmd, err = formatter_command(bufnr)
    if cmd then
        return run_shell_formatter(bufnr, cmd)
    end

    if vim.bo[bufnr].filetype == "java" then
        java_lsp.start(bufnr)
        if java_lsp.has_formatter(bufnr) then
            java_lsp.format(bufnr)
            return true
        end
        notify_warn("Java formatter unavailable. Install google-java-format or jdtls.")
        return false
    end

    notify_warn(err)
    return false
end

function M.setup()
    vim.api.nvim_create_user_command("F", function()
        if not M.format_current_buffer() then
            return
        end
    end, {
        nargs = 0,
        desc = "Format current file",
    })
end

return M
