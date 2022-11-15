--------------------
-- plugins config --
--------------------
local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim", install_path
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then return end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({border = "rounded"})
        end
    }
})

-- Install your plugins here
return packer.startup(function(use)
    use {"wbthomason/packer.nvim"} -- 插件管理器本身
    use {"nvim-lua/plenary.nvim"} -- 很多插件依赖此插件，放到前面
    use {"windwp/nvim-autopairs"} -- 符号的自动配对，补全插件和其他插件依赖
    use {
        "numToStr/Comment.nvim", 
        commit = "97a188a98b5a3a6f9b1b850799ac078faa17ab67" } -- 注释插件
    use {"JoosepAlviste/nvim-ts-context-commentstring", commit = "32d9627123321db65a4f158b72b757bcaef1a3f4"} -- 注释插件
    use {"kyazdani42/nvim-web-devicons"} -- 提供了一些icons
    use {"nvim-tree/nvim-tree.lua"} -- 树结构
    use {"akinsho/bufferline.nvim"} -- 实现标签页
--    use {"moll/vim-bbye"} -- 不更改布局的情况下关闭文件
    use {"nvim-lualine/lualine.nvim"} -- 状态栏插件
--    use {"akinsho/toggleterm.nvim"} -- 多终端切换
    use {"ahmedkhalf/project.nvim"} -- 项目管理

    use {"lewis6991/impatient.nvim"} -- 优化lua加载速度
    use {"lukas-reineke/indent-blankline.nvim"} -- 增加缩进参考线
--    use {"goolord/alpha-nvim"} -- nvim欢迎主题
--    use {"folke/which-key.nvim"}

    -- Colorschemes
--    use {"lunarvim/darkplus.nvim"}
    use {"catppuccin/nvim", as = "catppuccin"} -- 正在使用的配色

    -- Cmp 
    use {
        "hrsh7th/nvim-cmp",
        commit = "b0dff0ec4f2748626aae13f011d1a47071fe9abc"
    } -- 补全插件
    use {
        "hrsh7th/cmp-buffer",
        commit = "3022dbc9166796b644a841a02de8dd1cc1d311fa"
    } -- buffer 补全
    use {
        "hrsh7th/cmp-path",
        commit = "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1"
    } -- 路径补全
    use {
        "saadparwaiz1/cmp_luasnip",
        commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36"
    } -- 代码段补全
    use {
        "hrsh7th/cmp-nvim-lsp",
        commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8"
    }
    use {
        "hrsh7th/cmp-nvim-lua",
        commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21"
    }

    -- Snippets
    use {"L3MON4D3/LuaSnip"} -- snippet engine
    use {"rafamadriz/friendly-snippets"} -- a bunch of snippets to use

    -- LSP
    use {
        "neovim/nvim-lspconfig",
        commit = "f11fdff7e8b5b415e5ef1837bdcdd37ea6764dda"
    } -- enable LSP
    use {
        "williamboman/mason.nvim",
        commit = "c2002d7a6b5a72ba02388548cfaf420b864fbc12"
    } -- simple to use language server installer
    use {
        "williamboman/mason-lspconfig.nvim",
        commit = "0051870dd728f4988110a1b2d47f4a4510213e31"
    }
    use {
        "jose-elias-alvarez/null-ls.nvim",
        commit = "c0c19f32b614b3921e17886c541c13a72748d450"
    } -- for formatters and linters
    use {
        "RRethy/vim-illuminate",
        commit = "a2e8476af3f3e993bb0d6477438aad3096512e42"
    } -- 突出显示

    -- Telescope
    use {"nvim-telescope/telescope.nvim"} -- 模糊搜索

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        commit = "8e763332b7bf7b3a426fd8707b7f5aa85823a5ac"
    } -- 更好的高亮显示

    -- Git
    use {"lewis6991/gitsigns.nvim"} -- 状态栏集成git
    -- install without yarn or npm
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end
    })

    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function() vim.g.mkdp_filetypes = {"markdown"} end,
        ft = {"markdown"}
    })

--    use {"rinx/nvim-minimap"} -- Minimap
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then require("packer").sync() end
end)
