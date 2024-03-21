-- Show relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Use 4-space tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Automatically indent new lines
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true

-- Don't wrap lines
vim.opt.wrap = false

-- Save undo history to a file, but don't save swap or backups
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Don't highlight search matches, but do show matches whilst typing
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Keep lines visible above/below cursor
vim.opt.scrolloff = 8

-- Always leave a gap for signs in number gutter
vim.opt.signcolumn = "yes"

-- Make keys repeat faster
vim.opt.updatetime = 50

-- Reduce wait for key sequence to complete
vim.opt.timeout = true
vim.opt.timeoutlen = 500

-- Draw a hint for manually wrapping lines
vim.opt.colorcolumn = "80"

-- Highlight the line the cursor is on
vim.opt.cursorline = true

-- Search ignoring case unless search contains uppercase characters
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Prefer splitting windows to the right and the bottom
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.formatoptions = vim.opt.formatoptions
    - "a" -- Don't automatically format
    - "t" -- Don't auto-wrap text
    + "c" -- Auto-wrap comments to textwidth
    + "q" -- Allow comments to be formatted with `gq`
    - "o" -- Don't insert comment when `o` or `O` -ing on a comment
    + "r" -- But do continue a comment when hitting enter
    - "n" -- Recognise numbered lists when formatting
    + "j" -- Remove comment leaders when joining lines
    - "2" -- Don't allow paragraphs to have a different indent on first line

-- Use 24-bit colors in the terminal
vim.opt.termguicolors = true

-- Hide netrw banner
vim.g.netrw_banner = 0
