local M = {}

local JAVA_ROOT_MARKERS = {
    ".git",
    "gradlew",
    "mvnw",
    "pom.xml",
    "build.gradle",
    "settings.gradle",
}

function M.has_formatter(bufnr)
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
        if client.name == "jdtls" and client:supports_method("textDocument/formatting") then
            return true
        end
    end
    return false
end

local function root_dir(bufnr)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local search_path = filename ~= "" and vim.fs.dirname(filename) or vim.fn.getcwd()
    local matches = vim.fs.find(JAVA_ROOT_MARKERS, { upward = true, path = search_path })
    return matches[1] and vim.fs.dirname(matches[1]) or vim.fn.getcwd()
end

local function setup_completion(bufnr)
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", {
        buffer = bufnr,
        silent = true,
        desc = "Trigger LSP completion",
    })
end

function M.start(bufnr)
    if vim.bo[bufnr].filetype ~= "java" then
        return
    end
    if M.has_formatter(bufnr) then
        return
    end
    if vim.fn.executable("jdtls") ~= 1 then
        return
    end

    local project_root = root_dir(bufnr)
    local workspace = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(project_root, ":t")

    vim.lsp.start({
        name = "jdtls",
        cmd = { "jdtls", "-data", workspace },
        root_dir = project_root,
    }, { bufnr = bufnr })
end

function M.format(bufnr)
    local width = vim.bo[bufnr].shiftwidth
    if width == 0 then
        width = vim.bo[bufnr].tabstop
    end

    vim.lsp.buf.format({
        bufnr = bufnr,
        async = false,
        timeout_ms = 3000,
        formatting_options = {
            tabSize = width,
            insertSpaces = vim.bo[bufnr].expandtab,
        },
    })
end

function M.setup()
    local group = vim.api.nvim_create_augroup("JavaLspBootstrap", { clear = true })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "jdtls" then
                setup_completion(args.buf)
            end
        end,
    })

    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "java",
        callback = function(args)
            M.start(args.buf)
        end,
    })
end

return M
