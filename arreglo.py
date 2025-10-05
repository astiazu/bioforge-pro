"""
Script para corregir doctor_id inválidos en clinic.csv
"""
import csv
import os
import shutil

IMPORT_DIR = "exported_data"
CLINIC_FILE = os.path.join(IMPORT_DIR, "clinic.csv")

# IDs de usuarios que NO son doctores pero están como doctor_id
INVALID_DOCTORS = ['13']  # Stefy

# Reemplazo: dejar vacío o asignar a doctor válido
REPLACEMENT_DOCTOR_ID = '6'  # Salvador (o pon '' para vacío)

def fix_clinic_csv():
    """
    Corrige doctor_id inválidos en clinic.csv
    """
    print("=" * 60)
    print("🔧 CORRIGIENDO CLINIC.CSV")
    print("=" * 60)
    
    if not os.path.exists(CLINIC_FILE):
        print(f"❌ Archivo no encontrado: {CLINIC_FILE}")
        return
    
    # Crear backup
    backup_file = CLINIC_FILE + ".backup"
    shutil.copy2(CLINIC_FILE, backup_file)
    print(f"📦 Backup creado: {backup_file}")
    
    # Leer y corregir
    rows_to_write = []
    corrections = []
    
    with open(CLINIC_FILE, 'r', encoding='utf-8-sig') as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        
        for row in reader:
            original_doctor_id = row['doctor_id']
            
            if original_doctor_id in INVALID_DOCTORS:
                corrections.append({
                    'clinic_id': row['id'],
                    'clinic_name': row['name'],
                    'old_doctor_id': original_doctor_id,
                    'new_doctor_id': REPLACEMENT_DOCTOR_ID or '(vacío)'
                })
                row['doctor_id'] = REPLACEMENT_DOCTOR_ID
            
            rows_to_write.append(row)
    
    # Escribir archivo corregido
    with open(CLINIC_FILE, 'w', newline='', encoding='utf-8-sig') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows_to_write)
    
    # Reporte
    if corrections:
        print(f"\n✅ {len(corrections)} correcciones realizadas:")
        for corr in corrections:
            print(f"   • Clínica ID {corr['clinic_id']} ({corr['clinic_name']})")
            print(f"     doctor_id: {corr['old_doctor_id']} → {corr['new_doctor_id']}")
    else:
        print("\n✅ No se encontraron problemas")
    
    print(f"\n✅ Archivo corregido: {CLINIC_FILE}")
    print(f"📦 Backup disponible en: {backup_file}")
    print("\n🚀 Ahora puedes ejecutar el script de importación sin problemas")
    print("=" * 60)

if __name__ == "__main__":
    fix_clinic_csv()