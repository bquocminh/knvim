-- Statusline at the bottom
return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'nvim-telescope/telescope.nvim',  -- Switch filetype and git branches
        'SmiteshP/nvim-navic',  -- Show navic status
        'AckslD/swenv.nvim',  -- Show and switch python env
        'lewis6991/gitsigns.nvim',  -- Clickable diffthis
    },
    config = function()
        -- Custom components --------------------------------------------------
        -- Show and change the number of spaces per tab of the local buffer
        local fmt_stat = {
            function()
                local stat = ''
                stat = stat .. 'Spaces:' .. vim.opt_local.tabstop:get()
                return stat
            end,
            on_click = function()
                local spaces = tonumber(vim.fn.input('Local number of spaces per tab: '))
                vim.opt_local.tabstop = spaces
                vim.opt_local.softtabstop = spaces  -- For editing
                vim.opt_local.shiftwidth = spaces  -- For autoindent
            end,
        }

        -- Fancier version of the builtin 'progress' component
        local progress_stat = {
            function()
                -- Progress bar
                local sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
                local curr_line = vim.api.nvim_win_get_cursor(0)[1]
                local lines = vim.api.nvim_buf_line_count(0)
                local i = math.floor((curr_line - 1) / lines * #sbar) + 1
                local progress_bar = string.rep(sbar[i], 2)

                -- Percentage
                local percent = ''
                if curr_line == 1 then
                    percent = 'Top'
                elseif curr_line == lines then
                    percent = 'Bot'
                else
                    percent =  string.format('%2d%%%%', math.floor(curr_line / lines * 100))
                end

                return progress_bar .. ' ' .. percent
            end,
        }

        -- Custom components using nvim-navic
        local navic_stat = {
            function()
                local loc = require('nvim-navic').get_location()
                if loc ~= '' then
                    return '〉' .. loc
                end
                return loc
            end,
            cond = function()
                return require('nvim-navic').is_available()
            end,
            color = { bg = 'NONE' },
        }

        -- Custom components using swenv
        local env_stat = {
            function()
                local current_env = require('swenv.api').get_current_venv()
                if current_env ~= nil then
                    current_env = current_env.name
                else
                    current_env = ' ∅'
                end
                return current_env
            end,
            icon = '',
            on_click = function()
                require('swenv.api').pick_venv()
                vim.cmd.LspRestart()
            end,
        }

        -- Custom components using telescope
        local filetype_stat = {
            'filetype',  -- builtin filetype component
            on_click = function()
                require('telescope.builtin').filetypes()
                vim.cmd.LspRestart()
            end,
        }

        local branch_stat = {
            'branch',
            icon = '',
            on_click = function()
                require('telescope.builtin').git_branches()
            end,
        }

        local diagnostics_stat = {
            'diagnostics',
            on_click = function()
                require('telescope.builtin').diagnostics()
            end,
        }

        -- Custom components using gitsigns
        local diff_stat = {
            'diff',  -- builtin diff component
            on_click = function()
                require('gitsigns').diffthis()
            end,
        }

        -- Main config --------------------------------------------------------
        require('lualine').setup({
            options = {
                icons_enabled = true,
                theme = 'auto',
                --component_separators = {left='', right=''},
                --section_separators = {left='', right=''},
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {
                        'NvimTree',
                        'neo-tree',
                        'Outline',
                        'toggleterm',
                        'alpha',
                        'dap-repl',
                        'packer',
                    },
                },
                always_divide_middle = true,
                globalstatus = true,
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { branch_stat,
                              diff_stat,
                              diagnostics_stat,
                            },
                lualine_c = { { 'filename', path = 3, },
                            },
                lualine_x = { fmt_stat,
                              'encoding',
                              'fileformat',
                              filetype_stat,
                            },
                lualine_y = { { 'searchcount', icon = '', },
                              { 'location', icon = '', },
                              progress_stat,
                            },
                lualine_z = { env_stat },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { 'filename', path = 1, color = { bg = 'NONE' } },
                              navic_stat,
                            },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            inactive_winbar = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { 'filename', path = 1, color = { bg = 'NONE' } },
                            },
                lualine_x = {},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            -- extensions = { 'nvim-tree', 'neo-tree', 'quickfix', 'fugitive', 'symbols-outline', 'toggleterm', 'nvim-dap-ui' }
        })
    end,
}
