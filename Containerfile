FROM ghcr.io/ublue-os/arch-toolbox:latest AS distrobox-arch

# Install packages
RUN pacman -Syu \
        libva-mesa-driver \
        intel-media-driver \
        vulkan-mesa-layers \
        pipewire \
        pipewire-pulse \
        pipewire-alsa \
        pipewire-jack \
        wireplumber \
        xdg-user-dirs \
        noto-fonts-cjk \
        glibc-locales \
        openssh \
        podman \
        --noconfirm && \
    pacman -S --clean --clean && \
    rm -rf /var/cache/pacman/pkg/*

# Create build user (for AUR packages)
RUN useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install AUR packages
USER build
WORKDIR /home/build
RUN paru -S \
        ghostty \
        fish \
        jujutsu \
        git \
        go \
        procs \
        dust \
        jless \
        git-delta \
        difftastic \
        git-get \
        git-graph \
        tea \
        bitwarden-cli \
        ttf-go \
        atuin \
        direnv \
        rage \
        fzf \
        jq \
        zoxide \
        bat \
        eza \
        bottom \
        github-cli \
        fd \
        ripgrep \
        broot \
        tmux \
        neovim \
        kail \
        k9s \
        kapp-bin \
        krew \
        kubectl \
        kubectl-cnpg \
        kubectl-neat \
        kubectl-view-secret-bin \
        kubectx \
        kubelogin \
        helm \
        kustomize \
        helix \
        bash-language-server \
        gopls \
        lua-language-server \
        python-lsp-server \
        rust-analyzer \
        yaml-language-server \
        typescript-language-server \
        vscode-json-languageserver \
        --noconfirm
USER root
WORKDIR /

# Cleanup
RUN userdel -r build && \
    rm -drf /home/build && \
    sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    rm -rf /home/build/.cache/* && \
    rm -rf \
        /tmp/* \
        /var/cache/pacman/pkg/*
