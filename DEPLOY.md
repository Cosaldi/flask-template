# Fly.io Deployment Guide

## Prerequisites
- Fly.io account (sign up at https://fly.io)
- Credit card on file (free tier won't charge)

## Steps

```bash
# 1. Install flyctl
curl -L https://fly.io/install.sh | sh

# 2. Add to PATH (add to ~/.bashrc for persistence)
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# 3. Sign up (opens browser)
fly auth signup

# 4. Login
fly auth login

# 5. Go to project
cd /home/cosaldi/Public/armbian-hdd0/idlasoc/hermes-agent/hermes/developer/web-template

# 6. Generate a secret key
python3 -c "import secrets; print(secrets.token_hex(32))"

# 7. Set the secret on Fly.io
fly secrets set SECRET_KEY=your-generated-key-here

# 8. Deploy!
fly launch --copy-config --yes
```

## After Deploy
- Your app will be at: `https://web-template.fly.dev`
- Share this URL with friends

## Useful Commands
```bash
fly status          # Check app status
fly logs            # View logs
fly ssh console     # SSH into the container
fly deploy          # Redeploy after changes
fly scale memory 512  # Increase memory if needed
```
