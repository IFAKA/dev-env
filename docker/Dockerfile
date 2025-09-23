# Universal Development Environment - Docker Image
# Provides insulated environment for building and testing

FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Basic tools
    curl \
    wget \
    git \
    vim \
    nano \
    htop \
    tree \
    unzip \
    zip \
    # Build tools
    build-essential \
    cmake \
    pkg-config \
    # Node.js dependencies
    ca-certificates \
    gnupg \
    lsb-release \
    # Python dependencies
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    # Development tools
    neovim \
    fzf \
    ripgrep \
    bat \
    exa \
    lazygit \
    taskwarrior \
    httpie \
    # Network tools
    net-tools \
    iputils-ping \
    dnsutils \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install NVM for multiple Node.js versions
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR="/root/.nvm"
RUN . "$NVM_DIR/nvm.sh" && nvm install 14 && nvm install 18 && nvm install 20

# Install global npm packages
RUN npm install -g \
    typescript \
    typescript-language-server \
    eslint \
    prettier \
    dwupload \
    leetcode-cli

# Install Python packages
RUN pip3 install --upgrade pip && \
    pip3 install \
    jupyter \
    ipykernel \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    plotly \
    scikit-learn \
    tensorflow \
    torch \
    requests \
    beautifulsoup4

# Create development user
RUN useradd -m -s /bin/bash dev && \
    usermod -aG sudo dev && \
    echo 'dev ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create development directories
RUN mkdir -p /home/dev/workspace \
    /home/dev/.config/nvim \
    /home/dev/.local/share/nvim \
    /home/dev/.cache/nvim

# Copy Neovim configuration
COPY configs/nvim/ /home/dev/.config/nvim/
RUN chown -R dev:dev /home/dev/

# Set up shell environment
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /home/dev/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/dev/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /home/dev/.bashrc

# Create development scripts
COPY scripts/docker/ /home/dev/scripts/
RUN chmod +x /home/dev/scripts/*.sh && \
    chown -R dev:dev /home/dev/scripts/

# Expose common development ports
EXPOSE 3000 3001 4000 5000 8000 8080 9000

# Set working directory
WORKDIR /home/dev/workspace

# Switch to development user
USER dev

# Set default command
CMD ["/bin/bash"]
