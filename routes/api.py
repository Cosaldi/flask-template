from flask import Blueprint, jsonify, request
from flask_login import login_required, current_user
from flask_wtf.csrf import validate_csrf

from models import db, User

api_bp = Blueprint('api', __name__)


@api_bp.route('/health')
def health():
    """Health check endpoint."""
    return jsonify({'status': 'ok'})


@api_bp.route('/profile', methods=['PUT'])
@login_required
def update_profile():
    """Update current user's profile via AJAX."""
    try:
        validate_csrf(request.headers.get('X-CSRFToken'))
    except Exception:
        return jsonify({'error': 'Invalid CSRF token'}), 403

    data = request.get_json()
    if not data:
        return jsonify({'error': 'No data provided'}), 400

    if 'username' in data:
        existing = User.query.filter(User.username == data['username'], User.id != current_user.id).first()
        if existing:
            return jsonify({'error': 'Username already taken'}), 400
        current_user.username = data['username']

    db.session.commit()
    return jsonify({'message': 'Profile updated', 'username': current_user.username})
