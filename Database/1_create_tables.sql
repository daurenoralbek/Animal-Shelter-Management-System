-- =============================================
-- TABLE 1: SHELTERS
-- =============================================
CREATE TABLE Shelters (
    shelter_id NUMBER PRIMARY KEY,
    shelter_name VARCHAR2(100) NOT NULL,
    address VARCHAR2(200),
    city VARCHAR2(50),
    state VARCHAR2(50),
    zipcode VARCHAR2(10),
    phone VARCHAR2(20),
    email VARCHAR2(100) UNIQUE,
    capacity NUMBER CHECK (capacity > 0),
    manager_name VARCHAR2(100),
    created_date DATE DEFAULT SYSDATE
);

-- =============================================
-- TABLE 2: ANIMALS
-- =============================================
CREATE TABLE Animals (
    animal_id NUMBER PRIMARY KEY,
    shelter_id NUMBER NOT NULL,
    name VARCHAR2(100) NOT NULL,
    species VARCHAR2(50) NOT NULL,
    breed VARCHAR2(100),
    date_of_birth DATE,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    color VARCHAR2(50),
    weight NUMBER(5,2),
    intake_date DATE DEFAULT SYSDATE,
    status VARCHAR2(20) DEFAULT 'Available' 
        CHECK (status IN ('Available', 'Adopted', 'Fostered', 'Medical Care', 'Deceased')),
    microchip_number VARCHAR2(20) UNIQUE,
    notes VARCHAR2(500),
    CONSTRAINT fk_animals_shelter 
        FOREIGN KEY (shelter_id) REFERENCES Shelters(shelter_id)
);

-- =============================================
-- TABLE 3: ADOPTERS
-- =============================================
CREATE TABLE Adopters (
    adopter_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone VARCHAR2(20),
    address VARCHAR2(200),
    city VARCHAR2(50),
    state VARCHAR2(50),
    zipcode VARCHAR2(10),
    occupation VARCHAR2(100),
    housing_type VARCHAR2(50) CHECK (housing_type IN ('House', 'Apartment', 'Condo', 'Farm')),
    registration_date DATE DEFAULT SYSDATE
);

-- =============================================
-- TABLE 4: STAFF
-- =============================================
CREATE TABLE Staff (
    staff_id NUMBER PRIMARY KEY,
    shelter_id NUMBER NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    role VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    phone VARCHAR2(20),
    hire_date DATE DEFAULT SYSDATE,
    salary NUMBER(10,2),
    is_active CHAR(1) DEFAULT 'Y' CHECK (is_active IN ('Y', 'N')),
    CONSTRAINT fk_staff_shelter 
        FOREIGN KEY (shelter_id) REFERENCES Shelters(shelter_id)
);

-- =============================================
-- TABLE 5: VETERINARIANS
-- =============================================
CREATE TABLE Veterinarians (
    vet_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    specialty VARCHAR2(100),
    license_number VARCHAR2(50) UNIQUE NOT NULL,
    phone VARCHAR2(20),
    email VARCHAR2(100) UNIQUE,
    clinic_address VARCHAR2(200),
    years_experience NUMBER CHECK (years_experience >= 0),
    is_active CHAR(1) DEFAULT 'Y' CHECK (is_active IN ('Y', 'N'))
);

-- =============================================
-- TABLE 6: MEDICAL_RECORDS
-- =============================================
CREATE TABLE Medical_Records (
    record_id NUMBER PRIMARY KEY,
    animal_id NUMBER NOT NULL,
    vet_id NUMBER NOT NULL,
    visit_date DATE DEFAULT SYSDATE,
    diagnosis VARCHAR2(300),
    treatment VARCHAR2(500),
    prescription VARCHAR2(300),
    cost NUMBER(10,2),
    follow_up_date DATE,
    notes VARCHAR2(500),
    CONSTRAINT fk_medical_animal 
        FOREIGN KEY (animal_id) REFERENCES Animals(animal_id),
    CONSTRAINT fk_medical_vet 
        FOREIGN KEY (vet_id) REFERENCES Veterinarians(vet_id)
);

-- =============================================
-- TABLE 7: VACCINATIONS
-- =============================================
CREATE TABLE Vaccinations (
    vaccination_id NUMBER PRIMARY KEY,
    animal_id NUMBER NOT NULL,
    vet_id NUMBER NOT NULL,
    vaccine_name VARCHAR2(100) NOT NULL,
    date_administered DATE DEFAULT SYSDATE,
    next_due_date DATE,
    batch_number VARCHAR2(50),
    administered_by VARCHAR2(100),
    CONSTRAINT fk_vacc_animal 
        FOREIGN KEY (animal_id) REFERENCES Animals(animal_id),
    CONSTRAINT fk_vacc_vet 
        FOREIGN KEY (vet_id) REFERENCES Veterinarians(vet_id)
);

-- =============================================
-- TABLE 8: ADOPTIONS
-- =============================================
CREATE TABLE Adoptions (
    adoption_id NUMBER PRIMARY KEY,
    animal_id NUMBER NOT NULL,
    adopter_id NUMBER NOT NULL,
    staff_id NUMBER NOT NULL,
    adoption_date DATE DEFAULT SYSDATE,
    adoption_fee NUMBER(10,2),
    status VARCHAR2(20) DEFAULT 'Pending' 
        CHECK (status IN ('Pending', 'Approved', 'Completed', 'Returned')),
    contract_signed CHAR(1) DEFAULT 'N' CHECK (contract_signed IN ('Y', 'N')),
    return_date DATE,
    return_reason VARCHAR2(300),
    CONSTRAINT fk_adoption_animal 
        FOREIGN KEY (animal_id) REFERENCES Animals(animal_id),
    CONSTRAINT fk_adoption_adopter 
        FOREIGN KEY (adopter_id) REFERENCES Adopters(adopter_id),
    CONSTRAINT fk_adoption_staff 
        FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- =============================================
-- TABLE 9: APPOINTMENTS
-- =============================================
CREATE TABLE Appointments (
    appointment_id NUMBER PRIMARY KEY,
    animal_id NUMBER NOT NULL,
    vet_id NUMBER NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time VARCHAR2(10),
    purpose VARCHAR2(200),
    status VARCHAR2(20) DEFAULT 'Scheduled' 
        CHECK (status IN ('Scheduled', 'Completed', 'Cancelled', 'No-Show')),
    notes VARCHAR2(500),
    CONSTRAINT fk_appt_animal 
        FOREIGN KEY (animal_id) REFERENCES Animals(animal_id),
    CONSTRAINT fk_appt_vet 
        FOREIGN KEY (vet_id) REFERENCES Veterinarians(vet_id)
);

-- =============================================
-- TABLE 10: DONATIONS
-- =============================================
CREATE TABLE Donations (
    donation_id NUMBER PRIMARY KEY,
    donor_name VARCHAR2(100) NOT NULL,
    donor_email VARCHAR2(100),
    donor_phone VARCHAR2(20),
    amount NUMBER(10,2) CHECK (amount > 0),
    donation_date DATE DEFAULT SYSDATE,
    donation_type VARCHAR2(20) CHECK (donation_type IN ('Cash', 'Supplies', 'Food', 'Medical')),
    purpose VARCHAR2(200),
    is_recurring CHAR(1) DEFAULT 'N' CHECK (is_recurring IN ('Y', 'N'))
);

-- =============================================
-- TABLE 11: MEDICATIONS
-- =============================================
CREATE TABLE Medications (
    medication_id NUMBER PRIMARY KEY,
    medication_name VARCHAR2(100) NOT NULL,
    medication_type VARCHAR2(50),
    dosage_form VARCHAR2(50),
    manufacturer VARCHAR2(100),
    supplier VARCHAR2(100),
    unit_price NUMBER(10,2),
    stock_quantity NUMBER DEFAULT 0,
    reorder_level NUMBER DEFAULT 10,
    expiry_date DATE
);

-- =============================================
-- TABLE 12: TREATMENTS
-- =============================================
CREATE TABLE Treatments (
    treatment_id NUMBER PRIMARY KEY,
    animal_id NUMBER NOT NULL,
    medication_id NUMBER NOT NULL,
    vet_id NUMBER NOT NULL,
    treatment_date DATE DEFAULT SYSDATE,
    dosage_given VARCHAR2(50),
    frequency VARCHAR2(50),
    duration_days NUMBER,
    cost NUMBER(10,2),
    notes VARCHAR2(300),
    CONSTRAINT fk_treatment_animal 
        FOREIGN KEY (animal_id) REFERENCES Animals(animal_id),
    CONSTRAINT fk_treatment_medication 
        FOREIGN KEY (medication_id) REFERENCES Medications(medication_id),
    CONSTRAINT fk_treatment_vet 
        FOREIGN KEY (vet_id) REFERENCES Veterinarians(vet_id)
);

-- =============================================
-- AUDIT TABLE (for trigger logging)
-- =============================================
CREATE TABLE Animal_Status_Audit (
    audit_id NUMBER PRIMARY KEY,
    animal_id NUMBER,
    old_status VARCHAR2(20),
    new_status VARCHAR2(20),
    change_date DATE DEFAULT SYSDATE,
    changed_by VARCHAR2(100)
);