# nvim

Mi config de Neovim (LazyVim), empaquetada con Nix para poder instalarla en
una maquina limpia con un solo comando.

El paquete trae el editor y las herramientas **del editor**: `ripgrep`, `fd`,
`git`, un compilador para los parsers de treesitter, `nil`/`nixfmt` para los
`flake.nix` y `prettier`/`marksman` para markdown y json. Los servidores de
lenguaje no van dentro: los pone el devShell del
proyecto, con las plantillas de
[nix-templates](https://github.com/myticalruben/nix-templates). Asi el mismo
nvim sirve para Java, Rust, C/C++, Python y frontend sin arrastrar seis
toolchains ni duplicarlas.

Los atajos de teclado estan en [ATAJOS.md](ATAJOS.md).

## Usarlo

Probarlo sin instalar nada:

```sh
nix run github:myticalruben/nvim
```

Instalarlo en el perfil:

```sh
nix profile install github:myticalruben/nvim
```

Las dos formas usan la variante con la config dentro. Corre bajo
`NVIM_APPNAME=nvim-nix`, asi que vive en `~/.config/nvim-nix` y
`~/.local/share/nvim-nix` y no toca un `~/.config/nvim` que ya tengas. Los
plugins los sigue instalando lazy.nvim al primer arranque, con las versiones
de `config/lazy-lock.json`.

`~/.config/nvim-nix` es una **copia** de la config, no un enlace al store, y el
paquete la rehace cuando lo actualizas. No es un detalle de implementacion:
lazy.nvim escribe `lazy-lock.json` ahi dentro en cuanto instala un plugin, y si
no puede, aborta el arranque con un assert en vez de avisar. La consecuencia
practica es que lo que edites en esa copia dura hasta el siguiente
`nix profile upgrade`; los cambios de verdad van al repo.

## Lenguajes: los pone el proyecto

| Lenguaje | Plantilla | Lo que deja en el PATH |
| --- | --- | --- |
| Java | `java` | `jdtls`, `google-java-format`, JDK |
| Rust | `rust` | `rust-analyzer`, `taplo`, `cargo` |
| C/C++ | `c` | `gcc`, `clangd`, `clang-format`, `cmake`, `neocmakelsp`, `gdb` |
| Python | `python` | `pyright` (tipos) + `ruff` (lint y formato), `uv`, python |
| Angular | `frontend` (`.#angular`) | `vtsls`, `angular-language-server`, node, pnpm |
| React | `frontend` (`.#react`) | `vtsls`, node, pnpm |

Para que nvim los vea, el devShell tiene que estar activo en la shell desde la
que lo abres:

```sh
cd mi-proyecto      # .envrc con `use flake`
nvim
```

Una sola vez por maquina hacen falta dos cosas: `nix` en el PATH (el instalador
ya anade `~/.nix-profile/etc/profile.d/nix.sh` a `~/.profile`) y el hook de
direnv en `~/.bashrc`:

```sh
eval "$(direnv hook bash)"
```

Y `direnv allow` una vez por proyecto. Fuera de un devShell no hay LSP: es
deliberado, el editor no adivina con que toolchain se compila el proyecto.

## Desde otro flake

```nix
{
  inputs.nvim.url = "github:myticalruben/nvim";

  # ...
  modules = [ nvim.homeModules.default ];
}
```

y en la configuracion de home-manager:

```nix
programs.nvimConfig = {
  enable = true;

  # Con source, ~/.config/nvim es un enlace al checkout: editarlo edita el
  # repo. Es lo que quiere la maquina de diario.
  #
  # Sin source, la config viaja dentro del paquete (igual que `nix run`) y
  # ~/.config/nvim ni se crea. Es lo que quiere una maquina que tiene que
  # arrancar del flake y nada mas.
  source = "/home/ruben/nvim/config";

  # Los binarios que ninguna plantilla trae se enchufan aqui.
  extraPackages = [ ];
};
```

## Salidas del flake

| Salida | Que es |
| --- | --- |
| `packages.<sys>.default` | neovim + config + herramientas del editor. Lo que corre `nix run`. |
| `packages.<sys>.nvim-tools` | neovim + herramientas, sin config. Lo que instala el modulo. |
| `packages.<sys>.config` | solo los `.lua`, para colocarlos a mano. Ojo: si acaban en un sitio de solo lectura, lazy.nvim no arranca. |
| `homeModules.default` | el modulo de home-manager de arriba. |
| `devShells.<sys>.default` | `lua-language-server`, `stylua`, `luacheck`, `nil`, `nixfmt`. |
| `checks.<sys>.luacheck` | lo que corre el CI. |

## Que hay dentro

```
config/          lo que acaba en ~/.config/nvim
  init.lua
  lua/config/    opciones, atajos, arranque de lazy.nvim
  lua/plugins/   lo propio encima de LazyVim
  lazyvim.json   los extras de LazyVim activados
  lazy-lock.json las versiones exactas de cada plugin
nix/package.nix  el paquete, y la lista de herramientas del PATH
nix/home-manager.nix
```

`config/lua/config/options.lua` lo carga LazyVim **despues** de sus propios
defaults, que es lo que hace que lo que pongas ahi gane. No lo requires desde
`init.lua` o LazyVim lo pisa al arrancar.

## Iconos

LazyVim dibuja los iconos con `mini.icons` (glifos de **Nerd Font v3**). El
editor solo emite el caracter; quien lo dibuja es el terminal, asi que la fuente
va en la maquina desde la que te conectas, no en este paquete:

- **Windows Terminal**: `winget install DEVCOM.JetBrainsMonoNerdFont`, y en
  Ajustes > Perfiles > Predeterminados > Apariencia > Fuente:
  `JetBrainsMono Nerd Font Mono`. Cierra todas las ventanas y vuelve a abrir.
- **VS Code**: `"terminal.integrated.fontFamily": "JetBrainsMono Nerd Font Mono"`.
- **macOS**: `brew install --cask font-jetbrains-mono-nerd-font`.

Prueba rapida dentro de la sesion: `printf '\U000F0214  \U000F024B\n'`. Si
salen cuadros, la fuente no esta o es una Nerd Font v2 (p. ej. `MesloLGS NF` de
powerlevel10k): las v2 no tienen los glifos v3 y unos iconos saldran y otros no.

Si no puedes cambiar la fuente del terminal, `mini.icons` acepta
`style = "ascii"` y los iconos de archivo pasan a texto plano.

## Mason

Desactivado a proposito (`config/lua/plugins/mason.lua`). Bajaria otra vez los
mismos LSP que ya estan en el devShell del proyecto, y su `bin/` iria delante en
el PATH, tapando al binario correcto. Si falta una herramienta, el sitio es la
plantilla del proyecto o `extraPackages`; no Mason.

## Depuracion

DAP funciona dentro del devShell del proyecto, con el adaptador que trae la
plantilla:

| Lenguaje | Adaptador | Lo pone |
| --- | --- | --- |
| Java | `java-debug` via `JAVA_DEBUG_BUNDLES` | plantilla `java` |
| Rust | `codelldb` | plantilla `rust` |
| C/C++ | `codelldb` | plantilla `c` |
| Python | `debugpy-adapter` | plantilla `python` |
| Angular/React | `js-debug-adapter` | plantilla `frontend` |

Fuera del devShell no hay adaptador y el depurador no arranca: el mismo
principio que los LSP. El extra `dap.core` de LazyVim pone los atajos y la UI.

## Editar esta config

```sh
nix develop      # lua-language-server, stylua, luacheck, nil, nixfmt
luacheck config/
```

Dentro de nvim, `<leader>uR` (o `:NvimReset`) reinicia el editor y vuelve a
cargar la config, restaurando la sesion (mismos buffers y ventanas). Antes
arranca el wrapper del paquete para refrescar `~/.config/nvim-nix` si acabas de
hacer `nix profile upgrade`. Aborta si hay buffers sin guardar, y los terminales
abiertos no se restauran (mksession no los guarda).
