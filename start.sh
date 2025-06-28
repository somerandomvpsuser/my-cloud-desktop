#!/bin/bash

# This script will be run by our .gitpod.yml file

# Set a VNC password non-interactively.
# The password you will use to connect is "gitpod".
mkdir -p ~/.vnc
echo "gitpod" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Start essential services in the background
sudo tailscaled &

# --- FIX ---
# Start the VNC Server.
# The "-localhost no" option was causing an "Unrecognized option: no" error.
# It has been removed. We also explicitly point to the password file for robustness.
vncserver -geometry 1280x720 -rfbauth ~/.vnc/passwd :1 &

# Bring this machine online with Tailscale
# We add a small sleep to give the vncserver a moment to start
sleep 2
sudo tailscale up || true

# --- AUTOMATION SCRIPT ---
echo "-----------------------------------------------------"
echo "          WAITING FOR TAILSCALE IP...                "
echo "-----------------------------------------------------"
while [ -z "$(tailscale ip -4 2>/dev/null)" ]; do sleep 1; done
IP_ADDRESS=$(tailscale ip -4)

echo ""
echo "-----------------------------------------------------"
echo "           READY TO CONNECT!"
echo ""
echo "    Your VNC Address is: $IP_ADDRESS:5901"
echo "    Your VNC Password is: gitpod"
echo "    Or scan the QR code below with your phone's camera"
echo "-----------------------------------------------------"
echo ""

qrencode -t ANSIUTF8 "vnc://$IP_ADDRESS:5901"

echo ""
echo "-----------------------------------------------------"
echo "This terminal will keep running. You can now connect."
sleep infinity
