return {
  -- LSP and Mason configuration
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      -- Mason for managing LSP servers
      {
        "williamboman/mason.nvim",
        config = true,                     -- auto-runs require("mason").setup()
      },
      "williamboman/mason-lspconfig.nvim", -- Bridge for Mason and lspconfig
      "neovim/nvim-lspconfig",             -- Core LSP setup
      "hrsh7th/cmp-nvim-lsp",              -- LSP source for nvim-cmp
      "hrsh7th/nvim-cmp",                  -- Completion engine
    },
    config = function()
      local lsp_zero = require("lsp-zero")

      -- Function to set up LSP keymaps
      local lsp_attach = function(client, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
      end

      lsp_zero.extend_lspconfig({
        sign_text = true,
        lsp_attach = lsp_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })

      require('mason').setup({})
      require('mason-lspconfig').setup({
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({
              on_attach = lsp_attach,
              capabilities = require('cmp_nvim_lsp').default_capabilities(),
            })
          end,
        }
      })
    end,
  },

  -- nvim-cmp configuration
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",    -- Lazy-load cmp when entering Insert mode
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- LSP source
    },
    config = function()
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero').cmp_action()
      cmp.setup({
        completion = {
          completeopt = "menu,menuone,preview,noselect"
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
      })
    end,
  },

  -- Mason setup for LSP
  {
    "williamboman/mason.nvim",
    lazy = false,  -- load on startup
    config = true, -- Auto-configures with default settings
  },

  -- Mason-LSPConfig to bridge Mason and LSPConfig
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false, -- load on startup
    dependencies = { "neovim/nvim-lspconfig" },
  },

  -- nvim-lspconfig setup for LSP integration
  {
    "neovim/nvim-lspconfig",
    lazy = true,
  },
}
