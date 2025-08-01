---@class ProjetConfig
---@field database_path string?
---@field mappings table?

local ProjetConfig = {}
ProjetConfig.__index = ProjetConfig

local Editor = require("projet.editor")

local config = {
    database_path = vim.fs.joinpath(vim.fn.stdpath("data"), "project.json"),
    mappings = {
        { "n", "q", Editor.close },
        { "n", "<ESC><ESC>", Editor.close },
        {
            "n",
            "<CR>",
            function()
                Editor.select(function(project)
                    vim.cmd("cd " .. project.path)
                end)
            end,
        },
    },
}

---@param user_config ProjetConfig
function ProjetConfig:__call(user_config)
    for k, v in pairs(user_config) do
        config[k] = v
    end
end

return setmetatable(config, ProjetConfig)
