{ inputs, lib, config, pkgs, ... }: {
    # You can import other home-manager modules here
    imports = [
        # If you want to use home-manager modules from other flakes (such as nix-colors):
        # inputs.nix-colors.homeManagerModule

        # You can also split up your configuration and import pieces of it here:
        # ./nvim.nix
    ];

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
            # Workaround for https://github.com/nix-community/home-manager/issues/2942
            allowUnfreePredicate = _: true;
        };
    };

    home = {
        username = "ludihan";
        homeDirectory = "/home/ludihan";
    };

    # Add stuff for your user as you see fit:
    # programs.neovim.enable = true;
    home.packages = with pkgs; [ 
        discord
        wget
        curl
        jq
        jo
        git
        stow
        gcc
        rustup
        go
        nodejs
        uv
        waybar
        nushell
        blender
        vivid
        carapace
        firefox
        steam 
        osu-lazer-bin
        gh
        niri
    ];

    # Enable home-manager and git
    programs.home-manager.enable = true;
    programs.git.enable = true;
    programs.fuzzel.enable = true;
    programs.neovim = {
        enable = true;
        defaultEditor = true;
    };
    programs.tmux = {
        enable = true;
        extraConfig = ''
            bind C-p swapw -d -t -1
            bind C-n swapw -d -t +1

            bind h selectp -L
            bind j selectp -D
            bind k selectp -U
            bind l selectp -R

            bind -r H resizep -L 5
            bind -r J resizep -D 5
            bind -r K resizep -U 5
            bind -r L resizep -R 5

            bind o splitw -h
            bind i splitw -v
        '';
    };
    programs.swaylock = {
        enable = true;
        settings = {
            ignore-empty-password = true;
            indicator-caps-lock = true;
            color = "262626";
        };
    };

    services.mako = {
        enable = true;
        extraConfig = ''
            font=Terminus 10
            default-timeout=10000
            background-color=#222222
            border-color=#666666
            text-color=#ffffff

            [urgency=low]
            default-timeout=5000

            [urgency=critical]
            ignore-timeout=1
        '';
    };


    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "25.05";
}
