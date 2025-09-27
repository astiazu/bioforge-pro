# === ENDPOINT TEMPORAL PARA RENDER: INICIALIZAR BASE DE DATOS ===
def safe_iso_parse(date_str):
    if not date_str:
        return None
    if date_str.endswith('Z'):
        date_str = date_str[:-1] + '+00:00'
    try:
        return datetime.fromisoformat(date_str)
    except (ValueError, TypeError):
        return None

def safe_time_parse(time_str):
    if not time_str:
        return None
    try:
        if len(time_str.split(':')) == 2:
            return datetime.strptime(time_str, '%H:%M').time()
        return datetime.strptime(time_str, '%H:%M:%S').time()
    except (ValueError, TypeError):
        return None

@routes.route('/init-db-render', methods=['POST'])
def init_db_render():
    # 🔒 Verificación de seguridad: clave secreta obligatoria
    secret_key = os.environ.get('INIT_DB_SECRET_KEY')
    if not secret_key:
        return jsonify({"error": "Endpoint deshabilitado"}), 403
        
    provided_key = request.args.get('key') or request.headers.get('X-Init-Key')
    if provided_key != secret_key:
        return jsonify({"error": "Clave secreta inválida"}), 403

    # 🛑 Solo permitir si no hay mas de 1 usuarios (evita sobrescritura)
    user_count = User.query.count()
    if user_count > 1:
        return jsonify({"error": "La base de datos ya tiene datos reales"}), 400

    data = request.get_json()
    if not data:
        return jsonify({"error": "Se requiere JSON en el cuerpo"}), 400

    try:
        # === Desactivar FK temporalmente (solo para SQLite, pero inofensivo en PG)
        if 'sqlite' in str(db.engine.url):
            db.session.execute(text("PRAGMA foreign_keys = OFF"))
            db.session.commit()

        # === Limpiar tablas en orden inverso ===
        tables_to_clear = [
            Task, Note, Availability, Appointment, MedicalRecord,
            Schedule, Assistant, Publication, CompanyInvite,
            Subscriber, Clinic, User, UserRole
        ]
        for table in tables_to_clear:
            db.session.query(table).delete()
        db.session.commit()

        # === Cargar datos ===
        
        # USER ROLES
        user_roles_data = data.get('user_roles', data.get('user_role', []))
        for ur in user_roles_data:
            if ur.get('id') and ur.get('name'):
                db.session.add(UserRole(id=ur['id'], name=ur['name']))
        db.session.commit()

        # USERS
        users_data = data.get('users', data.get('user', []))
        for u in users_data:
            if not (u.get('id') and u.get('username') and u.get('email')):
                continue
            user = User(
                id=u['id'],
                username=u['username'],
                email=u['email'],
                is_professional=u.get('is_professional', False),
                is_admin=u.get('is_admin', False),
                role_name=u.get('role_name', 'user'),
                specialty=u.get('specialty'),
                bio=u.get('bio'),
                years_experience=u.get('years_experience'),
                profile_photo=u.get('profile_photo'),
                url_slug=u.get('url_slug'),
                license_number=u.get('license_number'),
                created_at=safe_iso_parse(u.get('created_at')),
                updated_at=safe_iso_parse(u.get('updated_at'))
            )
            user.set_password('temporal123')
            db.session.add(user)
        db.session.commit()

        # CLINICS
        clinics_data = data.get('clinics', data.get('clinic', []))
        for c in clinics_data:
            if not (c.get('id') and c.get('name') and c.get('doctor_id')):
                continue
            clinic = Clinic(
                id=c['id'],
                name=c['name'],
                address=c.get('address'),
                phone=c.get('phone'),
                specialty=c.get('specialty'),
                doctor_id=c['doctor_id'],
                is_active=c.get('is_active', True)
            )
            db.session.add(clinic)
        db.session.commit()

        # ASSISTANTS
        assistants_data = data.get('assistants', data.get('assistant', []))
        for a in assistants_data:
            if not (a.get('id') and a.get('name') and a.get('doctor_id')):
                continue
            assistant = Assistant(
                id=a['id'],
                name=a['name'],
                email=a.get('email'),
                whatsapp=a.get('whatsapp'),
                doctor_id=a['doctor_id'],
                clinic_id=a.get('clinic_id'),
                type=a.get('type', 'common'),
                user_id=a.get('user_id'),
                telegram_id=a.get('telegram_id'),
                created_at=safe_iso_parse(a.get('created_at'))
            )
            db.session.add(assistant)
        db.session.commit()

        # PUBLICATIONS
        pubs_data = data.get('publications', data.get('publication', []))
        for p in pubs_data:
            if not (p.get('id') and p.get('title') and p.get('user_id')):
                continue
            try:
                from slugify import slugify
                slug = p.get('slug') or slugify(p['title']) or f"pub-{p['id']}"
            except ImportError:
                slug = p.get('slug') or f"pub-{p['id']}"
            pub = Publication(
                id=p['id'],
                type=p.get('type', 'blog'),
                title=p['title'],
                excerpt=p.get('excerpt'),
                content=p.get('content', ''),
                is_published=(p.get('status') == 'published'),
                user_id=p['user_id'],
                image_url=p.get('image_url'),
                slug=slug,
                published_at=safe_iso_parse(p.get('published_at')),
                view_count=p.get('view_count', 0),
                tags=", ".join(p.get('tags', [])) if isinstance(p.get('tags'), list) else p.get('tags', "")
            )
            db.session.add(pub)
        db.session.commit()

        # NOTES
        notes_data = data.get('notes', data.get('note', []))
        for n in notes_data:
            if not (n.get('id') and n.get('content') and n.get('user_id')):
                continue
            raw_status = n.get('status', 'private')
            try:
                status_value = NoteStatus(raw_status).value
            except ValueError:
                status_value = NoteStatus.PRIVATE.value
            note = Note(
                id=n['id'],
                title=n.get('title', ''),
                content=n['content'],
                user_id=n['user_id'],
                status=status_value,
                created_at=safe_iso_parse(n.get('created_at'))
            )
            db.session.add(note)
        db.session.commit()

        # SCHEDULES
        schedules_data = data.get('schedules', data.get('schedule', []))
        for s in schedules_data:
            if not (s.get('id') and s.get('day_of_week') and s.get('doctor_id') and s.get('clinic_id')):
                continue
            schedule = Schedule(
                id=s['id'],
                day_of_week=s['day_of_week'],
                start_time=safe_time_parse(s.get('start_time')),
                end_time=safe_time_parse(s.get('end_time')),
                doctor_id=s['doctor_id'],
                clinic_id=s['clinic_id'],
                is_active=s.get('is_active', True)
            )
            db.session.add(schedule)
        db.session.commit()

        # AVAILABILITY
        avail_data = data.get('availabilities', data.get('availability', []))
        for a in avail_data:
            if not (a.get('id') and a.get('date') and a.get('clinic_id')):
                continue
            availability = Availability(
                id=a['id'],
                date=safe_iso_parse(a['date']).date() if a.get('date') else None,
                time=safe_time_parse(a.get('time')),
                clinic_id=a['clinic_id'],
                is_booked=a.get('is_booked', False),
                appointment_id=a.get('appointment_id')
            )
            db.session.add(availability)
        db.session.commit()

        # APPOINTMENTS
        appts_data = data.get('appointments', data.get('appointment', []))
        for ap in appts_data:
            if not (ap.get('id') and ap.get('patient_id') and ap.get('availability_id')):
                continue
            appt = Appointment(
                id=ap['id'],
                patient_id=ap['patient_id'],
                availability_id=ap['availability_id'],
                notes=ap.get('notes'),
                status=ap.get('status', 'confirmed')
            )
            db.session.add(appt)
        db.session.commit()

        # MEDICAL RECORDS
        mr_data = data.get('medical_records', data.get('medical_record', []))
        for mr in mr_data:
            if not (mr.get('id') and mr.get('patient_id') and mr.get('doctor_id') and mr.get('title')):
                continue
            record = MedicalRecord(
                id=mr['id'],
                patient_id=mr['patient_id'],
                doctor_id=mr['doctor_id'],
                title=mr['title'],
                notes=mr['notes'],
                created_at=safe_iso_parse(mr.get('created_at'))
            )
            db.session.add(record)
        db.session.commit()

        # TASKS
        tasks_data = data.get('tasks', data.get('task', []))
        for t in tasks_data:
            if not (t.get('id') and t.get('title') and t.get('doctor_id') and t.get('assistant_id')):
                continue
            raw_status = t.get('status', 'pending')
            try:
                status_value = TaskStatus(raw_status).value
            except ValueError:
                status_value = TaskStatus.PENDING.value
            task = Task(
                id=t['id'],
                title=t['title'],
                description=t.get('description'),
                due_date=safe_iso_parse(t.get('due_date')).date() if t.get('due_date') else None,
                status=status_value,
                doctor_id=t['doctor_id'],
                assistant_id=t['assistant_id'],
                clinic_id=t.get('clinic_id'),
                created_by=t.get('created_by'),
                created_at=safe_iso_parse(t.get('created_at'))
            )
            db.session.add(task)
        db.session.commit()

        # COMPANY INVITES
        invites_data = data.get('company_invites', data.get('company_invite', []))
        for inv in invites_data:
            if not (inv.get('id') and inv.get('invite_code') and inv.get('email') and inv.get('doctor_id')):
                continue
            invite = CompanyInvite(
                id=inv['id'],
                invite_code=inv['invite_code'],
                email=inv['email'],
                name=inv.get('name'),
                doctor_id=inv['doctor_id'],
                clinic_id=inv.get('clinic_id'),
                assistant_type=inv['assistant_type'],
                whatsapp=inv.get('whatsapp'),
                expires_at=safe_iso_parse(inv.get('expires_at')),
                is_used=inv.get('is_used', False)
            )
            db.session.add(invite)
        db.session.commit()

        # SUBSCRIBERS
        subs_data = data.get('subscribers', data.get('subscriber', []))
        for s in subs_data:
            if not (s.get('id') and s.get('email')):
                continue
            sub = Subscriber(
                id=s['id'],
                email=s['email'],
                subscribed_at=safe_iso_parse(s.get('subscribed_at'))
            )
            db.session.add(sub)
        db.session.commit()

        # Reactivar FK
        if 'sqlite' in str(db.engine.url):
            db.session.execute(text("PRAGMA foreign_keys = ON"))
            db.session.commit()

        return jsonify({
            "message": "✅ Base de datos inicializada exitosamente",
            "stats": {
                "users": User.query.count(),
                "clinics": Clinic.query.count(),
                "tasks": Task.query.count(),
                "publications": Publication.query.count()
            }
        }), 200

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": f"Falló la inicialización: {str(e)}"}), 500

# === FIN DEL ENDPOINT TEMPORAL ===