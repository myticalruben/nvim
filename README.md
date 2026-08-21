# nvim

Mi config de Neovim (LazyVim), empaquetada con Nix para poder instalarla en
una maquina limpia con un solo comando.

Lo que aporta el flake sobre clonar el repo en `~/.config/nvim` es el PATH: la
mitad de lo que hace LazyVim son programas externos -- `ripgrep` para buscar,
`gcc` para compilar los parsers de treesitter, un LSP por lenguaje -- y cuando
falta uno no salta ningun error, el plugin simplemente no hace nada. El
paquete los trae todos dentro.

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

  # Los LSP que no vienen de serie se enchufan aqui.
  extraPackages = [ ];
};
```

## Salidas del flake

| Salida | Que es |
| --- | --- |
| `packages.<sys>.default` | neovim + config + herramientas. Lo que corre `nix run`. |
| `packages.<sys>.nvim-tools` | neovim + herramientas, sin config. Lo que instala el modulo. |
| `packages.<sys>.config` | solo los `.lua`, para colocarlos a mano. Ojo: si acaban en un sitio de solo lectura, lazy.nvim no arranca. |
| `homeModules.default` | el modulo de home-manager de arriba. |
| `devShells.<sys>.default` | `lua-language-server`, `stylua`, `luacheck`. |
| `checks.<sys>.luacheck` | lo que corre el CI. |

## Que hay dentro

```
config/          lo que acaba en ~/.config/nvim
  init.lua
  lua/config/    opciones, atajos, colores, arranque de lazy.nvim
  lua/plugins/   lo propio encima de LazyVim
  lazyvim.json   los extras de LazyVim activados
  lazy-lock.json las versiones exactas de cada plugin
nix/package.nix  el paquete, y la lista de herramientas del PATH
nix/home-manager.nix
```

Mason sigue ahi para lo que la lista no cubre (jdtls, ktlint, los adaptadores
de depuracion): quitarlo significaria perder esos lenguajes. En NixOS sus
binarios no enlazan, y la salida es anadir el paquete de Nix equivalente a
`extraPackages`.

Rust es la otra excepcion de la lista de herramientas: `config/lua/plugins/rust.lua`
resuelve `rust-analyzer` con `rustup which`, asi que manda el toolchain de la
maquina. Meter otro desde Nix solo serviria para que discrepara del `cargo` con
el que compilas.

## Trabajar en la config

```sh
nix develop      # lua-language-server, stylua, luacheck
luacheck config/
```
