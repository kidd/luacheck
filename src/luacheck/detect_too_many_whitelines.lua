local MAX_WL_ALLOWED = 3
local CODE = "901"

local function is_white_line(line)
  return line:find("^$")
end

local function detect_too_many_whitelines(chstate)
  local wl_in_a_row = 0
  for line_number, line in ipairs(chstate.source_lines) do
    if is_white_line(line) then
      wl_in_a_row = wl_in_a_row + 1
    else
      wl_in_a_row = 0
    end

    if wl_in_a_row == MAX_WL_ALLOWED then
      table.insert(chstate.warnings, {code = CODE,
                                      line = line_number,
                                      column = 0,
                                      end_column = 1})
    end
  end
end

return detect_too_many_whitelines
