# Modulo de home-manager. Lo que aporta sobre instalar el paquete a mano es la
# decision de donde vive la config, que es la misma que ya toma el flake de
# .dotfiles con su bandera mutableConfigs:
#
#   source = null   - copia inmutable en el store. La maquina arranca con esta
#                     config y no hay nada que editar.
#   source = "ruta" - enlace fuera del store al checkout, asi que editar
#                     ~/.config/nvim edita el repo. La maquina de diario.
#
# En los dos casos ~/.config/nvim es un nvim normal y corriente: el binario que
# se instala aqui es la variante sin config dentro.
{ self }:
{ config, lib, pkgs, ... }:

let
  cfg = config.programs.nvimConfig;
  package = import ./package.nix {
    inherit pkgs;
    withConfig = false;
    inherit (cfg) extraPackages;
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
        null deja la copia del store, que es de solo lectura.
      '';
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.jdt-language-server ]";
      description = "Herramientas extra en el PATH de nvim.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ package ];

    xdg.configFile."nvim".source =
      if cfg.source == null
      then self.packages.${pkgs.stdenv.hostPlatform.system}.config
      else config.lib.file.mkOutOfStoreSymlink cfg.source;
  };
}
