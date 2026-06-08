#!/bin/bash
# Fly.io Deployment Script for web-template
# Run this on your local machine

set -e

echo "=== Fly.io Deployment ==="

# 1. Install flyctl
echo "[1/7] Installing flyctl..."
curl -L https://fly.io/install.sh | sh

# 2. Add to PATH
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# Check if logged in
if ! fly auth whoami &>/dev/null; then
    echo "[2/7] Please sign up or login..."
    fly auth signup || fly auth login
else
    echo "[2/7] Already logged in as $(fly auth whoami)"
fi

# 3. Generate SECRET_KEY if not set
if [ -z "$SECRET_KEY" ]; then
    SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")
    echo "[3/7] Generated SECRET_KEY"
else
    echo "[3/7] Using existing SECRET_KEY"
fi

# 4. Set secrets
echo "[4/7] Setting secrets on Fly.io..."
fly secrets set SECRET_KEY="$SECRET_KEY"

# 5. Deploy
echo "[5/7] Deploying..."
fly launch --copy-config --yes

echo ""
echo "=== Done! ==="
echo "Your app is live at: https://web-template.fly.dev"
echo "Share this URL with your friends!"
