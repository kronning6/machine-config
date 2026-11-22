return {
  'baggiponte/rex-navigator.nvim',
  main = 'rex-navigator',
  lazy = false,
  cond = function()
    return vim.env.REX_SESSION ~= nil and vim.env.REX_SESSION ~= ''
  end,
  opts = {},
}
