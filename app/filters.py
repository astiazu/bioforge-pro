# app/filters.py
from datetime import datetime

def format_date(value, format='%d %b %Y %H:%M'):
    """
    Formatea una fecha según el formato especificado.
    :param value: Fecha a formatear (datetime).
    :param format: Formato deseado (por defecto: '%d %b %Y %H:%M').
    :return: Fecha formateada como string.
    """
    if isinstance(value, datetime):
        return value.strftime(format)
    return value  # Retorna el valor original si no es una fecha válida