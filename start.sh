#!/bin/bash

# This script will be run by our .gitpod.yml file

# Start essential services in the background
# We add 'sudo' because tailscaled needs root permissions
sudo tailscaled &
vncserver -geometry 1280x720 :1 &

# Bring this machine online with Tailscale
# The '|| true' part prevents the workspace from stopping if you don't auth quickly
sudo tailscale up || true

# --- AUTOMATION SCRIPT ---
echo "-----------------------------------------------------"
echo "          WAITING FOR TAILSCALE IP...                "
echo "-----------------------------------------------------"
# Loop until the Tailscale IP is available
while [ -z "$(tailscale ip -4 2>/dev/null)" ]; do sleep 1; done

# Get the IP address
IP_ADDRESS=$(tailscale ip -4)

echo ""
echo "-----------------------------------------------------"
echo "           READY TO CONNECT!"
echo ""
echo "    Your VNC Address is: $IP_ADDRESS"
echo "    Or scan the QR code below with your phone's camera"
echo "-----------------------------------------------------"
echo ""

# Generate the VNC deep link and display it as a QR code
qrencode -t ANSIUTF8 "vnc://$IP_ADDRESS"

echo ""
echo "-----------------------------------------------------"
echo "This terminal will keep running. You can now connect."
# Keep the terminal alive so the workspace doesn't stop
sleep infinity
