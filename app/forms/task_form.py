# app/forms/task_form.py
from flask_wtf import FlaskForm
from wtforms import StringField, TextAreaField, SelectField, DateField, SubmitField
from wtforms.validators import DataRequired, Optional, Length

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