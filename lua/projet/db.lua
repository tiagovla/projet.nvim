---@class ProjetDatabase
---@field file_name string
---@field _content Project[]

local ProjetDatabase = {}
ProjetDatabase.__index = ProjetDatabase

---@param filename string
function ProjetDatabase:new(filename)
    return setmetatable({ file_name = filename, _content = {} }, self)
end

---@return ProjetDatabase
function ProjetDatabase:load()
    local ok, file_content, json_content
    ok, file_content = pcall(vim.fn.readfile, self.file_name)
    if not ok then
        return self
    end
    ok, json_content = pcall(vim.fn.json_decode, file_content)
    if not ok then
        vim.print("Error decoding json file: " .. self.file_name)
        return self
    end
    self._projects = json_content
    return self
end

function ProjetDatabase:save()
    local ok, json_content = pcall(vim.fn.json_encode, self._projects)
    if ok then
        vim.fn.writefile({ json_content }, self.file_name)
    else
        vim.print("Error encoding json file: " .. self.file_name)
    end
end

---@param projects Project[]
function ProjetDatabase:update(projects)
    self._projects = projects
end

function ProjetDatabase:content()
    return self._projects
end

---@param key string
---@param value string
---@param reorder boolean
---@return Project?
function ProjetDatabase:get_element_and_update_order(key, value, reorder)
    for i, _project in ipairs(self._projects) do
        if _project[key] == value then
            if reorder or true then
                table.remove(self._projects, i)
                table.insert(self._projects, 1, _project)
            end
            return _project
        end
    end
end

function ProjetDatabase:reset()
    self._projects = {}
end

return ProjetDatabase
