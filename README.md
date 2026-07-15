# Minimal Neovim C++ configuration

This is a small Neovim 0.12 configuration for C and C++ development. It uses
Neovim's built-in features where practical and adds focused plugins only for
navigation, debugging, and Git awareness.

The leader key is `Space`. Formatting is manual, build commands belong to the
project, and there is no permanent file tree or IDE-style debug UI.

See [INSTALL.md](INSTALL.md) to install this configuration on macOS or Arch
Linux.

## Main features

- Native Neovim LSP and completion with Mason-managed clangd.
- Diagnostics, semantic highlighting, symbol navigation, rename, and actions.
- Project-specific formatting through `.clang-format`.
- Two-space indentation for C/C++ buffers.
- File and text search with fzf-lua, fzf, and ripgrep.
- Persistent per-Git-project file bookmarks with Grapple.
- Editable directory buffers with Oil.
- Makefile builds and compiler errors through `:make` and quickfix.
- C/C++ debugging with nvim-dap and Mason-managed CodeLLDB.
- Git hunk signs, navigation, preview, staging, and blame with Gitsigns.
- Everforest dark/medium theme with terminal transparency and no font dependency.

## Configuration layout

| Path | Purpose |
| --- | --- |
| `init.lua` | Sets the leader and loads all modules. |
| `lua/configs.lua` | General options and global keymaps. |
| `lua/autocmds.lua` | General autocommands. |
| `lua/plugins.lua` | Plugins installed and locked with `vim.pack`. |
| `lua/lsp.lua` | Enables clangd and native LSP completion. |
| `lsp/clangd.lua` | clangd project detection and C/C++ actions. |
| `lua/debugger.lua` | CodeLLDB adapter, launch configuration, and mappings. |
| `lua/git_changes.lua` | Gitsigns configuration and buffer-local mappings. |
| `nvim-pack-lock.json` | Portable plugin revisions; do not edit manually. |

## C++ project requirements

clangd works best when a project provides one of:

- `compile_commands.json` — preferred for real projects.
- `compile_flags.txt` — useful for small projects with uniform flags.

Without compilation metadata, clangd guesses the command and may not know the
correct standard, macros, or include paths.

Formatting uses the nearest `.clang-format` found while searching toward the
filesystem root. Without one, clang-format falls back to LLVM style. For Google
C++ style, use:

```yaml
BasedOnStyle: Google
ColumnLimit: 100
```

Neovim also sets C/C++ buffers to two-space indentation while editing. This is
separate from `.clang-format`; keep both at the same width if you want `grf` to
preserve the indentation you typed.

## Theme and transparency

Everforest uses its dark, medium-contrast palette. Transparent background level
2 leaves the main editor and additional UI surfaces transparent, while Ghostty
controls the actual terminal opacity and background image or colour.

The relevant settings are in `lua/plugins.lua`:

```lua
vim.o.background = 'dark'
vim.g.everforest_background = 'medium'
vim.g.everforest_transparent_background = 2
vim.g.everforest_float_style = 'blend'
```

If floating windows blend too much into the editor, change the transparency
level to `1` or change the float style from `blend` to `bright`.

## Keymaps

### LSP and C++

These mappings are available in buffers where clangd is attached.

| Mapping | Action |
| --- | --- |
| `K` | Show hover documentation. |
| `Ctrl-]` | Go to definition; `Ctrl-t` returns. |
| `grr` | Find references. |
| `grn` | Rename a symbol. |
| `gra` | Show code actions. |
| `gri` | Go to implementation. |
| `gO` | Show document symbols. |
| `grf` | Format with clangd/clang-format. |
| `grh` | Switch between corresponding source and header files. |
| `Ctrl-y` | Accept the selected completion item. |
| `Ctrl-s` in insert mode | Show signature help. |

### Search and navigation

| Mapping | Action |
| --- | --- |
| `Space f f` | Find project files. |
| `Space f g` | Search project text with ripgrep. |
| `Space f b` | Switch between open buffers. |
| `Space f r` | Resume the previous fzf-lua picker and query. |
| `Space h a` | Add or remove the current file from Grapple. |
| `Space h m` | Manage the current project's tagged files. |
| `Space h 1` … `Space h 4` | Jump to tagged file 1 through 4. |
| `-` | Open the current file's parent directory with Oil. |

Useful Oil mappings are `Enter` to open an entry, `-` to move upward, `g.` to
toggle hidden files, and `g?` to show help. Editing names or lines stages
filesystem operations; `:write` reviews and applies them.

### Builds and quickfix

| Mapping | Action |
| --- | --- |
| `Space b q` | Open build errors in quickfix. |
| `Space b c` | Close quickfix. |
| `]q` / `[q` | Next / previous quickfix entry. |
| `]Q` / `[Q` | Last / first quickfix entry. |

Builds are run explicitly from an external terminal. Neovim retains its
quickfix controls for lists populated manually or by other commands.

### Debugging

Compile the target with debug information and little or no optimization:

```sh
clang++ -std=c++20 -g -O0 main.cpp -o app
```

`app` is the executable file created by `-o app`. When debugging starts, enter
the executable's path—not the source file or containing directory.

| Mapping | Action |
| --- | --- |
| `Space d b` | Toggle a breakpoint. |
| `Space d c` | Launch or continue. |
| `Space d n` | Step over. |
| `Space d i` | Step into. |
| `Space d o` | Step out. |
| `Space d r` | Toggle the debug REPL. |
| `Space d t` | Terminate the session. |

Terminating does not close an existing output split. A typical cleanup is:

```text
Space d t   terminate debugging
Ctrl-w j    focus the output split below
Ctrl-w c    close the focused output window
```

Use `Ctrl-w w` to cycle windows if the output is not directly below the source.

### Git changes

A hunk is one contiguous block of changed lines. These mappings are
buffer-local and appear only when Gitsigns attaches to a tracked file.

| Mapping | Action |
| --- | --- |
| `]h` / `[h` | Next / previous changed hunk. |
| `Space g p` | Preview the current hunk. |
| `Space g s` | Stage or unstage the current hunk. |
| `Space g b` | Show blame information for the current line. |

There is intentionally no reset-hunk mapping because resetting discards local
changes without confirmation.

## Quick verification

Open a C++ file in a project and run:

```vim
:checkhealth vim.lsp
:checkhealth mason
:checkhealth fzf-lua
```

clangd should be an active client with no missing-configuration warnings. For
mapping discovery, use commands such as `:verbose nmap grf` or
`:verbose nmap <Space>ff`.

## Design notes

- Only clangd is enabled; unrelated language servers are not installed or
  enabled implicitly.
- Native LSP completion is used instead of a completion framework.
- Built-in C++ syntax plus clangd semantic tokens are used instead of the
  archived original nvim-treesitter plugin.
- Formatting is explicit with `grf`; format-on-save is disabled.
- CMake integration and debug UI plugins remain optional and project-dependent.
