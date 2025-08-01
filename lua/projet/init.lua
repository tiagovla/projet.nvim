local ProjetDatabase = require("projet.database")
local ProjetConfig = require("projet.config")
local Editor = require("projet.editor")
local utils = require("projet.utils")

local M = {}

---@param user_config table
function M.setup(user_config)
    ProjetConfig(user_config)
    M.db = ProjetDatabase:new(ProjetConfig.database_path)
end

function M.toggle_editor()
    local db_content = M.db:load():projects()
    local content = utils.parse_to_ui(db_content)
    local options = {
        content = content,
        on_select = function(ui_content) end,
        on_validate = function(ui_content)
            return utils.validate_content(ui_content)
        end,
        on_save = function(ui_content)
            local edited_content = utils.parse_to_db(ui_content)
            M.db:update(edited_content)
            M.db:save()
        end,
    }
    Editor.toggle_edit_menu(options)
end

return M
