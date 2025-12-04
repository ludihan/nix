{
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./modules/niri
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

  xdg.enable = true;
  programs.bash = {
    enable = true;
    sessionVariables =
      let
        data = d: "${config.home.homeDirectory}/.local/share/${d}";
        cache = d: "${config.home.homeDirectory}/.cache/${d}";
        state = d: "${config.home.homeDirectory}/.local/state/${d}";
        configDir = d: "${config.home.homeDirectory}/.config/${d}";
      in
      {
        GOPATH = data "go";
        PYTHONUSERBASE = data "python";
        CARGO_HOME = data "cargo";
        RUSTUP_HOME = data "rustup";
        OPAMROOT = data "opam";

        CUDA_CACHE_PATH = cache "nv";
        PYTHONPYCACHEPREFIX = cache "python";
        NUGET_PACKAGES = cache "NuGetPackages";

        PYTHON_HISTORY = state "python_history";
        PSQL_HISTORY = state "psql_history";
        SQLITE_HISTORY = state "sqlite_history";
        NODE_REPL_HISTORY = state "node_repl_history";

        NPM_CONFIG_USERCONFIG = configDir "npm/npmrc";
        DOCKER_CONFIG = configDir "docker";
        OMNISHARPHOME = configDir "omnisharp";
        _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.home.homeDirectory}/.config/java";

        GHCUP_USE_XDG_DIRS = "true";
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    initExtra = ''
      # Provide a nice prompt if the terminal supports it.
      if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
        PROMPT_COLOR="1;31m"
        ((UID)) && PROMPT_COLOR="1;32m"
        if [ -n "$INSIDE_EMACS" ]; then
          # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
          PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
        else
          PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
        fi
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
      export PATH=$PATH:$HOME/.local/bin
      export PATH=$PATH:$CARGO_HOME/bin
      export PATH=$PATH:$GOPATH/bin
    '';
  };
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.LS_COLORS = (vivid generate gruvbox-dark)
      $env.config.edit_mode = 'vi'
      $env.config = {
          show_banner: false,
          table: {
              header_on_separator: true,
              mode: 'single'
          }
      }
    '';
  };
  # programs.carapace.enable = true;

  home = {
    username = "ludihan";
    homeDirectory = "/home/ludihan";
    preferXdgDirectories = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    #iconTheme = {
    #name = "Obsidian-Sand";
    #};
    cursorTheme = {
      name = "Adwaita";
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };
  dconf = {
    enable = true;
    settings = {
      #"org/gnome/desktop/background" = {
      #picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
      #};
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    discord
    wget
    curl
    jq
    jo
    fd
    ripgrep
    bat
    grim
    slurp
    gcc
    # rustup
    # dotnet-sdk
    # go
    gopls
    nil
    rust-analyzer
    godot
    nodejs
    python3
    uv
    blender
    vivid
    steam
    osu-lazer-bin
    docker-compose
    docker-buildx
    hyprpicker
    spotify
    wl-clipboard
    brightnessctl
    imv
    inxi
    papers
    gnome-text-editor
    nautilus
    krita
    # love
    mednafen
    swaybg
    lf
    pavucontrol
    batsignal
    networkmanagerapplet
    unzip
    unrar
    zip
    sunvox
    tuxpaint
    aseprite
    woomer
    xwayland-satellite
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    ffmpegthumbnailer
    quickshell
    nixfmt
    nixfmt-tree
    nix-output-monitor
    nvd
    wl-mirror
    reaper
    vital
    cmus
    kew
    nicotine-plus
  ];

  programs.firefox.enable = true;

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka:size=12";
        resize-by-cells = false;
      };
      # gruvbox
      colors = {
        background = "282828";
        foreground = "ebdbb2";
        regular0 = "282828";
        regular1 = "cc241d";
        regular2 = "98971a";
        regular3 = "d79921";
        regular4 = "458588";
        regular5 = "b16286";
        regular6 = "689d6a";
        regular7 = "a89984";
        bright0 = "928374";
        bright1 = "fb4934";
        bright2 = "b8bb26";
        bright3 = "fabd2f";
        bright4 = "83a598";
        bright5 = "d3869b";
        bright6 = "8ec07c";
        bright7 = "ebdbb2";
      };

      colors2 = {
        background = "fbf1c7";
        foreground = "3c3836";
        regular0 = "fbf1c7";
        regular1 = "cc241d";
        regular2 = "98971a";
        regular3 = "d79921";
        regular4 = "458588";
        regular5 = "b16286";
        regular6 = "689d6a";
        regular7 = "7c6f64";
        bright0 = "928374";
        bright1 = "9d0006";
        bright2 = "79740e";
        bright3 = "b57614";
        bright4 = "076678";
        bright5 = "8f3f71";
        bright6 = "427b58";
        bright7 = "3c3836";
      };
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ludihan";
        email = "65617704+ludihan@users.noreply.github.com";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      core = {
        autocrlf = "input";
      };
    };
  };
  programs.discord.enable = true;
  programs.home-manager.enable = true;
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka:size=16";
        lines = 30;
        dpi-aware = false;
        terminal = "foot";
      };
      colors = {
        background = "#1A1A1AFF";
        border = "#1A1A1AFF";
        selection = "#505050FF";
        selection-text = "#FFFFFFFF";
        selection-match = "#FE8019FF";
        input = "#FFFFFFFF";
        text = "#AAAAAAAA";
        match = "#FE8019FF";
        prompt = "#FE8019FF";
      };
      border = {
        radius = 0;
      };
    };
  };
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-window-option -g mode-keys vi
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

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      spacing = 10;
      modules-left = [
        "niri/workspaces"
        "niri/window"
      ];
      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "backlight"
        "battery"
        "clock"
      ];
      clock = {
        format = "[{:%F %H:%M}]";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };
      cpu = {
        format = "[CPU:{usage}%]";
      };
      memory = {
        format = "[MEM:{percentage}%]";
      };
      temperature = {
        critical-threshold = 80;
        format-critical = "[!!{temperatureC}°C!!]";
        format = "[{temperatureC}°C]";
      };
      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "[BAT:{capacity}%]";
      };
      pulseaudio = {
        format = "[VOL:{volume}% MIC:{format_source}]";
        format-muted = "[VOL:{volume}%(MUTE) MIC:{format_source}]";
        format-source = "{volume}%";
        format-source-muted = "{volume}%(MIC MUTE)";
      };
      network = {
        format-wifi = "[NET:{signalStrength}%]";
        format-ethernet = "[NET:{ifname}]";
        format-linked = "[NET:No IP]";
        format-disconnected = "[NET:Disconnected]";
      };
      backlight = {
        format = "[BKL: {percent}%]";
      };
    };
    style = ''
      * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: Iosevka;
          font-feature-settings: "liga off, calt off";
          border-radius: 0px;
          /* min-height: 0px; */
      }

      window#waybar {
          background-color: #1A1A1A;
          color: #ffffff;
          opacity: 1;
      }

      #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: #ffffff;
          border: none;
      }

      #workspaces button.focused {
          background-color: #4f4f4f;
          color: #ffffff;
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }

      button:hover {
          box-shadow: none;
          /* Remove predefined box-shadow */
          text-shadow: none;
          /* Remove predefined text-shadow */
          background: none;
          /* Remove predefined background color (white) */
          transition: none;
          /* Disable predefined animations */
      }

      #mode {
          background-color: #64727D;
      }
    '';
  };

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      # obs-vaapi #optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
  };

  programs.mpv = {
    enable = true;
    config = {
      keep-open = true;
    };
  };

  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/.nix-config";
  };

  xdg.configFile =
    let
      link =
        name: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nix-config/config/${name}";
    in
    {
      nvim.source = link "nvim";
      npm.source = link "npm";
      quickshell.source = link "quickshell";
    };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = null;
    publicShare = null;
  };
  xdg.mime.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
