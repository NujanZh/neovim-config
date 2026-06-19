# Installation and migration

This configuration is portable between macOS and Arch Linux. Recreate plugins
and Mason packages on each machine rather than copying platform-specific data
from `~/.local/share/nvim`.

## Requirements

- Neovim 0.12 or newer (`vim.pack` is used for plugins).
- Git.
- fzf and ripgrep (`rg`).
- A C++ compiler and Make for the documented build workflow.
- Mason's Unix utilities: curl or wget, unzip, tar, and gzip.

No Nerd Font or icon package is required.

Verify Neovim before continuing:

```sh
nvim --version
```

## macOS

Install Apple's command-line developer tools if they are not already present:

```sh
xcode-select --install
```

With Homebrew installed, install the editor and search tools:

```sh
brew install neovim fzf ripgrep
```

The Apple command-line tools provide Git, Clang, and Make. clangd and CodeLLDB
will be installed through Mason in a later step.

If a project uses CMake, install it separately:

```sh
brew install cmake
```

## Arch Linux

Update the system and install the required packages:

```sh
sudo pacman -Syu
sudo pacman -S --needed neovim git curl unzip tar gzip fzf ripgrep clang make
```

clangd and CodeLLDB will still be installed through Mason so their executable
locations are consistent with the Neovim configuration.

For CMake projects, also install:

```sh
sudo pacman -S --needed cmake
```

## Place the configuration

Neovim uses `~/.config/nvim` on both systems. Back up an existing configuration
before replacing it:

```sh
mv ~/.config/nvim ~/.config/nvim.backup
```

If this configuration is stored in a Git repository:

```sh
git clone <repository-url> ~/.config/nvim
```

Alternatively, copy an existing checkout:

```sh
mkdir -p ~/.config
cp -R /path/to/nvim ~/.config/nvim
```

Keep `nvim-pack-lock.json` with the configuration. It records portable plugin
revisions and allows `vim.pack` to reproduce the same plugin versions.

## First launch

Start Neovim:

```sh
nvim
```

On the first launch, `vim.pack` installs the plugins declared in
`lua/plugins.lua`. Internet access and Git are required.

Then install the two external C++ tools from inside Neovim:

```vim
:MasonInstall clangd codelldb
```

Do not copy Mason's installed packages between macOS and Linux; CodeLLDB and
clangd contain platform-specific binaries.

Restart Neovim after installation and run:

```vim
:checkhealth mason
:checkhealth vim.lsp
:checkhealth fzf-lua
```

## Open a C++ project

Start Neovim from the project root so search, Make, debugging, and project
bookmarks share the expected working directory:

```sh
cd /path/to/project
nvim .
```

Provide `compile_commands.json` or `compile_flags.txt` for accurate clangd
results. A CMake project can generate a compilation database with:

```sh
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -s build/compile_commands.json compile_commands.json
```

The symbolic link is needed because clangd searches parent directories of a
source file by default, while a typical `build/` directory is below the source
tree. Do not create the link if the project already puts the database at its
root or configures clangd another way.

## Updating

Update plugins interactively from Neovim:

```vim
:packupdate
```

Review the updates before accepting them. `nvim-pack-lock.json` is updated when
plugin revisions change.

Open `:Mason` to inspect or update clangd and CodeLLDB. Update system packages
with Homebrew or pacman separately.

## Moving between machines

Copy or clone only the configuration directory:

```text
~/.config/nvim
```

Reinstall system dependencies and run `:MasonInstall clangd codelldb` on the
new machine. Do not transfer these generated directories between operating
systems:

```text
~/.local/share/nvim
~/.local/state/nvim
~/.cache/nvim
```

They contain downloaded plugins, platform-specific tools, logs, state, and
caches that can be recreated.

## Troubleshooting

- `clangd` does not attach: run `:Mason`, confirm clangd is installed, then run
  `:checkhealth vim.lsp` inside a C++ buffer.
- clangd shows incorrect includes or flags: generate `compile_commands.json`
  and verify the project root shown by `:checkhealth vim.lsp`.
- Search does not start: verify `fzf --version` and `rg --version`, then run
  `:checkhealth fzf-lua`.
- Debugging does not start: compile an executable with `-g -O0`, confirm
  CodeLLDB is installed in `:Mason`, and enter the executable path at the
  prompt.
- Mason installation fails: run `:checkhealth mason` and verify Git, curl,
  unzip, tar, and gzip are available.
