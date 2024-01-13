local U = {}

function U.parse_to_ui(db_content)
    local content = {}
    for k, v in pairs(db_content) do
        content[k] = v.name .. " " .. v.path
    end
    return content
end

function U.parse_to_db(ui_content)
    local content = {}
    for _, v in pairs(ui_content) do
        if v ~= "" then
            local project, pwd = v:match("^(%S+)%s+(.+)$")
            table.insert(content, { name = project, path = pwd })
        end
    end
    return content
end

return U
