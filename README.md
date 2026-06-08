# Web Template

Reusable, lightweight web template built with **Flask + Alpine.js + Tailwind CSS**.

## Stack
- **Backend:** Python Flask + SQLAlchemy (SQLite)
- **Frontend:** Tailwind CSS (CDN) + Alpine.js
- **Security:** Flask-WTF (CSRF), Flask-Login (auth), Flask-Limiter (rate limit), Flask-Talisman (headers)
- **Carousel:** Splide.js
- **Deploy:** Docker + Gunicorn

## Quick Start

```bash
# 1. Clone and setup
cp .env.example .env
# Edit .env with your SECRET_KEY

# 2. Install dependencies
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# 3. Run
python app.py
# → http://localhost:5000
```

## Docker

```bash
cp .env.example .env
docker compose up -d
```

## Project Structure

```
├── app.py              # Flask app factory
├── config.py           # Configuration classes
├── models.py           # SQLAlchemy models (User, Event, Carousel)
├── routes/
│   ├── auth.py         # Login, register, profile
│   ├── main.py         # Homepage, events
│   └── api.py          # AJAX endpoints
├── templates/
│   ├── base.html       # Base layout
│   ├── index.html      # Homepage
│   ├── auth/           # Login, register, profile
│   └── components/     # Navbar, footer, carousel
├── static/
│   ├── css/style.css   # Custom styles
│   ├── js/app.js       # Alpine.js components
│   └── uploads/        # User uploads
├── Dockerfile
└── docker-compose.yml
```

## Customization

1. **Brand color:** Edit `primary` in `tailwind.config` inside `base.html`
2. **Fonts:** Change Google Fonts link in `base.html`
3. **App name:** Set `APP_NAME` in `.env`
4. **Database:** Change `DATABASE_URL` in `.env` (default: SQLite)

## Security Features

- CSRF protection on all forms (Flask-WTF)
- Server-side session management (Flask-Login)
- Rate limiting on auth endpoints (Flask-Limiter)
- Security headers: CSP, HSTS, X-Frame-Options (Flask-Talisman)
- Password hashing with Werkzeug (bcrypt-compatible)
- Parameterized queries via SQLAlchemy (no SQL injection)
