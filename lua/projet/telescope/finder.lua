local finders = require("telescope.finders")
local Path = require("plenary.path")
local strings = require("plenary.strings")
local entry_display = require("telescope.pickers.entry_display")

local function finder(opts, projects)
    local displayer = entry_display.create({
        separator = " ",
        items = {
            { width = 40 },
            { width = 40 },
        },
    })

    ---@param project Project
    local make_display = function(project)
        return displayer({
            { project.name },
            { project.path },
        })
    end

    return finders.new_table({
        results = projects,
        entry_maker = function(project)
            project.value = project.name
            project.ordinal = project.name
            project.display = make_display
            return project
        end,
    })
end

return finder
