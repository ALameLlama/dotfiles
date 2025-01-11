if true then return {} end

---@type LazySpec
return {
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   version = "^2",
  --   cmd = {
  --     "CopilotChat",
  --     "CopilotChatOpen",
  --     "CopilotChatClose",
  --     "CopilotChatToggle",
  --     "CopilotChatStop",
  --     "CopilotChatReset",
  --     "CopilotChatSave",
  --     "CopilotChatLoad",
  --     "CopilotChatDebugInfo",
  --     "CopilotChatModels",
  --     "CopilotChatExplain",
  --     "CopilotChatReview",
  --     "CopilotChatFix",
  --     "CopilotChatOptimize",
  --     "CopilotChatDocs",
  --     "CopilotChatFixDiagnostic",
  --     "CopilotChatCommit",
  --     "CopilotChatCommitStaged",
  --   },
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" },
  --     { "nvim-lua/plenary.nvim" },
  --     { "nvim-telescope/telescope.nvim" },
  --     {
  --       "AstroNvim/astrocore",
  --       ---@param opts AstroCoreOpts
  --       opts = function(_, opts)
  --         local maps = assert(opts.mappings)
  --         local prefix = "<Leader>P"
  --         local astroui = require "astroui"
  --
  --         maps.n[prefix] = { desc = astroui.get_icon("CopilotChat", 1, true) .. "CopilotChat" }
  --         maps.v[prefix] = { desc = astroui.get_icon("CopilotChat", 1, true) .. "CopilotChat" }
  --
  --         maps.n[prefix .. "o"] = { ":CopilotChatOpen<CR>", desc = "Open Chat" }
  --         maps.n[prefix .. "c"] = { ":CopilotChatClose<CR>", desc = "Close Chat" }
  --         maps.n[prefix .. "t"] = { ":CopilotChatToggle<CR>", desc = "Toggle Chat" }
  --         maps.n[prefix .. "r"] = { ":CopilotChatReset<CR>", desc = "Reset Chat" }
  --         maps.n[prefix .. "s"] = { ":CopilotChatStop<CR>", desc = "Stop Chat" }
  --
  --         maps.n[prefix .. "S"] = {
  --           function()
  --             vim.ui.input({ prompt = "Save Chat: " }, function(input)
  --               if input ~= nil and input ~= "" then require("CopilotChat").save(input) end
  --             end)
  --           end,
  --           desc = "Save Chat",
  --         }
  --
  --         maps.n[prefix .. "L"] = {
  --           function()
  --             local copilot_chat = require "CopilotChat"
  --             local path = copilot_chat.config.history_path
  --             local chats = require("plenary.scandir").scan_dir(path, { depth = 1, hidden = true })
  --             -- Remove the path from the chat names and .json
  --             for i, chat in ipairs(chats) do
  --               chats[i] = chat:sub(#path + 2, -6)
  --             end
  --             vim.ui.select(chats, { prompt = "Load Chat: " }, function(selected)
  --               if selected ~= nil and selected ~= "" then copilot_chat.load(selected) end
  --             end)
  --           end,
  --           desc = "Load Chat",
  --         }
  --
  --         -- Helper function to create mappings
  --         local function create_mapping(action_type, selection_type)
  --           return function()
  --             require("CopilotChat.integrations.telescope").pick(require("CopilotChat.actions")[action_type] {
  --               selection = require("CopilotChat.select")[selection_type],
  --             })
  --           end
  --         end
  --
  --         maps.n[prefix .. "p"] = {
  --           create_mapping("prompt_actions", "buffer"),
  --           desc = "Prompt actions",
  --         }
  --
  --         maps.v[prefix .. "p"] = {
  --           create_mapping("prompt_actions", "visual"),
  --           desc = "Prompt actions",
  --         }
  --
  --         maps.n[prefix .. "d"] = {
  --           create_mapping("help_actions", "buffer"),
  --           desc = "LSP Diagnostics actions",
  --         }
  --
  --         maps.v[prefix .. "d"] = {
  --           create_mapping("help_actions", "visual"),
  --           desc = "LSP Diagnostics actions",
  --         }
  --
  --         -- Quick Chat function
  --         local function quick_chat(selection_type)
  --           return function()
  --             vim.ui.input({ prompt = "Quick Chat: " }, function(input)
  --               if input ~= nil and input ~= "" then
  --                 require("CopilotChat").ask(input, { selection = require("CopilotChat.select")[selection_type] })
  --               end
  --             end)
  --           end
  --         end
  --
  --         maps.n[prefix .. "q"] = {
  --           quick_chat "buffer",
  --           desc = "Quick Chat",
  --         }
  --
  --         maps.v[prefix .. "q"] = {
  --           quick_chat "visual",
  --           desc = "Quick Chat",
  --         }
  --       end,
  --     },
  --     { "AstroNvim/astroui", opts = { icons = { CopilotChat = "" } } },
  --   },
  --   opts = {
  --     window = {
  --       layout = "float",
  --       width = 74, -- absolute width in columns
  --       height = vim.o.lines - 4, -- absolute height in rows, subtract for command line and status line
  --       row = 1, -- row position of the window, starting from the top
  --       col = vim.o.columns - 74, -- column position of the window, aligned to the right
  --     },
  --   },
  -- },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   specs = {
  --     { import = "astrocommunity.completion.copilot-lua" },
  --     {
  --       "hrsh7th/nvim-cmp",
  --       dependencies = { "zbirenbaum/copilot.lua" },
  --       opts = function(_, opts)
  --         local cmp, copilot = require "cmp", require "copilot.suggestion"
  --         local snip_status_ok, luasnip = pcall(require, "luasnip")
  --         if not snip_status_ok then return end
  --
  --         -- cmp.event:on("menu_opened", function() vim.b.copilot_suggestion_hidden = true end)
  --         -- cmp.event:on("menu_closed", function() vim.b.copilot_suggestion_hidden = false end)
  --
  --         -- Unfortunately this is really buggy
  --         -- Debounce setup
  --         -- local timer = vim.loop.new_timer()
  --         -- local DEBOUNCE_DELAY = 1000
  --         --
  --         -- local function debounce_copilot()
  --         --   timer:stop()
  --         --   vim.b.copilot_suggestion_hidden = true
  --         --   timer:start(DEBOUNCE_DELAY, 0, vim.schedule_wrap(function() vim.b.copilot_suggestion_hidden = false end))
  --         -- end
  --         --
  --         -- cmp.event:on("menu_opened", debounce_copilot)
  --         -- cmp.event:on("menu_closed", debounce_copilot)
  --
  --         local function has_words_before()
  --           local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  --           return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
  --         end
  --
  --         if not opts.mapping then opts.mapping = {} end
  --         opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
  --           if copilot.is_visible() then
  --             copilot.accept()
  --           elseif cmp.visible() then
  --             cmp.select_next_item()
  --             -- debounce_copilot()
  --           elseif luasnip.expand_or_jumpable() then
  --             luasnip.expand_or_jump()
  --           elseif has_words_before() then
  --             cmp.complete()
  --           else
  --             fallback()
  --           end
  --         end, { "i", "s" })
  --
  --         opts.mapping["<C-x>"] = cmp.mapping(function()
  --           if copilot.is_visible() then copilot.next() end
  --         end)
  --
  --         opts.mapping["<C-z>"] = cmp.mapping(function()
  --           if copilot.is_visible() then copilot.prev() end
  --         end)
  --
  --         opts.mapping["<C-right>"] = cmp.mapping(function()
  --           if copilot.is_visible() then copilot.accept_word() end
  --         end)
  --
  --         opts.mapping["<C-l>"] = cmp.mapping(function()
  --           if copilot.is_visible() then copilot.accept_word() end
  --         end)
  --
  --         opts.mapping["<C-down>"] = cmp.mapping(function()
  --           if copilot.is_visible() then copilot.accept_line() end
  --         end)
  --
  --         opts.mapping["<C-j>"] = cmp.mapping(function()
  --           if copilot.is_visible() then copilot.accept_line() end
  --         end)
  --
  --         opts.mapping["<C-c>"] = cmp.mapping(function()
  --           if copilot.is_visible() then copilot.dismiss() end
  --         end)
  --
  --         return opts
  --       end,
  --     },
  --   },
  -- },
}

---@type LazySpec
-- return {
--   {
--     "huynle/ogpt.nvim",
--     event = "VeryLazy",
--     dependencies = {
--       "MunifTanjim/nui.nvim",
--       "nvim-lua/plenary.nvim",
--       "nvim-telescope/telescope.nvim",
--     },
--     config = function()
--       -- local opts = {
--       -- edit_with_instructions = {
--       --   keymaps = {
--       --     use_output_as_input = "<C-a>",
--       --   },
--       -- },
--       -- api_params = {
--       --   model = "mistral:7b", -- Default
--       -- },
--       -- api_edit_params = {
--       --   model = "deepseek-coder:6.7b", -- Default
--       -- },
--       -- -- show_quickfixes_cmd = "copen",
--       -- -- add custom actions.json
--       -- actions_paths = {},
--       -- }

--       -- require("ogpt").setup(opts)

--       require("ogpt").setup()

--       local which_key_ok, which_key = pcall(require, "which-key")
--       if not which_key_ok then return end

--       opts = {
--         mode = { "n", "v" }, -- NORMAL and VISUAL mode
--         prefix = "<leader>",
--         buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--         silent = true, -- use `silent` when creating keymaps
--         noremap = true, -- use `noremap` when creating keymaps
--         nowait = true, -- use `nowait` when creating keymaps
--       }

--       local mappings = {
--         O = {
--           name = "+OLlama GPT",
--           c = { "<cmd>OGPT<CR>", "OGPT Chat" },
--           a = { "<cmd>OGPTActAs<CR>", "OGPT Act As" },
--           e = { "<cmd>OGPTRun edit_with_instructions<CR>", "Edit with instruction" },
--           E = { "<cmd>OGPTRun edit_code_with_instructions<CR>", "Edit Code with instruction" },
--           C = { "<cmd>OGPTRun complete_code<CR>", "Complete Code" },
--           G = { "<cmd>OGPTRun grammar_correction<CR>", "Grammar Correction" },
--           t = { "<cmd>OGPTRun translate<CR>", "Translate" },
--           k = { "<cmd>OGPTRun keywords<CR>", "Keywords" },
--           d = { "<cmd>OGPTRun docstring<CR>", "Docstring" },
--           A = { "<cmd>OGPTRun add_tests<CR>", "Add Tests" },
--           o = { "<cmd>OGPTRun optimize_code<CR>", "Optimize Code" },
--           s = { "<cmd>OGPTRun summarize<CR>", "Summarize" },
--           f = { "<cmd>OGPTRun fix_bugs<CR>", "Fix Bugs" },
--           x = { "<cmd>OGPTRun explain_code<CR>", "Explain Code" },
--           r = { "<cmd>OGPTRun roxygen_edit<CR>", "Roxygen Edit" },
--           l = { "<cmd>OGPTRun code_readability_analysis<CR>", "Code Readability Analysis" },
--         },
--       }

--       which_key.register(mappings, opts)
--     end,
--   },
-- }

-- return {
--   {
--     "Exafunction/codeium.vim",
--     event = "User AstroFile",
--     keys = {
--       {
--         "<leader>;",
--         function()
--           if vim.g.codeium_enabled == true then
--             vim.cmd "CodeiumDisable"
--           else
--             vim.cmd "CodeiumEnable"
--           end
--         end,
--         desc = "Toggle Codeium",
--       },
--     },
--     config = function()
--       vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
--       vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
--     end,
--   },
--   {
--     "rebelot/heirline.nvim",
--     -- WARN: codeium support
--     dependencies = {
--       "Exafunction/codeium.vim",
--     },
--     event = "BufEnter",
--     opts = function()
--       local status = require "astronvim.utils.status"
--       -- WARN: codeium support
--       local codeium_status = {
--         provider = function() return "🤖 " .. vim.api.nvim_eval "codeium#GetStatusString()" end,
--         update = true,
--       }
--       return {
--         opts = {
--           disable_winbar_cb = function(args)
--             return not require("astronvim.utils.buffer").is_valid(args.buf)
--               or status.condition.buffer_matches({
--                 buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
--                 filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
--               }, args.buf)
--           end,
--         },
--         statusline = { -- statusline
--           hl = { fg = "fg", bg = "bg" },
--           status.component.mode(),
--           status.component.git_branch(),
--           status.component.file_info { filetype = {}, filename = false, file_modified = false },
--           status.component.git_diff(),
--           status.component.diagnostics(),
--           status.component.diagnostics(),
--           status.component.fill(),
--           status.component.cmd_info(),
--           status.component.fill(),
--           --WARN: codeium support
--           codeium_status,
--           status.component.lsp(),
--           status.component.treesitter(),
--           status.component.nav(),
--           status.component.mode { surround = { separator = "right" } },
--         },
--         winbar = { -- winbar
--           init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
--           fallthrough = false,
--           {
--             condition = function() return not status.condition.is_active() end,
--             status.component.separated_path(),
--             status.component.file_info {
--               file_icon = { hl = status.hl.file_icon "winbar", padding = { left = 0 } },
--               file_modified = false,
--               file_read_only = false,
--               hl = status.hl.get_attributes("winbarnc", true),
--               surround = false,
--               update = "BufEnter",
--             },
--           },
--           status.component.breadcrumbs { hl = status.hl.get_attributes("winbar", true) },
--         },
--         tabline = { -- bufferline
--           { -- file tree padding
--             condition = function(self)
--               self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
--               return status.condition.buffer_matches({
--                 filetype = {
--                   "NvimTree",
--                   "OverseerList",
--                   "aerial",
--                   "dap%-repl",
--                   "dapui_.",
--                   "edgy",
--                   "neo%-tree",
--                   "undotree",
--                 },
--               }, vim.api.nvim_win_get_buf(self.winid))
--             end,
--             provider = function(self) return string.rep(" ", vim.api.nvim_win_get_width(self.winid) + 1) end,
--             hl = { bg = "tabline_bg" },
--           },
--           status.heirline.make_buflist(status.component.tabline_file_info()), -- component for each buffer tab
--           status.component.fill { hl = { bg = "tabline_bg" } }, -- fill the rest of the tabline with background color
--           { -- tab list
--             condition = function() return #vim.api.nvim_list_tabpages() >= 2 end, -- only show tabs if there are more than one
--             status.heirline.make_tablist { -- component for each tab
--               provider = status.provider.tabnr(),
--               hl = function(self) return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true) end,
--             },
--             { -- close button for current tab
--               provider = status.provider.close_button { kind = "TabClose", padding = { left = 1, right = 1 } },
--               hl = status.hl.get_attributes("tab_close", true),
--               on_click = {
--                 callback = function() require("astronvim.utils.buffer").close_tab() end,
--                 name = "heirline_tabline_close_tab_callback",
--               },
--             },
--           },
--         },
--         statuscolumn = vim.fn.has "nvim-0.9" == 1 and {
--           init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
--           status.component.foldcolumn(),
--           status.component.fill(),
--           status.component.numbercolumn(),
--           status.component.signcolumn(),
--         } or nil,
--       }
--     end,
--     config = require "plugins.configs.heirline",
--   },
-- }

-- Cool idea but I don't think this works that great, this could totally be a me problem
-- return {
--   {
--     "tzachar/cmp-ai",
--     dependencies = "nvim-lua/plenary.nvim",
--     config = function()
--       local cmp_ai = require "cmp_ai.config"
--
--       cmp_ai:setup {
--         max_lines = 100,
--         provider = "Ollama",
--         provider_options = {
--           model = "codellama:13b",
--           base_url = os.getenv "OLLAMA_API_HOST" .. "/api/generate",
--         },
--         notify = true,
--         notify_callback = function(msg)
--           vim.notify(msg, vim.log.levels.INFO, {
--             title = "OLlama",
--             render = "compact",
--           })
--         end,
--         run_on_every_keystroke = true,
--         ignored_file_types = {
--           -- lua = true
--         },
--       }
--     end,
--   },
--   {
--     "hrsh7th/nvim-cmp",
--     dependencies = {
--       "saadparwaiz1/cmp_luasnip",
--       "hrsh7th/cmp-buffer",
--       "hrsh7th/cmp-path",
--       "hrsh7th/cmp-nvim-lsp",
--       "tzachar/cmp-ai",
--     },
--     event = "InsertEnter",
--     opts = function()
--       local cmp = require "cmp"
--       local snip_status_ok, luasnip = pcall(require, "luasnip")
--       local lspkind_status_ok, lspkind = pcall(require, "lspkind")
--       local utils = require "astronvim.utils"
--       if not snip_status_ok then return end
--       local border_opts = {
--         border = "rounded",
--         winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
--       }
--
--       local function has_words_before()
--         local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
--         return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
--       end
--
--       return {
--         enabled = function()
--           local dap_prompt = utils.is_available "cmp-dap" -- add interoperability with cmp-dap
--             and vim.tbl_contains(
--               { "dap-repl", "dapui_watches", "dapui_hover" },
--               vim.api.nvim_get_option_value("filetype", { buf = 0 })
--             )
--           if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" and not dap_prompt then return false end
--           return vim.g.cmp_enabled
--         end,
--         preselect = cmp.PreselectMode.None,
--         formatting = {
--           fields = { "kind", "abbr", "menu" },
--           format = lspkind_status_ok and lspkind.cmp_format(utils.plugin_opts "lspkind.nvim") or nil,
--         },
--         snippet = {
--           expand = function(args) luasnip.lsp_expand(args.body) end,
--         },
--         duplicates = {
--           cmp_ai = 1,
--           nvim_lsp = 1,
--           luasnip = 1,
--           cmp_tabnine = 1,
--           buffer = 1,
--           path = 1,
--         },
--         confirm_opts = {
--           behavior = cmp.ConfirmBehavior.Replace,
--           select = false,
--         },
--         window = {
--           completion = cmp.config.window.bordered(border_opts),
--           documentation = cmp.config.window.bordered(border_opts),
--         },
--         mapping = {
--           ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
--           ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
--           ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
--           ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
--           ["<C-k>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
--           ["<C-j>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
--           ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
--           ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
--           ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
--           ["<C-y>"] = cmp.config.disable,
--           ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
--           ["<CR>"] = cmp.mapping.confirm { select = false },
--           ["<Tab>"] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--               cmp.select_next_item()
--             elseif luasnip.expand_or_jumpable() then
--               luasnip.expand_or_jump()
--             elseif has_words_before() then
--               cmp.complete()
--             else
--               fallback()
--             end
--           end, { "i", "s" }),
--           ["<S-Tab>"] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--               cmp.select_prev_item()
--             elseif luasnip.jumpable(-1) then
--               luasnip.jump(-1)
--             else
--               fallback()
--             end
--           end, { "i", "s" }),
--         },
--         sources = cmp.config.sources {
--           { name = "nvim_lsp", priority = 1000 },
--           { name = "luasnip", priority = 750 },
--           { name = "buffer", priority = 500 },
--           { name = "path", priority = 250 },
--           { name = "cmp_ai", priority = 300 },
--         },
--       }
--     end,
--   },
-- }
