local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local finder = require("projet.telescope.finder")
local conf = require("telescope.config").values

local picker = function(opts, projects)
    opts = opts or {}
    pickers
        .new(opts, {
            prompt_title = "Projects",
            finder = finder(opts, projects),
            -- previewer = conf.grep_previewer(opts),
            sorter = conf.generic_sorter(opts),
        })
        :find()
end

return picker
