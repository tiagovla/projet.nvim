local Utils = {}

function Utils.parse_to_ui(db_content)
    local content = {}
    for k, v in pairs(db_content) do
        content[k] = v.name .. " " .. v.path
    end
    return content
end

function Utils.parse_to_db(ui_content)
    local content = {}
    for _, v in pairs(ui_content) do
        if v ~= "" then
            local project, pwd = v:match("^(%S+)%s+(.+)$")
            table.insert(content, { name = project, path = pwd })
        end
    end
    return content
end

---@param str string
---@return number
function Utils.get_number_of_spaces(str)
    return str:match("^%s*()") - 1
end

return Utils
