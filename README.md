# projet.nvim

**A simple floating project manager for Neovim.**  
> _“Projet” means project in French — there is no typo!_

---

## ✨ Features

- 🪟 Floating buffer interface to manage and switch between projects
- 🔍 Telescope integration: `:Telescope projet`
- 🛠️ Customizable key mappings and behavior
- 📁 Automatically change the working directory (`:cd`) when selecting a project or your own action
- 🧩 Can be used standalone, with Telescope, or integrated into any other picker or UI

---

## 🚀 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "tiagovla/projet.nvim",
  config = function()
    require("projet").setup()
  end,
}
```

---

## 🔧 Configuration

Here are the default configuration options:

```lua
require("projet").setup({
  database_path = vim.fs.joinpath(vim.fn.stdpath("data"), "project.json"),
  mappings = {
    { "n", "q", require("projet.editor").close },
    { "n", "<ESC><ESC>", require("projet.editor").close },
    {
      "n",
      "<CR>",
      function()
        require("projet.editor").select(function(project)
          vim.cmd("cd " .. project.path)
        end)
      end,
    },
  },
})
```

You can override this by passing a custom config to `setup()`.

---

## 📚 Usage

### Open the floating editor

```lua
require("projet").toggle_editor()
```

Or bind it to a key in your config:

```lua
vim.keymap.set("n", "<leader>p", require("projet").toggle_editor)
```
The floating editor expects lines in the format:
```txt
super-secret ~/dev/super-secret
coolbeans ~/dev/coolbeans
```
That's it!

### Telescope Integration

Launch the Telescope picker with:

```vim
:Telescope projet
```

(Ensure you have Telescope installed and configured.)

---

## 📦 Data Format

Projects are saved as a simple JSON array at the configured `database_path`.  
Example:

```json
[
  { "name": "MyApp", "path": "/home/user/dev/myapp" },
  { "name": "Dotfiles", "path": "/home/user/.dotfiles" }
]
```

---

## 📝 License

MIT — feel free to use, modify, and share.
