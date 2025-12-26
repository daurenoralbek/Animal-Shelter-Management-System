-- Package definition with record types
CREATE OR REPLACE PACKAGE animal_pkg IS
  TYPE animal_record IS RECORD (
    animal_id       ANIMALS.animal_id%TYPE,
    name            ANIMALS.name%TYPE,
    species         ANIMALS.species%TYPE,
    breed           ANIMALS.breed%TYPE,
    age_years       NUMBER,
    status          ANIMALS.status%TYPE,
    shelter_name    SHELTERS.shelter_name%TYPE,
    vet_name        VETERINARIANS.first_name%TYPE
  );
  
  TYPE animal_table IS TABLE OF animal_record INDEX BY PLS_INTEGER;
END animal_pkg;
/

-- Procedure 1: Explicit cursor processing
CREATE OR REPLACE PROCEDURE process_available_animals IS 
  CURSOR animal_cursor IS 
    SELECT a.animal_id, 
           a.name, 
           a.species, 
           a.breed, 
           ROUND(MONTHS_BETWEEN(SYSDATE, a.date_of_birth) / 12, 2) as age_years, 
           a.status, 
           s.shelter_name as shelter_name, 
           v.first_name as vet_name 
    FROM ANIMALS a 
    JOIN SHELTERS s ON a.shelter_id = s.shelter_id 
    LEFT JOIN MEDICAL_RECORDS m ON a.animal_id = m.animal_id 
    LEFT JOIN VETERINARIANS v ON m.vet_id = v.vet_id 
    WHERE a.status = 'Available' 
    ORDER BY a.intake_date ASC; 
   
  v_animal_rec animal_pkg.animal_record; 
  v_count NUMBER := 0; 
BEGIN 
  OPEN animal_cursor; 
  LOOP 
    FETCH animal_cursor INTO v_animal_rec; 
    EXIT WHEN animal_cursor%NOTFOUND; 
    v_count := v_count + 1; 
    DBMS_OUTPUT.PUT_LINE(v_count || '. ' || v_animal_rec.name ||  
                         ' (' || v_animal_rec.species || ')'); 
    DBMS_OUTPUT.PUT_LINE('   Breed: ' || v_animal_rec.breed);
    DBMS_OUTPUT.PUT_LINE('   Age: ' || v_animal_rec.age_years || ' years');
    DBMS_OUTPUT.PUT_LINE('   Status: ' || v_animal_rec.status);
    DBMS_OUTPUT.PUT_LINE('   Shelter: ' || v_animal_rec.shelter_name);
    IF v_animal_rec.vet_name IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE('   Vet: ' || v_animal_rec.vet_name);
    END IF;
  END LOOP; 
  CLOSE animal_cursor; 
  DBMS_OUTPUT.PUT_LINE('Total Available Animals: ' || v_count); 
EXCEPTION 
  WHEN OTHERS THEN 
    IF animal_cursor%ISOPEN THEN CLOSE animal_cursor; END IF; 
    RAISE_APPLICATION_ERROR(-20001, 'Error: ' || SQLERRM); 
END process_available_animals; 
/

-- Procedure 2: Cursor FOR loop
CREATE OR REPLACE PROCEDURE update_medical_animals IS
  CURSOR medical_animals_cursor IS
    SELECT a.animal_id, a.name,
           COUNT(m.record_id) as total_treatments,
           MAX(m.visit_date) as last_visit
    FROM ANIMALS a
    LEFT JOIN MEDICAL_RECORDS m ON a.animal_id = m.animal_id
    WHERE a.status = 'Medical Care'
    GROUP BY a.animal_id, a.name;
  
  v_medical_rec medical_animals_cursor%ROWTYPE;
  v_updated_count NUMBER := 0;
BEGIN
  FOR v_medical_rec IN medical_animals_cursor LOOP
    IF v_medical_rec.total_treatments > 0 THEN
      UPDATE ANIMALS SET notes = 'Treated ' || v_medical_rec.total_treatments || 
                                  ' times. Last visit: ' || v_medical_rec.last_visit
      WHERE animal_id = v_medical_rec.animal_id;
      v_updated_count := v_updated_count + 1;
    END IF;
  END LOOP;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Updated ' || v_updated_count || ' animals');
EXCEPTION
  WHEN OTHERS THEN ROLLBACK; 
    RAISE_APPLICATION_ERROR(-20002, 'Error: ' || SQLERRM);
END update_medical_animals;
/

-- Procedure 3: Collection with records
CREATE OR REPLACE PROCEDURE get_shelter_animals(
  p_shelter_id IN NUMBER,
  p_animals_table OUT animal_pkg.animal_table
) IS
  CURSOR shelter_animals IS
    SELECT a.animal_id, a.name, a.species, a.breed,
           ROUND(MONTHS_BETWEEN(SYSDATE, a.date_of_birth) / 12, 2),
           a.status, s.shelter_name, v.first_name
    FROM ANIMALS a
    JOIN SHELTERS s ON a.shelter_id = s.shelter_id
    LEFT JOIN MEDICAL_RECORDS m ON a.animal_id = m.animal_id 
    LEFT JOIN VETERINARIANS v ON m.vet_id = v.vet_id 
    WHERE a.shelter_id = p_shelter_id;
  
  v_index PLS_INTEGER := 1;
  v_animal_rec animal_pkg.animal_record;
BEGIN
  p_animals_table.DELETE;
  FOR v_animal_rec IN shelter_animals LOOP
    p_animals_table(v_index) := v_animal_rec;
    v_index := v_index + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Retrieved ' || (v_index - 1) || ' animals');
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20003, 'Error: ' || SQLERRM);
END get_shelter_animals;
/

-- Function 4: Processing cursor records
CREATE OR REPLACE FUNCTION calc_avg_weight_by_species(
  p_species IN VARCHAR2
) RETURN NUMBER IS
  CURSOR weight_cursor IS
    SELECT weight FROM ANIMALS
    WHERE species = p_species AND weight IS NOT NULL;
  
  v_weight_rec weight_cursor%ROWTYPE;
  v_total_weight NUMBER := 0;
  v_count NUMBER := 0;
BEGIN
  FOR v_weight_rec IN weight_cursor LOOP
    v_total_weight := v_total_weight + v_weight_rec.weight;
    v_count := v_count + 1;
  END LOOP;
  
  IF v_count > 0 THEN
    RETURN v_total_weight / v_count;
  ELSE
    RETURN NULL;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20004, 'Error: ' || SQLERRM);
END calc_avg_weight_by_species;
/
