local _actions = require("projet.telescope.actions")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finder = require("projet.telescope.finder")
local pickers = require("telescope.pickers")

local function cd_on_select(project)
    vim.cmd("cd " .. project.path)
end

local picker = function(opts, projects)
    opts = opts or {}
    pickers
        .new(opts, {
            prompt_title = "Projects",
            finder = finder(opts, projects),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                map("i", "<s-cr>", _actions.enhanced_select_action("live_grep", cd_on_select))
                actions.select_default:replace(_actions.enhanced_select_action("find_files", cd_on_select))
                return true
            end,
        })
        :find()
end

return picker
