local opt = vim.opt
local global = vim.g
local keymap = vim.keymap
local lsp = vim.lsp

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.wrap = false

opt.signcolumn = "yes"
opt.undofile = true
opt.updatetime = 250

opt.clipboard = "unnamedplus"

opt.tabstop = 2
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

opt.laststatus = 3
opt.cmdheight = 0

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

opt.swapfile = false
opt.winborder = "rounded"

global.mapleader = " "

keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
keymap.set('n', '<leader>w', ':write<CR>')
keymap.set('n', '<leader>q', ':quit<CR>')

vim.pack.add({
        { src = "https://github.com/catppuccin/nvim" },
        { src = "https://github.com/stevearc/oil.nvim" },
        { src = "https://github.com/echasnovski/mini.pick" },
        { src = "https://github.com/neovim/nvim-lspconfig" },
        { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
        { src = "https://github.com/mason-org/mason.nvim" },
})

require "mason".setup()
require "mini.pick".setup()
require "oil".setup()

keymap.set('n', '<leader>lf', vim.lsp.buf.format)
lsp.enable({ 'lua_ls', 'hyprls', 'clangd', 'python-lsp-server', 'basedpyright', 'qmlls',  })
lsp.config('lua_ls', {
        settings = {
                Lua = {
                        workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                        }
                }
        }
})
require("lspconfig").qmlls.setup {}
--require('nvim-treesitter.configs').setup({
--	auto_install = true,
--	highlight = {
--		enable = true,
--	},
--})

vim.keymap.set('n', '<leader>f', ':Pick files<CR>')
vim.keymap.set('n', '<leader>h', ':Pick help<CR>')
vim.keymap.set('n', '<leader>e', ':Oil<CR>')

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

require("catppuccin").setup({
        flavour = "mocha",
        background = {
                light = "latte",
                dark = "mocha",
        },
        transparent_background = true,
        float = {
                transparent = true,
                solid = false,
        },
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
                enabled = false,
                shade = "dark",
                percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = { "bold" },
                strings = {},
                variables = { "bold" },
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        auto_integrations = false,
        integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                treesitter = true,
                notify = false,
                mini = {
                        enabled = true,
                        indentscope_color = "",
                },
        },
})

vim.cmd("colorscheme catppuccin")
vim.cmd(":hi statusline guibg=NONE")

vim.keymap.set({ 'n', 'i' }, '<Esc>', function()
        if vim.fn.mode() == 'n' then
                vim.cmd.nohlsearch()
        end
        return '<Esc>'
end, { expr = true })

vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if client:supports_method('textDocument/completion') then
                        vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
                end
        end,
})
vim.cmd("set completeopt+=noselect")

-- Noob corner
-- Disable arrows movement
vim.keymap.set('', '<Up>', '<Nop>')
vim.keymap.set('', '<Down>', '<Nop>')
vim.keymap.set('', '<Left>', '<Nop>')
vim.keymap.set('', '<Right>', '<Nop>')

local mode_names = {
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        ['␖'] = "V-BLOCK",
        V = "V-LINE",
        c = "COMMAND",
        ['!'] = "SHELL",
        r = "REPLACE",
        s = "SELECT",
        t = "TERMINAL",
}

_G.statusline = function()
        local file_path = vim.fn.expand('%:p:~:.')
        local left = '%#StatusLineLeft#' .. file_path

        local mode = mode_names[vim.fn.mode()] or "NORMAL"
        local line = vim.fn.line('.')
        local col = vim.fn.col('.')
        local right = '%#StatusLineRight# -- ' .. mode .. ' -- %#StatusLinePos# ' .. line .. ' ' .. col .. ' '

        return left .. '%=' .. right
end

vim.opt.statusline = '%!v:lua.statusline()'

local catppuccin = require("catppuccin.palettes").get_palette("mocha")

vim.cmd('highlight StatusLine      guibg=NONE guifg=' .. catppuccin.text)
vim.cmd('highlight StatusLineLeft  guibg=NONE guifg=' .. catppuccin.teal)
vim.cmd('highlight StatusLineRight guibg=NONE guifg=' .. catppuccin.peach)
vim.cmd('highlight StatusLinePos   guibg=NONE guifg=' .. catppuccin.mauve)

-- entry
vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
                if vim.fn.argc() == 0 then
                        local buf = vim.api.nvim_create_buf(false, true)
                        local width = 60
                        local height = 20
                        local win = vim.api.nvim_open_win(buf, true, {
                                relative = "editor",
                                width = width,
                                height = height,
                                col = math.floor((vim.o.columns - width) / 2),
                                row = math.floor((vim.o.lines - height) / 3),
                                style = "minimal",
                                border = "rounded",
                        })

                        vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = catppuccin.teal }) -- Rose-Pine cyan
                        vim.api.nvim_set_hl(0, 'DashboardSubtitle', { fg = catppuccin.rose }) -- Rose-Pine rose

                        local header = {
                                "",
                                [[ ██╗      █████╗  ██████╗  ██████╗ ███╗   ███╗ ]],
                                [[ ██║     ██╔══██╗██╔════╝ ██╔═══██╗████╗ ████║ ]],
                                [[ ██║     ███████║██║  ███╗██║   ██║██╔████╔██║ ]],
                                [[ ██║     ██╔══██║██║   ██║██║   ██║██║╚██╔╝██║ ]],
                                [[ ███████╗██║  ██║╚██████╔╝╚██████╔╝██║ ╚═╝ ██║ ]],
                                [[ ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝     ╚═╝ ]],
                                "",
                                "Just The Right Amount, Not Too Little, Not Too Much",
                                "",
                        }

                        -- Buttons to display
                        local buttons = {
                                "e:      New file",
                                "f:     Find file",
                                "h:          Help",
                                "c: Configuration",
                                "q:          Quit",
                        }

                        -- Combine and center all content
                        local centered_content = {}

                        -- Center header lines
                        for _, line in ipairs(header) do
                                local padding = math.floor((width - vim.fn.strdisplaywidth(line)) / 2)
                                table.insert(centered_content, string.rep(" ", padding) .. line)
                        end

                        -- Add spacing between header and buttons
                        table.insert(centered_content, "")
                        table.insert(centered_content, "")

                        -- Center buttons
                        for _, line in ipairs(buttons) do
                                local padding = math.floor((width - vim.fn.strdisplaywidth(line)) / 2)
                                table.insert(centered_content, string.rep(" ", padding) .. line)
                        end

                        -- Set buffer content
                        vim.api.nvim_buf_set_lines(buf, 0, -1, false, centered_content)

                        -- Apply syntax highlighting
                        for i = 1, 7 do -- First 6 lines are ASCII art
                                vim.api.nvim_buf_add_highlight(buf, -1, 'DashboardHeader', i - 1, 0, -1)
                        end
                        vim.api.nvim_buf_add_highlight(buf, -1, 'DashboardSubtitle', 8, 0, -1) -- Subtitle line

                        -- Button highlights (starting after header + 2 empty lines)
                        local button_start_line = #header + 2
                        for i = 1, #buttons do
                                vim.api.nvim_buf_add_highlight(buf, -1, 'Comment', button_start_line + i, 0, -1)
                        end

                        -- Button functionality
                        local actions = {
                                e = function()
                                        vim.api.nvim_win_close(win, false)
                                        vim.cmd("ene | startinsert")
                                end,
                                f = function()
                                        vim.api.nvim_win_close(win, false)
                                        vim.cmd("Pick files")
                                end,
                                h = function()
                                        vim.api.nvim_win_close(win, false)
                                        vim.cmd("Pick help")
                                end,
                                c = function()
                                        vim.api.nvim_win_close(win, false)
                                        vim.cmd("e ~/.config/nvim/init.lua")
                                end,
                                q = function()
                                        vim.cmd("qa")
                                end
                        }

                        -- Set keymaps
                        for key, action in pairs(actions) do
                                vim.keymap.set("n", key, action, { buffer = buf })
                        end
                end
        end
})
