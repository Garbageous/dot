return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require 'dap'

      -- C#
      dap.adapters.coreclr = {
        type = 'executable',
        command = vim.fn.stdpath 'data' .. '/mason/bin/netcoredbg',
        args = { '--interpreter=vscode' },
      }
      dap.configurations.cs = {
        {
          type = 'coreclr',
          name = 'launch - netcoredbg',
          request = 'launch',
          program = function() -- Ask the user what executable wants to debug
            return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Program.exe', 'file')
          end,
        },
      }

      -- F#
      dap.configurations.fsharp = dap.configurations.cs

      -- Visual basic dotnet
      dap.configurations.vb = dap.configurations.cs

      -- -- Python
      -- dap.adapters.python = {
      --   type = 'executable',
      --   command = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python',
      --   args = { '-m', 'debugpy.adapter' },
      -- }
      -- dap.configurations.python = {
      --   {
      --     type = 'python',
      --     request = 'launch',
      --     name = 'Launch file',
      --     program = '${file}', -- This configuration will launch the current file if used.
      --   },
      -- }
      --
      -- -- Lua
      -- dap.adapters.nlua = function(callback, config)
      --   callback { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 }
      -- end
      -- dap.configurations.lua = {
      --   {
      --     type = 'nlua',
      --     request = 'attach',
      --     name = 'Attach to running Neovim instance',
      --     program = function()
      --       pcall(require('osv').launch { port = 8086 })
      --     end,
      --   },
      -- }

      -- Rust
      dap.configurations.rust = {
        {
          name = 'Launch',
          type = 'codelldb',
          request = 'launch',
          program = function() -- Ask the user what executable wants to debug
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/bin/program', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          initCommands = function() -- add rust types support (optional)
            -- Find out where to look for the pretty printer Python module
            local rustc_sysroot = vim.fn.trim(vim.fn.system 'rustc --print sysroot')

            local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
            local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

            local commands = {}
            local file = io.open(commands_file, 'r')
            if file then
              for line in file:lines() do
                table.insert(commands, line)
              end
              file:close()
            end
            table.insert(commands, 1, script_import)

            return commands
          end,
        },
      }

      -- Kotlin
      -- Kotlin projects have very weak project structure conventions.
      -- You must manually specify what the project root and main class are.
      -- dap.adapters.kotlin = {
      --   type = 'executable',
      --   command = vim.fn.stdpath 'data' .. '/mason/bin/kotlin-debug-adapter',
      -- }
      -- dap.configurations.kotlin = {
      --   {
      --     type = 'kotlin',
      --     request = 'launch',
      --     name = 'Launch kotlin program',
      --     projectRoot = '${workspaceFolder}/app', -- ensure this is correct
      --     mainClass = 'AppKt', -- ensure this is correct
      --   },
      -- }
      --
      -- -- Javascript / Typescript (firefox)
      -- dap.adapters.firefox = {
      --   type = 'executable',
      --   command = vim.fn.stdpath 'data' .. '/mason/bin/firefox-debug-adapter',
      -- }
      -- dap.configurations.typescript = {
      --   {
      --     name = 'Debug with Firefox',
      --     type = 'firefox',
      --     request = 'launch',
      --     reAttach = true,
      --     url = 'http://localhost:4200', -- Write the actual URL of your project.
      --     webRoot = '${workspaceFolder}',
      --     firefoxExecutable = '/usr/bin/firefox',
      --   },
      -- }
      -- dap.configurations.javascript = dap.configurations.typescript
      -- dap.configurations.javascriptreact = dap.configurations.typescript
      -- dap.configurations.typescriptreact = dap.configurations.typescript
    end, -- of dap config
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'rcarriga/cmp-dap',
      'jay-babu/mason-nvim-dap.nvim',
      'jbyuki/one-small-step-for-vimkind',
    },
  },
}
