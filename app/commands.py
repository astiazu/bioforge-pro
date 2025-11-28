import click
from flask.cli import with_appcontext
from app.services.servicio_anuncios import ServicioAnuncios

def register_commands(app):
    """Registra comandos CLI con la aplicación"""
    
    @app.cli.command("generar-anuncios")
    def generar_anuncios():
        """Genera anuncios automáticamente desde profesionales destacados"""
        anuncios_creados = ServicioAnuncios.generar_anuncios_desde_profesionales_destacados()
        click.echo(f"✅ Generados/actualizados {anuncios_creados} anuncios desde profesionales destacados")

    @app.cli.command("listar-profesionales-destacados")
    def listar_profesionales_destacados():
        """Lista profesionales destacados"""
        from app.models import User
        destacados = User.query.filter_by(es_destacado=True).order_by(User.prioridad_anuncio.desc()).all()
        
        click.echo("🎯 Profesionales Destacados:")
        for prof in destacados:
            click.echo(f"  - {prof.username} (Prioridad: {prof.prioridad_anuncio})")