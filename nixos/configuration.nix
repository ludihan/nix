{ inputs, lib, config, pkgs, ... }: {
    imports = [
        # If you want to use modules from other flakes (such as nixos-hardware):
        # inputs.hardware.nixosModules.common-cpu-amd
        # inputs.hardware.nixosModules.common-ssd

        # You can also split up your configuration and import pieces of it here:
        # ./users.nix

        # Import your generated (nixos-generate-config) hardware configuration
        ./hardware-configuration.nix
    ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nixpkgs = {
        # You can add overlays here
        overlays = [
            # If you want to use overlays exported from other flakes:
            # neovim-nightly-overlay.overlays.default

            # Or define it inline, for example:
            # (final: prev: {
            #   hi = final.hello.overrideAttrs (oldAttrs: {
            #     patches = [ ./change-hello-to-hi.patch ];
            #   });
            # })
        ];
        # Configure your nixpkgs instance
        config = {
            # Disable if you don't want unfree packages
            allowUnfree = true;
        };
    };

    fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
            iosevka
            noto-fonts
        ];
    };

    nix = let
        flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
        settings = {
            # Enable flakes and new 'nix' command
            experimental-features = [
                "nix-command" 
                "flakes"
            ];
            # Opinionated: disable global registry
            flake-registry = "";
            # Workaround for https://github.com/NixOS/nix/issues/9574
            nix-path = config.nix.nixPath;
        };
        # Opinionated: disable channels
        channel.enable = false;

        # Opinionated: make flake registry and nix path match flake inputs
        registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
        nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

    networking.hostName = "nixos";

    # Enable networking
    networking.networkmanager.enable = true;

    environment.localBinInPath = true;

    # Set your time zone.
    # time.timeZone = "America/Fortaleza";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "C.UTF-8";
        LC_IDENTIFICATION = "C.UTF-8";
        LC_MEASUREMENT = "C.UTF-8";
        LC_MONETARY = "C.UTF-8";
        LC_NAME = "C.UTF-8";
        LC_NUMERIC = "C.UTF-8";
        LC_PAPER = "C.UTF-8";
        LC_TELEPHONE = "C.UTF-8";
        LC_TIME = "C.UTF-8";
    };
    i18n.inputMethod = {
        type = "fcitx5";
        enable = false;
        fcitx5.addons = with pkgs; [
            fcitx5-mozc
            fcitx5-gtk
        ];
    };

    users.users.ludihan = {
        isNormalUser = true;
        extraGroups = [
            "wheel"
            "networkmanager"
            "audio"
            "video"
        ];
        shell = pkgs.bash;
    };

    services = {
        displayManager.ly = {
            enable = true;
        };
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
        };
        automatic-timezoned.enable = true;
        gnome.gnome-keyring.enable = true;
    };
    security.polkit.enable = true;
    services.gvfs.enable = true;

    programs.nix-ld.enable = true;
    xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
    };

    # not present in home manager
    programs.niri.enable = true;

    programs = {
        nautilus-open-any-terminal.enable = true;
        nautilus-open-any-terminal.terminal = "foot";
    };

    # theme option does not exist in home manager
    programs.foot = {
        enable = true;
        theme = "gruvbox";
        settings.main = {
            font = "Iosevka:size=12";
            resize-by-cells=false;
        };
    };

    virtualisation.docker = {
        enable = true;
        rootless = {
            enable = true;
            setSocketVariable = true;
        };
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    system.stateVersion = "25.05";
}
