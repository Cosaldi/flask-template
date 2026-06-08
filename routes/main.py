from flask import Blueprint, render_template, redirect, url_for, flash, request
from flask_login import login_user, logout_user, login_required, current_user

from models import db, User, Event, Carousel

main_bp = Blueprint('main', __name__)


@main_bp.route('/')
def index():
    """Homepage."""
    events = Event.query.filter_by(is_published=True).order_by(Event.event_date.desc()).limit(6).all()
    carousels = Carousel.query.filter_by(is_active=True).order_by(Carousel.sort_order).all()
    return render_template('index.html', events=events, carousels=carousels)


@main_bp.route('/events')
def events():
    """Events listing page."""
    page = request.args.get('page', 1, type=int)
    events = Event.query.filter_by(is_published=True).order_by(
        Event.event_date.desc()
    ).paginate(page=page, per_page=9)
    return render_template('events.html', events=events)


@main_bp.route('/events/<int:event_id>')
def event_detail(event_id):
    """Single event page."""
    event = Event.query.get_or_404(event_id)
    return render_template('event_detail.html', event=event)
