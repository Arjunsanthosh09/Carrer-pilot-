from flask import Blueprint, render_template
from flask_login import login_required

officer_bp = Blueprint('officer', __name__)

@officer_bp.route('/dashboard')
@login_required
def dashboard():
    return render_template('officer/dashboard.html')    