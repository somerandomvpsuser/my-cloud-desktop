# Use a standard Gitpod image as our starting point
FROM gitpod/workspace-full

# Switch to the 'root' user to get permissions to install software
USER root

# --- THIS IS THE FIX ---
# Set the DEBIAN_FRONTEND variable to 'noninteractive'.
# This prevents the package installer (apt-get) from asking any
# interactive questions (like keyboard layout) that would hang the build.
ENV DEBIAN_FRONTEND=noninteractive

# Update software lists and install our required packages
# No changes are needed here; the ENV command above applies to this RUN instruction.
RUN apt-get update && \
    apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    qrencode \
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
