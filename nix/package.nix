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

  # Editor y herramientas DEL EDITOR. Los servidores de lenguaje no van aqui:
  # los pone el devShell del proyecto (github:myticalruben/nix-templates), que
  # es el unico que sabe que version de JDK, rust o node usa ese proyecto. Si
  # algo de esto falta, nvim no da un error: el plugin simplemente no hace nada.
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

    # Nix es el idioma de los flake.nix de todos los proyectos.
    nil
    nixfmt

    # Markdown no tiene plantilla: es el unico LSP que se queda aqui.
    marksman

    # Formateador de markdown/json/yaml. LazyVim lo cablea para esos tipos en
    # cualquier proyecto; no es una herramienta de lenguaje.
    prettier
  ])
  # Sin esto "+y no sale de nvim. Solo existe en Linux, y dejarlo fuera del
  # resto es lo que permite que el paquete evalue tambien en macOS.
  ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.wl-clipboard
  ++ extraPackages;

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
