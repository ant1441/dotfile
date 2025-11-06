#!/bin/bash

export RUSTUP_TARGETS=(
    x86_64-unknown-linux-musl
)

export RUSTUP_TOOLCHAINS=(
    nightly
)

export RUSTUP_COMPONENTS=(
    rust-src
)

export CARGO_BINARIES=(
    ## Rust editing
    cargo-edit
    # Expand macros
    cargo-expand
    # Update dependencies and global binaries
    cargo-update
    # Run commands when code changes
    cargo-watch
    # flamegraph

    ## Utils
    # A cat(1) clone with wings.
    bat
    # `ls` alternative
    eza
    # `find` alternative
    fd-find
    # A syntax-highlighting pager for git, diff, and grep output
    git-delta
    # `hexdump` alternative
    hexyl
    # Profiler
    hyperfine
    ripgrep
    # Create beautiful image of your code
    # silicon
    # Count your code, quickly.
    tokei
    # Websocket cli util
    websocat
    # Language server for NASM/GAS/GO Assembly
    asm-lsp
)

export APT_PACKAGES=(
    # Libraries
    libfontconfig1-dev
    libfreetype6-dev
    libssl-dev
    libxcb-xfixes0-dev
    libxkbcommon-dev

    # Python packages
    python3-dev
    python3-neovim
    python3-pip
    python3-venv

    pkg-config

    cmake

    # Tools
    1password
    1password-cli
    ccls
    curl
    git
    htop
    # iperf has a config screen on install which breaks
    # iperf3
    jq
    neovim
    nmap
    gron
    shellcheck
    whois
    # inetutils-traceroute
    traceroute
    tmux
    pv

    # Wayland clipboard tools - required for Neovim clipboard integration
    wl-clipboard

    # Editor / LSP
    # clangd # clangd is a very large install (pulls in libllvm)
    # Needs Hashicorp PPA
    # terraform
    # terraform-ls

    # TODO: see custom/node
    # nodejs

    # Manual
    # Google Chrome - https://linuxhint.com/install_google_chrome_ubuntu_ppa/
    # ```
    # sudo wget -q -O /etc/apt/trusted.gpg.d/google_linux_signing_key.pub https://dl-ssl.google.com/linux/linux_signing_key.pub
    # sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/google_linux_signing_key.pub] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    # sudo apt update
    # sudo apt install google-chrome-stable
    # ```
)

# Snap packages?
# ttyplot

export NODE_PACKAGES=(
    # Neovim LSP
    bash-language-server
    yaml-language-server
    vim-language-server
    vscode-langservers-extracted
)

## Other
# Vault - https://www.vaultproject.io/downloads
# AWS CLI - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
# aws-creds - https://gitlab.newsweaver.lan/cloud/aws-credentials/-/releases
# aws-whoami - https://github.com/benkehoe/aws-whoami
