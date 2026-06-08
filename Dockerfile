FROM python:3.12-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Create uploads directory
RUN mkdir -p static/uploads/avatars static/uploads/carousels static/uploads/events

# Make startup script executable
RUN chmod +x start.sh

# Expose port
EXPOSE 5000

# Run startup script (creates DB, then starts gunicorn)
CMD ["./start.sh"]
