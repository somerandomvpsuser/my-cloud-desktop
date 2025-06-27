# Use a standard Gitpod image as our starting point
FROM gitpod/workspace-full

# Switch to the 'root' user to get permissions to install software
USER root

# Update the list of available software and install our required packages
# This installs the desktop (xfce4), VNC server, and tools for installing Chrome
RUN apt-get update && \
    apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Download and Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmour -o /usr/share/keyrings/chrome-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable --no-install-recommends

# Install Tailscale for our secure connection
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | apt-key add - && \
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && \
    apt-get install -y tailscale

# Switch back to the standard, non-root 'gitpod' user
USER gitpod
