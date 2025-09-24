from app.models import User, Assistant

# Busca al doctor Maicai
maicai = User.query.filter_by(username="MaicaiPeques").first()
if not maicai:
    print("❌ No se encontró el usuario MaicaiPeques")
else:
    print(f"✅ MaicaiPeques encontrado: ID={maicai.id}")

# Busca al asistente JoseLuis
jose = User.query.filter_by(email="joseluis@gmail.com").first()
if not jose:
    print("❌ No se encontró el usuario joseluis@gmail.com")
else:
    print(f"✅ JoseLuis encontrado: ID={jose.id}")

# Busca todos los Assistant vinculados a Maicai
assistants_de_maicai = Assistant.query.filter_by(doctor_id=maicai.id).all()
print(f"\n📋 Asistentes de MaicaiPeques ({len(assistants_de_maicai)}):")
for a in assistants_de_maicai:
    print(f" - {a.name} (ID: {a.id}, user_id: {a.user_id})")

# Busca todos los Assistant de JoseLuis
assistant_accounts_de_jose = Assistant.query.filter_by(user_id=jose.id).all()
print(f"\n💼 Roles de JoseLuis ({len(assistant_accounts_de_jose)}):")
for a in assistant_accounts_de_jose:
    doctor = User.query.get(a.doctor_id)
    print(f" - {a.name} → Doctor: {doctor.username if doctor else 'N/A'} (doctor_id: {a.doctor_id})")