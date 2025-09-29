UPDATE clinic
SET doctor_id = 36
WHERE id = 4;  -- GINA 1

SELECT id, username, is_professional FROM users WHERE id = 36;

SELECT id, name, doctor_id FROM clinic WHERE id = 4;

-- Verificar asistente
SELECT id, user_id, doctor_id, type FROM assistants WHERE user_id = 36;

DELETE FROM users WHERE id = 13;

SELECT id, name, email, user_id
FROM assistants
WHERE email = 'stefyocen99@gmail.com';

SELECT id, username, is_professional
FROM users
WHERE id = 36;