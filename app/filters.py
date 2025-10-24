# app/filters.py
from datetime import datetime
from babel.numbers import format_currency


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

def format_currency_filter(value, currency='USD'):
    """
    Filtro personalizado para formatear monedas usando Babel.
    """
    return format_currency(value, currency)

def now():
    """
    Retorna la fecha y hora actual.
    """
    return datetime.now()