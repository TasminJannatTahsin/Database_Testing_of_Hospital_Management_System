# 🏥 Hospital Management System -- Database Testing

## 📌 Project Overview

This project is a **MySQL-based Hospital Management System Database
Testing project** developed to validate the **accuracy, integrity,
consistency, reliability, and business rules** of hospital and
hospital-website data.

The database contains **21 related tables** covering patient management,
doctors, appointments, medical records, prescriptions, medicines,
admissions, billing, payments, website content, feedback, contact
messages, and notifications.

The project uses SQL queries to identify data defects and verify that
database relationships and business rules work correctly.

------------------------------------------------------------------------

## 🎯 Testing Objectives

-   Verify **CRUD operations**
-   Validate **Primary Key and Foreign Key relationships**
-   Test **NOT NULL and CHECK constraints**
-   Detect **duplicate records**
-   Identify **orphan records**
-   Validate **data consistency**
-   Test **JOIN queries**
-   Test **GROUP BY and HAVING**
-   Validate **aggregate functions**
-   Perform **boundary-value testing**
-   Validate **billing and payment calculations**
-   Test real-world **hospital business rules**

------------------------------------------------------------------------

## 🏗️ Database Modules

  -----------------------------------------------------------------------
  Module                              Tables
  ----------------------------------- -----------------------------------
  👤 User & Patient Management        `user_roles`, `users`, `patients`

  🏥 Hospital Management              `departments`, `doctors`, `rooms`,
                                      `admissions`

  🩺 Appointment & Medical Management `services`, `appointments`,
                                      `medical_records`, `prescriptions`,
                                      `medicines`,
                                      `prescription_medicines`

  💳 Billing & Payment                `billing`, `payments`

  🌐 Website Content Management       `website_pages`, `health_articles`,
                                      `faqs`

  💬 Communication & Feedback         `contact_messages`, `feedback`,
                                      `notifications`
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## 🗂️ Entity Relationship Diagram

The ER diagram shows the database tables and their relationships. The diagram is added in current repository.
🗂️ ER_DiagramHMS.png
------------------------------------------------------------------------

## 🧪 Database Testing Areas

### 1. CRUD Testing

Testing basic database operations:

-   `INSERT` -- Create
-   `SELECT` -- Read
-   `UPDATE` -- Modify
-   `DELETE` -- Remove

### 2. Primary Key Testing

Verify that:

-   Primary keys are unique
-   Primary keys are not NULL
-   Auto-increment values work correctly

Example:

``` sql
SELECT patient_id, COUNT(*) AS total
FROM patients
GROUP BY patient_id
HAVING COUNT(*) > 1;
```

**Expected Result:** `0 rows`

### 3. Foreign Key Testing

Verify relationships between tables and detect invalid references.

``` sql
SELECT a.*
FROM appointments a
LEFT JOIN patients p ON a.patient_id = p.patient_id
LEFT JOIN doctors d ON a.doctor_id = d.doctor_id
LEFT JOIN services s ON a.service_id = s.service_id
WHERE p.patient_id IS NULL
   OR d.doctor_id IS NULL
   OR s.service_id IS NULL;
```

**Expected Result:** `0 rows`

### 4. Duplicate Data Testing

``` sql
SELECT license_number, COUNT(*) AS total
FROM doctors
GROUP BY license_number
HAVING COUNT(*) > 1;
```

**Expected Result:** `0 rows`

### 5. Constraint Testing

Test:

-   `NOT NULL`
-   `UNIQUE`
-   `CHECK`
-   `DEFAULT`
-   Primary Key
-   Foreign Key

Example:

``` sql
SELECT *
FROM feedback
WHERE rating < 1 OR rating > 5;
```

**Expected Result:** `0 rows`

### 6. JOIN Testing

Example:

``` sql
SELECT
    d.doctor_id,
    CONCAT(u.first_name, ' ', u.last_name) AS doctor_name,
    d.specialization,
    dep.department_name
FROM doctors d
JOIN users u ON d.user_id = u.user_id
JOIN departments dep ON d.department_id = dep.department_id;
```

### 7. Aggregate Function Testing

``` sql
SELECT
    COUNT(*) AS total_patients,
    AVG(consultation_fee) AS average_doctor_fee
FROM doctors;
```

Common functions tested:

-   `COUNT()`
-   `SUM()`
-   `AVG()`
-   `MIN()`
-   `MAX()`

### 8. GROUP BY / HAVING Testing

``` sql
SELECT
    status,
    COUNT(*) AS total_appointments
FROM appointments
GROUP BY status;
```

``` sql
SELECT
    department_id,
    COUNT(*) AS total_doctors
FROM doctors
GROUP BY department_id
HAVING COUNT(*) > 1;
```

### 9. Billing Total Validation

Verify that the stored bill total matches the calculated total:

``` sql
SELECT
    bill_id,
    total_amount,
    consultation_fee + medicine_fee + room_fee
    + test_fee + tax - discount AS calculated_total
FROM billing
WHERE total_amount <>
      consultation_fee + medicine_fee + room_fee
      + test_fee + tax - discount;
```

**Expected Result:** `0 rows`

### 10. Payment Validation

Check whether a payment is greater than the related bill:

``` sql
SELECT
    p.payment_id,
    p.bill_id,
    p.amount_paid,
    b.total_amount
FROM payments p
JOIN billing b ON p.bill_id = b.bill_id
WHERE p.amount_paid > b.total_amount;
```

### 11. Data Consistency Testing

Verify that a medical record belongs to the same patient as its
appointment:

``` sql
SELECT
    mr.record_id,
    mr.patient_id AS record_patient,
    a.patient_id AS appointment_patient
FROM medical_records mr
JOIN appointments a
    ON mr.appointment_id = a.appointment_id
WHERE mr.patient_id <> a.patient_id;
```

**Expected Result:** `0 rows`

### 12. Orphan Record Testing

``` sql
SELECT p.*
FROM patients p
LEFT JOIN users u ON p.user_id = u.user_id
WHERE u.user_id IS NULL;
```

**Expected Result:** `0 rows`

### 13. Boundary-Value Testing

Examples:

``` sql
SELECT *
FROM feedback
WHERE rating IN (1, 5);
```

``` sql
SELECT *
FROM medicines
WHERE stock_quantity = 0;
```

Boundary values are tested for fields such as:

-   Feedback rating: `1–5`
-   Medicine stock: `0+`
-   Doctor consultation fee: `0+`
-   Service fee: `0+`
-   Medicine price: `0+`

### 14. Notification Business Rule Testing

The database requires:

-   Unread notification → `read_at` must be `NULL`
-   Read notification → `read_at` must contain a date/time

``` sql
SELECT *
FROM notifications
WHERE (is_read = FALSE AND read_at IS NOT NULL)
   OR (is_read = TRUE AND read_at IS NULL);
```

**Expected Result:** `0 rows`

------------------------------------------------------------------------

## 📊 Key Business Rules Tested

  -----------------------------------------------------------------------
  Business Rule                       Validation
  ----------------------------------- -----------------------------------
  Patient must reference a valid user Foreign Key

  Doctor must belong to a valid       Foreign Key
  department                          

  Appointment must reference valid    Foreign Keys
  patient, doctor and service         

  Feedback rating must be 1--5        CHECK constraint

  Medicine stock cannot be negative   CHECK constraint

  Medicine price cannot be negative   CHECK constraint

  Room available beds cannot exceed   Data validation
  bed count                           

  Discharge date cannot be before     CHECK constraint
  admission date                      

  Bill total must equal calculated    Calculation validation
  amount                              

  Payment amount should not exceed    Business-rule validation
  bill amount                         

  Read notification must have         CHECK constraint
  `read_at`                           

  Unread notification must not have   CHECK constraint
  `read_at`                           

  Published article should have       Business-rule validation
  `published_at`                      
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## 🛠️ Tools & Technologies

-   **MySQL**
-   **MySQL Workbench / MySQL CLI**
-   **SQL**
-   **Git & GitHub**
-   **ER Diagram**

------------------------------------------------------------------------

## 📁 Project Structure

``` text
Hospital_Database_Testing/
│
├── Database Dump file folder
│   └── hospital_management_system(Dump file)
│
├── ER_Diagram/
│   └── ER_Diagram_HMS.png
│
├── SQL_Queries/
│   ├── 01_CRUD_Testing.sql
│   ├── 02_Key_Constraint_Testing.sql
│   ├── 03_Duplicate_Data_Testing.sql
│   ├── 04_JOIN_Testing.sql
│   ├── 05_Aggregate_Testing.sql
│   ├── 06_GroupBy_Having_Testing.sql
│   ├── 07_Billing_Payment_Testing.sql
│   ├── 08_Data_Consistency_Testing.sql
│   └── 09_Business_Rule_Testing.sql
│
├── Hospital Management System.docx
└── README.md
```

------------------------------------------------------------------------

## 🚀 How to Use

### Step 1 -- Create the database

``` sql
CREATE DATABASE hospital_management_system;
USE hospital_management_system;
```

### Step 2 -- Import the database dump file

``` text
hospital_management_system(Dump file)
```

### Step 3 -- Verify the tables

``` sql
SHOW TABLES;
```

### Step 4 -- Execute test queries

Run the SQL test queries against the database and compare the actual
result with the expected result.

### Step 5 -- Record defects

For failed tests, record:

-   Test Case ID
-   Test Scenario
-   SQL Query
-   Expected Result
-   Actual Result
-   Status
-   Bug/Issue Description

------------------------------------------------------------------------

## ✅ Expected Testing Result

The database should maintain:

-   **Data Accuracy**
-   **Referential Integrity**
-   **Data Consistency**
-   **Constraint Integrity**
-   **Correct Calculations**
-   **Valid Relationships**
-   **Reliable Business Rules**

------------------------------------------------------------------------

## 👨‍💻 Project Type

**Database Testing / SQL Testing **

This project demonstrates practical SQL skills and database testing
techniques using a realistic hospital management environment.

------------------------------------------------------------------------
## 👨‍ Author: Tasmin Jannat Tahsin

⭐ **If you find this project useful, feel free to star the
repository.**

