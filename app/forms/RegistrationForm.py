# app/forms/registrationForm.py
from flask_wtf import FlaskForm
from wtforms import PasswordField, SubmitField
from wtforms.validators import DataRequired, EqualTo, Length

class RegistrationForm(FlaskForm):
    password = PasswordField('Contraseña', validators=[DataRequired(), Length(min=8)])
    password2 = PasswordField('Confirma contraseña', validators=[
        DataRequired(), EqualTo('password', message='Las contraseñas deben coincidir')
    ])
    submit = SubmitField('Crear cuenta')