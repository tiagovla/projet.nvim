---@class ProjectConfig
---@field on_enter fun()?
---@field database_path string?

local ProjetConfig = {}
ProjetConfig.__index = ProjetConfig

local config = {
    on_enter = function() end,
    database_path = vim.fs.joinpath(vim.fn.stdpath("data"), "project.json"),
}

---@param user_config ProjectConfig
function ProjetConfig:__call(user_config)
    for k, v in pairs(user_config) do
        config[k] = v
    end
end

return setmetatable(config, ProjetConfig)
