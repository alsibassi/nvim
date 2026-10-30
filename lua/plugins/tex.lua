-- LaTeX: vimtex with Tectonic (compile) and Sioyek (view); extra imported in lazy.lua
return {
  {
    "lervag/vimtex",
    init = function()
      -- Tectonic only does single-shot builds; the autocmd below rebuilds on save
      vim.g.vimtex_compiler_method = "tectonic"
      vim.g.vimtex_compiler_tectonic = {
        out_dir = "build",
        options = { "--keep-logs", "--synctex" },
      }
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_view_sioyek_exe = "/Applications/sioyek.app/Contents/MacOS/sioyek"
      -- Don't pop the quickfix window on warnings, only on errors
      vim.g.vimtex_quickfix_open_on_warning = 0

      vim.api.nvim_create_autocmd("BufWritePost", {
        group = vim.api.nvim_create_augroup("vimtex_build_on_save", { clear = true }),
        pattern = { "*.tex", "*.bib" },
        command = "silent! VimtexCompile",
      })
    end,
  },
}
