{
  description = "Config de Neovim (LazyVim), empaquetada con Nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      # Los mismos sistemas que .dotfiles, y por el mismo motivo: que
      # `nix flake check` no falle en una maquina distinta de la de diario
      # solo porque las salidas no existan para su arquitectura.
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: rec {
        # `nix run github:myticalruben/nvim` o `nix profile install ...`:
        # neovim con esta config dentro y las herramientas en el PATH.
        default = nvim;
        nvim = import ./nix/package.nix { inherit pkgs; };

        # Neovim con las herramientas pero sin config: lee ~/.config/nvim.
        # Es lo que instala el modulo de home-manager.
        nvim-tools = import ./nix/package.nix {
          inherit pkgs;
          withConfig = false;
        };

        # Solo los .lua, para quien quiera colocarlos el mismo.
        config = nvim.configDir;
      });

      homeModules.default = import ./nix/home-manager.nix;
      # home-manager acepto `homeModules` hace poco; el nombre viejo sigue
      # siendo el que buscan las configuraciones que no se han actualizado.
      homeManagerModules = self.homeModules;

      # `nix develop`: lo que hace falta para trabajar en esta config, que no
      # es lo mismo que lo que hace falta para usarla.
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [ lua-language-server stylua luajitPackages.luacheck ];
        };
      });

      checks = forAllSystems (pkgs: {
        # Que el paquete construya ya es media comprobacion; esta es la otra
        # mitad, y es la que pilla un typo en un .lua antes de abrir nvim.
        luacheck = pkgs.runCommandLocal "luacheck" {
          nativeBuildInputs = [ pkgs.luajitPackages.luacheck ];
        } ''
          cd ${./.}
          luacheck config/
          touch $out
        '';
      });
    };
}
