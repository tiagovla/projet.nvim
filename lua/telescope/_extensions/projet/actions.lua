local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local transform_mod = require("telescope.actions.mt").transform_mod

local M = {}

M.get_selected_project = function(prompt_bufnr)
    return actions_state.get_selected_entry(prompt_bufnr)
end

M.enhanced_select_action = function(action, enhancement)
    return function(prompt_bufnr, hidden_files)
        local project = M.get_selected_project(prompt_bufnr)
        actions._close(prompt_bufnr, true)
        vim.schedule(function()
            builtin[action]({
                cwd = project.path,
                hidden = hidden_files,
                attach_mappings = function()
                    local acts = { "select_default", "select_horizontal", "select_vertical", "select_tab" }
                    for _, act in ipairs(acts) do
                        if enhancement then
                            actions[act]:enhance({
                                post = function()
                                    enhancement(project)
                                end,
                            })
                        end
                    end
                    return true
                end,
            })
        end)
    end
end

return M
