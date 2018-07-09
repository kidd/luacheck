local CODE = "904"

local function is_white_line(line)
  return line:find("^ *$")
end


local function is_return_line(line)
  return line:find("^%s*return ")
end


local function is_allowed_line(line)
  local allowed_patterns = {"function", "if", "else", "elsif", "log", "then"}
  for i, v in ipairs(allowed_patterns) do
    if line:find(v) then
      return true
    end
  end

  return false
end


local function sanitize(line)
  return line:gsub("%-%-.*$", "")
end


local function detect_no_empty_line_before_return(chstate)
  local openning_paragraph = true
  local buffer = {}
  for line_number, line in ipairs(chstate.source_lines) do
    line = sanitize(line)
    buffer[1], buffer[2], buffer[3], buffer[4] = line, buffer[1], buffer[2], nil
    if buffer[3] and
      is_return_line(buffer[1]) and
      not is_white_line(buffer[2]) and
      not is_allowed_line(buffer[2])
    then
      table.insert(chstate.warnings, {code = CODE,
        line = line_number,
        column = 0,
        end_column = 1})
    end
  end
end

return detect_no_empty_line_before_return
