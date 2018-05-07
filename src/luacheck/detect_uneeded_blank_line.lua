local CODE = "902"

local function is_white_line(line)
  return line:find("^$")
end


local err_check_patterns = { "if err then",
                             "if not ok then",
                             "if error then" }

local function detect_uneeded_blank_line(chstate)
  local openning_paragraph = true

  for line_number, line in ipairs(chstate.source_lines) do
    if is_white_line(line) then
      openning_paragraph = true
    elseif openning_paragraph then
      openning_paragraph = false

      for i, pat in ipairs(err_check_patterns) do
        local match_start, match_end = line:find(pat)
        if match_start then
          table.insert(chstate.warnings, {code = CODE,
                                          line = line_number,
                                          column = match_start,
                                          end_column = match_end})
        end
      end
    else
      openning_paragraph = false
    end
  end
end

return detect_uneeded_blank_line
