local callout_styles = {
  note      = { label = "󰋽 Note", hl = "RenderMarkdownInfo" },
  tip       = { label = "󰌶 Tip", hl = "RenderMarkdownSuccess" },
  important = { label = "󰅾 Important", hl = "RenderMarkdownHint" },
  warning   = { label = "󰀪 Warning", hl = "RenderMarkdownWarn" },
  caution   = { label = "󰳦 Caution", hl = "RenderMarkdownError" },
}

local function pad_to_winwidth(ctx, s)
  local win = ctx.win or 0
  local win_w = vim.api.nvim_win_get_width(win)
  local sw = vim.fn.strdisplaywidth(s)
  if sw < win_w then
    s = s .. string.rep(" ", win_w - sw)
  end
  return s
end

local function parse_quarto_callouts(ctx)
  local marks = {}
  local buf = ctx.buf
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- Make the left border thicker by using TWO glyphs.
  -- Try: "▍▍ " or "▌▌ " or "┃┃ " depending on what looks best in your font.
  local bar = "▉ "

  local i = 1
  while i <= #lines do
    local line = lines[i]

    local kind =
        line:match("^:::%s*%{?%s*%.callout%-([%a]+)") or
        line:match("^:::%s*callout%-([%a]+)")

    kind = kind and kind:lower() or nil
    local style = kind and callout_styles[kind] or nil

    if style then
      -- find closing fence
      local j = i + 1
      while j <= #lines and not lines[j]:match("^:::%s*$") do
        j = j + 1
      end

      if j <= #lines then
        -- (1) Header line: include the SAME bar prefix so it aligns with body text
        local header = bar .. style.label
        header = pad_to_winwidth(ctx, header)

        marks[#marks + 1] = {
          start_row = i - 1,
          start_col = 0,
          opts = {
            virt_text = { { header, style.hl } },
            virt_text_pos = "overlay",
            virt_text_hide = true,
          },
        }

        -- (2) Body lines: add thick bar inline, pushing text right
        for row = i + 1, j - 1 do
          marks[#marks + 1] = {
            start_row = row - 1,
            start_col = 0,
            opts = {
              virt_text = { { bar, style.hl } },
              virt_text_pos = "inline",
            },
          }
        end

        -- (3) Optional: highlight region
        marks[#marks + 1] = {
          start_row = i - 1,
          start_col = 0,
          opts = {
            end_row = j, -- exclusive
            end_col = 0,
            hl_group = style.hl,
            hl_eol = true,
          },
        }

        -- (4) Hide closing ::: line (optional but usually nicer)
        marks[#marks + 1] = {
          start_row = j - 1,
          start_col = 0,
          opts = {
            virt_text = { { pad_to_winwidth(ctx, ""), style.hl } },
            virt_text_pos = "overlay",
            virt_text_hide = true,
          },
        }

        i = j + 1
      else
        i = i + 1
      end
    else
      i = i + 1
    end
  end

  return marks
end


return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = true,
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      latex = {
        enabled = false,
      },
    },
    config = function()
      require('render-markdown').setup({

        file_types = { "markdown", "quarto" },
        custom_handlers = {
          markdown = {
            extends = true, -- keep builtin rendering too
            parse = parse_quarto_callouts,
          },
        },
        completions = { blink = { enabled = true } },
        code = {
          language_pad = 2,
          min_width = 50,
          left_pad = 4,
          right_pad = 4,
          width = 'block',
          border = 'thick',
        },
        paragraph = {
          left_margin = 0,
          min_width = 70,
        },
        heading = {
          sign        = false,
          position    = "inline",

          width       = { "block", "block", "block", "block", "block", "block" },
          min_width   = 40,
          left_margin = { 0, 0, 0, 0, 0, 0 },
          left_pad    = { 0, 2, 4, 6, 8, 10 },
          right_pad   = { 0, 0, 0, 0, 0, 0 },

          -- Number H2+ only:
          -- H1: (no number)
          -- H2: "1. "
          -- H3: "1.1 "
          -- H4: "1.1.1 " ...
          icons       = function(ctx)
            if ctx.level == 1 then
              return ""
            end

            local sections = ctx.sections or {}
            if #sections <= 1 then
              return ""
            end

            -- drop the H1 component
            local trimmed = {}
            for i = 2, #sections do
              trimmed[#trimmed + 1] = sections[i]
            end

            local s = table.concat(trimmed, ".")
            if s == "" then
              return ""
            end

            -- add a trailing dot for H2 only (so it becomes "1. ")
            if ctx.level == 2 then
              return s .. ". "
            end

            return s .. " "
          end,
        },
      })
    end,
  },

  {
    "folke/snacks.nvim",
    enabled = false,
    ---@type snacks.Config
    opts = {
      image = {
        -- To find image path
        resolve = function(_, src)
          -- 1) Expand '~/…' ➜ '/home/you/…'
          src = src:gsub("^~", vim.env.HOME)
          local imgPaths = {
            coding = vim.fn.expand("~/personal/Notes/PROGRAMMESANA/Media/Images/"),
            notes = vim.fn.expand("~/personal/Notes/ObsidianNotes/Media/Images/")
          }

          if src:find("/") then return nil end

          for _, value in pairs(imgPaths) do
            local myPath = value .. src
            if (vim.uv.fs_stat(myPath)) then
              return myPath
            end
          end

          return nil
        end,
        doc = {
          max_width  = 80, -- cells (↓ from 80)
          max_height = 10, -- cells (↓ from 40)
        },
        convert = {
          magick = {
            math = { "-density", "384", "{src}[0]", "-trim" },
          },
        },
        -- debug = {
        --     request = true,
        --     placement = true,
        -- },
        math = {
          enabled = true, -- enable math expression rendering
          -- in the templates below, `${header}` comes from any section in your document,
          -- between a start/end header comment. Comment syntax is language-specific.
          -- * start comment: `// snacks: header start`
          -- * end comment:   `// snacks: header end`
          latex = {
            font_size = "large",
            packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
            tpl = [[
                            \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
                            \usepackage{${packages}}
                            \begin{document}
                            ${header}
                            { \${font_size} \selectfont
                            \color[HTML]{${color}}
                            ${content}}
                            \end{document}]],
          },
        },
      }
    },
  },

  {
    "obsidian-nvim/obsidian.nvim",
    enabled = false,
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = false,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      ui = { enable = false },
      completion = {
        nvim_cmp = false,
        blink = true,
      },
      attachments = {
        img_folder = "Media/Images"
      },
      workspaces = {
        {
          name = "Work",
          path = "~/personal/Notes/ObsidianNotes",
        },
        {
          name = "Coding",
          path = "~/personal/Notes/PROGRAMMESANA",
        },
      },
    },
  }
}
