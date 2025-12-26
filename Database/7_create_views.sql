-- =============================================
-- VIEWS FOR ANIMAL SHELTER MANAGEMENT SYSTEM
-- =============================================

-- 1. View: Animals with Shelter and Age Information
CREATE OR REPLACE VIEW v_animal_summary AS
SELECT 
    a.animal_id,
    a.name,
    a.species,
    a.breed,
    a.gender,
    calculate_animal_age(a.animal_id) AS age_years,
    a.status,
    s.shelter_name,
    a.intake_date,
    a.microchip_number
FROM Animals a
JOIN Shelters s ON a.shelter_id = s.shelter_id
WHERE a.status <> 'Deceased';

-- 2. View: Available Animals for Adoption
CREATE OR REPLACE VIEW v_available_animals AS
SELECT 
    a.animal_id,
    a.name,
    a.species,
    a.breed,
    a.gender,
    a.color,
    a.weight,
    s.shelter_name,
    a.intake_date
FROM Animals a
JOIN Shelters s ON a.shelter_id = s.shelter_id
WHERE a.status = 'Available';

-- 3. View: Animals in Medical Care
CREATE OR REPLACE VIEW v_medical_animals AS
SELECT 
    a.animal_id,
    a.name,
    a.species,
    a.breed,
    s.shelter_name,
    m.visit_date,
    m.diagnosis,
    m.treatment
FROM Animals a
JOIN Shelters s ON a.shelter_id = s.shelter_id
JOIN Medical_Records m ON a.animal_id = m.animal_id
WHERE a.status = 'Medical Care'
ORDER BY m.visit_date DESC;

-- 4. View: Adoptions This Month
CREATE OR REPLACE VIEW v_adoptions_month AS
SELECT 
    ad.adoption_id,
    a.name AS animal_name,
    ad.adopter_id,
    ad.adoption_date,
    ad.status
FROM Adoptions ad
JOIN Animals a ON ad.animal_id = a.animal_id
WHERE TRUNC(ad.adoption_date, 'MM') = TRUNC(SYSDATE, 'MM');

-- 5. View: Donations This Month
CREATE OR REPLACE VIEW v_donations_month AS
SELECT 
    d.donation_id,
    d.donor_name,
    d.amount,
    d.donation_date,
    d.donation_type
FROM Donations d
WHERE TRUNC(d.donation_date, 'MM') = TRUNC(SYSDATE, 'MM')
ORDER BY d.donation_date DESC;

-- 6. View: Total Animals Count
CREATE OR REPLACE VIEW v_total_animals_count AS
SELECT COUNT(*) AS total_animals
FROM Animals
WHERE status <> 'Deceased';

-- 7. View: Animals by Status
CREATE OR REPLACE VIEW v_animals_by_status AS
SELECT 
    status,
    COUNT(*) AS count
FROM Animals
WHERE status <> 'Deceased'
GROUP BY status;

-- 8. View: Staff Members at Each Shelter
CREATE OR REPLACE VIEW v_staff_by_shelter AS
SELECT 
    s.shelter_name,
    st.first_name,
    st.last_name,
    st.phone
FROM Staff st
JOIN Shelters s ON st.shelter_id = s.shelter_id
ORDER BY s.shelter_name, st.first_name;

-- 9. View: Veterinarians and Their Specialties
CREATE OR REPLACE VIEW v_veterinarians_info AS
SELECT 
    v.vet_id,
    v.first_name,
    v.last_name,
    v.license_number,
    v.phone,
    v.years_experience,
    v.is_active
FROM Veterinarians v
WHERE v.is_active = 'Y'
ORDER BY v.last_name;

-- 10. View: Recent Vaccinations
CREATE OR REPLACE VIEW v_recent_vaccinations AS
SELECT 
    a.animal_id,
    a.name AS animal_name,
    a.species,
    v.vaccine_name,
    v.date_administered,
    v.next_due_date
FROM Vaccinations v
JOIN Animals a ON v.animal_id = a.animal_id
WHERE v.next_due_date >= SYSDATE
ORDER BY v.next_due_date;

-- Confirm all views created
COMMIT;