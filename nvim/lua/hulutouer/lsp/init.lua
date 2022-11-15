local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require("hulutouer.lsp.mason")
require("hulutouer.lsp.handlers").setup()
require("hulutouer.lsp.null-ls")