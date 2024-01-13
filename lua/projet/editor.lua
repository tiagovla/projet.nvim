local popup = require("plenary.popup")
local Editor = {}

local state = { win_id = nil }

local function create_window(options)
    options = options or {}
    local width = options.width or 60
    local height = options.height or 10
    local bufnr = vim.api.nvim_create_buf(false, true)
    local bordercharts = options.bordercharts or { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local win_id, win = popup.create(bufnr, {
        title = "Project",
        highlight = "ProjectWindow",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = bordercharts,
    })
    vim.api.nvim_win_set_var(win.border.win_id, "winhl", "WinSeparator:ProjectBorder")
    return {
        bufnr = bufnr,
        win_id = win_id,
    }
end

function Editor.toggle_edit_menu(options)
    if state.win_id ~= nil and vim.api.nvim_win_is_valid(state.win_id) then
        vim.api.nvim_win_close(state.win_id, true)
        state.win_id = nil
        return
    end

    local window_info = create_window(options)
    local win_id = window_info.win_id
    state.win_id = win_id
    local buf = window_info.bufnr
    vim.api.nvim_win_set_var(win_id, "number", true)
    vim.api.nvim_win_set_var(win_id, "filetype", "project")
    -- vim.api.nvim_win_set_var(win_id, "buftype", "acwrite")
    -- vim.api.nvim_win_set_var(win_id, "bufhidden", "delete")
    vim.api.nvim_buf_set_lines(window_info.bufnr, 0, -1, false, options.content)
    vim.keymap.set("n", "q", function()
        vim.api.nvim_win_close(win_id, true)
        local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        options.on_quit(content)
        vim.print(content)
    end, { buffer = buf })
    local group = vim.api.nvim_create_augroup("Project", {})
    vim.api.nvim_create_autocmd({ "BufWriteCmd", "BufWritePost", "BufLeave" }, {
        buffer = buf,
        group = group,
        callback = function()
            local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            options.on_quit(content)
            vim.api.nvim_win_close(win_id, true)
            state.win_id = nil
        end,
    })
end

return Editor
