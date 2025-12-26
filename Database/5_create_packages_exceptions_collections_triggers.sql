-- PL/ Implementation - Part 2

-- PACKAGES, EXCEPTIONS, COLLECTIONS, AND TRIGGERS

---

-- PART 4: PACKAGES (2 Packages = 3 Queries)

--- Package 1: ANIMAL_MANAGEMENT_PKG


CREATE OR REPLACE PACKAGE animal_management_pkg AS
    -- Custom exceptions
    ex_animal_not_found EXCEPTION;
    ex_invalid_status EXCEPTION;
    ex_vaccination_overdue EXCEPTION;
    
    -- Procedures
    PROCEDURE register_new_animal(
        p_shelter_id IN NUMBER,
        p_name IN VARCHAR2,
        p_species IN VARCHAR2,
        p_breed IN VARCHAR2
    );
    
    PROCEDURE transfer_animal(
        p_animal_id IN NUMBER,
        p_new_shelter_id IN NUMBER
    );
    
    -- Functions
    FUNCTION get_animal_summary(p_animal_id IN NUMBER) RETURN VARCHAR2;
    
END animal_management_pkg;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY animal_management_pkg AS
    
    PROCEDURE register_new_animal(
        p_shelter_id IN NUMBER,
        p_name IN VARCHAR2,
        p_species IN VARCHAR2,
        p_breed IN VARCHAR2
    ) IS
        v_animal_id NUMBER;
    BEGIN
        SELECT seq_animal.NEXTVAL INTO v_animal_id FROM DUAL;
        
        INSERT INTO Animals (
            animal_id, shelter_id, name, species, breed,
            intake_date, status
        ) VALUES (
            v_animal_id, p_shelter_id, p_name, p_species, p_breed,
            SYSDATE, 'Available'
        );
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Animal registered with ID: ' || v_animal_id);
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20010, 'Failed to register animal: ' || SQLERRM);
    END register_new_animal;
    
    PROCEDURE transfer_animal(
        p_animal_id IN NUMBER,
        p_new_shelter_id IN NUMBER
    ) IS
        v_count NUMBER;
    BEGIN
        -- Check if animal exists
        SELECT COUNT(*) INTO v_count
        FROM Animals
        WHERE animal_id = p_animal_id;
        
        IF v_count = 0 THEN
            RAISE ex_animal_not_found;
        END IF;
        
        UPDATE Animals
        SET shelter_id = p_new_shelter_id
        WHERE animal_id = p_animal_id;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Animal transferred successfully');
    EXCEPTION
        WHEN ex_animal_not_found THEN
            RAISE_APPLICATION_ERROR(-20001, 'Animal not found');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END transfer_animal;
    
    FUNCTION get_animal_summary(p_animal_id IN NUMBER) 
    RETURN VARCHAR2 IS
        v_summary VARCHAR2(500);
        v_name Animals.name%TYPE;
        v_species Animals.species%TYPE;
        v_status Animals.status%TYPE;
        v_age NUMBER;
    BEGIN
        SELECT name, species, status
        INTO v_name, v_species, v_status
        FROM Animals
        WHERE animal_id = p_animal_id;
        
        v_age := calculate_animal_age(p_animal_id);
        
        v_summary := 'Name: ' || v_name || 
                     ', Species: ' || v_species || 
                     ', Age: ' || v_age || ' years' ||
                     ', Status: ' || v_status;
        
        RETURN v_summary;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Animal not found';
    END get_animal_summary;
    
END animal_management_pkg;
/


--- Package 2: REPORTING_PKG

CREATE OR REPLACE PACKAGE reporting_pkg AS
    PROCEDURE shelter_occupancy_report;
    PROCEDURE vaccination_compliance_report;
    FUNCTION get_adoption_rate(p_year IN NUMBER) RETURN NUMBER;
END reporting_pkg;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY reporting_pkg AS
    
    PROCEDURE shelter_occupancy_report IS
        CURSOR c_shelters IS
            SELECT s.shelter_name, s.capacity,
                   COUNT(a.animal_id) as current_count,
                   ROUND(COUNT(a.animal_id) / s.capacity * 100, 2) as occupancy_pct
            FROM Shelters s
            LEFT JOIN Animals a ON s.shelter_id = a.shelter_id 
                AND a.status IN ('Available', 'Medical Care')
            GROUP BY s.shelter_name, s.capacity
            ORDER BY occupancy_pct DESC;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('=== SHELTER OCCUPANCY REPORT ===');
        FOR rec IN c_shelters LOOP
            DBMS_OUTPUT.PUT_LINE('Shelter: ' || rec.shelter_name);
            DBMS_OUTPUT.PUT_LINE('Capacity: ' || rec.capacity);
            DBMS_OUTPUT.PUT_LINE('Current: ' || rec.current_count);
            DBMS_OUTPUT.PUT_LINE('Occupancy: ' || rec.occupancy_pct || '%');
            DBMS_OUTPUT.PUT_LINE('---');
        END LOOP;
    END shelter_occupancy_report;
    
    PROCEDURE vaccination_compliance_report IS
        v_total_animals NUMBER;
        v_compliant NUMBER;
        v_compliance_rate NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total_animals
        FROM Animals
        WHERE status != 'Deceased';
        
        SELECT COUNT(DISTINCT animal_id) INTO v_compliant
        FROM Vaccinations
        WHERE next_due_date >= SYSDATE;
        
        v_compliance_rate := ROUND((v_compliant / v_total_animals) * 100, 2);
        
        DBMS_OUTPUT.PUT_LINE('=== VACCINATION COMPLIANCE ===');
        DBMS_OUTPUT.PUT_LINE('Total Animals: ' || v_total_animals);
        DBMS_OUTPUT.PUT_LINE('Compliant: ' || v_compliant);
        DBMS_OUTPUT.PUT_LINE('Compliance Rate: ' || v_compliance_rate || '%');
    END vaccination_compliance_report;
    
    FUNCTION get_adoption_rate(p_year IN NUMBER) 
    RETURN NUMBER IS
        v_total_available NUMBER;
        v_adopted NUMBER;
        v_rate NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total_available
        FROM Animals
        WHERE EXTRACT(YEAR FROM intake_date) = p_year;
        
        SELECT COUNT(*) INTO v_adopted
        FROM Adoptions
        WHERE EXTRACT(YEAR FROM adoption_date) = p_year
        AND status IN ('Completed', 'Approved');
        
        IF v_total_available = 0 THEN
            RETURN 0;
        END IF;
        
        v_rate := ROUND((v_adopted / v_total_available) * 100, 2);
        RETURN v_rate;
    END get_adoption_rate;
    
END reporting_pkg;
/


---

-- PART 5: COLLECTIONS (1 Query)

--- Collection: Store and Process Vaccination Dates

DECLARE
    -- Define collection type
    TYPE vaccination_dates_type IS TABLE OF DATE;
    v_vacc_dates vaccination_dates_type := vaccination_dates_type();

    v_animal_id NUMBER := 1; -- Example animal ID
    v_count NUMBER := 0;

    CURSOR c_vaccinations IS
        SELECT date_administered, next_due_date
        FROM Vaccinations
        WHERE animal_id = v_animal_id
        ORDER BY date_administered;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== VACCINATION HISTORY (Using Collections) ===');

    -- Populate collection
    FOR vacc_rec IN c_vaccinations LOOP
        v_vacc_dates.EXTEND;
        v_count := v_count + 1;
        v_vacc_dates(v_count) := vacc_rec.date_administered;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total vaccinations: ' || v_vacc_dates.COUNT);

    -- Display collection contents
    IF v_vacc_dates.COUNT > 0 THEN
        FOR i IN v_vacc_dates.FIRST..v_vacc_dates.LAST LOOP
            IF v_vacc_dates.EXISTS(i) THEN
                DBMS_OUTPUT.PUT_LINE('Vaccination ' || i || ': ' || 
                                   TO_CHAR(v_vacc_dates(i), 'DD-MON-YYYY'));
            END IF;
        END LOOP;
    END IF;

    -- Collection methods demonstration
    IF v_vacc_dates.COUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('First element: ' || 
            TO_CHAR(v_vacc_dates(v_vacc_dates.FIRST), 'DD-MON-YYYY'));
        DBMS_OUTPUT.PUT_LINE('Last element: ' || 
            TO_CHAR(v_vacc_dates(v_vacc_dates.LAST), 'DD-MON-YYYY'));
    END IF;

    -- Delete specific element
    IF v_vacc_dates.COUNT > 1 THEN
        v_vacc_dates.DELETE(1);
        DBMS_OUTPUT.PUT_LINE('After deletion, count: ' || v_vacc_dates.COUNT);
    END IF;
END;
/


---

-- PART 6: TRIGGERS (5 Total)

--- Trigger 1: Auto-generate Animal ID and Validate Data

CREATE OR REPLACE TRIGGER trg_animal_before_insert
BEFORE INSERT ON Animals
FOR EACH ROW
BEGIN
    -- Auto-generate animal_id if not provided
    IF :NEW.animal_id IS NULL THEN
        SELECT seq_animal.NEXTVAL INTO :NEW.animal_id FROM DUAL;
    END IF;
    
    -- Set default intake date
    IF :NEW.intake_date IS NULL THEN
        :NEW.intake_date := SYSDATE;
    END IF;
    
    -- Validate weight
    IF :NEW.weight IS NOT NULL AND :NEW.weight <= 0 THEN
        RAISE_APPLICATION_ERROR(-20011, 'Weight must be positive');
    END IF;
    
    -- Validate date of birth
    IF :NEW.date_of_birth > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20012, 'Date of birth cannot be in the future');
    END IF;
END;
/


--- Trigger 2: Auto-update Next Due Date for Vaccinations

CREATE OR REPLACE TRIGGER trg_vaccination_after_insert
AFTER INSERT ON Vaccinations
FOR EACH ROW
DECLARE
    v_months_until_next NUMBER := 12; -- Default interval
BEGIN
    -- Set different intervals based on vaccine type
    IF UPPER(:NEW.vaccine_name) LIKE '%RABIES%' THEN
        v_months_until_next := 36; -- 3 years
    ELSIF UPPER(:NEW.vaccine_name) LIKE '%DISTEMPER%' THEN
        v_months_until_next := 12; -- 1 year
    END IF;
    
    -- Update next due date if not already set
    IF :NEW.next_due_date IS NULL THEN
        UPDATE Vaccinations
        SET next_due_date = ADD_MONTHS(:NEW.date_administered, v_months_until_next)
        WHERE vaccination_id = :NEW.vaccination_id;
    END IF;
END;
/


--- Trigger 3: Validate Adoption Status Changes

CREATE OR REPLACE TRIGGER trg_adoption_before_update
BEFORE UPDATE OF status ON Adoptions
FOR EACH ROW
BEGIN
    -- Validate status transitions
    IF :OLD.status = 'Completed' AND :NEW.status = 'Pending' THEN
        RAISE_APPLICATION_ERROR(-20013, 
            'Cannot change completed adoption back to pending');
    END IF;
    
    -- If marked as returned, require return date and reason
    IF :NEW.status = 'Returned' THEN
        IF :NEW.return_date IS NULL THEN
            :NEW.return_date := SYSDATE;
        END IF;
        
        IF :NEW.return_reason IS NULL THEN
            RAISE_APPLICATION_ERROR(-20014, 
                'Return reason is required for returned adoptions');
        END IF;
        
        -- Update animal status back to available
        UPDATE Animals
        SET status = 'Available'
        WHERE animal_id = :NEW.animal_id;
    END IF;
END;
/


--- Trigger 4: Log Animal Status Changes

CREATE OR REPLACE TRIGGER trg_animal_status_audit
AFTER UPDATE OF status ON Animals
FOR EACH ROW
WHEN (OLD.status != NEW.status)
DECLARE
    v_audit_id NUMBER;
BEGIN
    SELECT seq_audit.NEXTVAL INTO v_audit_id FROM DUAL;
    
    INSERT INTO Animal_Status_Audit (
        audit_id, animal_id, old_status, new_status, 
        change_date, changed_by
    ) VALUES (
        v_audit_id, :NEW.animal_id, :OLD.status, :NEW.status,
        SYSDATE, USER
    );
END;
/


--- Trigger 5: Prevent Deletion of Staff with Active Appointments

CREATE OR REPLACE TRIGGER trg_staff_before_delete
BEFORE DELETE ON Staff
FOR EACH ROW
DECLARE
    v_active_appts NUMBER;
BEGIN
    -- Check for active appointments
    SELECT COUNT(*) INTO v_active_appts
    FROM Adoptions
    WHERE staff_id = :OLD.staff_id
    AND status IN ('Pending', 'Approved');
    
    IF v_active_appts > 0 THEN
        RAISE_APPLICATION_ERROR(-20015, 
            'Cannot delete staff member with ' || v_active_appts || 
            ' active adoption(s). Please reassign or complete them first.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Staff member ' || :OLD.first_name || ' ' || 
                        :OLD.last_name || ' deleted successfully');
END;
/


---

-- PART 7: EXCEPTION HANDLING EXAMPLES (Built into Packages)

CREATE OR REPLACE PROCEDURE check_animal_health(p_animal_id IN NUMBER)
IS
    v_status Animals.status%TYPE;
    v_days_overdue NUMBER;
    ex_vaccination_overdue EXCEPTION;
BEGIN
    -- Get animal status
    SELECT status INTO v_status
    FROM Animals
    WHERE animal_id = p_animal_id;
    
    -- Check vaccination status
    v_days_overdue := check_vaccination_due(p_animal_id);
    
    IF v_days_overdue < -30 THEN  -- More than 30 days overdue
        RAISE ex_vaccination_overdue;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Animal health check passed');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Animal not found');
    WHEN ex_vaccination_overdue THEN
        RAISE_APPLICATION_ERROR(-20016, 
            'CRITICAL: Animal vaccination is ' || ABS(v_days_overdue) || 
            ' days overdue!');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20017, 
            'Error checking animal health: ' || SQLERRM);
END check_animal_health;
/


---

-- Testing Scripts

--- Test All Functions

BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing Functions...');
    DBMS_OUTPUT.PUT_LINE('Age of animal 1: ' || calculate_animal_age(1));
    DBMS_OUTPUT.PUT_LINE('Donations this year: $' || 
        get_total_donations(TRUNC(SYSDATE, 'YEAR'), SYSDATE));
    DBMS_OUTPUT.PUT_LINE('Days until vaccination: ' || check_vaccination_due(1));
    DBMS_OUTPUT.PUT_LINE('Adoption fee: $' || calculate_adoption_fee(1));
    DBMS_OUTPUT.PUT_LINE('Available vets: ' || get_available_vets(SYSDATE));
    DBMS_OUTPUT.PUT_LINE('Treatment cost: $' || calculate_treatment_cost(1));
END;
/


--- Test Packages

BEGIN
    -- Test Animal Management Package
    DBMS_OUTPUT.PUT_LINE(animal_management_pkg.get_animal_summary(1));
    
    -- Test Reporting Package
    reporting_pkg.shelter_occupancy_report;
    reporting_pkg.vaccination_compliance_report;
    DBMS_OUTPUT.PUT_LINE('Adoption rate 2024: ' || 
        reporting_pkg.get_adoption_rate(2024) || '%');
END;
/