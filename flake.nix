{
  description = "AngelOS dotfiles & Quickshell environment for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    homeManagerModules.default = { config, lib, pkgs, ... }:
      let
        cfg = config.programs.angelos;
      in
      {
        options.programs.angelos = {
          enable = lib.mkEnableOption "AngelOS environment";
        };

        config = lib.mkIf cfg.enable {
          # 1. Системные пакеты и зависимости, необходимые для AngelOS и его Python-скриптов
          home.packages = with pkgs; [
            quickshell
            kitty
            fish
            python3
            python3Packages.psutil
            grim
            slurp
            wl-clipboard
            qt6.qtdeclarative
            qt6.qt5compat
            fastfetch
          ];

          # 2. Декларативная привязка конфигов через симлинки в ~/.config
          home.file = {
            ".config/niri".source = ./pleased_or_custom_path_if_needed / .config/niri; # Точнее, пути ниже:
            
            # Поскольку конфиги лежат в папке .config/ внутри вашего репозитория:
            ".config/alacritty".source = ./.config/alacritty;
            ".config/fish".source = ./.config/fish;
            ".config/foot".source = ./.config/foot;
            ".config/niri".source = ./.config/niri;
            ".config/nvim".source = ./.config/nvim;
            ".config/quickshell".source = ./.config/quickshell;
          };
        };
      };

    homeModules.default = self.homeManagerModules.default;
  };
}
