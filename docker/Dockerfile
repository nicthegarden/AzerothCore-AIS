FROM debian:trixie-slim

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    sudo \
    tmux \
    nano \
    vim \
    net-tools \
    iputils-ping \
    mariadb-server \
    mariadb-client \
    build-essential \
    cmake \
    clang \
    libssl-dev \
    libmariadb-dev \
    libace-dev \
    libcurl4-openssl-dev \
    libbz2-dev \
    libreadline-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /azerothcore

# Copy the installation script
COPY install.sh /usr/local/bin/install-azerothcore
RUN chmod +x /usr/local/bin/install-azerothcore

# Copy entrypoint
COPY docker-entrypoint-local.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose WoW server ports
EXPOSE 3724 8085

# Expose MySQL port (optional)
EXPOSE 3306

# Set environment variables
ENV INSTALL_DIR=/azerothcore
ENV REALM_NAME="AzerothCore Docker"
ENV SERVER_IP="0.0.0.0"
ENV ACORE_USER=acore
ENV ACORE_PASS=acore

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5m --retries=3 \
    CMD nc -z localhost 8085 || exit 1

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["interactive"]
