local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local organizeImports = function()
    if vim.fn.exists(":OrganizeImports") > 0 then
        vim.cmd("OrganizeImports")
    end
end

return {
    "stevearc/conform.nvim",
    lazy = false,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                organizeImports()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            desc = "[F]ormat buffer/selection",
            mode = { "n", "x" },
        },
    },
    config = function()
        local opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                sh = { "shfmt" },
            },
            format_on_save = {
                lsp_fallback = true,
                timeout_ms = 500,
            },
        }

        local prettier_fts = {
            "css",
            "graphql",
            "html",
            "javascript",
            "javascriptreact",
            "json",
            "jsonc",
            "markdown",
            "markdown.mdx",
            "scss",
            "typescript",
            "typescriptreact",
            "yaml",
        }

        for _, ft in ipairs(prettier_fts) do
            opts.formatters_by_ft[ft] = { { "prettierd", "prettier" } }
        end

        require("conform").setup(opts)

        local formatter_group = augroup("formatter", { clear = true })
        autocmd("BufWritePre", {
            group = formatter_group,
            callback = function(args)
                organizeImports()
                require("conform").format({
                    async = false,
                    bufnr = args.buf,
                    lsp_fallback = true,
                    timeout_ms = 500,
                })
            end,
        })
    end,
}
