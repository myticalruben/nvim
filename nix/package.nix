# El paquete: esta config mas un neovim que ya trae en el PATH todo lo que la
# config invoca.
#
# La division importante es `withConfig`. Un editor se instala de dos maneras
# distintas y solo una de ellas puede llevar la config dentro:
#
#   true  - el binario apunta a la config del /nix/store y no mira
#           ~/.config/nvim. Es lo que hace que `nix run github:...` sirva de
#           algo en una maquina donde no hay nada clonado.
#   false - un neovim normal, con las herramientas en el PATH, que lee
#           ~/.config/nvim como siempre. Es lo que quiere la maquina de
#           diario, donde la config esta enlazada al checkout y se edita en
#           caliente.
{ pkgs
, lib ? pkgs.lib

, # La copia de config/ que se mete dentro del binario. Solo se usa si
  # withConfig es true.
  configSrc ? ../config

, withConfig ? true

, # Herramientas extra en el PATH de nvim. Los LSP que no vienen de serie
  # (java, kotlin, lo que sea) se enchufan por aqui sin tocar este archivo.
  extraPackages ? [ ]

, # El nombre bajo el que vive el estado de la variante withConfig. Manda en
  # ~/.config/<appName>, ~/.local/share/<appName> y ~/.local/state/<appName>,
  # asi que cambiarlo equivale a empezar de cero.
  appName ? "nvim-nix"
}:

let
  # config/ tal cual, dentro del store. Es tambien la salida que consume el
  # modulo de home-manager cuando la config va inmutable.
  configDir = pkgs.runCommandLocal "nvim-config" { } ''
    cp -r ${configSrc} $out
  '';

  # Todo lo que la config llama por su nombre y espera encontrar en el PATH.
  # Si algo de esto falta, nvim no da un error: el plugin correspondiente
  # simplemente no hace nada, que es exactamente el tipo de fallo silencioso
  # que este paquete existe para evitar.
  runtimeDeps = (with pkgs; [
    # Lo que LazyVim da por sentado.
    ripgrep
    fd
    git
    curl
    unzip
    gnutar
    gzip

    # nvim-treesitter compila los parsers en la maquina, al vuelo.
    gcc
    gnumake
    tree-sitter

    nodejs         # varios LSP y formateadores son paquetes de npm

    # config/lua/config/base.lua fija `shell = "zsh"`. En la maquina de
    # diario ya esta; en una limpia, :terminal y :! fallarian sin esto.
    zsh

    # Un LSP o formateador por cada extra de config/lazyvim.json que lo pide.
    # Mason sigue instalando por su cuenta lo que no esta en esta lista
    # (jdtls, ktlint, los adaptadores de depuracion). Se queda asi a
    # proposito: bajar de esta lista significaria perder esos lenguajes. Lo
    # que si importa es que en NixOS los binarios de mason no enlazan, y ahi
    # la salida es anadir el paquete de Nix a extraPackages.
    lua-language-server
    stylua
    vscode-langservers-extracted   # json, html, css, eslint
    typescript-language-server
    angular-language-server
    emmet-language-server
    prettierd
    pyright
    ruff
    clang-tools                    # clangd
    cmake-language-server
    taplo                          # toml
    marksman                       # markdown
    shfmt
  ])
  # Sin esto "+y no sale de nvim. Solo existe en Linux, y dejarlo fuera del
  # resto es lo que permite que el paquete evalue tambien en macOS.
  ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.wl-clipboard
  ++ extraPackages;

  # rust no esta en la lista. config/lua/plugins/rust.lua resuelve
  # rust-analyzer con `rustup which`, asi que el que manda es el toolchain de
  # la maquina; meter otro desde Nix solo serviria para que discrepara del
  # cargo con el que se compila.

  # Deja la config del store en ~/.config/<appName> antes de arrancar, y la
  # refresca cuando el paquete cambia.
  #
  # Es una copia y no un enlace por una razon concreta: lazy.nvim escribe
  # lazy-lock.json dentro de stdpath("config") en cuanto instala un plugin, y
  # si no puede, no avisa -- aborta el arranque entero con un assert. LazyVim
  # hace lo mismo con lazyvim.json al migrar de version. Un directorio de
  # config de solo lectura no es una limitacion aceptable, es un editor que no
  # abre.
  #
  # La copia se rehace cuando cambia la ruta del store, asi que lo que se edite
  # ahi dentro dura hasta la siguiente actualizacion del paquete. Es
  # deliberado: en esta variante la fuente de la verdad es el repo.
  #
  # Y va por NVIM_APPNAME en vez de por XDG_CONFIG_HOME porque lo segundo lo
  # heredarian los procesos que nvim lanza -- :terminal, git, lazygit -- y les
  # quitaria su propia config sin decir nada.
  syncConfig = ''
    nvim_appdir="''${XDG_CONFIG_HOME:-$HOME/.config}/${appName}"
    nvim_want="${configDir}"
    nvim_stamp="$nvim_appdir/.nix-config"

    if [ -L "$nvim_appdir" ]; then
      rm "$nvim_appdir"                       # una version anterior enlazaba
    elif [ -d "$nvim_appdir" ] && [ ! -e "$nvim_stamp" ]; then
      echo "nvim: $nvim_appdir existe y no lo ha puesto este paquete." >&2
      echo "nvim: quitalo a mano o cambia appName; no lo voy a borrar yo." >&2
      exit 1
    fi

    if [ "$(cat "$nvim_stamp" 2>/dev/null)" != "$nvim_want" ]; then
      rm -rf "$nvim_appdir"
      mkdir -p "$(dirname "$nvim_appdir")"
      cp -r "$nvim_want" "$nvim_appdir"
      chmod -R u+w "$nvim_appdir"             # del store sale sin permiso de escritura
      printf '%s\n' "$nvim_want" > "$nvim_stamp"
    fi
  '';
in
pkgs.runCommandLocal "nvim${lib.optionalString (!withConfig) "-tools"}"
{
  nativeBuildInputs = [ pkgs.makeWrapper ];
  passthru = { inherit configDir runtimeDeps; };
  meta = {
    description = "Neovim con la config de este repo y sus herramientas";
    mainProgram = "nvim";
    inherit (pkgs.neovim-unwrapped.meta) license platforms;
  };
} ''
  makeWrapper ${lib.getExe pkgs.neovim-unwrapped} $out/bin/nvim \
    --prefix PATH : ${lib.makeBinPath runtimeDeps} \
    ${lib.optionalString withConfig ''
      --set NVIM_APPNAME ${appName} \
      --run ${lib.escapeShellArg syncConfig} \
    ''}
''
