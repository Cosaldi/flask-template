# Deployment Guide

## Render.com (Current)

**Live URL:** https://flask-test-9fzb.onrender.com/

### How to Deploy
1. Push code to GitHub: `https://github.com/cosaldi/flask-template`
2. Render auto-deploys from `render.yaml`
3. Free tier — sleeps after 15min inactivity (~30s cold start)

### Useful Commands
```bash
# View logs on Render dashboard
# https://dashboard.render.com

# Redeploy (after pushing to GitHub)
git add .
git commit -m "your changes"
git push origin main
# Render auto-deploys on push
```

---

## Fly.io (Alternative)

```bash
fly auth login
fly deploy
fly status
fly logs
```

---

## Docker (Local / armbian)

```bash
cp .env.example .env
# Edit .env with a real SECRET_KEY
docker compose up -d
# Access at http://localhost:5000
```

---

## Generate SECRET_KEY

```bash
python3 -c "import secrets; print(secrets.token_hex(32))"
```
