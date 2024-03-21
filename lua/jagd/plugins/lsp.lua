local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "tsserver",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = {
                                    version = "LuaJIT",
                                },
                                diagnostics = {
                                    globals = { "vim", "require" },
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file(
                                        "",
                                        true
                                    ),
                                },
                            },
                        },
                    })
                end,

                ["tsserver"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.tsserver.setup({
                        capabilities = capabilities,
                        commands = {
                            OrganizeImports = {
                                function()
                                    vim.lsp.buf_request_sync(
                                        0,
                                        "workspace/executeCommand",
                                        {
                                            command = "_typescript.organizeImports",
                                            arguments = {
                                                vim.api.nvim_buf_get_name(0),
                                            },
                                        },
                                        500
                                    )
                                end,
                                description = "Organize Imports",
                            },
                        },
                    })
                end,
            },
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
            }, {
                { name = "buffer" },
            }),
        })

        vim.diagnostic.config({
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        local jagd_lsp_group = augroup("jagd_lsp", { clear = true })
        autocmd("LspAttach", {
            group = jagd_lsp_group,
            callback = function(args)
                vim.keymap.set("n", "gd", function()
                    vim.lsp.buf.definition()
                end, {
                    buffer = args.buf,
                    desc = "Go to Definition",
                })

                vim.keymap.set("n", "K", function()
                    vim.lsp.buf.hover()
                end, { buffer = args.buf })

                vim.keymap.set("n", "<leader>ls", function()
                    vim.lsp.buf.workspace_symbol()
                end, {
                    buffer = args.buf,
                    desc = "LSP: Search workspace for Symbol",
                })

                vim.keymap.set("n", "<leader>ld", function()
                    vim.diagnostic.open_float()
                end, {
                    buffer = args.buf,
                    desc = "LSP: view Diagnostic float",
                })

                vim.keymap.set("n", "<leader>lca", function()
                    vim.lsp.buf.code_action()
                end, {
                    buffer = args.buf,
                    desc = "LSP: select a Code Action",
                })

                vim.keymap.set("n", "<leader>.", function()
                    vim.lsp.buf.code_action()
                end, {
                    buffer = args.buf,
                    desc = "LSP: select a code action",
                })

                vim.keymap.set("n", "<leader>lr", function()
                    vim.lsp.buf.references()
                end, {
                    buffer = args.buf,
                    desc = "LSP: find symbol References",
                })

                vim.keymap.set("n", "<leader>lR", function()
                    vim.lsp.buf.rename()
                end, {
                    buffer = args.buf,
                    desc = "LSP: Rename symbol",
                })

                vim.keymap.set("i", "<C-h>", function()
                    vim.lsp.buf.signature_help()
                end, { buffer = args.buf })

                vim.keymap.set("n", "[d", function()
                    vim.diagnostic.goto_prev()
                end, {
                    buffer = args.buf,
                    desc = "Go to previous diagnostic",
                })

                vim.keymap.set("n", "]d", function()
                    vim.diagnostic.goto_next()
                end, {
                    buffer = args.buf,
                    desc = "Go to next diagnostic",
                })
            end,
        })
    end,
}