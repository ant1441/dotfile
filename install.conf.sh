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
    exa
    # `find` alternative
    fd-find
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
)
