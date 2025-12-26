--- Procedure 1: Add Animal Intake

CREATE OR REPLACE PROCEDURE add_animal_intake(
    p_shelter_id IN NUMBER,
    p_name IN VARCHAR2,
    p_species IN VARCHAR2,
    p_breed IN VARCHAR2,
    p_dob IN DATE,
    p_gender IN CHAR,
    p_color IN VARCHAR2,
    p_weight IN NUMBER,
    p_microchip IN VARCHAR2 DEFAULT NULL
)
IS
    v_animal_id NUMBER;
BEGIN
    -- Get next animal ID
    SELECT seq_animal.NEXTVAL INTO v_animal_id FROM DUAL;
    
    -- Insert new animal
    INSERT INTO Animals (
        animal_id, shelter_id, name, species, breed,
        date_of_birth, gender, color, weight, microchip_number,
        intake_date, status
    ) VALUES (
        v_animal_id, p_shelter_id, p_name, p_species, p_breed,
        p_dob, p_gender, p_color, p_weight, p_microchip,
        SYSDATE, 'Available'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Animal added successfully with ID: ' || v_animal_id);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Microchip number already exists');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Error adding animal: ' || SQLERRM);
END add_animal_intake;
/


--- Procedure 2: Process Adoption

CREATE OR REPLACE PROCEDURE process_adoption(
    p_animal_id IN NUMBER,
    p_adopter_id IN NUMBER,
    p_staff_id IN NUMBER
)
IS
    v_adoption_id NUMBER;
    v_fee NUMBER;
    v_current_status VARCHAR2(20);
    ex_invalid_status EXCEPTION;
BEGIN
    -- Check animal status
    SELECT status INTO v_current_status
    FROM Animals
    WHERE animal_id = p_animal_id;
    
    IF v_current_status != 'Available' THEN
        RAISE ex_invalid_status;
    END IF;
    
    -- Calculate adoption fee
    v_fee := calculate_adoption_fee(p_animal_id);
    
    -- Create adoption record
    SELECT seq_adoption.NEXTVAL INTO v_adoption_id FROM DUAL;
    
    INSERT INTO Adoptions (
        adoption_id, animal_id, adopter_id, staff_id,
        adoption_date, adoption_fee, status, contract_signed
    ) VALUES (
        v_adoption_id, p_animal_id, p_adopter_id, p_staff_id,
        SYSDATE, v_fee, 'Pending', 'N'
    );
    
    -- Update animal status
    UPDATE Animals
    SET status = 'Adopted'
    WHERE animal_id = p_animal_id;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Adoption processed. Fee: $' || v_fee);
EXCEPTION
    WHEN ex_invalid_status THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20005, 'Animal not available for adoption');
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'Animal, adopter, or staff not found');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20006, 'Error processing adoption: ' || SQLERRM);
END process_adoption;
/


--- Procedure 3: Schedule Appointment

CREATE OR REPLACE PROCEDURE schedule_appointment(
    p_animal_id IN NUMBER,
    p_vet_id IN NUMBER,
    p_appt_date IN DATE,
    p_appt_time IN VARCHAR2,
    p_purpose IN VARCHAR2
)
IS
    v_appointment_id NUMBER;
BEGIN
    SELECT seq_appointment.NEXTVAL INTO v_appointment_id FROM DUAL;
    
    INSERT INTO Appointments (
        appointment_id, animal_id, vet_id, appointment_date,
        appointment_time, purpose, status
    ) VALUES (
        v_appointment_id, p_animal_id, p_vet_id, p_appt_date,
        p_appt_time, p_purpose, 'Scheduled'
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Appointment scheduled with ID: ' || v_appointment_id);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20007, 'Error scheduling appointment: ' || SQLERRM);
END schedule_appointment;
/


--- Procedure 4: Update Vaccination Record

CREATE OR REPLACE PROCEDURE update_vaccination_record(
    p_animal_id IN NUMBER,
    p_vet_id IN NUMBER,
    p_vaccine_name IN VARCHAR2,
    p_batch_number IN VARCHAR2,
    p_months_until_next IN NUMBER DEFAULT 12
)
IS
    v_vacc_id NUMBER;
    v_next_due DATE;
BEGIN
    SELECT seq_vaccination.NEXTVAL INTO v_vacc_id FROM DUAL;
    
    v_next_due := ADD_MONTHS(SYSDATE, p_months_until_next);
    
    INSERT INTO Vaccinations (
        vaccination_id, animal_id, vet_id, vaccine_name,
        date_administered, next_due_date, batch_number,
        administered_by
    ) VALUES (
        v_vacc_id, p_animal_id, p_vet_id, p_vaccine_name,
        SYSDATE, v_next_due, p_batch_number,
        USER
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Vaccination recorded. Next due: ' || 
                         TO_CHAR(v_next_due, 'DD-MON-YYYY'));
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END update_vaccination_record;
/


--- Procedure 5: Generate Monthly Report

CREATE OR REPLACE PROCEDURE generate_monthly_report(
    p_month IN NUMBER,
    p_year IN NUMBER
)
IS
    v_total_intake NUMBER;
    v_total_adoptions NUMBER;
    v_total_donations NUMBER;
    v_start_date DATE;
    v_end_date DATE;
BEGIN
    v_start_date := TO_DATE('01-' || p_month || '-' || p_year, 'DD-MM-YYYY');
    v_end_date := LAST_DAY(v_start_date);
    
    -- Count new intakes
    SELECT COUNT(*) INTO v_total_intake
    FROM Animals
    WHERE intake_date BETWEEN v_start_date AND v_end_date;
    
    -- Count adoptions
    SELECT COUNT(*) INTO v_total_adoptions
    FROM Adoptions
    WHERE adoption_date BETWEEN v_start_date AND v_end_date;
    
    -- Get total donations
    v_total_donations := get_total_donations(v_start_date, v_end_date);
    
    DBMS_OUTPUT.PUT_LINE('===== MONTHLY REPORT =====');
    DBMS_OUTPUT.PUT_LINE('Month: ' || p_month || '/' || p_year);
    DBMS_OUTPUT.PUT_LINE('Total Intakes: ' || v_total_intake);
    DBMS_OUTPUT.PUT_LINE('Total Adoptions: ' || v_total_adoptions);
    DBMS_OUTPUT.PUT_LINE('Total Donations: $' || v_total_donations);
    DBMS_OUTPUT.PUT_LINE('==========================');
END generate_monthly_report;
/


--- Procedure 6: Process Donation

CREATE OR REPLACE PROCEDURE process_donation(
    p_donor_name IN VARCHAR2,
    p_amount IN NUMBER,
    p_donation_type IN VARCHAR2,
    p_purpose IN VARCHAR2 DEFAULT NULL
)
IS
    v_donation_id NUMBER;
BEGIN
    IF p_amount <= 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 'Donation amount must be positive');
    END IF;
    
    SELECT seq_donation.NEXTVAL INTO v_donation_id FROM DUAL;
    
    INSERT INTO Donations (
        donation_id, donor_name, amount, donation_date,
        donation_type, purpose
    ) VALUES (
        v_donation_id, p_donor_name, p_amount, SYSDATE,
        p_donation_type, p_purpose
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Donation recorded. Thank you ' || p_donor_name || '!');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END process_donation;
/


---

-- PART 3: CURSORS AND RECORDS (5 Total)

--- Query 1: Animals Overdue for Vaccination (Explicit Cursor)

DECLARE
    CURSOR c_overdue_vacc IS
        SELECT a.animal_id, a.name, a.species, v.vaccine_name, v.next_due_date
        FROM Animals a
        JOIN Vaccinations v ON a.animal_id = v.animal_id
        WHERE v.next_due_date < SYSDATE
        AND a.status != 'Deceased'
        ORDER BY v.next_due_date;
    
    v_rec c_overdue_vacc%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ANIMALS OVERDUE FOR VACCINATION ===');
    OPEN c_overdue_vacc;
    LOOP
        FETCH c_overdue_vacc INTO v_rec;
        EXIT WHEN c_overdue_vacc%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Animal: ' || v_rec.name || ' (' || v_rec.species || ')');
        DBMS_OUTPUT.PUT_LINE('Vaccine: ' || v_rec.vaccine_name);
        DBMS_OUTPUT.PUT_LINE('Due Date: ' || TO_CHAR(v_rec.next_due_date, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Days Overdue: ' || (SYSDATE - v_rec.next_due_date));
        DBMS_OUTPUT.PUT_LINE('---');
    END LOOP;
    CLOSE c_overdue_vacc;
END;
/


--- Query 2: Animals by Shelter Location (Explicit Cursor with Record)

DECLARE
    CURSOR c_animals_by_shelter IS
        SELECT s.shelter_name, s.city, 
               COUNT(a.animal_id) as animal_count,
               COUNT(CASE WHEN a.status = 'Available' THEN 1 END) as available_count
        FROM Shelters s
        LEFT JOIN Animals a ON s.shelter_id = a.shelter_id
        GROUP BY s.shelter_name, s.city
        ORDER BY animal_count DESC;
    
    TYPE shelter_record_type IS RECORD (
        shelter_name Shelters.shelter_name%TYPE,
        city Shelters.city%TYPE,
        animal_count NUMBER,
        available_count NUMBER
    );
    
    v_shelter shelter_record_type;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ANIMALS BY SHELTER ===');
    FOR v_shelter IN c_animals_by_shelter LOOP
        DBMS_OUTPUT.PUT_LINE('Shelter: ' || v_shelter.shelter_name || ' (' || v_shelter.city || ')');
        DBMS_OUTPUT.PUT_LINE('Total Animals: ' || v_shelter.animal_count);
        DBMS_OUTPUT.PUT_LINE('Available: ' || v_shelter.available_count);
        DBMS_OUTPUT.PUT_LINE('---');
    END LOOP;
END;
/


--- Query 3: Adoption History Report (Explicit Cursor)

DECLARE
    CURSOR c_adoptions(p_start_date DATE, p_end_date DATE) IS
        SELECT ad.adoption_date, 
               an.name as animal_name,
               an.species,
               a.first_name || ' ' || a.last_name as adopter_name,
               ad.adoption_fee,
               ad.status
        FROM Adoptions ad
        JOIN Animals an ON ad.animal_id = an.animal_id
        JOIN Adopters a ON ad.adopter_id = a.adopter_id
        WHERE ad.adoption_date BETWEEN p_start_date AND p_end_date
        ORDER BY ad.adoption_date DESC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ADOPTION HISTORY ===');
    FOR rec IN c_adoptions(ADD_MONTHS(SYSDATE, -3), SYSDATE) LOOP
        DBMS_OUTPUT.PUT_LINE('Date: ' || TO_CHAR(rec.adoption_date, 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Animal: ' || rec.animal_name || ' (' || rec.species || ')');
        DBMS_OUTPUT.PUT_LINE('Adopted by: ' || rec.adopter_name);
        DBMS_OUTPUT.PUT_LINE('Fee: $' || rec.adoption_fee);
        DBMS_OUTPUT.PUT_LINE('---');
    END LOOP;
END;
/


--- Query 4: Animals Ready for Adoption (Implicit Cursor)

DECLARE
    v_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ANIMALS READY FOR ADOPTION ===');
    FOR animal_rec IN (
        SELECT animal_id, name, species, breed, 
               TRUNC(MONTHS_BETWEEN(SYSDATE, date_of_birth)/12) as age_years
        FROM Animals
        WHERE status = 'Available'
        AND animal_id IN (
            SELECT DISTINCT animal_id FROM Vaccinations
            WHERE next_due_date > SYSDATE
        )
        ORDER BY intake_date
    ) LOOP
        v_count := v_count + 1;
        DBMS_OUTPUT.PUT_LINE('Name: ' || animal_rec.name);
        DBMS_OUTPUT.PUT_LINE('Species: ' || animal_rec.species || ' - ' || animal_rec.breed);
        DBMS_OUTPUT.PUT_LINE('Age: ' || animal_rec.age_years || ' years');
        DBMS_OUTPUT.PUT_LINE('Adoption Fee: $' || calculate_adoption_fee(animal_rec.animal_id));
        DBMS_OUTPUT.PUT_LINE('---');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total animals ready: ' || v_count);
END;
/


--- Query 5: Update Animal Statuses (Implicit Cursor)

DECLARE
    v_count NUMBER := 0;
BEGIN
    -- Update animals in medical care for over 30 days to available if no recent records
    FOR animal_rec IN (
        SELECT a.animal_id, a.name
        FROM Animals a
        WHERE a.status = 'Medical Care'
        AND NOT EXISTS (
            SELECT 1 FROM Medical_Records m
            WHERE m.animal_id = a.animal_id
            AND m.visit_date > SYSDATE - 30
        )
    ) LOOP
        UPDATE Animals
        SET status = 'Available'
        WHERE animal_id = animal_rec.animal_id;

        v_count := v_count + 1;

        DBMS_OUTPUT.PUT_LINE('Updated ' || animal_rec.name || ' to Available status');
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status update complete. Records updated: ' || v_count);
END;
/


--- 
