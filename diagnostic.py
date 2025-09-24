# diagnostic.py - Crear este archivo en la raíz del proyecto
import sqlite3
import os

def check_database_structure():
    """Verifica la estructura actual de la base de datos"""
    
    # Buscar archivo de base de datos
    possible_paths = [
        'instance/portfolio.db',
        'app.db', 
        'database.db',
        'instance/app.db'
    ]
    
    db_path = None
    for path in possible_paths:
        if os.path.exists(path):
            db_path = path
            break
    
    if not db_path:
        print("❌ No se encontró el archivo de base de datos")
        return
    
    print(f"✅ Base de datos encontrada: {db_path}")
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        # Ver estructura de la tabla assistants
        print("\n=== ESTRUCTURA DE LA TABLA 'assistants' ===")
        cursor.execute("PRAGMA table_info(assistants);")
        columns = cursor.fetchall()
        
        if not columns:
            print("❌ La tabla 'assistants' no existe")
            return
        
        for col in columns:
            col_id, name, type_name, not_null, default_value, pk = col
            null_str = "NOT NULL" if not_null else "NULL"
            pk_str = "PRIMARY KEY" if pk else ""
            default_str = f"DEFAULT {default_value}" if default_value else ""
            
            print(f"  {name:15} | {type_name:15} | {null_str:8} | {default_str:15} | {pk_str}")
        
        # Verificar si user_id existe
        column_names = [col[1] for col in columns]
        
        print(f"\n=== DIAGNÓSTICO ===")
        print(f"✅ user_id existe: {'user_id' in column_names}")
        print(f"✅ doctor_id existe: {'doctor_id' in column_names}")
        print(f"✅ type existe: {'type' in column_names}")
        
        # Ver algunos registros
        print(f"\n=== DATOS DE EJEMPLO ===")
        cursor.execute("SELECT id, name, doctor_id, user_id, type FROM assistants LIMIT 3;")
        rows = cursor.fetchall()
        
        if rows:
            print("ID | Name           | Doctor ID | User ID | Type")
            print("-" * 50)
            for row in rows:
                print(f"{row[0]:2} | {str(row[1])[:15]:15} | {row[2]:9} | {row[3] or 'NULL':7} | {row[4] or 'NULL'}")
        else:
            print("No hay datos en la tabla assistants")
        
        conn.close()
        
    except Exception as e:
        print(f"❌ Error al acceder a la base de datos: {e}")

if __name__ == "__main__":
    check_database_structure()