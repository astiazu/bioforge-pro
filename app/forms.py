# app/forms.py
from flask_wtf import FlaskForm
from flask_wtf.file import FileField, FileAllowed
from wtforms import (
    StringField, TextAreaField, SubmitField, BooleanField,
    PasswordField, EmailField, SelectField, IntegerField,
    DateField, TimeField
)
from wtforms.validators import DataRequired, Length, Email, EqualTo, Optional

# === Formularios de Autenticación ===
class RegistrationForm(FlaskForm):
    password = PasswordField('Contraseña', validators=[DataRequired(), Length(min=8)])
    password2 = PasswordField('Confirma contraseña', validators=[
        DataRequired(), EqualTo('password', message='Las contraseñas deben coincidir')
    ])
    submit = SubmitField('Crear cuenta')

class LoginForm(FlaskForm):
    email = EmailField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Contraseña', validators=[DataRequired()])
    remember = BooleanField('Recordarme')
    submit = SubmitField('Iniciar sesión')

class RequestResetForm(FlaskForm):
    email = EmailField('Email', validators=[DataRequired(), Email()])
    submit = SubmitField('Solicitar cambio de contraseña')

class ResetPasswordForm(FlaskForm):
    password = PasswordField('Nueva contraseña', validators=[DataRequired()])
    password2 = PasswordField('Repetir contraseña', validators=[DataRequired(), EqualTo('password')])
    submit = SubmitField('Cambiar contraseña')

# === Formularios principales ===
class NoteForm(FlaskForm):
    title = StringField('Título')
    content = TextAreaField('Contenido', validators=[DataRequired()])
    submit = SubmitField('Guardar')

class PublicationForm(FlaskForm):
    title = StringField('Título', validators=[DataRequired()])
    excerpt = TextAreaField('Extracto')
    content = TextAreaField('Contenido', validators=[DataRequired()])
    image = FileField('Imagen', validators=[FileAllowed(['jpg', 'png', 'jpeg'], 'Solo imágenes')])
    submit = SubmitField('Publicar')

class ClinicForm(FlaskForm):
    name = StringField('Nombre', validators=[DataRequired()])
    address = StringField('Dirección')
    phone = StringField('Teléfono')
    specialty = StringField('Especialidad')
    submit = SubmitField('Guardar')

class AssistantForm(FlaskForm):
    name = StringField('Nombre', validators=[DataRequired()])
    email = EmailField('Email')
    whatsapp = StringField('WhatsApp')
    type = SelectField('Tipo', choices=[('common', 'Común'), ('general', 'General')], default='common')
    submit = SubmitField('Guardar')

class TaskForm(FlaskForm):
    title = StringField(
        "Título",
        validators=[DataRequired(message="El título es obligatorio"),
                    Length(max=200, message="El título no puede superar los 200 caracteres")]
    )
    
    description = TextAreaField(
        "Descripción",
        validators=[Optional(), Length(max=1000, message="La descripción es demasiado larga")]
    )

    assistant_id = SelectField(
        "Asignar a",
        coerce=int,
        validators=[DataRequired(message="Debe seleccionar un asistente")]
    )

    due_date = DateField(
        "Fecha límite",
        format="%Y-%m-%d",
        validators=[Optional()]
    )

    status = SelectField(
        "Estado",
        choices=[
            ("pending", "⏳ Pendiente"),
            ("in_progress", "🔴 En progreso"),
            ("completed", "✅ Completada"),
            ("cancelled", "❌ Cancelada"),
        ],
        default="pending",
        validators=[DataRequired()]
    )

    submit = SubmitField("Guardar")
    
class TaskAssignmentForm(FlaskForm):
    title = StringField('Título', validators=[DataRequired()])
    description = TextAreaField('Descripción')
    due_date = DateField('Fecha límite', validators=[Optional()])
    assistant_id = SelectField('Asistente', coerce=int, validators=[DataRequired()])
    clinic_id = SelectField('Clínica', coerce=int, validators=[Optional()])
    submit = SubmitField('Asignar')

class AppointmentForm(FlaskForm):
    notes = TextAreaField('Notas')
    submit = SubmitField('Confirmar')

class MedicalRecordForm(FlaskForm):
    title = StringField('Título', validators=[DataRequired()])
    notes = TextAreaField('Notas', validators=[DataRequired()])
    submit = SubmitField('Guardar')

class CompanyInviteForm(FlaskForm):
    email = EmailField('Email', validators=[DataRequired(), Email()])
    name = StringField('Nombre')
    assistant_type = SelectField('Tipo de asistente', choices=[('common', 'Común'), ('general', 'General')], default='common')
    whatsapp = StringField('WhatsApp')
    clinic_id = SelectField('Clínica', coerce=int, validators=[Optional()])
    submit = SubmitField('Enviar Invitación')

class SubscriberForm(FlaskForm):
    email = EmailField('Email', validators=[DataRequired(), Email()])
    submit = SubmitField('Suscribirse')

class DataUploadForm(FlaskForm):
    file = FileField('Archivo CSV', validators=[DataRequired()])
    submit = SubmitField('Subir Archivo')

class ProfessionalProfileForm(FlaskForm):
    specialty = StringField('Especialidad')
    bio = TextAreaField('Biografía')
    years_experience = IntegerField('Años de experiencia', validators=[Optional()])
    license_number = StringField('Número de licencia')
    services = TextAreaField('Servicios')
    skills = TextAreaField('Habilidades (JSON)')
    profile_photo = FileField('Foto de perfil', validators=[FileAllowed(['jpg', 'png', 'jpeg'], 'Solo imágenes')])
    submit = SubmitField('Actualizar')

class PublicationFilterForm(FlaskForm):
    search = StringField('Buscar')
    category = SelectField('Categoría', choices=[('', 'Todas'), ('blog', 'Blog'), ('news', 'Noticias')])
    submit = SubmitField('Filtrar')