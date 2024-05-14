-- Writing and navigating an Obsidian vault
return {
    {
        "MeanderingProgrammer/markdown.nvim",
        name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        keys = {
            { "<leader>m", "<CMD>RenderMarkdownToggle<CR>", desc = "Toggle render markdown" },
        },
        config = function()
            require("render-markdown").setup({
                -- Configure whether Markdown should be rendered by default or not
                start_enabled = false,
                checkbox = {
                    -- Character that will replace the [ ] in unchecked checkboxes
                    unchecked = "󰄱 ",
                    -- Character that will replace the [x] in checked checkboxes
                    checked = "󰄲 ",
                },
            })
        end,
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        --   "BufReadPre path/to/my-vault/**.md",
        --   "BufNewFile path/to/my-vault/**.md",
        -- },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "work",
                    path = "~/Documents/vaults/work",
                },
                {
                    name = "personal",
                    path = "~/Documents/vaults/personal",
                },
            },
            mappings = {
                -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
                ["gf"] = {
                    action = function()
                        return require("obsidian").util.gf_passthrough()
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
                -- Toggle check-boxes.
                ["<C-space>"] = {
                    action = function()
                        return require("obsidian").util.toggle_checkbox()
                    end,
                    opts = { buffer = true },
                },
            },
            ui = {
                enable = false,
                -- enable = true,
                -- checkboxes = {
                --     [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
                --     ["x"] = { char = "󰄲", hl_group = "ObsidianDone" },
                -- },
                -- reference_text = { hl_group = "ObsidianRefText" },
                -- highlight_text = { hl_group = "ObsidianHighlightText" },
                -- tags = { hl_group = "ObsidianTag" },
                -- hl_groups = {
                --     ObsidianTodo = { bold = true, fg = "#ed8796" },
                --     ObsidianDone = { bold = true, fg = "#a6da95" },
                --     ObsidianRefText = { underline = true, fg = "#b7bdf8" },
                --     ObsidianTag = { italic = true, fg = "#7dc4e4" },
                --     ObsidianHighlightText = { bg = "#eed49f", fg = "#24273a" },
                -- },
            },
            daily_notes = {
                folder = "journal",
                date_format = "%Y-%m-%d",
                alias_format = "%B %-d, %Y",
                template = nil,
            },
        },
    },
}
