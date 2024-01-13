---@class Project
---@field name string
---@field path string

local Project = {}
Project.__index = Project

function Project:new(name, path)
    return setmetatable({ name = name, path = path }, self)
end

---@return string
function Project:str()
    return self.name .. " (" .. self.path .. ")"
end

return Project
