# app/models.py
import json
from datetime import datetime
from enum import Enum
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from app import db

class UserRole(Enum):
    USER = "user"
    ADMIN = "admin"

class NoteStatus(str, Enum):
    PRIVATE = "private"
    PENDING = "pending"
    PUBLISHED = "published"

class Note(db.Model):
    __tablename__ = "notes"
    
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    content = db.Column(db.Text, nullable=False)
    status = db.Column(db.String(20), default=NoteStatus.PRIVATE, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    patient_id = db.Column(db.Integer, db.ForeignKey("users.id"))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    approved_by = db.Column(db.Integer, db.ForeignKey("users.id"))
    approved_at = db.Column(db.DateTime)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    
    # ✅ Campos nuevos
    featured_image = db.Column(db.String(200), nullable=True)
    view_count = db.Column(db.Integer, default=0)
    
    # Relaciones
    author = db.relationship("User", foreign_keys=[user_id], back_populates="authored_notes")
    patient = db.relationship("User", foreign_keys=[patient_id], back_populates="received_notes")
    approved_by_user = db.relationship("User", foreign_keys=[approved_by], back_populates="approved_notes")

    def can_edit(self, user):
        return user.is_admin_user or user.id == self.user_id

    def can_view(self, user):
        if self.status == NoteStatus.PUBLISHED:
            return True
        if user.is_authenticated and (self.user_id == user.id or user.is_admin):
            return True
        return False
    
    @property
    def status_display(self):
        return {
            NoteStatus.PRIVATE: "Privada",
            NoteStatus.PENDING: "Pendiente",
            NoteStatus.PUBLISHED: "Publicada"
        }.get(self.status, "Desconocido")

    @property
    def status_class(self):
        return {
            NoteStatus.PRIVATE: "bg-secondary",
            NoteStatus.PENDING: "bg-warning text-dark",
            NoteStatus.PUBLISHED: "bg-success"
        }.get(self.status, "bg-secondary")

class User(UserMixin, db.Model):
    __tablename__ = "users"
    
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(100), unique=True, nullable=False)
    email = db.Column(db.String(150), unique=True, nullable=False)
    password_hash = db.Column(db.String(200), nullable=False)
    is_admin = db.Column(db.Boolean, default=False, nullable=False)
    is_professional = db.Column(db.Boolean, default=False, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    url_slug = db.Column(db.String(100), unique=True, nullable=True)
    
    # ✅ Campos para perfil profesional
    professional_category = db.Column(db.String(50))
    specialty = db.Column(db.String(100))
    bio = db.Column(db.Text)
    years_experience = db.Column(db.Integer)
    profile_photo = db.Column(db.String(200))
    license_number = db.Column(db.String(100))
    services = db.Column(db.Text)
    skills = db.Column(db.Text)
    
    # ✅ RENOMBRADO: evita conflicto con relación role_obj
    role_name = db.Column(db.String(50), default="user")  # "user", "assistant", etc.
    
    # ✅ FK a UserRole
    role_id = db.Column(db.Integer, db.ForeignKey("user_roles.id"), nullable=True)
    
    # ✅ RELACIONES PRINCIPALES
    assistants = db.relationship(
        "Assistant",
        foreign_keys="Assistant.doctor_id",
        back_populates="doctor",
        lazy="select",
        cascade="all, delete-orphan"
    )
    
    assistant_accounts = db.relationship(
        "Assistant",
        foreign_keys="Assistant.user_id",
        back_populates="user",
        uselist=True,
        lazy="select"
    )
    
    # ✅ Otras relaciones existentes
    schedules = db.relationship("Schedule", back_populates="doctor", lazy="select")
    clinics = db.relationship("Clinic", back_populates="doctor", lazy="select")
    authored_notes = db.relationship("Note", foreign_keys="Note.user_id", back_populates="author", lazy="select")
    received_notes = db.relationship("Note", foreign_keys="Note.patient_id", back_populates="patient", lazy="select")
    approved_notes = db.relationship("Note", foreign_keys="Note.approved_by", back_populates="approved_by_user", lazy="select")
    publications = db.relationship("Publication", back_populates="author", lazy="select")
    appointments = db.relationship("Appointment", foreign_keys="Appointment.patient_id", back_populates="patient", lazy="select")
    as_doctor_records = db.relationship("MedicalRecord", foreign_keys="MedicalRecord.doctor_id", back_populates="doctor", lazy="select")
    as_patient_records = db.relationship("MedicalRecord", foreign_keys="MedicalRecord.patient_id", back_populates="patient", lazy="select")
    sent_invites = db.relationship("CompanyInvite", back_populates="doctor", lazy="select")
    
    # ✅ Relación con UserRole
    role_obj = db.relationship("UserRole", back_populates="users")

    # ✅ PROPIEDADES NUEVAS PARA ASISTENTES
    @property
    def is_general_assistant(self):
        return any(a.type == 'general' for a in self.assistant_accounts)

    @property
    def is_common_assistant(self):
        return any(
            a.type == 'common' and a.is_active 
            for a in self.assistant_accounts
    )

    @property
    def can_assign_tasks(self):
        return self.is_admin or self.is_professional or self.is_general_assistant

    @property
    def role_display(self):
        """Devuelve el nombre del rol desde UserRole o fallback al role_name"""
        if self.role_obj:
            return self.role_obj.name
        return self.role_name or "Sin rol"

    def to_dict(self):
        try:
            skills_data = json.loads(self.skills) if self.skills and self.skills.strip() else []
            skills_data = skills_data if isinstance(skills_data, list) else []
        except (json.JSONDecodeError, TypeError):
            skills_data = []

        clinics_data = []
        if hasattr(self, 'clinics') and self.clinics:
            clinics_data = [
                {"id": c.id, "name": c.name, "address": c.address}
                for c in self.clinics if c.is_active
            ]

        return {
            "id": self.id,
            "username": self.username,
            "professional_category": self.professional_category,
            "specialty": self.specialty,
            "bio": self.bio or "",
            "profile_photo": self.profile_photo or "/static/img/default-avatar.png",
            "url_slug": self.url_slug or f"profesional-{self.id}",
            "years_experience": self.years_experience or 0,
            "services": self.services or "",
            "skills": skills_data,
            "clinics": clinics_data,
            "role_name": self.role_display
        }

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    @property
    def is_admin_user(self):
        return self.is_admin

    def __repr__(self):
        return f"<User {self.username} | Profesional: {self.is_professional} | Admin: {self.is_admin}>"
    
class Publication(db.Model):
    __tablename__ = "publications"
    
    id = db.Column(db.Integer, primary_key=True)
    slug = db.Column(db.String(200), unique=True, nullable=True, index=True)
    type = db.Column(db.String(50), nullable=False)
    title = db.Column(db.String(200), nullable=False)
    content = db.Column(db.Text, nullable=False)
    excerpt = db.Column(db.String(500), nullable=True)
    is_published = db.Column(db.Boolean, default=True, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    tags = db.Column(db.String(200), nullable=True)
    read_time = db.Column(db.Integer, nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    published_at = db.Column(db.DateTime, nullable=True)
    image_url = db.Column(db.String(300), nullable=True)
    view_count = db.Column(db.Integer, default=0)

    # ✅ Relación bidireccional
    author = db.relationship("User", back_populates="publications")

    def can_edit(self, user):
        return user.is_admin_user or user.id == self.user_id

    @property
    def type_icon(self):
        return {
            "Educativo": "fa-graduation-cap",
            "Caso de éxito": "fa-trophy",
            "Autoridad técnica": "fa-star",
            "Tutorial": "fa-book",
            "Análisis": "fa-chart-line"
        }.get(self.type, "fa-file-alt")

    @property
    def type_color(self):
        return {
            "Educativo": "text-info",
            "Caso de éxito": "text-success",
            "Autoridad técnica": "text-warning",
            "Tutorial": "text-primary",
            "Análisis": "text-danger"
        }.get(self.type, "text-secondary")

    @property
    def tag_list(self):
        if self.tags:
            return [tag.strip() for tag in self.tags.split(",") if tag.strip()]
        return []

class Clinic(db.Model):
    __tablename__ = "clinic"
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    address = db.Column(db.String(200), nullable=False)
    phone = db.Column(db.String(20))
    specialty = db.Column(db.String(50))
    doctor_id = db.Column(db.Integer, db.ForeignKey("users.id"))
    is_active = db.Column(db.Boolean, default=True)

    # ✅ Relaciones
    doctor = db.relationship("User", foreign_keys=[doctor_id], back_populates="clinics")
    availability = db.relationship("Availability", back_populates="clinic")
    schedules = db.relationship("Schedule", back_populates="clinic")
    assistants = db.relationship("Assistant", back_populates="clinic", cascade="all, delete-orphan", lazy="select")
    tasks = db.relationship("Task", back_populates="clinic", cascade="all, delete-orphan")

class Availability(db.Model):
    __tablename__ = "availability"
    
    id = db.Column(db.Integer, primary_key=True)
    clinic_id = db.Column(db.Integer, db.ForeignKey("clinic.id"))
    date = db.Column(db.Date, nullable=False)
    time = db.Column(db.Time, nullable=False)
    is_booked = db.Column(db.Boolean, default=False)

    # ✅ Relaciones
    clinic = db.relationship("Clinic", back_populates="availability")
    appointments = db.relationship("Appointment", back_populates="availability", cascade="all, delete-orphan")

class Appointment(db.Model):
    __tablename__ = "appointments"
    
    id = db.Column(db.Integer, primary_key=True)
    availability_id = db.Column(db.Integer, db.ForeignKey("availability.id"))
    patient_id = db.Column(db.Integer, db.ForeignKey("users.id"))
    
    status = db.Column(db.String(20), default="confirmed")
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    # Relaciones
    clinical_note = db.relationship("MedicalRecord", back_populates="appointment")
    availability = db.relationship("Availability", back_populates="appointments")
    patient = db.relationship("User", back_populates="appointments")

class MedicalRecord(db.Model):
    __tablename__ = "medical_records"
    
    id = db.Column(db.Integer, primary_key=True)
    patient_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    doctor_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    appointment_id = db.Column(db.Integer, db.ForeignKey("appointments.id"))
    title = db.Column(db.String(100), nullable=False)
    notes = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # ✅ Relaciones con back_populates
    patient = db.relationship("User", foreign_keys=[patient_id], back_populates="as_patient_records")
    doctor = db.relationship("User", foreign_keys=[doctor_id], back_populates="as_doctor_records")
    appointment = db.relationship("Appointment", back_populates="clinical_note")

class Schedule(db.Model):
    __tablename__ = "schedules"
    
    id = db.Column(db.Integer, primary_key=True)
    doctor_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    clinic_id = db.Column(db.Integer, db.ForeignKey("clinic.id"), nullable=False)
    day_of_week = db.Column(db.Integer, nullable=False)
    start_time = db.Column(db.Time, nullable=False)
    end_time = db.Column(db.Time, nullable=False)
    is_active = db.Column(db.Boolean, default=True)

    # ✅ Relaciones con back_populates
    doctor = db.relationship("User", back_populates="schedules")
    clinic = db.relationship("Clinic", back_populates="schedules")

class UserRole(db.Model):
    __tablename__ = "user_roles"
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    description = db.Column(db.Text)
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    # ✅ Apunta a la relación, no al campo
    users = db.relationship("User", back_populates="role_obj", lazy="select")

    def __repr__(self):
        return f"<UserRole {self.name}>"
    
class Subscriber(db.Model):
    __tablename__ = "subscribers"
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(150), unique=True, nullable=False)
    subscribed_at = db.Column(db.DateTime, default=datetime.utcnow)

class TaskStatus(Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    CANCELLED = "cancelled"

class Assistant(db.Model):
    __tablename__ = "assistants"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), nullable=True)
    whatsapp = db.Column(db.String(20), nullable=True)
    is_active = db.Column(db.Boolean, default=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    # Puede ser NULL para asistentes generales
    clinic_id = db.Column(db.Integer, db.ForeignKey("clinic.id"), nullable=True, index=True)
    # Médico/Profesional dueño
    doctor_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False, index=True)
    # Telegram para notificaciones
    telegram_id = db.Column(db.String(50), nullable=True, index=True,
        doc="ID de Telegram del asistente (para notificaciones)"
    )
    # Tipo: "common" (por consultorio) o "general" (sin consultorio, con cuenta)
    type = db.Column(db.String(20), default="common", nullable=False)  # "common" | "general"
    # Vinculación con User (solo si es asistente con cuenta)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=True, index=True)
    # ✅ Campo para saber quién asignó una tarea
    created_by_user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=True)


    # ✅ RELACIONES 
    tasks = db.relationship("Task", back_populates="assistant", cascade="all, delete-orphan", lazy="select")
    clinic = db.relationship("Clinic", back_populates="assistants", foreign_keys=[clinic_id], lazy="select")
    doctor = db.relationship("User", foreign_keys=[doctor_id], back_populates="assistants", lazy="select")
    user = db.relationship("User", foreign_keys=[user_id], back_populates="assistant_accounts")

    # ✅ Restricción: no duplicados en mismo consultorio
    __table_args__ = (
        db.UniqueConstraint('clinic_id', 'name', name='uq_assistant_clinic_name'),
        db.CheckConstraint(type.in_(["common", "general"]), name="valid_assistant_type"),
        {"extend_existing": True}  # Útil si hay herencia o múltiples declaraciones
    )

    # ✅ MÉTODOS PARA GESTIÓN DE TAREAS
    def can_assign_tasks_to(self, other_assistant):
        """
        Verifica si este asistente puede asignar tareas a otro.
        Solo los asistentes generales activos pueden hacerlo, y solo dentro del mismo equipo.
        """
        if not self.is_active or self.type != "general":
            return False
        if not other_assistant.is_active:
            return False
        return self.doctor_id == other_assistant.doctor_id

    def get_assignable_assistants(self):
        """
        Obtiene todos los asistentes a los que puede asignar tareas.
        Incluye comunes y generales del mismo médico, excepto a sí mismo.
        """
        if self.type != "general" or not self.is_active:
            return []

        return Assistant.query.filter(
            Assistant.doctor_id == self.doctor_id,
            Assistant.id != self.id,
            Assistant.is_active == True
        ).all()

    def __repr__(self):
        return f"<Assistant {self.name} | Tipo: {self.type} | Doctor ID: {self.doctor_id}>"

    @property
    def full_info(self):
        """Devuelve información serializable del asistente"""
        return {
            "id": self.id,
            "name": self.name,
            "email": self.email,
            "whatsapp": self.whatsapp,
            "type": self.type,
            "is_active": self.is_active,
            "clinic_id": self.clinic_id,
            "has_user_account": self.user_id is not None
        }
    
class Task(db.Model):
    __tablename__ = "tasks"
    
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(150), nullable=False)
    description = db.Column(db.Text, nullable=True)
    due_date = db.Column(db.Date, nullable=True)
    status = db.Column(db.String(20), default=TaskStatus.PENDING.value, nullable=False)
    
    doctor_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    assistant_id = db.Column(db.Integer, db.ForeignKey("assistants.id"), nullable=False)
    created_by = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=True)  # Quién creó la tarea

    # ✅ Puede ser NULL si el asistente es general
    clinic_id = db.Column(db.Integer, db.ForeignKey("clinic.id"), nullable=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    
    # NUEVO campo para auditoría
    created_by = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=True, index=True)

    # Relaciones
    doctor = db.relationship("User", foreign_keys=[doctor_id])
    assistant = db.relationship("Assistant", back_populates="tasks")
    clinic = db.relationship("Clinic", back_populates="tasks")
    creator = db.relationship("User", foreign_keys=[created_by])  # opcional: quien creó la tarea
    
class CompanyInvite(db.Model):
    __tablename__ = "company_invites"
    
    id = db.Column(db.Integer, primary_key=True)
    doctor_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    invite_code = db.Column(db.String(20), unique=True, nullable=False, index=True)
    email = db.Column(db.String(150), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    clinic_id = db.Column(db.Integer, db.ForeignKey("clinic.id"), nullable=True)
    whatsapp = db.Column(db.String(20), nullable=True)  # ✅ Nuevo campo
    assistant_type = db.Column(db.String(20), default="general", nullable=False)  # "general" | "common"

    is_used = db.Column(db.Boolean, default=False, index=True)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    expires_at = db.Column(db.DateTime, nullable=False)
    used_at = db.Column(db.DateTime, nullable=True)
    
    # Relaciones
    doctor = db.relationship("User", back_populates="sent_invites")
    clinic = db.relationship("Clinic")
    
    def is_expired(self):
        return datetime.utcnow() > self.expires_at
    
    def is_valid(self):
        return not self.is_used and not self.is_expired()

    def __repr__(self):
        return f"<CompanyInvite {self.invite_code} | {self.email} | Doctor: {self.doctor_id}>"

class InvitationLog(db.Model):
    __tablename__ = "invitation_logs"

    id = db.Column(db.Integer, primary_key=True)
    invite_code = db.Column(db.String(20), nullable=False, index=True)
    email = db.Column(db.String(150), nullable=False)
    method = db.Column(db.String(20))  # "email", "whatsapp", "manual"
    success = db.Column(db.Boolean, default=False)
    error_message = db.Column(db.Text)
    sent_at = db.Column(db.DateTime, default=datetime.utcnow)
    doctor_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    assistant_name = db.Column(db.String(100))

    doctor = db.relationship("User", backref="sent_invitation_logs")

    def __repr__(self):
        return f"<InvitationLog {self.invite_code} | {self.email} | {self.method} | {'Éxito' if self.success else 'Fallo'}>"
    
class Visit(db.Model):
    __tablename__ = 'visits'

    id = db.Column(db.Integer, primary_key=True)
    ip_address = db.Column(db.String(45), nullable=True)  # IPv6 compatible
    user_agent = db.Column(db.Text, nullable=True)
    path = db.Column(db.String(255), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    @classmethod
    def log_visit(cls, request):
        """Registra una visita desde un request."""
        visit = cls(
            ip_address=request.environ.get('HTTP_X_REAL_IP', request.remote_addr),
            user_agent=request.headers.get('User-Agent'),
            path=request.path
        )
        db.session.add(visit)
        db.session.commit()