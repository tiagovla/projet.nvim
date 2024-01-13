local ProjetDatabase = require("projet.db")
local ProjetConfig = require("projet.config")

local M = {}

---@param user_config table
function M.setup(user_config)
    ProjetConfig(user_config)
end

return M
