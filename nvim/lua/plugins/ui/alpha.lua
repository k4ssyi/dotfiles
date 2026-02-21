return {
  "goolord/alpha-nvim",
  opts = function(_, opts)
    if vim.fn.executable("fastfetch") ~= 1 then return end

    local raw = vim.fn.system("fastfetch --pipe")
    if vim.v.shell_error ~= 0 then return end

    -- fastfetch output format:
    --   Logo lines (ASCII art)
    --   ESC[1G ESC[<up>A ESC[<col>C  (cursor reset to position info beside logo)
    --   Info lines (each prefixed with ESC[<col>C)
    local logo_text, up_n, col_n, info_text =
      raw:match("(.-)\27%[1G\27%[(%d+)A\27%[(%d+)C(.*)")

    if not logo_text then
      -- No logo detected, show text only
      local cleaned = raw:gsub("\27%[[%d;]*%a", "")
      local lines = {}
      for _, line in ipairs(vim.split(cleaned, "\n", { plain = true })) do
        if not line:match("^%s*$") then
          table.insert(lines, line)
        end
      end
      if #lines > 0 then opts.section.header.val = lines end
      return
    end

    up_n = tonumber(up_n)
    col_n = tonumber(col_n)

    local logo_lines = vim.split(logo_text, "\n", { plain = true, trimempty = true })

    -- Strip ANSI codes from info and split into lines
    info_text = info_text:gsub("\27%[[%d;]*%a", ""):gsub("\r", "")
    local info_lines = {}
    for _, line in ipairs(vim.split(info_text, "\n", { plain = true })) do
      if not line:match("^%s*$") then
        table.insert(info_lines, line)
      end
    end

    -- Combine logo and info side-by-side
    local info_start = #logo_lines - up_n
    local total = math.max(#logo_lines, info_start + #info_lines - 1)
    local result = {}

    for i = 1, total do
      local logo = logo_lines[i] or ""
      local info_idx = i - info_start + 1
      local info = (info_idx >= 1 and info_idx <= #info_lines) and info_lines[info_idx] or ""
      local pad = math.max(col_n - #logo, 2)
      local combined = (logo .. string.rep(" ", pad) .. info):gsub("%s+$", "")
      table.insert(result, combined)
    end

    if #result > 0 then
      opts.section.header.val = result
    end
  end,
}
