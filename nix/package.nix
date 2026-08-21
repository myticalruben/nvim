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
    # Mason no aparece aqui a proposito: descarga binarios precompilados que
    # en NixOS no enlazan, y en el resto duplican lo que ya hay en el store.
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

  # Enlaza ~/.config/<appName> a la config del store antes de arrancar.
  #
  # Es un rodeo, y tiene motivo: la forma directa seria exportar
  # XDG_CONFIG_HOME al store, pero eso lo heredan los procesos que nvim lanza
  # -- :terminal, lazygit, git -- y a esos les quitaria su propia config sin
  # decir nada. NVIM_APPNAME solo lo mira neovim.
  linkConfig = ''
    nvim_appdir="''${XDG_CONFIG_HOME:-$HOME/.config}/${appName}"
    nvim_want="${configDir}"
    if [ -L "$nvim_appdir" ]; then
      if [ "$(readlink "$nvim_appdir")" != "$nvim_want" ]; then
        rm "$nvim_appdir" && ln -s "$nvim_want" "$nvim_appdir"
      fi
    elif [ -e "$nvim_appdir" ]; then
      echo "nvim: $nvim_appdir existe y no es un enlace a /nix/store." >&2
      echo "nvim: quitalo a mano o cambia appName; no lo voy a borrar yo." >&2
      exit 1
    else
      mkdir -p "$(dirname "$nvim_appdir")" && ln -s "$nvim_want" "$nvim_appdir"
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
      --run ${lib.escapeShellArg linkConfig} \
    ''}
''
