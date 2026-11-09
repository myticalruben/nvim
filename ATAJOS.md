# Atajos de Neovim

Referencia de los atajos activos en esta config. El **leader es la barra espaciadora** y la mayoría son de modo normal (`n`); cuando un atajo funciona en más de un modo se indica entre paréntesis: `x` visual, `v` visual/selección, `i` insertar, `o` operador, `t` terminal, `c` línea de comandos.

La primera sección son los atajos propios (`config/lua/config/maps.lua`). El resto sale de LazyVim y sus plugins; los textos en inglés son el `desc` original, que es lo que busca `<leader>sk`.

## Tus atajos

| Atajo | Qué hace |
| --- | --- |
| `<Space>` | Salta a la ventana siguiente (`<C-w>w`). Ojo: el leader también es espacio, así que `espacio + tecla` sigue siendo leader; espacio solo cambia de ventana. |
| `dw` | Borra hacia atrás hasta el inicio de la palabra (`vb"_d`). No borra hacia delante, y `3dw` borra tres palabras hacia atrás. |
| `dl` | Duplica la línea actual (`:t.`). Pisa el `dl` estándar de borrar el carácter de la derecha. |
| `ss` | Split horizontal y pasa a la ventana nueva. |
| `sv` | Split vertical y pasa a la ventana nueva. |
| `sh` `sk` `sj` `sl` | Moverse a la ventana izquierda / arriba / abajo / derecha. |
| `jk` (i) | Escape en modo insertar. |
| `gh` | Guardar (`:w`). Pisa el `gh` estándar (modo selección). |
| `el` | Salir (`:q`). Falla si hay cambios sin guardar. |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Moverse entre ventanas; con tmux, también entre paneles (`vim-tmux-navigator`). |
| `<C-\>` | Panel anterior de tmux. |
| `<leader>uR` | Reinicia nvim y recarga la config conservando la sesión (también `:NvimReset`). |

## Accesos directos

| Atajo | Qué hace |
| --- | --- |
| `<leader>,` | Switch Buffer |
| `<leader>-` | Split Window Below |
| `<leader>.` | Toggle Scratch Buffer |
| `<leader>/` | Grep (Root Dir) |
| `<leader>:` | Command History |
| `<leader><space>` | Find Files (Root Dir) |
| `<leader>?` | Buffer Keymaps (which-key) |
| `<leader>E` | Explorer NeoTree (cwd) |
| `<leader>K` | Keywordprg |
| `<leader>L` | LazyVim Changelog |
| `<leader>S` | Select Scratch Buffer |
| `<leader>` + `` ` `` | Switch to Other Buffer |
| `<leader>e` | Explorer NeoTree (Root Dir) |
| `<leader>l` | Lazy |
| `<leader>n` | Notification History |
| `<leader>\|` | Split Window Right |

## Pestañas

| Atajo | Qué hace |
| --- | --- |
| `<leader><Tab><Tab>` | New Tab |
| `<leader><Tab>[` | Previous Tab |
| `<leader><Tab>]` | Next Tab |
| `<leader><Tab>d` | Close Tab |
| `<leader><Tab>f` | First Tab |
| `<leader><Tab>l` | Last Tab |
| `<leader><Tab>o` | Close Other Tabs |

## Buffers

| Atajo | Qué hace |
| --- | --- |
| `<leader>bD` | Delete Buffer and Window |
| `<leader>bP` | Delete Non-Pinned Buffers |
| `<leader>bb` | Switch to Other Buffer |
| `<leader>bd` | Delete Buffer |
| `<leader>be` | Buffer Explorer |
| `<leader>bl` | Delete Buffers to the Left |
| `<leader>bo` | Delete Other Buffers |
| `<leader>bp` | Toggle Pin |
| `<leader>br` | Delete Buffers to the Right |

## Código (LSP)

| Atajo | Qué hace |
| --- | --- |
| `<leader>cA` | Source Action |
| `<leader>cF` (n, x) | Format Injected Langs |
| `<leader>cS` | LSP references/definitions/... (Trouble) |
| `<leader>ca` (n, x) | Code Action |
| `<leader>cd` | Line Diagnostics |
| `<leader>cf` (n, x) | Format |
| `<leader>cl` | Lsp Info |
| `<leader>co` | Organize Imports |
| `<leader>cr` | Rename |
| `<leader>cs` | Toggle Outline |
| `<leader>cv` | Select VirtualEnv |

## Depuración (DAP)

| Atajo | Qué hace |
| --- | --- |
| `<leader>dB` | Breakpoint Condition |
| `<leader>dC` | Run to Cursor |
| `<leader>dO` | Step Over |
| `<leader>dP` | Pause |
| `<leader>dPc` | Debug Class |
| `<leader>dPt` | Debug Method |
| `<leader>da` | Run with Args |
| `<leader>db` | Toggle Breakpoint |
| `<leader>dc` | Run/Continue |
| `<leader>de` (n, x) | Eval |
| `<leader>dg` | Go to Line (No Execute) |
| `<leader>di` | Step Into |
| `<leader>dj` | Down |
| `<leader>dk` | Up |
| `<leader>dl` | Run Last |
| `<leader>do` | Step Out |
| `<leader>dph` | Toggle Profiler Highlights |
| `<leader>dpp` | Toggle Profiler |
| `<leader>dps` | Profiler Scratch Buffer |
| `<leader>dr` | Toggle REPL |
| `<leader>ds` | Session |
| `<leader>dt` | Terminate |
| `<leader>du` | Dap UI |
| `<leader>dw` | Widgets |

## Archivos

| Atajo | Qué hace |
| --- | --- |
| `<leader>fB` | Buffers (all) |
| `<leader>fE` | Explorer NeoTree (cwd) |
| `<leader>fF` | Find Files (cwd) |
| `<leader>fR` | Recent (cwd) |
| `<leader>fT` | Terminal (cwd) |
| `<leader>fb` | Buffers |
| `<leader>fc` | Find Config File |
| `<leader>fe` | Explorer NeoTree (Root Dir) |
| `<leader>ff` | Find Files (Root Dir) |
| `<leader>fg` | Find Files (git-files) |
| `<leader>fn` | New File |
| `<leader>fr` | Recent |
| `<leader>ft` | Terminal (Root Dir) |

## Git

| Atajo | Qué hace |
| --- | --- |
| `<leader>gB` (n, x) | Git Browse (open) |
| `<leader>gL` | Git Log (cwd) |
| `<leader>gS` | Git Stash |
| `<leader>gY` (n, x) | Git Browse (copy) |
| `<leader>gb` | Git Blame Line |
| `<leader>gc` | Commits |
| `<leader>ge` | Git Explorer |
| `<leader>gf` | Git Current File History |
| `<leader>gl` | Commits |
| `<leader>gs` | Status |

## Salir y sesiones

| Atajo | Qué hace |
| --- | --- |
| `<leader>qS` | Select Session |
| `<leader>qd` | Don't Save Current Session |
| `<leader>ql` | Restore Last Session |
| `<leader>qq` | Quit All |
| `<leader>qs` | Restore Session |

## Buscar

| Atajo | Qué hace |
| --- | --- |
| `<leader>s"` | Registers |
| `<leader>s/` | Search History |
| `<leader>sC` | Commands |
| `<leader>sD` | Buffer Diagnostics |
| `<leader>sG` | Grep (cwd) |
| `<leader>sH` | Search Highlight Groups |
| `<leader>sM` | Man Pages |
| `<leader>sR` | Resume |
| `<leader>sS` | Goto Symbol (Workspace) |
| `<leader>sT` | Todo/Fix/Fixme |
| `<leader>sW` | Word (cwd) |
| `<leader>sW` (x) | Selection (cwd) |
| `<leader>sa` | Auto Commands |
| `<leader>sb` | Buffer Lines |
| `<leader>sc` | Command History |
| `<leader>sd` | Diagnostics |
| `<leader>sg` | Grep (Root Dir) |
| `<leader>sh` | Help Pages |
| `<leader>sj` | Jumplist |
| `<leader>sk` | Key Maps |
| `<leader>sl` | Location List |
| `<leader>sm` | Jump to Mark |
| `<leader>sna` | Noice All |
| `<leader>snd` | Dismiss All |
| `<leader>snh` | Noice History |
| `<leader>snl` | Noice Last Message |
| `<leader>snt` | Noice Picker (Telescope/FzfLua) |
| `<leader>so` | Options |
| `<leader>sq` | Quickfix List |
| `<leader>sr` (n, x) | Search and Replace |
| `<leader>ss` | Goto Symbol |
| `<leader>st` | Todo |
| `<leader>sw` | Word (Root Dir) |
| `<leader>sw` (x) | Selection (Root Dir) |

## Tests

| Atajo | Qué hace |
| --- | --- |
| `<leader>tO` | Toggle Output Panel (Neotest) |
| `<leader>tS` | Stop (Neotest) |
| `<leader>tT` | Run All Test Files (Neotest) |
| `<leader>ta` | Attach to Test (Neotest) |
| `<leader>td` | Debug Nearest |
| `<leader>tl` | Run Last (Neotest) |
| `<leader>to` | Show Output (Neotest) |
| `<leader>tr` | Run Nearest (Neotest) |
| `<leader>ts` | Toggle Summary (Neotest) |
| `<leader>tt` | Run File (Neotest) |
| `<leader>tw` | Toggle Watch (Neotest) |

## UI y editor

| Atajo | Qué hace |
| --- | --- |
| `<leader>uA` | Toggle Tabline |
| `<leader>uC` | Colorscheme with Preview |
| `<leader>uD` | Toggle Dimming |
| `<leader>uF` | Toggle Auto Format (Buffer) |
| `<leader>uG` | Toggle Git Signs |
| `<leader>uI` | Inspect Tree |
| `<leader>uL` | Toggle Relative Number |
| `<leader>uS` | Toggle Smooth Scroll |
| `<leader>uT` | Toggle Treesitter Highlight |
| `<leader>uZ` | Toggle Zoom Mode |
| `<leader>ua` | Toggle Animations |
| `<leader>ub` | Toggle Dark Background |
| `<leader>uc` | Toggle Conceal Level |
| `<leader>ud` | Toggle Diagnostics |
| `<leader>uf` | Toggle Auto Format (Global) |
| `<leader>ug` | Toggle Indent Guides |
| `<leader>uh` | Toggle Inlay Hints |
| `<leader>ui` | Inspect Pos |
| `<leader>ul` | Toggle Line Numbers |
| `<leader>un` | Dismiss All Notifications |
| `<leader>ur` | Redraw / Clear hlsearch / Diff Update |
| `<leader>us` | Toggle Spelling |
| `<leader>uw` | Toggle Wrap |
| `<leader>uz` | Toggle Zen Mode |

## Ventanas

| Atajo | Qué hace |
| --- | --- |
| `<leader>wd` | Delete Window |
| `<leader>wm` | Toggle Zoom Mode |

## Diagnósticos (Trouble)

| Atajo | Qué hace |
| --- | --- |
| `<leader>xL` | Location List (Trouble) |
| `<leader>xQ` | Quickfix List (Trouble) |
| `<leader>xT` | Todo/Fix/Fixme (Trouble) |
| `<leader>xX` | Buffer Diagnostics (Trouble) |
| `<leader>xl` | Location List |
| `<leader>xq` | Quickfix List |
| `<leader>xt` | Todo (Trouble) |
| `<leader>xx` | Diagnostics (Trouble) |

## Sin leader (global)

Atajos que no empiezan por leader. Los de `[` y `]` navegan por listas, diagnósticos, todos y buffers.

| Atajo | Qué hace |
| --- | --- |
| `<C-/>` (n, t) | Terminal (Root Dir) |
| `<C-Down>` | Decrease Window Height |
| `<C-Left>` | Decrease Window Width |
| `<C-Right>` | Increase Window Width |
| `<C-Up>` | Increase Window Height |
| `<C-W><space>` | Window Hydra Mode (which-key) |
| `<C-W><C-D>` | Show diagnostics under the cursor |
| `<C-W>d` | Show diagnostics under the cursor |
| `<Down>` (n, x) | Down |
| `<S-CR>` (c) | Redirect Cmdline |
| `<Up>` (n, x) | Up |
| `H` | Prev Buffer |
| `L` | Next Buffer |
| `N` (n, x, o) | Prev Search Result |
| `[<space>` | Add empty line above cursor |
| `[B` | Move buffer prev |
| `[D` | Jump to the first diagnostic in the current buffer |
| `[N` (x) | Select previous sibling node |
| `[b` | Prev Buffer |
| `[d` | Prev Diagnostic |
| `[e` | Prev Error |
| `[n` (x) | Select previous node |
| `[q` | Previous Trouble/Quickfix Item |
| `[t` | Previous Todo Comment |
| `[w` | Prev Warning |
| `]<space>` | Add empty line below cursor |
| `]B` | Move buffer next |
| `]D` | Jump to the last diagnostic in the current buffer |
| `]N` (x) | Select next sibling node |
| `]b` | Next Buffer |
| `]d` | Next Diagnostic |
| `]e` | Next Error |
| `]n` (x) | Select next node |
| `]q` | Next Trouble/Quickfix Item |
| `]t` | Next Todo Comment |
| `]w` | Next Warning |
| `an` (x, o) | Select parent (outer) node |
| `gc` (n, x) | Toggle comment |
| `gc` (o) | Comment textobject |
| `gcO` | Add Comment Above |
| `gcc` | Toggle comment line |
| `gco` | Add Comment Below |
| `gx` (n, x) | Opens filepath or URI under cursor with the system handler (file explorer, web browser, …) |
| `in` (x, o) | Select child (inner) node |
| `j` (n, x) | Down |
| `k` (n, x) | Up |
| `n` (n, x, o) | Next Search Result |

## Insertar (y atajos que también valen ahí)

| Atajo | Qué hace |
| --- | --- |
| `<C-B>` (n, i) | Scroll Backward |
| `<C-F>` (n, i) | Scroll Forward |
| `<C-S>` (n, x, i) | Save File |
| `<Esc>` (n, i) | Escape and Clear hlsearch |
| `<M-j>` (n, v, i) | Move Down |
| `<M-k>` (n, v, i) | Move Up |

## LSP por buffer

Solo existen con un servidor de lenguaje enganchado, así que dependen del devShell del proyecto. Las acciones con leader (`<leader>ca`, `<leader>cr`, ...) están en su grupo; aquí van los que no llevan leader. `<leader>cv` (venv) está en Código y solo aparece en proyectos Python.

| Atajo | Qué hace |
| --- | --- |
| `<C-K>` (i) | Signature Help |
| `<M-n>` | Next Reference |
| `<M-p>` | Prev Reference |
| `K` | Hover |
| `[[` | Prev Reference |
| `]]` | Next Reference |
| `gD` | Goto Declaration |
| `gI` | Goto Implementation |
| `gK` | Signature Help |
| `gd` | Goto Definition |
| `gr` | References |
| `gy` | Goto T[y]pe Definition |

## Notas

- **Flash desactivado** (`folke/flash.nvim`): no están `s`, `S`, `r` en operador, `R` ni `<C-space>` de LazyVim. `s` vuelve a ser el substituto normal.

- El picker es **Telescope**, y `find_files`/`live_grep` excluyen `.venv`, `node_modules`, `.gradle`, `target`, `build`, `_test-logs`, etc.

- **DAP activo**: los adaptadores los pone el devShell de cada proyecto (`codelldb`, `debugpy`, `java-debug`, `js-debug-adapter`).

- Para la lista viva: `<leader>sk` (Telescope keymaps), `<leader>?` (which-key del buffer) o `:Telescope keymaps`.

- Generado desde los keymaps cargados de la config; si cambias `maps.lua`, actualízalo.

