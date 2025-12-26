# Animal Shelter Management System - APEX Application README

**Last Updated:** December 10, 2025
**Status:** Phase 2 Complete (Analytics Core)
**Version:** 2.0

---

## ðŸ“‹ Table of Contents

1. [Overview](#overview)
2. [Application Architecture](#application-architecture)
3. [Completed Features](#completed-features)
4. [Page-by-Page Guide](#page-by-page-guide)
5. [Database Schema](#database-schema)
6. [SQL Queries Reference](#sql-queries-reference)
7. [Installation & Deployment](#installation--deployment)
8. [Troubleshooting](#troubleshooting)
9. [Future Enhancements](#future-enhancements)

---

## Overview

The **Animal Shelter Management System** is an Oracle APEX application designed to manage animal shelter operations including:

- **Core Operations:** Animal inventory management, medical tracking, adoption processing
- **Analytics & Reporting:** 15+ data visualizations, trend analysis, performance metrics
- **User Management:** Secure login, role-based access control
- **Mobile Responsive:** Optimized for desktop, tablet, and mobile devices

**Technology Stack:**
- Frontend: Oracle APEX 22.x+ (HTML5, CSS3, JavaScript)
- Backend: Oracle Database 19c+ (PL/SQL)
- Charts: APEX Native Charts (Pie, Bar, Line)
- Design: Minimalistic green theme (#2E7D32), Roboto typography

---

## Application Architecture

```
Animal Shelter Management System (App 164320)
â”‚
â”œâ”€â”€ Authentication Layer
â”‚ â””â”€â”€ Login Page (Page 1)
â”‚
â”œâ”€â”€ Navigation & Layout
â”‚ â”œâ”€â”€ Global Navigation Menu
â”‚ â”œâ”€â”€ Breadcrumb Trail
â”‚ â””â”€â”€ User Profile Menu
â”‚
â”œâ”€â”€ Core Operations Pages
â”‚ â”œâ”€â”€ Home/Dashboard (Page 3)
â”‚ â”œâ”€â”€ Animal Management (Page 2 - Search/List)
â”‚ â”œâ”€â”€ Insert New Animal (Form)
â”‚ â””â”€â”€ Delete Animal (with safety checks)
â”‚
â”œâ”€â”€ Analytics & Reporting Pages
â”‚ â”œâ”€â”€ Enhanced Dashboard (Page 5)
â”‚ â”œâ”€â”€ Analytics (Page 6)
â”‚ â”œâ”€â”€ Medical Management (Page 7)
â”‚ â””â”€â”€ Adoption Analytics (Page 8)
â”‚
â””â”€â”€ Database Layer (Oracle 19c)
â”œâ”€â”€ ANIMALS table
â”œâ”€â”€ MEDICAL_RECORDS table
â”œâ”€â”€ VACCINATIONS table
â”œâ”€â”€ ADOPTIONS table
â”œâ”€â”€ ADOPTERS table
â”œâ”€â”€ VETERINARIANS table
â””â”€â”€ Supporting lookup tables
```

---

## Completed Features

### âœ… Phase 1: Foundation (Complete)
- [x] Secure login authentication
- [x] Home/Dashboard with key metrics
- [x] Animal search/list with 10+ columns
- [x] Insert new animal form with validation
- [x] Delete animal with safety checks
- [x] Database connectivity to Oracle
- [x] User-friendly navigation menu
- [x] Minimalistic green theme (#2E7D32)
- [x] Icon-based navigation
- [x] Responsive design

### âœ… Phase 2: Analytics Core (Complete)
- [x] Enhanced Dashboard with KPI cards
- [x] Status Distribution chart (Pie/Doughnut)
- [x] Analytics page with filters
- [x] Species Distribution chart
- [x] Age Distribution bar chart
- [x] Top Breeds table (top 10)
- [x] Medical Management page
- [x] Medical Summary metrics
- [x] Current Treatments table
- [x] Upcoming Vaccinations table
- [x] Adoption Analytics page
- [x] Adoption Metrics cards
- [x] Monthly Trend line chart
- [x] By Species adoption rate chart
- [x] Top Adopters table

### ðŸ”„ Phase 3: In Progress
- [ ] Financial Report page (donations/funding)
- [ ] User Profile/Settings page
- [ ] Advanced search with filters
- [ ] Mobile optimization
- [ ] Export to PDF/Excel
- [ ] Dark mode support

### ðŸ“‹ Phase 4: Future
- [ ] Custom dashboards (user-specific views)
- [ ] Advanced reporting with drill-down
- [ ] API integration (third-party systems)
- [ ] Mobile app version (native)
- [ ] Email notifications
- [ ] Audit logging system

---

## Page-by-Page Guide

### Page 1: Login
**Type:** Authentication
**Features:**
- Secure credentials validation
- Session management
- Password reset link
- Auto-logout on idle

---

### Page 2: Animal Management (Search/List)
**Type:** Data Management
**Features:**
- Search animals by name, species, status
- View 10+ columns: ID, Name, Species, Breed, Status, Intake Date, Age, etc.
- Sort and filter capabilities
- Links to edit/view details
- Integration with Insert and Delete pages

**SQL Query:**
```sql
SELECT
animal_id,
name,
species,
breed,
status,
intake_date,
TRUNC(MONTHS_BETWEEN(SYSDATE, date_of_birth) / 12) as age,
medical_status,
adoption_date
FROM animals
ORDER BY animal_id DESC
```

---

### Page 3: Home/Dashboard
**Type:** Overview Dashboard
**Features:**
- KPI cards showing:
- Total Animals
- Available for Adoption
- Adopted This Month
- In Medical Care
- Status Distribution chart (visual breakdown)
- Quick action buttons

**Regions:**
1. **KPI Cards Region** (Static Content + SQL)
- 4 metric cards with database values
2. **Status Distribution** (Chart Region - Pie/Donut)
- Visual breakdown of animal statuses
- Interactive legend

**Chart SQL:**
```sql
SELECT
status,
COUNT(*) as count,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM animals), 1) as percentage
FROM animals
GROUP BY status
ORDER BY count DESC
```

---

### Page 4: Insert New Animal
**Type:** Form/Data Entry
**Features:**
- Form fields for all animal attributes
- Validation rules (required fields, data formats)
- Success/error messages
- Auto-redirect to animal list after save

---

### Page 5: Delete Animal
**Type:** Data Management
**Features:**
- Confirmation dialog before deletion
- Safety checks (no orphaned records)
- Audit trail logging
- Error handling for dependent records

---

### Page 6: Enhanced Dashboard (Page 5 in APEX)
**Type:** Analytics Dashboard
**Regions:**
1. **Summary Cards** - Total animals, available, adopted, medical care
2. **Status Distribution** - Pie chart showing animal status breakdown
3. **Recent Activity** - Table of latest adoptions/admissions

---

### Page 7: Analytics (Page 6 in APEX)
**Type:** Advanced Analytics
**Regions:**

#### 1. Filter Bar
- **P6_SPECIES** (Select List) - Filter by species
- **P6_STATUS** (Select List) - Filter by status
- **P6_GO_BUTTON** (Button) - Apply filters

#### 2. Species Distribution Chart
- **Type:** Pie/Doughnut Chart
- **SQL:**
```sql
SELECT
species,
COUNT(*) AS count,
ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM animals), 1) AS percentage
FROM animals
WHERE (:P6_SPECIES IS NULL OR species = :P6_SPECIES)
GROUP BY species
ORDER BY count DESC
```

#### 3. Age Distribution Chart
- **Type:** Bar Chart
- **SQL:**
```sql
SELECT
CASE
WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, date_of_birth) / 12) < 2 THEN '0-2 years'
WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, date_of_birth) / 12) < 5 THEN '2-5 years'
ELSE '5+ years'
END as age_group,
COUNT(*) as count
FROM animals
WHERE date_of_birth IS NOT NULL
AND (:P6_SPECIES IS NULL OR species = :P6_SPECIES)
GROUP BY
CASE
WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, date_of_birth) / 12) < 2 THEN '0-2 years'
WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, date_of_birth) / 12) < 5 THEN '2-5 years'
ELSE '5+ years'
END
ORDER BY age_group
```

#### 4. Top Breeds Table
- **Type:** Classic Report
- **SQL:**
```sql
SELECT
breed,
COUNT(*) as count
FROM animals
WHERE breed IS NOT NULL
AND (:P6_SPECIES IS NULL OR species = :P6_SPECIES)
GROUP BY breed
ORDER BY count DESC
FETCH FIRST 10 ROWS ONLY
```

---

### Page 8: Medical Management (Page 7 in APEX)
**Type:** Medical Tracking Dashboard
**Regions:**

#### 1. Medical Summary Cards
- In Treatment count
- Total Animals count
- Percentage in medical care
- **SQL:**
```sql
SELECT
(SELECT COUNT(*) FROM animals WHERE status = 'Medical Care') AS in_treatment,
(SELECT COUNT(*) FROM animals WHERE status = 'Medical Care')
/ NULLIF((SELECT COUNT(*) FROM animals), 0) * 100 AS pct_in_treatment,
(SELECT COUNT(*) FROM animals) AS total_animals
FROM dual
```

#### 2. Current Treatments Table
- **Columns:** Animal ID, Name, Last Visit Date, Diagnosis
- **Type:** Classic Report
- **SQL:**
```sql
SELECT
a.animal_id,
a.name,
MAX(m.visit_date) AS last_visit,
MAX(m.diagnosis) KEEP (DENSE_RANK LAST ORDER BY m.visit_date) AS diagnosis
FROM animals a
LEFT JOIN medical_records m
ON a.animal_id = m.animal_id
WHERE a.status = 'Medical Care'
GROUP BY a.animal_id, a.name
ORDER BY last_visit DESC NULLS LAST
```

#### 3. Upcoming Vaccinations Table
- **Columns:** Animal ID, Name, Vaccine Type, Due Date, Days Until Due
- **Type:** Classic Report
- **SQL:**
```sql
SELECT
a.animal_id,
a.name,
vac.vaccine_type,
vac.next_due_date,
TRUNC(vac.next_due_date - SYSDATE) AS days_until_due
FROM animals a
JOIN vaccinations vac
ON a.animal_id = vac.animal_id
WHERE vac.next_due_date IS NOT NULL
AND vac.next_due_date <= ADD_MONTHS(TRUNC(SYSDATE), 1)
ORDER BY vac.next_due_date ASC
```

---

### Page 9: Adoption Analytics (Page 8 in APEX)
**Type:** Adoption Metrics & Trends
**Regions:**

#### 1. Adoption Metrics Cards
- **Metrics:** Total adoptions, this month, success rate, average adoption days
- **Type:** Classic Report (styled as cards)
- **SQL:**
```sql
SELECT
(SELECT COUNT(*) FROM adoptions) AS total_adoptions,
(SELECT COUNT(*) FROM adoptions
WHERE TRUNC(adoption_date, 'MM') = TRUNC(SYSDATE, 'MM')) AS month_adoptions,
ROUND(
(SELECT COUNT(*) FROM animals WHERE status = 'Adopted')
/ NULLIF((SELECT COUNT(*) FROM animals), 0) * 100,
1
) AS success_rate,
(SELECT ROUND(AVG(a.adoption_date - an.intake_date), 1)
FROM adoptions a
JOIN animals an ON an.animal_id = a.animal_id) AS avg_adoption_days
FROM dual
```

#### 2. Monthly Trend Chart
- **Type:** Line Chart
- **X-Axis:** Month (YYYY-MM)
- **Y-Axis:** Adoption count
- **SQL:**
```sql
SELECT
TO_CHAR(adoption_date, 'YYYY-MM') AS month,
COUNT(*) AS adoption_count
FROM animals
WHERE status = 'Adopted'
AND adoption_date >= ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -12)
GROUP BY TO_CHAR(adoption_date, 'YYYY-MM')
ORDER BY month
```

#### 3. By Species Chart
- **Type:** Bar Chart
- **Shows:** Adoption rate by species
- **SQL:**
```sql
SELECT
species,
COUNT(*) AS total_animals,
SUM(CASE WHEN status = 'Adopted' THEN 1 ELSE 0 END) AS adopted_count,
ROUND(
SUM(CASE WHEN status = 'Adopted' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
1
) AS adoption_rate
FROM animals
GROUP BY species
ORDER BY adoption_rate DESC
```

#### 4. Top Adopters Table
- **Type:** Classic Report
- **SQL:**
```sql
SELECT
ad.adopter_id,
ad.first_name,
COUNT(*) AS adoption_count,
MAX(a.adoption_date) AS last_adoption
FROM adopters ad
LEFT JOIN adoptions a
ON ad.adopter_id = a.adopter_id
GROUP BY ad.adopter_id, ad.first_name
ORDER BY adoption_count DESC
FETCH FIRST 10 ROWS ONLY
```

---

## Database Schema

### Core Tables

#### ANIMALS
```sql
CREATE TABLE animals (
animal_id NUMBER PRIMARY KEY,
name VARCHAR2(100) NOT NULL,
species VARCHAR2(50),
breed VARCHAR2(100),
status VARCHAR2(30), -- Available, Adopted, Fostered, Medical Care
intake_date DATE,
date_of_birth DATE,
adoption_date DATE,
medical_status VARCHAR2(50),
CONSTRAINT fk_animals_status CHECK (status IN ('Available', 'Adopted', 'Fostered', 'Medical Care'))
);
```

#### MEDICAL_RECORDS
```sql
CREATE TABLE medical_records (
record_id NUMBER PRIMARY KEY,
animal_id NUMBER REFERENCES animals(animal_id),
visit_date DATE,
veterinarian_id NUMBER,
diagnosis VARCHAR2(500),
treatment VARCHAR2(500),
created_date TIMESTAMP DEFAULT SYSDATE
);
```

#### VACCINATIONS
```sql
CREATE TABLE vaccinations (
vaccination_id NUMBER PRIMARY KEY,
animal_id NUMBER REFERENCES animals(animal_id),
vaccine_type VARCHAR2(100),
vaccination_date DATE,
next_due_date DATE,
veterinarian_id NUMBER
);
```

#### ADOPTIONS
```sql
CREATE TABLE adoptions (
adoption_id NUMBER PRIMARY KEY,
animal_id NUMBER REFERENCES animals(animal_id),
adopter_id NUMBER REFERENCES adopters(adopter_id),
adoption_date DATE,
adoption_fee NUMBER,
notes VARCHAR2(500)
);
```

#### ADOPTERS
```sql
CREATE TABLE adopters (
adopter_id NUMBER PRIMARY KEY,
first_name VARCHAR2(100),
last_name VARCHAR2(100),
email VARCHAR2(100),
phone VARCHAR2(20),
address VARCHAR2(255),
created_date TIMESTAMP DEFAULT SYSDATE
);
```

#### VETERINARIANS
```sql
CREATE TABLE veterinarians (
veterinarian_id NUMBER PRIMARY KEY,
name VARCHAR2(100),
email VARCHAR2(100),
phone VARCHAR2(20),
specialization VARCHAR2(100)
);
```

---

## SQL Queries Reference

### Quick Lookup Queries

**Total Animals by Status:**
```sql
SELECT status, COUNT(*) as count
FROM animals
GROUP BY status
ORDER BY count DESC;
```

**Animals Due for Vaccination:**
```sql
SELECT a.animal_id, a.name, v.vaccine_type, v.next_due_date
FROM animals a
JOIN vaccinations v ON a.animal_id = v.animal_id
WHERE v.next_due_date <= TRUNC(SYSDATE)
ORDER BY v.next_due_date;
```

**Adoption Success Rate by Species:**
```sql
SELECT
species,
COUNT(*) as total,
SUM(CASE WHEN status = 'Adopted' THEN 1 ELSE 0 END) as adopted,
ROUND(SUM(CASE WHEN status = 'Adopted' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as rate_percent
FROM animals
GROUP BY species
ORDER BY rate_percent DESC;
```

**Average Adoption Time (in days):**
```sql
SELECT
ROUND(AVG(a.adoption_date - an.intake_date), 1) as avg_days_to_adoption
FROM adoptions a
JOIN animals an ON a.animal_id = an.animal_id;
```

---

## Installation & Deployment

### Prerequisites
- Oracle APEX 22.x or higher
- Oracle Database 19c or higher
- Modern web browser (Chrome, Firefox, Safari, Edge)
- Network access to Oracle database

### Step 1: Import Application
1. In **Oracle APEX**, go to **App Builder**
2. Click **Import**
3. Upload the APEX application export file (`.sql`)
4. Follow wizard and install

### Step 2: Create Database Objects
1. Run all table creation scripts in **SQL Workshop**
2. Insert sample data if provided
3. Create necessary indexes on frequently queried columns

### Step 3: Configure Workspace
1. Set up workspace users and roles
2. Configure authentication scheme
3. Set development vs. production mode

### Step 4: Test All Pages
1. Login with test credentials
2. Navigate through all 8 pages
3. Test filters and data entry forms
4. Verify charts display correctly
5. Check mobile responsiveness

### Step 5: Deploy to Production
1. Export application in production mode
2. Disable debug mode
3. Set up SSL/TLS certificates
4. Configure backup procedures

---

## Troubleshooting

### Chart Shows No Data
**Symptom:** Chart region displays empty
**Solution:**
1. Check SQL query in region Source
2. Verify column names match table definitions
3. Check Series configuration (Label Column, Value Column)
4. Run SQL query directly in SQL Workshop to verify results
5. Check page item values if using filters (`:P6_SPECIES`, etc.)

### SQL Error: "ORA-00937: not a single-group group function"
**Symptom:** Aggregate function error
**Solution:**
1. Add missing columns to GROUP BY clause
2. Or wrap aggregate in subquery with `FROM dual`
3. Ensure all non-aggregated columns are grouped

### SQL Error: "invalid identifier"
**Symptom:** Column name not recognized
**Solution:**
1. Verify table and column names match actual schema
2. Check case sensitivity
3. Run `DESCRIBE animals;` in SQL Workshop
4. Update SQL queries to use correct names

### Filter Not Affecting Chart
**Symptom:** Chart doesn't update when filter changes
**Solution:**
1. Verify page items exist (P6_SPECIES, P6_STATUS)
2. Check SQL uses bind variables (`:P6_SPECIES`)
3. Add **Page Item to Submit** in region definition
4. Check button submits page correctly

### Page Load is Slow
**Symptom:** Pages take >5 seconds to load
**Solution:**
1. Add indexes to frequently queried columns
2. Limit FETCH FIRST rows in queries
3. Check for missing table joins
4. Use pagination in large result sets
5. Check database performance (V$SESSION_LONGOPS)

---

## Future Enhancements

### Phase 3 (4-6 weeks out)
- [ ] Financial Report page (donation tracking)
- [ ] User Profile/Settings page
- [ ] Advanced search with saved filters
- [ ] Email export reports
- [ ] Mobile app home screen optimization

### Phase 4 (Long-term)
- [ ] Veterinary appointment scheduling
- [ ] Donor management system
- [ ] Grant/funding tracking
- [ ] Volunteer management
- [ ] Social media integration (adoption postings)
- [ ] QR code animal records
- [ ] Photo gallery per animal

---

## Support & Documentation

- **APEX_Enhancement_Guide.md** - Design system, color codes, UI patterns
- **APEX_Implementation_Steps.md** - Step-by-step code examples
- **SQL_Workshop** - Built-in SQL editor for testing queries
- **APEX Docs** - https://docs.oracle.com/en/database/oracle/apex/

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | Dec 5, 2025 | Initial foundation (5 pages) |
| 1.5 | Dec 8, 2025 | Dashboard enhancements |
| 2.0 | Dec 10, 2025 | Analytics core complete (Pages 6, 7, 8) |

---

**Last Updated:** December 10, 2025
**Next Review:** December 17, 2025
**Maintained By:** Development Team
