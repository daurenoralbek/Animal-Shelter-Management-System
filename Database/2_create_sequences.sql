-- =============================================
-- CREATE SEQUENCES FOR AUTO-INCREMENT
-- =============================================
CREATE SEQUENCE seq_shelter START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_animal START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_adopter START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_staff START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_vet START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_medical_record START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_vaccination START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_adoption START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_appointment START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_donation START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_medication START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_treatment START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_audit START WITH 1 INCREMENT BY 1;

-- =============================================
-- CREATE INDEXES FOR PERFORMANCE
-- =============================================
CREATE INDEX idx_animals_shelter ON Animals(shelter_id);
CREATE INDEX idx_animals_status ON Animals(status);
CREATE INDEX idx_animals_species ON Animals(species);
CREATE INDEX idx_staff_shelter ON Staff(shelter_id);
CREATE INDEX idx_medical_animal ON Medical_Records(animal_id);
CREATE INDEX idx_vacc_animal ON Vaccinations(animal_id);
CREATE INDEX idx_vacc_due_date ON Vaccinations(next_due_date);
CREATE INDEX idx_adoption_animal ON Adoptions(animal_id);
CREATE INDEX idx_adoption_adopter ON Adoptions(adopter_id);
CREATE INDEX idx_appt_date ON Appointments(appointment_date);
CREATE INDEX idx_treatment_animal ON Treatments(animal_id);