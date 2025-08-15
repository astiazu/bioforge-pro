from datetime import datetime
from enum import Enum

from app import db
from flask_dance.consumer.storage.sqla import OAuthConsumerMixin
from flask_login import UserMixin
from sqlalchemy import UniqueConstraint


# User roles enum
class UserRole(Enum):
    USER = "user"
    ADMIN = "admin"


# Note status enum
class NoteStatus(Enum):
    PRIVATE = "private"      # Solo visible para el creador
    PENDING = "pending"      # Pendiente de aprobación del admin
    PUBLISHED = "published"  # Publicada y visible para todos


# (IMPORTANT) This table is mandatory for Replit Auth, don't drop it.
class User(UserMixin, db.Model):
    __tablename__ = 'users'
    id = db.Column(db.String, primary_key=True)
    email = db.Column(db.String, unique=True, nullable=True)
    first_name = db.Column(db.String, nullable=True)
    last_name = db.Column(db.String, nullable=True)
    profile_image_url = db.Column(db.String, nullable=True)
    role = db.Column(db.Enum(UserRole), default=UserRole.USER, nullable=False)

    created_at = db.Column(db.DateTime, default=datetime.now)
    updated_at = db.Column(db.DateTime,
                           default=datetime.now,
                           onupdate=datetime.now)

    # Relationships
    notes = db.relationship('Note', backref='author', lazy=True, cascade='all, delete-orphan')
    publications = db.relationship('Publication', backref='author', lazy=True, cascade='all, delete-orphan')

    def is_admin(self):
        return self.role == UserRole.ADMIN
    
    @property
    def full_name(self):
        if self.first_name and self.last_name:
            return f"{self.first_name} {self.last_name}"
        elif self.first_name:
            return self.first_name
        elif self.last_name:
            return self.last_name
        else:
            return self.email or f"Usuario {self.id[:8]}"


# (IMPORTANT) This table is mandatory for Replit Auth, don't drop it.
class OAuth(OAuthConsumerMixin, db.Model):
    user_id = db.Column(db.String, db.ForeignKey(User.id))
    browser_session_key = db.Column(db.String, nullable=False)
    user = db.relationship(User)

    __table_args__ = (UniqueConstraint(
        'user_id',
        'browser_session_key',
        'provider',
        name='uq_user_browser_session_key_provider',
    ),)


# Notes model
class Note(db.Model):
    __tablename__ = 'notes'
    
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    content = db.Column(db.Text, nullable=False)
    status = db.Column(db.Enum(NoteStatus), default=NoteStatus.PRIVATE, nullable=False)
    
    # Foreign key to user
    user_id = db.Column(db.String, db.ForeignKey('users.id'), nullable=False)
    
    # Approval tracking
    approved_by = db.Column(db.String, db.ForeignKey('users.id'), nullable=True)
    approved_at = db.Column(db.DateTime, nullable=True)
    
    # Timestamps
    created_at = db.Column(db.DateTime, default=datetime.now, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now, nullable=False)
    
    # Relationships
    approver = db.relationship('User', foreign_keys=[approved_by])
    
    def can_edit(self, user):
        """Check if user can edit this note"""
        return user.is_admin() or user.id == self.user_id
    
    def can_view(self, user):
        """Check if user can view this note"""
        if self.status == NoteStatus.PUBLISHED:
            return True
        elif self.status == NoteStatus.PENDING:
            return user.is_admin() or user.id == self.user_id
        else:  # PRIVATE
            return user.id == self.user_id
    
    @property
    def status_display(self):
        status_map = {
            NoteStatus.PRIVATE: "Privada",
            NoteStatus.PENDING: "Pendiente",
            NoteStatus.PUBLISHED: "Publicada"
        }
        return status_map.get(self.status, "Desconocido")
    
    @property
    def status_class(self):
        """CSS class for status badge"""
        class_map = {
            NoteStatus.PRIVATE: "bg-secondary",
            NoteStatus.PENDING: "bg-warning text-dark",
            NoteStatus.PUBLISHED: "bg-success"
        }
        return class_map.get(self.status, "bg-secondary")


# Publications model
class Publication(db.Model):
    __tablename__ = 'publications'
    
    id = db.Column(db.Integer, primary_key=True)
    type = db.Column(db.String(50), nullable=False)  # Educativo, Caso de éxito, etc.
    title = db.Column(db.String(200), nullable=False)
    content = db.Column(db.Text, nullable=False)
    excerpt = db.Column(db.String(500), nullable=True)  # Resumen corto
    is_published = db.Column(db.Boolean, default=True, nullable=False)
    
    # Foreign key to user (author)
    user_id = db.Column(db.String, db.ForeignKey('users.id'), nullable=False)
    
    # SEO and metadata
    tags = db.Column(db.String(200), nullable=True)  # Comma-separated tags
    read_time = db.Column(db.Integer, nullable=True)  # Estimated read time in minutes
    
    # Timestamps
    created_at = db.Column(db.DateTime, default=datetime.now, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now, nullable=False)
    published_at = db.Column(db.DateTime, nullable=True)
    
    def can_edit(self, user):
        """Check if user can edit this publication"""
        return user.is_admin() or user.id == self.user_id
    
    @property
    def type_icon(self):
        """Get Font Awesome icon for publication type"""
        icon_map = {
            "Educativo": "fa-graduation-cap",
            "Caso de éxito": "fa-trophy",
            "Autoridad técnica": "fa-star",
            "Tutorial": "fa-book",
            "Análisis": "fa-chart-line"
        }
        return icon_map.get(self.type, "fa-file-alt")
    
    @property
    def type_color(self):
        """Get color class for publication type"""
        color_map = {
            "Educativo": "text-info",
            "Caso de éxito": "text-success",
            "Autoridad técnica": "text-warning",
            "Tutorial": "text-primary",
            "Análisis": "text-danger"
        }
        return color_map.get(self.type, "text-secondary")
    
    @property
    def tag_list(self):
        """Get list of tags"""
        if self.tags:
            return [tag.strip() for tag in self.tags.split(',') if tag.strip()]
        return []