return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<C-t>", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Toggle Terminal (vertical)" },
    {
      "<leader>gg",
      function()
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
        lazygit:toggle()
      end,
      desc = "Lazygit",
    },
  },
  config = function()
    require("toggleterm").setup({
      size = 40,
      direction = "vertical",
    })
  end,
}
