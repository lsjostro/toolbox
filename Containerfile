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
        nix \
        xdg-user-dirs \
        noto-fonts-cjk \
        glibc-locales \
        openssh \
        podman \
        systemd \
        shellcheck \
        fuse-overlayfs \
        ghostty \
        --noconfirm && \
    pacman -U \
      https://archive.archlinux.org/packages/m/mesa/mesa-1%3A26.0.1-1-x86_64.pkg.tar.zst \
      https://archive.archlinux.org/packages/l/llvm-libs/llvm-libs-21.1.8-1-x86_64.pkg.tar.zst \
      https://archive.archlinux.org/packages/l/lib32-llvm-libs/lib32-llvm-libs-1%3A21.1.8-1-x86_64.pkg.tar.zst \
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
RUN paru -Sy \
        fish \
        jujutsu \
        git \
        procs \
        jless \
        git-delta \
        difftastic \
        git-get \
        git-graph \
        git-credential-oauth \
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
        pass \
        github-cli \
        fd \
        ripgrep \
        broot \
        bats \
        bats-assert \
        bats-support \
        tmux \
        zellij \
        neovim \
        k9s \
        kapp-bin \
        krew \
        kubectl \
        kubectl-cnpg \
        kubectl-view-secret-bin \
        kubectx \
        kubelogin \
        kubeseal \
        dyff-bin \
        argocd \
        fluxcd \
        istio \
        helm \
        helmfile \
        kustomize \
        talosctl \
        crane \
        helix \
        bash-language-server \
        gopls \
        lua-language-server \
        python-lsp-server \
        taplo-cli \
        typos-lsp \
        rust-analyzer \
        yaml-language-server \
        typescript-language-server \
        vscode-json-languageserver \
        yq \
        --noconfirm && \
        curl -L https://github.com/nickel-lang/nickel/releases/download/1.16.0/nickel-x86_64-linux -o /usr/bin/nickel && \
        curl -L https://github.com/nickel-lang/nickel/releases/download/1.16.0/nls-x86_64-linux -o /usr/bin/nls && \
        chmod +x /usr/bin/nickel /usr/bin/nls
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
