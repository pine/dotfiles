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
vim.opt.shortmess:remove("S")     -- vim-anzu の代替 (検索結果のカウント [1/10] を標準表示)

vim.g.mapleader = " "             -- リーダーキーをスペースに設定


---------------------------------------------
-- クリップボード
---------------------------------------------

-- OSのクリップボードと同期
vim.opt.clipboard = "unnamedplus"

-- 書式付きテキストを貼り付けできない問題を修正
-- クリップボードプロバイダを自動検出に頼らず、macOS純正の pbcopy/pbpaste に強制固定する
vim.g.clipboard = {
  name = 'macOS-clipboard',
  copy = {
    ['+'] = 'pbcopy',
    ['*'] = 'pbcopy',
  },
  paste = {
    ['+'] = 'pbpaste',
    ['*'] = 'pbpaste',
  },
  cache_enabled = 0,
}

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

        -- 標準キーバインドの無効化
        vim.keymap.set('n', 'd', '<Nop>', opts('None'))
        vim.keymap.set('n', 'a', '<Nop>', opts('None'))
        vim.keymap.set('n', 'c', '<Nop>', opts('None'))
        vim.keymap.set('n', 'e', '<Nop>', opts('None'))

        -- 【重要】ファイラー内部で <C-e> を押した時は、ツリーを閉じる命令にする
        vim.keymap.set('n', '<C-e>', api.tree.close, opts('Close'))

        -- カスタムキーバインドの追加
        vim.keymap.set('n', 'r', api.tree.reload, opts('Refresh')) -- リフレッシュ
        vim.keymap.set('n', 'x', api.node.navigate.parent_close, opts('Close Directory')) -- 閉じる
        vim.keymap.set('n', 'ma', api.fs.create, opts('Create')) -- 新規作成
        vim.keymap.set('n', 'mc', api.fs.create, opts('Create')) -- 新規作成
        vim.keymap.set('n', 'mr', api.fs.rename, opts('Rename')) -- リネーム
        vim.keymap.set('n', 'mm', api.fs.rename, opts('Move'))   -- 移動
        vim.keymap.set('n', 'md', api.fs.remove, opts('Delete')) -- 削除

        -- 必要であれば追記：切り取り（Cut）機能を大文字の X に退避させる
        vim.keymap.set('n', 'X', api.fs.cut, opts('Cut'))
      end

      require("nvim-tree").setup({
        on_attach = my_on_attach, -- 作成したキーバインド設定を登録
        view = {
          width = 30,
        },
        filters = {
          dotfiles = false,
          custom = {
            "^\\.DS_Store$",
          },
          -- gitignore 対象のファイルも隠さず表示する
          git_ignored = false,
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


-- =====================================================================
-- 条件付き自動起動：特定のファイル指定時以外、初期状態でファイラを開く
-- =====================================================================
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    -- 1. 引数なしで起動したかどうかの判定 (例: nvim)
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

    -- 2. ディレクトリを指定して起動したかどうかの判定 (例: nvim .)
    local directory = vim.fn.isdirectory(data.file) == 1

    -- 「引数なし」でも「ディレクトリ指定」でもない場合（＝ファイル指定時）は何もしない
    if not no_name and not directory then
      return
    end

    -- ディレクトリ指定だった場合は、Neovimのカレントディレクトリをそこに移動
    if directory then
      vim.cmd.cd(data.file)
    end

    -- ファイラーを開く
    require("nvim-tree.api").tree.open()
  end,
})
