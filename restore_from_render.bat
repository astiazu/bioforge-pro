@echo off
setlocal

REM === Configuración ===
set DB_NAME=bioforge_dev
set DB_USER=bioforge_user
set BACKUP_FILE=backups\backup_render.sql

REM === Verificar si el backup existe ===
if not exist "%BACKUP_FILE%" (
    echo ❌ Error: No se encontró el archivo de backup: %BACKUP_FILE%
    pause
    exit /b 1
)

REM === Confirmar acción ===
echo.
echo ⚠️  ATENCIÓN: Este script reiniciará tu base de datos local "%DB_NAME%".
echo    Se perderán todos los datos actuales en local.
echo.
set /p confirm=¿Continuar? (escribe "si" y presiona Enter): 
if /i not "%confirm%"=="si" (
    echo Operación cancelada.
    pause
    exit /b 0
)

REM === Reiniciar base de datos ===
echo.
echo 🔄 Reiniciando base de datos "%DB_NAME%"...
dropdb %DB_NAME%
if %errorlevel% neq 0 (
    echo ❌ Error al eliminar la base de datos.
    pause
    exit /b 1
)

createdb %DB_NAME%
if %errorlevel% neq 0 (
    echo ❌ Error al crear la base de datos.
    pause
    exit /b 1
)

REM === Restaurar backup ===
echo.
echo 📥 Restaurando backup desde "%BACKUP_FILE%"...
psql -U %DB_USER% -d %DB_NAME% -f "%BACKUP_FILE%"
if %errorlevel% neq 0 (
    echo ❌ Error al restaurar el backup.
    pause
    exit /b 1
)

echo.
echo ✅ ¡Restauración completada! Tu entorno local ahora es idéntico a Render.
pause