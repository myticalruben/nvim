# Modulo de home-manager. Lo que aporta sobre instalar el paquete a mano es la
# decision de donde vive la config, que es la misma que ya toma el flake de
# .dotfiles con su bandera mutableConfigs:
#
#   source = "ruta" - ~/.config/nvim es un enlace al checkout, asi que
#                     editarlo edita el repo. La maquina de diario.
#   source = null   - la config viaja dentro del paquete y no hay checkout que
#                     valga. La maquina que tiene que arrancar del flake y
#                     nada mas.
#
# Los dos casos instalan un ejecutable llamado `nvim`; lo que cambia es de
# donde lee. El caso inmutable no toca ~/.config/nvim en absoluto: usa
# NVIM_APPNAME, porque la config tiene que acabar en un sitio donde lazy.nvim
# pueda escribir su lockfile. Ver el comentario largo en package.nix.
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.nvimConfig;
  package = import ./package.nix {
    inherit pkgs;
    withConfig = cfg.source == null;
    inherit (cfg) extraPackages appName;
  };
in
{
  options.programs.nvimConfig = {
    enable = lib.mkEnableOption "la config de neovim de este repo";

    source = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/home/ruben/nvim/config";
      description = ''
        Ruta al directorio config/ del checkout, para editar en caliente.
        null instala la config dentro del propio paquete.
      '';
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.jdt-language-server ]";
      description = "Herramientas extra en el PATH de nvim.";
    };

    appName = lib.mkOption {
      type = lib.types.str;
      default = "nvim-nix";
      description = ''
        NVIM_APPNAME de la variante inmutable: manda en ~/.config/<appName> y
        ~/.local/share/<appName>. Sin efecto si source apunta a un checkout.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ package ];

    xdg.configFile = lib.mkIf (cfg.source != null) {
      "nvim".source = config.lib.file.mkOutOfStoreSymlink cfg.source;
    };
  };
}
