require("jacobmaizel.remaps")
require("jacobmaizel.luasnip")
require("jacobmaizel.opts")
require("jacobmaizel.mason")
require("jacobmaizel.treesitter")
require("jacobmaizel.cmp")
require("jacobmaizel.rustacean")

require("nvim-autopairs").setup {}
require('lualine').setup()
require('crates').setup()

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.cmd("hi IlluminatedWordRead guibg=#2c313c")
vim.cmd("hi IlluminatedWord guibg=#2c313c")
vim.cmd("hi IlluminatedWordText guibg=#2c313c")

