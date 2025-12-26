-- PL/ Implementation - Complete Code

-- PHASE 3: Functions, Procedures, Cursors, Records, Packages, Exceptions, Collections, and Triggers

---

-- PART 1: FUNCTIONS (6 Total)

--- Function 1: Calculate Animal Age

CREATE OR REPLACE FUNCTION calculate_animal_age(p_animal_id IN NUMBER)
RETURN NUMBER
IS
    v_dob DATE;
    v_age NUMBER;
BEGIN
    -- Get date of birth
    SELECT date_of_birth INTO v_dob
    FROM Animals
    WHERE animal_id = p_animal_id;
    
    -- Calculate age in years
    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, v_dob) / 12, 1);
    
    RETURN v_age;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Animal not found');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error calculating age: ' || SQLERRM);
END calculate_animal_age;
/


--- Function 2: Get Total Donations

CREATE OR REPLACE FUNCTION get_total_donations(
    p_start_date IN DATE,
    p_end_date IN DATE
)
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(amount), 0) INTO v_total
    FROM Donations
    WHERE donation_date BETWEEN p_start_date AND p_end_date;
    
    RETURN v_total;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END get_total_donations;
/


--- Function 3: Check Vaccination Due Status

CREATE OR REPLACE FUNCTION check_vaccination_due(p_animal_id IN NUMBER)
RETURN NUMBER
IS
    v_next_due DATE;
    v_days_until NUMBER;
BEGIN
    -- Get the earliest upcoming vaccination due date
    SELECT MIN(next_due_date) INTO v_next_due
    FROM Vaccinations
    WHERE animal_id = p_animal_id
    AND next_due_date >= SYSDATE;
    
    IF v_next_due IS NULL THEN
        RETURN -1; -- No upcoming vaccinations
    END IF;
    
    v_days_until := v_next_due - SYSDATE;
    RETURN TRUNC(v_days_until);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
END check_vaccination_due;
/


--- Function 4: Calculate Adoption Fee

CREATE OR REPLACE FUNCTION calculate_adoption_fee(p_animal_id IN NUMBER)
RETURN NUMBER
IS
    v_species VARCHAR2(50);
    v_age NUMBER;
    v_fee NUMBER := 100; -- Base fee
BEGIN
    SELECT species INTO v_species
    FROM Animals
    WHERE animal_id = p_animal_id;
    
    v_age := calculate_animal_age(p_animal_id);
    
    -- Fee structure based on species and age
    IF v_species = 'Dog' THEN
        v_fee := 150;
    ELSIF v_species = 'Cat' THEN
        v_fee := 100;
    ELSE
        v_fee := 75;
    END IF;
    
    -- Discount for senior animals (over 7 years)
    IF v_age > 7 THEN
        v_fee := v_fee * 0.5;
    END IF;
    
    RETURN v_fee;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END calculate_adoption_fee;
/


--- Function 5: Get Available Vets

CREATE OR REPLACE FUNCTION get_available_vets(p_date IN DATE)
RETURN VARCHAR2
IS
    v_vet_list VARCHAR2(4000) := '';
    v_count NUMBER := 0;
BEGIN
    FOR vet_rec IN (
        SELECT v.vet_id, v.first_name, v.last_name
        FROM Veterinarians v
        WHERE v.is_active = 'Y'
        AND v.vet_id NOT IN (
            SELECT vet_id FROM Appointments
            WHERE TRUNC(appointment_date) = TRUNC(p_date)
            AND status = 'Scheduled'
        )
    ) LOOP
        v_vet_list := v_vet_list || vet_rec.first_name || ' ' || 
                      vet_rec.last_name || ', ';
        v_count := v_count + 1;
    END LOOP;
    
    IF v_count = 0 THEN
        RETURN 'No vets available';
    END IF;
    
    RETURN RTRIM(v_vet_list, ', ');
END get_available_vets;
/


--- Function 6: Calculate Total Treatment Cost

CREATE OR REPLACE FUNCTION calculate_treatment_cost(p_animal_id IN NUMBER)
RETURN NUMBER
IS
    v_total_cost NUMBER;
BEGIN
    SELECT NVL(SUM(cost), 0) INTO v_total_cost
    FROM Treatments
    WHERE animal_id = p_animal_id;
    
    RETURN v_total_cost;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END calculate_treatment_cost;
/