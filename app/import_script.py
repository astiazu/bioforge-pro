def validate_foreign_keys(csv_data, foreign_key_column, referenced_table):
    """
    Valida que los valores de una columna de clave foránea en los datos CSV
    coincidan con los IDs existentes en la tabla referenciada.
    """
    referenced_ids = {row.id for row in referenced_table.query.all()}
    invalid_keys = [row[foreign_key_column] for row in csv_data if row[foreign_key_column] not in referenced_ids]
    if invalid_keys:
        raise ValueError(f"Claves foráneas inválidas en {foreign_key_column}: {invalid_keys}")

def import_csv_to_model(csv_path, model, skip_id=False):
    """
    Importa datos desde un archivo CSV a una tabla específica del modelo.
    """
    if not os.path.exists(csv_path):
        print(f"⚠️ Archivo CSV no encontrado: {csv_path}")
        return

    with open(csv_path, "r", encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        rows = list(reader)  # Convertimos el lector en una lista para validación

        # Validar claves foráneas si es necesario
        foreign_key_columns = {
            "clinic": "doctor_id",
            "assistants": "doctor_id",
            "tasks": "doctor_id",
            "appointments": "patient_id",
        }
        if model.__tablename__ in foreign_key_columns:
            foreign_key_column = foreign_key_columns[model.__tablename__]
            referenced_table = globals()[model.__tablename__.capitalize()]
            validate_foreign_keys(rows, foreign_key_column, referenced_table)

        count = 0
        for row in rows:
            try:
                cleaned = {}
                for key, value in row.items():
                    if key == "id" and skip_id:
                        continue  # Saltar el ID si se especifica
                    if value == "" or value is None:
                        cleaned[key] = None
                    elif key.endswith("_id"):  # Claves foráneas
                        cleaned[key] = int(value) if str(value).isdigit() else None
                    elif key.startswith("is_"):  # Campos booleanos
                        cleaned[key] = str(value).strip().lower() in ("1", "true", "t", "yes", "on", "sí", "si")
                    else:
                        cleaned[key] = value

                obj = model(**cleaned)
                db.session.add(obj)
                count += 1
            except (ValueError, IntegrityError, DataError) as e:
                print(f"❌ Error al procesar fila {count + 1} en {csv_path}: {e}")
                db.session.rollback()
                continue

        db.session.commit()
        print(f"✅ Importado: {count} registros en {model.__tablename__}")

def import_csv_to_render_db():
    """
    Importa datos desde múltiples archivos CSV a la base de datos.
    """
    print("🗑️ Vaciamos todas las tablas para sincronización limpia...")
    inspector = inspect(db.engine)
    existing_tables = inspector.get_table_names()

    # Lista de tablas a vaciar
    TABLES_TO_CLEAR = [
        "clinic",
        "assistants",
        "tasks",
        "users",
        "product_category",
        "notes",
        "publications",
        "medical_records",
        "appointments",
        "availability",
        "event",
    ]

    for table in reversed(db.metadata.sorted_tables):
        if table.name in existing_tables and table.name in TABLES_TO_CLEAR:
            print(f"  → Eliminando {table.name}...")
            db.session.execute(table.delete())
        else:
            print(f"  ⚠️ Tabla {table.name} no existe. Creándola...")
            table.create(bind=db.engine)
    db.session.commit()
    print("✅ Todas las tablas vaciadas.")

    # Orden de importación basado en dependencias
    TARGET_TABLES = [
        "users",
        "user_roles",
        "clinic",
        "product_category",
        "assistants",
        "tasks",
        "availability",
        "appointments",
        "medical_records",
        "publications",
        "notes",
        "event",
        "subscribers",
        "company_invites",
        "invitation_logs",
        "visits",
        "product",
    ]

    for table in TARGET_TABLES:
        csv_path = os.path.join(IMPORT_DIR, f"{table}.csv")
        if not os.path.exists(csv_path):
            print(f"  ⚠️ Archivo CSV para {table} no encontrado. Saltando...")
            continue

        model_class = globals().get(table.capitalize())
        if not model_class:
            print(f"  ⚠️ Modelo para {table} no encontrado. Saltando...")
            continue

        import_csv_to_model(csv_path, model_class, skip_id=(table in ["invitation_logs", "visits"]))

    print("🎉 Sincronización completada exitosamente.")