local Utils = {}

---@param db_content string
---@return table
function Utils.parse_to_ui(db_content)
    local content = {}
    for k, v in pairs(db_content) do
        content[k] = v.name .. " " .. v.path
    end
    return content
end

---@param ui_content table
---@return table
function Utils.parse_to_db(ui_content)
    local content = {}
    for n, v in pairs(ui_content) do
        if v ~= "" then
            local project, pwd = v:match("^(%S+)%s+(.+)$")
            table.insert(content, { name = project, path = pwd, line = n })
        end
    end
    return content
end

---@param ui_content table
---@return table
function Utils.validate_content(ui_content)
    local ok, result = pcall(Utils.parse_to_db, ui_content)
    if not ok then
        vim.notify("Error parsing content: " .. result, vim.log.levels.ERROR)
        return nil
    end
    local function folder_exists(path)
        local expanded = vim.fn.expand(path)
        local stat = vim.loop.fs_stat(expanded)
        return stat and stat.type == "directory"
    end
    local valid_content = {}
    for _, v in pairs(result) do
        table.insert(valid_content, { line = v.line, valid = folder_exists(v.path), path = v.path, name = v.name })
    end
    return valid_content
end

---@param str string
---@return number
function Utils.get_number_of_spaces(str)
    return str:match("^%s*()") - 1
end

return Utils
