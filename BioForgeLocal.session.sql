-- 1. Mabel y Emiliano → clinic_id = 1
UPDATE assistants
SET clinic_id = 1
WHERE clinic_id IS NULL
  AND email IN ('macalu1966@gmail.com', 'emiliano@gmail.com');

-- 2. Todos los demás (incluidos los que NO tienen email) → clinic_id = 3
UPDATE assistants
SET clinic_id = 3
WHERE clinic_id IS NULL
  AND (email IS NULL OR email NOT IN ('macalu1966@gmail.com', 'emiliano@gmail.com'));