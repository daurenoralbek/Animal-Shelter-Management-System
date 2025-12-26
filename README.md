# Animal Shelter Management System - README

## Project Overview

This is a comprehensive database and web application project for managing animal shelters

## Quick Start - Database Setup

### Prerequisites
- Oracle Database installed
- Oracle SQL Plus or SQL Workshop access
- Oracle APEX environment (22.x+)

### Installation Steps

Run the SQL scripts in **exact order**:

```bash
1. Database/1_create_tables.sql                          # Creates all 11 tables
2. Database/2_create_sequences.sql                       # Creates auto-increment sequences
3. Database/3_create_functions.sql                       # Creates PL/SQL functions
4. Database/4_create_procedures.sql                      # Creates PL/SQL procedures
5. Database/5_create_packages_exceptions_triggers.sql    # Creates packages, exceptions, triggers
6. Database/6_insert_data.sql                            # Loads 150+ animal records
7. Database/7_create_views.sql                           # Creates 10 database views
8. Database/8_create_cursors_and_records.sql             # Creates cursors and records (advanced PL/SQL)
```

### APEX Application Setup

1. In Oracle APEX, go to **App Builder → Import**
2. Select and import `APEX/APEX_Application_Export.sql`
3. Run the application (Application ID: 164320)
4. Login with your APEX credentials
5. Navigate through all 8 pages to explore features

---

## Project Structure

```
Animal_Shelter_Management_System/
├── README.md                          # This file
├── README_Database.md                 # Database setup guide
├── README_APEX.md                     # APEX application guide
│
├── Database/
│   ├── 1_create_tables.sql
│   ├── 2_create_sequences.sql
│   ├── 3_create_functions.sql
│   ├── 4_create_procedures.sql
│   ├── 5_create_packages_exceptions_triggers.sql
│   ├── 6_insert_data.sql
│   ├── 7_create_views.sql
│   └── 8_create_cursors_and_records.sql
│
├── APEX/
│   ├── APEX_Application_Export.sql
│   └── APEX_Pages_Screenshots/
│       ├── Page_1_Login.jpg
│       ├── Page_2_Animal_Search.jpg
│       ├── Page_3_Insert_Animal.jpg
│       ├── Page_4_Delete_Animal.jpg
│       ├── Page_5_Dashboard.jpg
│       ├── Page_6_Analytics.jpg
│       ├── Page_7_Medical_Management.jpg
│       └── Page_8_Adoption_Analytics.jpg
│
└── Documentation/
    ├── Database_Design.pdf
    ├── Technical_Report.pdf
    └── PRESENTATION.pptx
```

---

## System Features

### Core Functionality (Phase 1 ✅)
- **Animal Management**: Track 150+ animals with microchip identification
- **Veterinary System**: Manage 50+ veterinarians and medical records
- **Adoption Tracking**: Complete adoption history and donor information
- **Dashboard**: Real-time metrics and reporting
- **CRUD Operations**: Secure add, search, update, delete operations

### Analytics & Reporting (Phase 2 ✅ NEW)
- **Enhanced Dashboard (Page 5)**: KPI cards with status visualization
- **Analytics Page (Page 6)**: Species distribution, age groups, top breeds with filters
- **Medical Management (Page 7)**: Treatment tracking, vaccination schedules, medical alerts
- **Adoption Analytics (Page 8)**: Adoption trends, success rates, top adopters, monthly analysis
- **15+ SQL Queries**: All optimized and documented for <500ms performance
- **8+ Data Visualizations**: Pie, bar, and line charts with interactive features
- **Filter Systems**: Multi-filter analytics with bind variables (P6_SPECIES, P6_STATUS)

### Technical Features
✓ 11 normalized database tables (3NF design)  
✓ 10 database views for query optimization  
✓ **8 complete SQL scripts** (all INF 305 requirements met)  
✓ **Advanced PL/SQL:** Functions, procedures, packages, exceptions, cursors, records  
✓ Triggers for automatic status updates and audit logging  
✓ Exception handling and transaction management  
✓ Oracle APEX web interface with 8 pages  
✓ Interactive charts and visualizations (Phase 2)  
✓ Advanced filtering and reporting (Phase 2)  
✓ Mobile-responsive design (100% responsive)

---

## Database Design (Complete - All INF 305 Requirements Met)

### Database Files (8 Complete Scripts)

| File # | Filename | Size | Purpose | PL/SQL Components |
|--------|----------|------|---------|-------------------|
| 1 | `1_create_tables.sql` | 8 KB | Core data tables (11 tables) | Table definitions |
| 2 | `2_create_sequences.sql` | 2 KB | Auto-increment sequences (3) | Sequence definitions |
| 3 | `3_create_functions.sql` | 4 KB | **Functions (6)** | Functions, date calculations |
| 4 | `4_create_procedures.sql` | 12 KB | **Procedures (6)** | Stored procedures, business logic |
| 5 | `5_create_packages_exceptions_triggers.sql` | 14 KB | **Packages (3), Exceptions, Triggers (5)** | Advanced error handling |
| 6 | `6_insert_data.sql` | 479 KB | Sample data (150+ animals) | DML insert statements |
| 7 | `7_create_views.sql` | 3 KB | Reporting views (10) | Views for data access |
| 8 | `8_create_cursors_and_records.sql` | 5 KB | **Cursors (5), Records (5)** | Advanced PL/SQL structures |

---

### PL/SQL Components Summary (20+ Components)

**Total PL/SQL Objects Implemented:**

| Component Type | Count | Files | Purpose |
|---|---|---|---|
| **Functions** | 6 | 3_create_functions.sql | Date calculations, utilities, data transformations |
| **Procedures** | 6 | 4_create_procedures.sql | Business logic, animal intake, deletion, status updates |
| **Packages** | 3 | 5_create_packages... | Code organization, exception handling, reusability |
| **Exceptions** | 3 | 5_create_packages... | Custom error handling, meaningful error messages |
| **Triggers** | 5 | 5_create_packages... | Automatic updates, audit logging, data validation |
| **Cursors** | 5 | 8_create_cursors... | Advanced record processing, iteration, data retrieval |
| **Records** | 5 | 8_create_cursors... | Composite data structures, grouped data handling |
| **Collections** | 1 | Various | Collection types for multiple record handling |

**TOTAL: 34 PL/SQL components across 8 SQL files**

---

## INF 305 Course Requirements (All Met ✅)

### Advanced SQL Concepts
✅ **Complex Queries (15+)** - Joins, subqueries, aggregates, window functions  
✅ **Database Normalization** - 3NF design with no redundancy  
✅ **Transactions** - COMMIT, ROLLBACK, savepoints  
✅ **Performance Optimization** - Indexes, query plans, <500ms execution  

### PL/SQL Programming (All Components)
✅ **Functions (6)** - calculate_animal_age(), date utilities, data transformations  
✅ **Procedures (6)** - add_animal_intake(), delete_animal(), update_animal_status()  
✅ **Packages (3)** - Code organization and reusable components  
✅ **Exception Handling (3)** - Custom exceptions, RAISE_APPLICATION_ERROR  
✅ **Triggers (5)** - Automatic updates, audit logging, data validation  
✅ **Cursors (5)** - Explicit cursors for advanced data processing  
✅ **Records (5)** - Composite data types for grouped data  
✅ **Collections (1)** - Collection types for multiple record handling  

### Database Objects
✅ **Tables (11)** - Fully normalized with constraints  
✅ **Views (10)** - Query optimization and data encapsulation  
✅ **Sequences (3)** - Auto-increment primary keys  
✅ **Indexes** - Performance optimization on key columns  

### Web Application (APEX)
✅ **Pages (8)** - Core CRUD + 4 analytics pages  
✅ **Forms** - Data entry with validation  
✅ **Reports** - Interactive tables and charts  
✅ **Charts (8+)** - Pie, bar, line visualizations  
✅ **Filters** - Dynamic filtering with bind variables  

---

## Database Statistics

| Component | Count | File(s) | Status |
|-----------|-------|---------|--------|
| Tables | 11 | 1_create_tables.sql | ✅ Complete |
| Sequences | 3 | 2_create_sequences.sql | ✅ Complete |
| Functions | 6 | 3_create_functions.sql | ✅ Complete |
| Procedures | 6 | 4_create_procedures.sql | ✅ Complete |
| Packages | 3 | 5_create_packages... | ✅ Complete |
| Exceptions | 3 | 5_create_packages... | ✅ Complete |
| Triggers | 5 | 5_create_packages... | ✅ Complete |
| Views | 10 | 7_create_views.sql | ✅ Complete |
| Cursors | 5 | 8_create_cursors... | ✅ Complete |
| Records | 5 | 8_create_cursors... | ✅ Complete |
| Collections | 1 | Various | ✅ Complete |
| Animal Records | 150+ | 6_insert_data.sql | ✅ Complete |
| Veterinarian Records | 50+ | 6_insert_data.sql | ✅ Complete |
| **SQL Queries (Phase 2)** | **15+** | APEX queries | ✅ Complete |
| **Chart Components (Phase 2)** | **8+** | APEX charts | ✅ Complete |
| **APEX Pages** | **8** | APEX_Application_Export | ✅ Complete |

---

## Key Tables

### Animals
Stores animal information with unique microchip tracking:
- animal_id, name, species, breed, gender, color, weight
- date_of_birth, intake_date, status, microchip_number, notes

### Shelters
Facility information and locations

### Veterinarians
Professional veterinarian details and specialties

### Adoptions
Adoption records linking animals to adopters

### Medical_Records
Complete medical history for each animal

### Vaccinations
Vaccination schedules and records

### Donations
Donation tracking and records

---

## PL/SQL Components Detail

### Functions (File 3: 6 Functions)
- `calculate_animal_age(animal_id)` - Returns age in years
- `get_animal_status(animal_id)` - Retrieves current status
- Additional utility functions for date calculations and data transformation

### Procedures (File 4: 6 Procedures)
- `add_animal_intake(...)` - Register new animal with validation
- `delete_animal(...)` - Safe deletion with constraint checking
- `update_animal_status(...)` - Update animal status with logging
- `record_adoption(...)` - Process adoption with updates
- `schedule_vaccination(...)` - Schedule vaccination records
- `log_medical_visit(...)` - Record medical visit

### Packages (File 5: 3 Packages)
- `pkg_animal_management` - Animal-related procedures
- `pkg_medical_care` - Medical operations package
- `pkg_adoption_tracking` - Adoption-related functions

### Exceptions (File 5: 3 Custom Exceptions)
- `invalid_animal_exception` - When animal not found
- `duplicate_microchip_exception` - Duplicate microchip ID
- `adoption_conflict_exception` - Adoption constraints violated

### Triggers (File 5: 5 Triggers)
1. **tr_animal_status_update** - Automatic status updates on adoption
2. **tr_audit_deletion** - Audit logging on record deletions
3. **tr_timestamp_update** - Automatic timestamp modifications
4. **tr_vaccination_reminder** - Vaccination due alert trigger
5. **tr_medical_status** - Update medical status automatically

### Cursors (File 8: 5 Cursors)
1. `cur_animals_needing_care` - Animals in medical care
2. `cur_overdue_vaccinations` - Vaccinations past due date
3. `cur_recent_adoptions` - Recent adoption records
4. `cur_available_animals` - Animals ready for adoption
5. `cur_donor_history` - Donation history for donors

### Records (File 8: 5 Records)
1. `rec_animal` - Complete animal information
2. `rec_medical` - Medical record structure
3. `rec_adoption` - Adoption transaction record
4. `rec_vaccination` - Vaccination record
5. `rec_donor` - Donor information record

---

## Database Views

1. **v_animal_summary** - Animals with shelter and age info
2. **v_available_animals** - Animals ready for adoption
3. **v_medical_animals** - Animals needing veterinary care
4. **v_adoptions_month** - Current month adoptions
5. **v_donations_month** - Current month donations
6. **v_animals_by_status** - Animals grouped by status
7. **v_staff_by_shelter** - Staff assignments by facility
8. **v_veterinarians_info** - Veterinarian profiles
9. **v_recent_vaccinations** - Recent vaccination records
10. **v_total_animals_count** - Quick animal count

---

## APEX Web Application

### Pages (8 Total - Phase 2 Complete)

**Core Pages:**
- **Page 1**: Login/Authentication
- **Page 2**: Animal Search & Management
- **Page 3**: Insert New Animal (Form)
- **Page 4**: Delete Animal (with safety checks)

**Analytics Pages (Phase 2 - NEW):**
- **Page 5**: Enhanced Dashboard
  - 4 KPI cards (Total, Available, Adopted, Medical Care)
  - Status Distribution pie/donut chart
  - Real-time metrics refresh

- **Page 6**: Analytics with Filters
  - Filter bar: Species, Status dropdowns
  - Species Distribution pie chart
  - Age Distribution bar chart (0-2, 2-5, 5+ years)
  - Top Breeds table (top 10)
  
- **Page 7**: Medical Management
  - Medical Summary metrics (count, percentage)
  - Current Treatments table (animals in medical care)
  - Upcoming Vaccinations table (next 30 days)
  
- **Page 8**: Adoption Analytics
  - Adoption Metrics cards (4 KPIs: total, this month, success rate, avg days)
  - Monthly Trend line chart (12-month history)
  - Species Adoption Rate chart
  - Top Adopters table (top 10)

### Features
- Interactive search by name, species, breed
- Form-based animal registration
- Safe deletion with validation
- **Real-time dashboard metrics (Phase 2)**
- **Interactive charts and data visualizations (Phase 2)**
- **Advanced filtering with page items (Phase 2)**
- **15+ SQL queries for analytics (Phase 2)**
- Export to Excel functionality
- Mobile-responsive design (100%)

---

## SQL Queries & Performance (Phase 2)

### 15+ Production Queries
All queries optimized for <500ms performance with proper indexing.

**Dashboard Queries:**
1. Status Distribution - Pie chart data
2. KPI Metrics - Total, Available, Adopted, Medical Care

**Analytics Queries (with filters):**
3. Species Distribution (filters by P6_SPECIES)
4. Age Distribution (3 age groups)
5. Top Breeds (top 10)

**Medical Queries:**
6. Medical Summary Metrics
7. Current Treatments Table
8. Upcoming Vaccinations Table

**Adoption Queries:**
9. Adoption Metrics (4 KPIs)
10. Monthly Trend (12 months)
11. Species Adoption Rate
12. Top Adopters Table

Plus 3+ additional reporting queries

**See Technical_Report.pdf for complete query documentation.**

---

## Error Handling & Validation

### Database Level
- NOT NULL constraints on required fields
- UNIQUE constraint on microchip numbers
- Foreign key constraints for data integrity
- CHECK constraints for valid status values

### PL/SQL Level (Advanced)
- **Custom exceptions** (3) for specific errors
- **Input validation** in all procedures
- **RAISE_APPLICATION_ERROR** for meaningful messages
- **WHEN OTHERS** exception handling with logging
- **Transaction control** with ROLLBACK on errors
- **Exception propagation** through packages

### APEX Level
- Required field validation
- Format validation (dates, numbers)
- Confirmation dialogs for destructive operations
- Clear error messages to users
- **Bind variable validation (Phase 2)**
- **Chart error handling (Phase 2)**

---

## Usage Guidelines

### Adding an Animal
1. Go to APEX Page 3 (Insert New Animal)
2. Fill in animal details (Name, Species required)
3. Select date of birth from date picker
4. Click "Save"
5. Receive confirmation message

### Searching Animals
1. Go to APEX Page 2 (Animal Search)
2. Type partial name/species/breed
3. Click "Search"
4. View filtered results
5. Click column headers to sort
6. Export to Excel if needed

### Deleting an Animal
1. Go to APEX Page 4 (Delete Animal)
2. Enter animal ID
3. Confirm in popup dialog
4. System checks for active adoptions
5. Delete proceeds only if no conflicts
6. Receive confirmation or error message

### **Viewing Analytics (Phase 2)**
1. **Go to APEX Page 5/6/7/8** (Analytics pages)
2. **Use filters to refine data** (Page 6: Species, Status)
3. **Click "Apply Filters"** to refresh charts
4. **Hover over charts** for tooltips and details
5. **View tables** for detailed breakdowns
6. **Export data** if needed (future Phase 3)

---

## Files Included

| File | Purpose | Size |
|------|---------|------|
| 1_create_tables.sql | Define 11 database tables | 8 KB |
| 2_create_sequences.sql | Create auto-increment sequences | 2 KB |
| 3_create_functions.sql | PL/SQL functions (6) | 4 KB |
| 4_create_procedures.sql | PL/SQL procedures (6) | 12 KB |
| 5_create_packages_exceptions_triggers.sql | Packages (3), exceptions (3), triggers (5) | 14 KB |
| 6_insert_data.sql | Populate 150+ animal records | 479 KB |
| 7_create_views.sql | Create 10 views | 3 KB |
| 8_create_cursors_and_records.sql | Cursors (5) and records (5) | 5 KB |
| APEX_Application_Export.sql | Complete APEX application (8 pages) | - |
| Database_Design.pdf | Database architecture document | - |
| Technical_Report.pdf | Implementation details and analysis (Phase 2) | - |
| PRESENTATION.pptx | 15-minute presentation slides | - |

---

## Documentation

For detailed information, see:
- **Database_Design.pdf** - ER diagram, table structures, normalization, complete database design
- **Technical_Report.pdf** - Implementation details, all 15+ SQL queries, Phase 2 analysis, PL/SQL components
- **README_Database.md** - Database installation and management with all 8 scripts
- **README_APEX.md** - APEX application usage and features

---

## Technical Stack

| Layer | Technology |
|-------|-----------| 
| Database | Oracle Database 19c+ |
| Backend | **PL/SQL (34 components across 8 scripts)** |
| Frontend | Oracle APEX 22.x+ |
| Design | 3NF Normalization |
| Reporting | SQL Queries, Views, Charts (Phase 2) |
| Performance | <500ms queries, indexed tables |
| Responsiveness | 100% mobile-responsive |

---

## Support & Documentation

For questions or issues:
1. Check Database_Design.pdf for architecture
2. See Technical_Report.pdf for implementation details and all SQL queries
3. Review README_APEX.md for application usage
4. Check README_Database.md for database setup
5. Review SQL comments in code files (8 scripts) for explanations
