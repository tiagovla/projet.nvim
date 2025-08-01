local has_telescope, telescope = pcall(require, "telescope")
local picker = require("telescope._extensions.projet.picker")

if not has_telescope then
    error("This plugins requires nvim-telescope/telescope.nvim")
end

return telescope.register_extension({
    exports = {
        projet = function(opts)
            local projects = require("projet").db:load():projects()
            picker(opts, projects)
        end,
    },
})
