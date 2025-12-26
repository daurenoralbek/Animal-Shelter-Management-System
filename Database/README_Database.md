# README_Database - UPDATED WITH CURSORS & RECORDS

## Database Setup Guide
### Animal Shelter Management System
### INF 305: Database Management Systems 2

---

## QUICK START

### Prerequisites
- Oracle Database 11g or higher
- SQL*Plus or Oracle SQL Developer
- Administrator access to create tables and procedures

### Installation Steps
1. Connect to Oracle Database
2. Run scripts 1-8 **in order** (1, 2, 3, 4, 5, 6, 7, 8)
3. Each script builds on the previous one

---

## SQL SCRIPTS - COMPLETE EXECUTION GUIDE

### 1. **1_create_tables.sql**
**Purpose:** Create the core database schema

**Creates:**
- 11 normalized tables (3NF)
- Primary keys on all tables
- Foreign key constraints
- Check constraints for data validation
- NOT NULL constraints for required fields

**Tables Created:**
```
ANIMALS - Animal records
SHELTERS - Facility information
VETERINARIANS - Vet professional data
STAFF - Employee records
MEDICAL_RECORDS - Health history
VACCINATIONS - Immunization tracking
TREATMENTS - Treatment logs
ADOPTIONS - Adoption tracking
ADOPTERS - Recipient information
DONATIONS - Financial records
APPOINTMENTS - Scheduling
```

**Execution Time:** < 1 second
**Expected Output:** All 11 tables created successfully

**Run Command:**
```sql
@1_create_tables.sql
```

---

### 2. **2_create_sequences.sql**
**Purpose:** Create auto-increment sequences for primary keys

**Creates Sequences:**
```
seq_animal - For ANIMALS.animal_id
seq_shelter - For SHELTERS.shelter_id
seq_adopter - For ADOPTERS.adopter_id
seq_staff - For STAFF.staff_id
seq_vet - For VETERINARIANS.veterinarian_id
seq_medical - For MEDICAL_RECORDS.record_id
seq_vaccination - For VACCINATIONS.vaccination_id
seq_treatment - For TREATMENTS.treatment_id
seq_appointment - For APPOINTMENTS.appointment_id
seq_donation - For DONATIONS.donation_id
```

**Why Sequences?**
- Atomic ID generation (prevents duplicates)
- Works across distributed systems
- Controllable start/increment values
- Oracle standard practice

**Execution Time:** < 1 second
**Expected Output:** 10 sequences created

**Run Command:**
```sql
@2_create_sequences.sql
```

---

### 3. **3_create_functions.sql**
**Purpose:** Create reusable PL/SQL functions

**Functions Created:**

**calculate_animal_age**
```sql
FUNCTION calculate_animal_age(p_animal_id IN NUMBER) RETURN NUMBER
```
- Calculates age in years using MONTHS_BETWEEN
- Returns NULL if date_of_birth is NULL
- Used in views and reports
- Example: `SELECT calculate_animal_age(1) FROM DUAL;`

**get_animal_status**
```sql
FUNCTION get_animal_status(p_animal_id IN NUMBER) RETURN VARCHAR2
```
- Retrieves current status of an animal
- Returns Available, Adopted, Fostered, Medical Care, or Deceased
- Used in dashboards

**count_available_animals**
```sql
FUNCTION count_available_animals(p_shelter_id IN NUMBER) RETURN NUMBER
```
- Counts animals available for adoption by shelter
- Used in dashboard metrics
- Example: `SELECT count_available_animals(1) FROM DUAL;`

**Execution Time:** < 1 second
**Expected Output:** 3 functions created successfully

**Run Command:**
```sql
@3_create_functions.sql
```

---

### 4. **4_create_procedures.sql**
**Purpose:** Create stored procedures for business logic

**Procedures Created:**

**add_animal_intake**
```sql
PROCEDURE add_animal_intake(
p_shelter_id IN NUMBER, p_name IN VARCHAR2, p_species IN VARCHAR2,
p_breed IN VARCHAR2, p_dob IN DATE, p_gender IN CHAR,
p_color IN VARCHAR2, p_weight IN NUMBER, p_microchip IN VARCHAR2,
p_notes IN VARCHAR2
)
```
- Validates required fields
- Checks microchip uniqueness
- Assigns auto-incrementing ID
- Sets status to 'Available'
- Commits transaction

**delete_animal**
```sql
PROCEDURE delete_animal(p_animal_id IN NUMBER)
```
- Prevents deletion if active adoptions pending
- Prevents deletion if animal in medical care
- Cascade deletes related records (medical, vaccinations, etc.)
- Maintains referential integrity

**update_animal_status**
```sql
PROCEDURE update_animal_status(p_animal_id IN NUMBER, p_new_status IN VARCHAR2)
```
- Validates status values
- Updates animal status
- Records modification timestamp

**Execution Time:** < 1 second
**Expected Output:** 3 procedures created successfully

**Run Command:**
```sql
@4_create_procedures.sql
```

---

### 5. **5_create_triggers.sql**
**Purpose:** Create automatic database triggers

**Triggers Created:**

**trg_adoption_complete**
- Fires when new adoption is recorded
- Automatically updates animal status to 'Adopted'
- Ensures data consistency

**trg_animal_delete_log**
- Fires when animal is deleted
- Creates audit log entry
- Maintains deletion history for recovery

**Execution Time:** < 1 second
**Expected Output:** 2 triggers created successfully

**Run Command:**
```sql
@5_create_triggers.sql
```

---

### 6. **6_insert_data.sql**
**Purpose:** Populate database with sample data

**Data Inserted:**

**Sample Animals (150+)**
- Dogs, cats, birds, rabbits
- Various breeds and ages
- Different statuses (Available, Adopted, Medical Care)
- Realistic names and characteristics

**Sample Shelters (3-5)**
- Multiple facility records
- Different locations
- Address and contact info

**Sample Veterinarians (50+)**
- Medical professionals
- Specializations
- License numbers
- Contact information

**Sample Staff (30+)**
- Shelter employees
- Different roles
- Contact details

**Sample Adoptions (30+)**
- Historical adoption records
- Different adoption dates
- Adopter information

**Sample Medical Records (100+)**
- Health history
- Treatments
- Veterinarian visits
- Vaccinations

**Sample Donations (100+)**
- Financial records
- Donation amounts
- Donor information
- Donation dates

**Execution Time:** 2-3 seconds
**Expected Output:** 150+ records inserted per table

**Verify Data:**
```sql
SELECT COUNT(*) FROM ANIMALS; -- Should be 150+
SELECT COUNT(*) FROM SHELTERS; -- Should be 3-5
SELECT COUNT(*) FROM VETERINARIANS; -- Should be 50+
SELECT COUNT(*) FROM MEDICAL_RECORDS; -- Should be 100+
```

**Run Command:**
```sql
@6_insert_data.sql
```

---

### 7. **7_create_views.sql**
**Purpose:** Create optimized views for querying

**Views Created:**

**v_animal_summary** (14 columns)
- Combines ANIMALS with SHELTERS
- Calculates age in years
- Used for animal search page
- Optimized for dashboard

**v_available_animals**
- Shows only available animals
- Ordered by intake date
- Used for adoption listings

**v_adoptions_month**
- Current month adoption metrics
- Completed and pending counts
- Used in dashboard

**v_donations_month**
- Current month donation totals
- Average donation calculation
- Used in financial dashboard

**v_medical_animals**
- Animals with medical records
- Includes veterinarian information
- Ordered by visit date

**v_animals_by_status**
- Distribution of animals by status
- Shows available, adopted, fostered, etc.

**v_staff_by_shelter**
- Staff assignments by facility

**v_veterinarians_info**
- Vet contact and specialization info

**v_recent_vaccinations**
- Recent vaccination records

**v_total_animals_count**
- Quick summary count

**Execution Time:** < 1 second
**Expected Output:** 10 views created successfully

**Query Views:**
```sql
SELECT * FROM v_animal_summary; -- View all animals
SELECT * FROM v_available_animals; -- View available for adoption
SELECT * FROM v_adoptions_month; -- View this month's adoptions
SELECT * FROM v_donations_month; -- View this month's donations
SELECT * FROM v_medical_animals; -- View animals in medical care
```

**Run Command:**
```sql
@7_create_views.sql
```

---

### 8. **8_create_cursors_and_records.sql** ⭐ NEW
**Purpose:** Implement PL/SQL Cursors and Records (Week 6 Requirement)

**Creates:**

**Package: animal_pkg**
- Record type definition (animal_record)
- Table type definition (animal_table collection)
- Used by all cursor implementations

**Procedure 1: process_available_animals**
- Demonstrates explicit cursor
- Uses OPEN/FETCH/CLOSE cycle
- Processes cursor with record variable
- Uses cursor attributes (%NOTFOUND, %ISOPEN)
- Outputs formatted animal list

**Procedure 2: update_medical_animals**
- Demonstrates cursor FOR loop
- Uses %ROWTYPE attribute
- Group by aggregate functions
- Updates records based on cursor data
- Simpler syntax than explicit cursor

**Procedure 3: get_shelter_animals**
- Demonstrates record collection (TABLE type)
- Stores multiple records
- OUT parameter returns collection
- Indexed table access (PLS_INTEGER)
- Can be used by APEX forms

**Function: calc_avg_weight_by_species**
- Demonstrates cursor in function
- Calculates averages from cursor rows
- Uses FOR loop to process records
- Returns computed value

**Learning Outcomes Covered:**
- ✅ Explicit cursor declaration and usage
- ✅ Implicit cursor with FOR loops
- ✅ Record types (custom records)
- ✅ Collections (TABLE OF records)
- ✅ Cursor attributes (%NOTFOUND, %ISOPEN, %ROWTYPE)
- ✅ Record processing in loops
- ✅ Exception handling with cursors
- ✅ Real-world data processing

**Execution Time:** < 1 second
**Expected Output:** Package + 3 procedures + 1 function created

**Test Cursor Code:**
```sql
-- Test 1: Process available animals
BEGIN
process_available_animals();
END;
/

-- Test 2: Update medical animals
BEGIN
update_medical_animals();
END;
/

-- Test 3: Get shelter animals into collection
DECLARE
v_shelter_animals animal_pkg.animal_table;
v_count NUMBER;
BEGIN
get_shelter_animals(1, v_shelter_animals);
v_count := v_shelter_animals.COUNT;
DBMS_OUTPUT.PUT_LINE('Total: ' || v_count);
FOR i IN 1 .. v_count LOOP
DBMS_OUTPUT.PUT_LINE(v_shelter_animals(i).name);
END LOOP;
END;
/

-- Test 4: Calculate average weight
DECLARE
v_avg NUMBER;
BEGIN
v_avg := calc_avg_weight_by_species('Dog');
DBMS_OUTPUT.PUT_LINE('Avg Dog Weight: ' || v_avg || ' kg');
END;
/
```

**Run Command:**
```sql
@8_create_cursors_and_records.sql
```

---

## COMPLETE SETUP SEQUENCE

### All Scripts in Order
```sql
-- Run in this order:
@1_create_tables.sql
@2_create_sequences.sql
@3_create_functions.sql
@4_create_procedures.sql
@5_create_triggers.sql
@6_insert_data.sql
@7_create_views.sql
@8_create_cursors_and_records.sql

-- Total execution time: ~5-10 seconds
```

### Or Run Combined Script
If all scripts are in one file:
```sql
@create_all.sql
```

---

## VERIFICATION CHECKLIST

After running all scripts, verify:

- [ ] **Tables:** 11 tables created
```sql
SELECT COUNT(*) FROM user_tables WHERE table_name LIKE 'ANIMAL%' OR table_name LIKE 'SHELTER%';
```

- [ ] **Sequences:** 10 sequences created
```sql
SELECT COUNT(*) FROM user_sequences WHERE sequence_name LIKE 'SEQ_%';
```

- [ ] **Functions:** 3 functions created
```sql
SELECT COUNT(*) FROM user_functions WHERE function_name LIKE '%ANIMAL%';
```

- [ ] **Procedures:** 3 procedures created
```sql
SELECT COUNT(*) FROM user_procedures WHERE procedure_name LIKE '%ANIMAL%';
```

- [ ] **Triggers:** 2 triggers created
```sql
SELECT COUNT(*) FROM user_triggers WHERE trigger_name LIKE 'TRG_%';
```

- [ ] **Package:** 1 package created
```sql
SELECT COUNT(*) FROM user_packages WHERE package_name = 'ANIMAL_PKG';
```

- [ ] **Views:** 10 views created
```sql
SELECT COUNT(*) FROM user_views WHERE view_name LIKE 'V_%';
```

- [ ] **Data:** 150+ animals inserted
```sql
SELECT COUNT(*) FROM ANIMALS;
```

- [ ] **Test Procedures:** All execute without error
```sql
BEGIN process_available_animals(); END;
BEGIN update_medical_animals(); END;
EXEC calc_avg_weight_by_species('Dog');
```

---

## TROUBLESHOOTING

### Error: Table already exists
**Solution:** Drop tables first
```sql
DROP TABLE ANIMALS CASCADE CONSTRAINTS;
DROP TABLE SHELTERS CASCADE CONSTRAINTS;
-- etc...
```

### Error: Sequence already exists
**Solution:** Drop sequence first
```sql
DROP SEQUENCE seq_animal;
-- etc...
```

### Error: Cannot insert NULL into required field
**Solution:** Check data file - all required columns must have values

### Error: Foreign key constraint violated
**Solution:** Tables must be created in correct order (parent before child)

### Error: Function compilation failed
**Solution:** Check for typos in column names

### Error: Procedure compilation failed
**Solution:** Check that all referenced tables exist

---

## SCRIPT DEPENDENCIES

```
1_create_tables.sql
↓
2_create_sequences.sql
↓
3_create_functions.sql (references ANIMALS, SHELTERS, VETERINARIANS)
↓
4_create_procedures.sql (uses sequences + functions)
↓
5_create_triggers.sql (uses tables + procedures)
↓
6_insert_data.sql (inserts into all tables)
↓
7_create_views.sql (queries from tables with data)
↓
8_create_cursors_and_records.sql (processes data with cursors)
```

**DO NOT run out of order!**

---

## IMPORTANT NOTES

### Data Persistence
- All data is saved after COMMIT in each script
- ROLLBACK on error prevents partial inserts
- Data survives database restart

### Performance
- Indexes on primary keys created automatically
- Foreign key indexes improve join performance
- Views optimize common queries

### Security
- Procedures validate inputs (prevents SQL injection)
- Constraints prevent invalid data
- Exception handling prevents crashes

### Maintenance
- Use procedures to add/update/delete animals
- Don't modify table data directly (triggers may not fire)
- Review audit logs for deleted records

---

## NEXT STEPS

1. **Run all 8 scripts** in order
2. **Verify installation** using checklist above
3. **Import APEX application** to use web interface
4. **Test procedures** manually
5. **Review data** in views

---

**Status:** ✅ Complete Database Setup Guide
**Version:** 2.0 (Updated with Cursors & Records)
**Total Scripts:** 8
**Total Setup Time:** ~5-10 seconds
**Production Ready:** Yes
