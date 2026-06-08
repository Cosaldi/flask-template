# 🧠 Web Server & Python Web — Learning Notes

> Notes for learning how web servers, WSGI, Flask, and the full stack work.
> Created: June 2026

---

## Table of Contents
1. [How a Web Request Works](#1-how-a-web-request-works)
2. [WSGI — Web Server Gateway Interface](#2-wsgi)
3. [Gunicorn — WSGI HTTP Server](#3-gunicorn)
4. [Flask — Web Framework](#4-flask)
5. [Jinja2 — Template Engine](#5-jinja2)
6. [SQLAlchemy — ORM](#6-sqlalchemy)
7. [Reverse Proxy (Nginx/Caddy)](#7-reverse-proxy)
8. [Docker & Containerization](#8-docker)
9. [Security Concepts](#9-security-concepts)

---

## 1. How a Web Request Works

```
User Browser
     ↓ (HTTP request)
Reverse Proxy (Nginx/Caddy)     ← handles HTTPS, static files
     ↓
WSGI Server (Gunicorn)          ← manages worker processes
     ↓
Flask App (your Python code)    ← routes, logic, templates
     ↓
Database (SQLite/PostgreSQL)    ← stores data
```

**Key insight:** Flask alone cannot handle production traffic. It needs a
WSGI server (like Gunicorn) to manage multiple requests at once.

### 📺 Videos
- **"How the Web Works"** — Tech With Tim
  https://www.youtube.com/watch?v=Q33KBi2iti4
- **"HTTP & Web Servers"** — CS50 (Harvard)
  https://www.youtube.com/watch?v=z4SNFF3MfQI

---

## 2. WSGI — Web Server Gateway Interface

**What is it?**
WSGI is a standard (PEP 3333) that defines how Python web apps communicate
with web servers. Think of it as a "plug" standard — any WSGI server can
run any WSGI app.

**Why does it exist?**
Before WSGI, every web framework had its own server. WSGI unified them so
you can swap servers without changing your app code.

**How it works:**
```python
# A WSGI application is just a callable:
def application(environ, start_response):
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [b'<h1>Hello World</h1>']

# environ = request data (URL, headers, method)
# start_response = function to send status + headers
# return = response body (bytes)
```

**Flask IS a WSGI app.** When you write:
```python
app = Flask(__name__)
```
You're creating a WSGI-compliant application.

### 📺 Videos
- **"WSGI Explained"** — Pretty Printed
  https://www.youtube.com/watch?v=WqrCnVAkldo
- **"Python WSGI Tutorial"** — Corey Schafer
  https://www.youtube.com/watch?v=ORg1THA2k3c

### 📖 Reading
- PEP 3333 (official spec): https://peps.python.org/pep-3333/
- Flask docs on deployment: https://flask.palletsprojects.com/en/stable/deploying/

---

## 3. Gunicorn — WSGI HTTP Server

**What is it?**
Gunicorn (Green Unicorn) is a production WSGI server. It:
- Listens on a port (e.g., 5000)
- Manages multiple worker processes
- Routes incoming requests to your Flask app

**Workers explained:**
```
Gunicorn Master Process
  ├── Worker 1 (handles request A)
  ├── Worker 2 (handles request B)
  ├── Worker 3 (handles request C)
  └── Worker 4 (handles request D)
```

More workers = more concurrent requests. But each worker uses memory.

**Our config:**
```bash
gunicorn --bind 0.0.0.0:5000 --workers 2 --threads 4 app:create_app()
```
- `--bind 0.0.0.0:5000` — listen on all interfaces, port 5000
- `--workers 2` — 2 worker processes
- `--threads 4` — each worker has 4 threads (hybrid model)
- `app:create_app()` — import `create_app` from `app.py` and call it

**Why not just `python app.py`?**
Flask's built-in server is single-threaded and not secure for production.
Gunicorn handles concurrency, graceful restarts, and process management.

### 📺 Videos
- **"Gunicorn Explained"** — Tech With Tim
  https://www.youtube.com/watch?v=i1c-8YyFOCM
- **"Deploy Flask with Gunicorn"** — Corey Schafer
  https://www.youtube.com/watch?v=goToXTCUT6c

### 📖 Reading
- Gunicorn docs: https://docs.gunicorn.org/en/stable/

---

## 4. Flask — Web Framework

**What is it?**
Flask is a micro web framework for Python. "Micro" means it doesn't force
you to use a specific database, template engine, or structure.

**Core concepts:**

### Routes
```python
@app.route('/')           # URL path
def index():              # function name = route name
    return 'Hello!'       # response
```

### Blueprints
Organize routes into groups (like modules):
```python
auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/login')
def login():
    return 'Login page'

# In app.py:
app.register_blueprint(auth_bp)
```

This is why our project has `routes/auth.py`, `routes/main.py`, etc.

### Application Factory
```python
def create_app(config_name='default'):
    app = Flask(__name__)
    # configure, register blueprints, etc.
    return app
```
This pattern lets you create multiple instances (for testing, etc.)

### 📺 Videos
- **"Flask Tutorial"** — Corey Schafer (full series)
  https://www.youtube.com/playlist?list=PL-osiE80TeTs4UjLw5MM6OjgkjFeUxCYH
- **"Flask in 15 minutes"** — Tech With Tim
  https://www.youtube.com/watch?v=Z1RJmh_OqeA

### 📖 Reading
- Flask docs: https://flask.palletsprojects.com/
- Flask mega-tutorial: https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-i-hello-world

---

## 5. Jinja2 — Template Engine

**What is it?**
Jinja2 generates HTML by combining templates with data.

**Syntax:**
```html
<!-- Variables -->
<h1>{{ user.username }}</h1>

<!-- Logic -->
{% if user.is_admin %}
    <span>Admin</span>
{% endif %}

<!-- Loops -->
{% for item in items %}
    <li>{{ item }}</li>
{% endfor %}

<!-- Template inheritance -->
{% extends 'base.html' %}
{% block content %}
    <p>This goes inside base.html's content block</p>
{% endblock %}
```

**Why template inheritance?**
`base.html` has the navbar, footer, CSS links. Child templates only define
the unique content. No code duplication.

**Auto-escaping:**
Jinja2 automatically escapes `{{ variable }}` so `<script>` tags in user
input become `&lt;script&gt;` — prevents XSS attacks.

### 📺 Videos
- **"Jinja2 Templates"** — Corey Schafer
  https://www.youtube.com/watch?v=OgS1B9SV4wI
- **"Template Inheritance"** — Pretty Printed
  https://www.youtube.com/watch?v=Fnk5H0VMfF4

### 📖 Reading
- Jinja2 docs: https://jinja.palletsprojects.com/

---

## 6. SQLAlchemy — ORM

**What is it?**
ORM = Object-Relational Mapping. It lets you write Python instead of SQL.

**Instead of this SQL:**
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    username VARCHAR(80) NOT NULL,
    email VARCHAR(120) NOT NULL
);
INSERT INTO users (username, email) VALUES ('john', 'john@mail.com');
SELECT * FROM users WHERE username = 'john';
```

**You write this Python:**
```python
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), nullable=False)
    email = db.Column(db.String(120), nullable=False)

# Create
user = User(username='john', email='john@mail.com')
db.session.add(user)
db.session.commit()

# Read
user = User.query.filter_by(username='john').first()
```

**Why use it?**
- No raw SQL (prevents SQL injection)
- Database-agnostic (switch SQLite → PostgreSQL easily)
- Pythonic syntax

**SQLite vs PostgreSQL:**
- SQLite: file-based, no server, good for dev/small apps
- PostgreSQL: full server, better for production/concurrency

### 📺 Videos
- **"SQLAlchemy Tutorial"** — Corey Schafer
  https://www.youtube.com/playlist?list=PL-osiE80TeTsKOdPrKeSOp4rN3mza8VHN
- **"ORM Explained"** — Tech With Tim
  https://www.youtube.com/watch?v=QsY88j8T5aQ

### 📖 Reading
- SQLAlchemy docs: https://docs.sqlalchemy.org/
- Flask-SQLAlchemy: https://flask-sqlalchemy.palletsprojects.com/

---

## 7. Reverse Proxy (Nginx/Caddy)

**What is it?**
A reverse proxy sits in front of your app and handles:
- HTTPS (SSL certificates)
- Static files (CSS, JS, images)
- Load balancing (multiple app instances)
- Rate limiting

```
Internet → Nginx (port 443, HTTPS) → Gunicorn (port 5000, HTTP)
```

**Why needed?**
- Gunicorn doesn't handle HTTPS
- Nginx is faster at serving static files
- Adds a security layer

**Nginx vs Caddy:**
- Nginx: most popular, manual SSL config
- Caddy: auto HTTPS, simpler config, Go-based

### 📺 Videos
- **"Nginx Explained"** — TechWorld with Nana
  https://www.youtube.com/watch?v=JKxlsvZXG7c
- **"Caddy Server Tutorial"** — Techno Tim
  https://www.youtube.com/watch?v=S0FkUVkL5Mo

### 📖 Reading
- Nginx docs: https://nginx.org/en/docs/
- Caddy docs: https://caddyserver.com/docs/

---

## 8. Docker & Containerization

**What is it?**
Docker packages your app + dependencies into a "container" that runs
identically everywhere.

**Dockerfile explained:**
```dockerfile
FROM python:3.12-slim    # Base image (Python 3.12)
WORKDIR /app             # Set working directory
COPY requirements.txt .  # Copy dependency list
RUN pip install -r requirements.txt  # Install deps
COPY . .                 # Copy app code
EXPOSE 5000              # Document the port
CMD ["./start.sh"]       # Command to run
```

**Docker Compose:**
```yaml
services:
  web:
    build: .              # Build from Dockerfile
    ports:
      - "5000:5000"       # Map container port to host
    volumes:
      - ./instance:/app/instance  # Persist database
```

**Why Docker?**
- "Works on my machine" → works everywhere
- Isolated environment
- Easy deployment (Fly.io, Railway, etc.)

### 📺 Videos
- **"Docker Tutorial"** — TechWorld with Nana
  https://www.youtube.com/watch?v=3c-iBn73dDE
- **"Docker Compose"** — NetworkChuck
  https://www.youtube.com/watch?v=DM65_J9GdXY

### 📖 Reading
- Docker docs: https://docs.docker.com/
- Dockerfile reference: https://docs.docker.com/engine/reference/builder/

---

## 9. Security Concepts

### CSRF (Cross-Site Request Forgery)
**Problem:** A malicious site can submit forms on behalf of your users.
**Fix:** Every form gets a unique token. Server verifies it.

```html
<form method="POST">
    {{ form.hidden_tag() }}  <!-- adds CSRF token -->
    ...
</form>
```

### XSS (Cross-Site Scripting)
**Problem:** User injects `<script>` into your site.
**Fix:** Jinja2 auto-escapes `{{ variables }}`. CSP headers block inline scripts.

### SQL Injection
**Problem:** User inputs `'; DROP TABLE users; --` into a form.
**Fix:** SQLAlchemy uses parameterized queries. Never use f-strings in SQL.

### Password Hashing
**Problem:** Storing passwords in plaintext.
**Fix:** Use `werkzeug.security.generate_password_hash()` — one-way hash.

```python
# Store
user.password_hash = generate_password_hash('mypassword')

# Verify
check_password_hash(user.password_hash, 'mypassword')  # True
```

### CSP (Content Security Policy)
**Problem:** Malicious scripts injected into your page.
**Fix:** HTTP header tells browser which sources are allowed.

```python
Talisman(app, content_security_policy={
    'script-src': "'self' https://cdn.jsdelivr.net",
    'style-src': "'self' 'unsafe-inline'",
})
```

### 📺 Videos
- **"Web Security Explained"** — Computerphile
  https://www.youtube.com/watch?v=0q5j9l2M7Eg
- **"CSRF, XSS, SQL Injection"** — LiveOverflow
  https://www.youtube.com/watch?v=L5l9lSn0Ug4

### 📖 Reading
- OWASP Top 10: https://owasp.org/www-project-top-ten/
- Flask security: https://flask.palletsprojects.com/en/stable/security/

---

## Quick Reference: Our Project Stack

```
Layer               Tool                Role
─────────────────────────────────────────────────
WSGI Server         Gunicorn            Manages workers, handles HTTP
Web Framework       Flask               Routes, logic, config
Template Engine     Jinja2              HTML generation
ORM                 SQLAlchemy          Database abstraction
Auth                Flask-Login         Session management
CSRF                Flask-WTF           Form security
Rate Limit          Flask-Limiter       Abuse prevention
Headers             Flask-Talisman      Security headers
Frontend JS         Alpine.js           Interactivity (no jQuery)
CSS                 Tailwind CSS        Utility-first styling
Database            SQLite              File-based DB
Container           Docker              Packaging & deployment
Cloud               Fly.io              Hosting
```

---

## Recommended Learning Path

1. **Start here:** How the Web Works (CS50 video)
2. **Then:** Flask basics (Corey Schafer series)
3. **Then:** Templates with Jinja2
4. **Then:** Database with SQLAlchemy
5. **Then:** Gunicorn + deployment
6. **Then:** Docker basics
7. **Then:** Security (OWASP Top 10)
8. **Then:** Nginx/Caddy reverse proxy

---

*Last updated: June 2026*
