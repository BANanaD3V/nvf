{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.visuals;
in {
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.lspkind.enable {
      vim.startPlugins = ["lspkind"];
      vim.luaConfigRC.lspkind = nvim.dag.entryAnywhere ''
        -- lspkind
        require'lspkind'.init()
      '';
    })

    (mkIf cfg.indentBlankline.enable {
      vim.startPlugins = ["indent-blankline"];
      vim.luaConfigRC.indent-blankline = nvim.dag.entryAnywhere ''
        -- highlight error: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
        vim.wo.colorcolumn = "99999"
        vim.opt.list = true

        ${optionalString (cfg.indentBlankline.eolChar != "") ''
          vim.opt.listchars:append({ eol = "${cfg.indentBlankline.eolChar}" })
        ''}
        ${optionalString (cfg.indentBlankline.fillChar != "") ''
          vim.opt.listchars:append({ eol = "${cfg.indentBlankline.fillChar}" })
        ''}

        require("indent_blankline").setup {
          char = "${cfg.indentBlankline.listChar}",
          show_current_context = ${boolToString cfg.indentBlankline.showCurrContext},
          show_end_of_line = true,
        }
      '';
    })

    (mkIf cfg.cursorWordline.enable {
      vim.startPlugins = ["nvim-cursorline"];
      vim.luaConfigRC.cursorline = nvim.dag.entryAnywhere ''
        vim.g.cursorline_timeout = ${toString cfg.cursorWordline.lineTimeout}
      '';
    })

    (mkIf cfg.nvimWebDevicons.enable {
      vim.startPlugins = ["nvim-web-devicons"];
    })

    (mkIf cfg.scrollBar.enable {
      vim.startPlugins = ["scrollbar-nvim"];
      vim.luaConfigRC.scrollBar = nvim.dag.entryAnywhere ''
        require('scrollbar').setup{
            excluded_filetypes = {
              'prompt',
              'TelescopePrompt',
              'noice',
              'NvimTree',
              'alpha'
            },
          }
      '';
    })

    (mkIf cfg.smoothScroll.enable {
      vim.startPlugins = ["cinnamon-nvim"];
      vim.luaConfigRC.smoothScroll = nvim.dag.entryAnywhere ''
        require('cinnamon').setup()
      '';
    })

    (mkIf cfg.cellularAutomaton.enable {
      vim.startPlugins = ["cellular-automaton"];
      vim.luaConfigRC.cellularAUtomaton = nvim.dag.entryAnywhere ''
        local config = {
              fps = 50,
              name = 'slide',
            }

            -- init function is invoked only once at the start
            -- config.init = function (grid)
            --
            -- end

            -- update function
            config.update = function (grid)
            for i = 1, #grid do
              local prev = grid[i][#(grid[i])]
                for j = 1, #(grid[i]) do
                  grid[i][j], prev = prev, grid[i][j]
                end
              end
              return true
            end

            require("cellular-automaton").register_animation(config)

            vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
      '';
    })

    (mkIf cfg.fidget-nvim.enable {
      vim.startPlugins = ["fidget-nvim"];
      vim.luaConfigRC.fidget-nvim = nvim.dag.entryAnywhere ''
        require"fidget".setup{
          align = {
            bottom = ${boolToString cfg.fidget-nvim.align.bottom},
            right = ${boolToString cfg.fidget-nvim.align.right},
          }
        }
      '';
    })
  ]);
}
