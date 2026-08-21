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

Las dos formas usan la variante con la config dentro: `NVIM_APPNAME=nvim-nix`,
asi que vive en `~/.local/share/nvim-nix` y no toca un `~/.config/nvim` que ya
tengas. Los plugins los sigue instalando lazy.nvim al primer arranque, con las
versiones de `config/lazy-lock.json`.

Como la config esta en el store, es de solo lectura: `:Lazy update` actualiza
los plugins pero no puede guardar el lockfile. Actualizar de verdad es
actualizar `config/lazy-lock.json` en el repo.

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

  # Sin source, la config va inmutable: una copia del store en ~/.config/nvim.
  # Con source, ~/.config/nvim es un enlace al checkout y editarlo edita el
  # repo, que es lo que quiere la maquina de diario.
  source = "/home/ruben/nvim/config";

  # Los LSP que no vienen de serie se enchufan aqui.
  extraPackages = [ ];
};
```

El modulo instala la variante *sin* config dentro: un `nvim` normal que lee
`~/.config/nvim`. La que decide que hay en `~/.config/nvim` es la opcion
`source`.

## Salidas del flake

| Salida | Que es |
| --- | --- |
| `packages.<sys>.default` | neovim + config + herramientas. Lo que corre `nix run`. |
| `packages.<sys>.nvim-tools` | neovim + herramientas, sin config. Lo que instala el modulo. |
| `packages.<sys>.config` | solo los `.lua`, para colocarlos a mano. |
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

Rust es la excepcion de la lista de herramientas: `config/lua/plugins/rust.lua`
resuelve `rust-analyzer` con `rustup which`, asi que manda el toolchain de la
maquina. Meter otro desde Nix solo serviria para que discrepara del `cargo` con
el que compilas.

## Trabajar en la config

```sh
nix develop      # lua-language-server, stylua, luacheck
luacheck config/
```
