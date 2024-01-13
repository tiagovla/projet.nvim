local picker = require("projet.telescope.picker")

local M = {
    prompt = function(opts, projects)
        picker(opts, projects)
    end,
}

return M
