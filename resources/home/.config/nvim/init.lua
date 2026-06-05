-- ==========================================
-- 1. 基本設定
-- ==========================================
vim.opt.number = true             -- 行番号を表示
vim.opt.cursorline = true         -- カーソル行の強調
vim.opt.cursorcolumn = true       -- カーソル列の強調
vim.opt.expandtab = true          -- タブを空白に展開
vim.opt.tabstop = 4               -- タブ幅
vim.opt.softtabstop = 4           -- ソフトタブ幅
vim.opt.shiftwidth = 4            -- インデント幅
vim.opt.autowrite = true          -- 自動保存
vim.opt.hidden = true             -- 保存していないバッファの切り替えを有効
vim.opt.mouse = "h"               -- マウス操作の制限
vim.opt.clipboard = "unnamedplus" -- OSのクリップボードと同期
vim.opt.shortmess:remove("S")     -- vim-anzu の代替 (検索結果のカウント [1/10] を標準表示)

vim.g.mapleader = " "             -- リーダーキーをスペースに設定


-- ==========================================
-- 2. キーマッピング (common.vim / cursor.vim からの移植)
-- ==========================================
local keymap = vim.keymap.set
local opts = { silent = true }

-- バッファとウィンドウの移動
keymap('n', '<Left>', '<Esc>:bp<CR>', opts)
keymap('n', '<Right>', '<Esc>:bn<CR>', opts)
keymap('n', 'tt', '<C-w>w', opts)

-- 表示行での移動 (j/k と gj/gk の入れ替え)
keymap({'n', 'v'}, 'j', 'gj', opts)
keymap({'n', 'v'}, 'k', 'gk', opts)
keymap({'n', 'v'}, 'gj', 'j', opts)
keymap({'n', 'v'}, 'gk', 'k', opts)

-- 検索ハイライトの解除
keymap('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>', opts)

-- インデント後も Visual mode を維持 (common.vim からの移植)
keymap('v', '>', '>gv', opts)
keymap('v', '<', '<gv', opts)

-- ==========================================
-- 3. lazy.nvim のブートストラップ
-- ==========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- ==========================================
-- 3. lazy.nvim のブートストラップ
-- ==========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- ==========================================
-- 4. プラグインの定義
-- ==========================================
require("lazy").setup({
  -- [カラースキーム]
  {
    "cocopon/iceberg.vim",
    config = function()
      vim.cmd("colorscheme iceberg")
    end
  },

  -- [ステータスライン] lualine (自作関数の代替)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "iceberg_dark" }
      })
    end
  },
  -- 構文ハイライト
  {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    config = function()
    require("tree-sitter-manager").setup({
      -- Default Options
      -- ensure_installed = {}, -- list of parsers to install at the start of a neovim session. If set to "all", install all parsers.
      -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
      -- auto_install = false, -- if enabled, install missing parsers when editing a new file
      -- highlight = true, -- treesitter highlighting is enabled by default
      -- languages = {}, -- override or add new parser sources
    })
    end
  },
  -- [自動補完]
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({{ name = 'buffer' }, { name = 'path' }})
      })
    end
  },
  -- [ファイラー]
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- ファイラー専用画面の中だけで有効にするキーバインド設定
      local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- デフォルトのキーバインド（Enterで開く、aで新規作成など）をまず読み込む
        api.config.mappings.default_on_attach(bufnr)

        -- 【重要】ファイラー内部で <C-e> を押した時は、ツリーを閉じる命令にする
        vim.keymap.set('n', '<C-e>', api.tree.close, opts('Close'))
      end

      require("nvim-tree").setup({
        on_attach = my_on_attach, -- 作成したキーバインド設定を登録
        view = {
          width = 30,
        },
        filters = {
          dotfiles = false,
          custom = { "^\\.git$" }
        },
        actions = {
          open_file = {
            quit_on_open = false,
          }
        }
      })

      -- グローバルマッピング（通常のコード画面から開閉する用）
      vim.keymap.set('n', '<C-e>', ':NvimTreeToggle<CR>', { silent = true, desc = "Toggle NvimTree" })
    end
  }
})
