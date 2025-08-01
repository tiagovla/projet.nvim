local popup = require("plenary.popup")
local Project = require("projet.project")
local Editor = { state = { win_id = nil }, on_validate = function(_) end, on_save = function(_) end }

function Editor.setup(events)
    Editor.on_validate = events.on_validate or Editor.on_validate
    Editor.on_save = events.on_save or Editor.on_save
end

function Editor.is_open()
    return Editor.state.win_id ~= nil and vim.api.nvim_win_is_valid(Editor.state.win_id)
end

function Editor.close()
    if Editor.is_open() then
        vim.api.nvim_win_close(Editor.state.win_id, true)
        Editor.state.win_id = nil
    end
end

function Editor.select(callback)
    local linenr = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
    local validation = Editor.on_validate({ line })
    if #validation > 0 then
        if validation[1].valid then
            local project = Project:new(validation[1].name, validation[1].path)
            callback(project)
        end
    end
    Editor.close()
end

local function create_window(options)
    options = options or {}
    local width = options.width or 100
    local height = options.height or 20
    local bufnr = vim.api.nvim_create_buf(false, true)
    local bordercharts = options.bordercharts or { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local win_id, win = popup.create(bufnr, {
        title = "Project Editor",
        highlight = "ProjetWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = bordercharts,
        borderhighlight = "WinSeparator",
        titlehighlight = "TelescopePromptTitle",
    })
    return {
        bufnr = bufnr,
        win_id = win_id,
    }
end

function Editor.toggle_edit_menu(options)
    if Editor.is_open() then
        vim.api.nvim_win_close(Editor.state.win_id, true)
        Editor.state.win_id = nil
        return
    end

    local window_info = create_window(options)

    local win_id = window_info.win_id
    local buf = window_info.bufnr

    Editor.state.win_id = win_id

    vim.api.nvim_win_set_option(win_id, "number", true)
    vim.api.nvim_buf_set_name(buf, "project-editor")
    vim.api.nvim_win_set_option(win_id, "filetype", "projet")
    vim.api.nvim_win_set_option(win_id, "buftype", "acwrite")
    vim.api.nvim_win_set_option(win_id, "bufhidden", "delete")
    vim.api.nvim_buf_set_lines(window_info.bufnr, 0, -1, false, options.content)

    for _, mapping in ipairs(options.mappings or {}) do
        local mode, key, action = unpack(mapping)
        vim.keymap.set(mode, key, action, { buffer = buf, silent = true })
    end

    local group = vim.api.nvim_create_augroup("Project", {})
    vim.api.nvim_create_autocmd({ "BufWriteCmd" }, {
        buffer = buf,
        group = group,
        callback = function()
            local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            Editor.on_save(content)
        end,
    })
    local ns_id = vim.api.nvim_create_namespace("ProjetHighlight")
    vim.api.nvim_set_hl(0, "ProjetRed", { link = "ErrorMsg" })
    vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
        buffer = buf,
        group = group,
        callback = function()
            local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            local validation = Editor.on_validate(content)
            local lines_to_highlight = {}
            for _, v in ipairs(validation) do
                if not v.valid then
                    table.insert(lines_to_highlight, v.line)
                end
            end
            vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
            for _, linenr in ipairs(lines_to_highlight) do
                vim.api.nvim_buf_add_highlight(0, ns_id, "ProjetRed", linenr - 1, 0, -1)
            end
        end,
    })
end

return Editor
