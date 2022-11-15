------------------
-- basic config --
------------------


local options = {
    fileencoding = "utf-8",                  -- 字符集设置
    number = true,                           -- 显示行号
    cursorline = true,                       -- 突出显示当前行
    relativenumber = false,                  -- 相对行号
    numberwidth = 4,                         -- 数字列宽
    expandtab = true,                        -- 将制表符转换为空格
    tabstop = 4,                             -- 一个缩进是四个空格
    smartindent = true,                      -- 智能缩进（新行对齐当前行）
    shiftwidth = 2,                          -- 为每个缩进插入的空格数
    hlsearch = true,                         -- 搜索高亮
    ignorecase = true,                       -- 搜索忽略大小写
    smartcase = true,                        -- 智能搜索
    backup = false,                          -- 是否创建备份文件
    swapfile = false,                        -- 是否创建交换文件
    clipboard = "unnamedplus",               -- 允许访问剪贴板
    showtabline = 2,                         -- 始终显示tabs
    pumheight = 10,                          -- 弹出菜单的高度
    undofile = true,                         -- 启用持久撤销
    showmode = false,                        -- 使用增强状态栏插件则禁用此项不再显示 -- INSERT --等信息
    mouse = "a",                             -- 启用鼠标
    splitbelow = true,                       -- 水平分屏在下侧
    splitright = true,                       -- 垂直分屏在右侧
    cmdheight = 2,                           -- 命令行高，用于显示更多信息
    guifont = "monospace:h17",               -- gui字体
    wrap = true,                             -- 是否折行
    timeoutlen = 300,                        -- 判断快捷键的连击时间
    scrolloff = 8,                           -- 保证光标上方和下方的最少空间（行数）
    sidescrolloff = 8,                       -- wrap为false时光标两侧是最少空间（列数）
    autoread = true,                          -- 程序被外部修改时自动加载
    writebackup = false,                     -- 如果文件正在被另外程序编辑（或者在用另外的程序编辑时被写入文件）则不允许对其进行编辑
    list = false,                            -- 是否显示不可见字符
    listchars = "space:·,tab:··",            -- 不可见字符的显示
    completeopt = { "menu,menuone,noselect,noinsert" }, -- 自动补全不自动选中
    -- updatetime = 300,                        -- faster completion (4000ms default)
    -- linebreak = true,                        -- companion to wrap, don't split words
    -- conceallevel = 0,                        -- so that `` is visible in markdown files
    -- termguicolors = true,                    -- set term gui colors (most terminals support this)
    -- signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
}
  
  vim.opt.shortmess:append "c"
  
  for k, v in pairs(options) do
    vim.opt[k] = v
  end
  
vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work

--theme from catppuccin https://github.com/catppuccin/nvim
vim.cmd.colorscheme "catppuccin"
-- NORMAL mode chage fcitx5 
vim.cmd "let fcitx5state=system('fcitx5-remote')"
vim.cmd "autocmd InsertLeave * :silent let fcitx5state=system('fcitx5-remote')[0] | silent !fcitx5-remote -c "
-- vim.cmd "autocmd InsertEnter * :silent if fcitx5state == 2 | call system('fcitx5-remote -o') | endif "
