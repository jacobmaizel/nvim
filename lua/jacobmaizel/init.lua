require("jacobmaizel.remaps")
require("jacobmaizel.luasnip")
require("jacobmaizel.opts")
require("jacobmaizel.mason")
require("jacobmaizel.treesitter")
require("jacobmaizel.cmp")
require("jacobmaizel.rustacean")
-- require("jacobmaizel.cmdlinenoice")

local banned_messages = { "No information available" }
vim.notify = function(msg, ...)
  for _, banned in ipairs(banned_messages) do
    if msg == banned then
      return
    end
  end
  return require("notify")(msg, ...)
end


require("nvim-autopairs").setup {}
require('lualine').setup()
require('crates').setup()
-- require('Comment').setup()


-- Leap
require('leap').create_default_mappings()
require('leap').opts.special_keys.prev_target = '<bs>'
require('leap').opts.special_keys.prev_group = '<bs>'
require('leap.user').set_repeat_keys('<cr>', '<bs>')

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.cmd("hi IlluminatedWordRead guibg=#2c313c")
vim.cmd("hi IlluminatedWord guibg=#2c313c")
vim.cmd("hi IlluminatedWordWrite guibg=#2c313c")
vim.cmd("hi IlluminatedWordText guibg=#2c313c")

vim.keymap.set('n', '<leader>lg', function()
  vim.cmd('LazyGit')
end, {})


