#!/bin/bash

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
    python3-dev
    python3-pip
    libssl-dev

    # Tools
    1password
    curl
    git
    htop
    iperf3
    jq
    neovim
    gron
    shellcheck
    whois
    # inetutils-traceroute
    tmux
    pv

    # Editor / LSP
    clangd
    # Needs Hashicorp PPA
    # terraform
    # terraform-ls

    # TODO: see custom/node
    #nodejs

    # Manual
    # Google Chrome - https://linuxhint.com/install_google_chrome_ubuntu_ppa/
)

# TODO: Sort out node
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
