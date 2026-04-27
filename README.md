# Manual + SQL Project

## Project Goal

This project simulates a real QA workflow for a telecom billing system.

The main goal is to demonstrate practical manual QA skills:

- test data preparation;
- requirements analysis;
- functional testing;
- regression testing;
- SQL data validation;
- Jira-style bug reporting;
- change request analysis;
- daily QA reporting;
- communication with BA/Dev/QA Lead.

## Domain

The project is based on a simplified telecom billing system.

The system includes the following business entities:

- customers;
- tariff plans;
- subscriptions;
- invoices;
- payments;
- additional services;
- support tickets.

## Tested Business Flow

Main business flow:

1. A customer is created.
2. A tariff plan is assigned to the customer.
3. A subscription becomes active.
4. An invoice is generated for the customer.
5. The customer makes a payment.
6. The invoice status should be updated.
7. QA validates the result using SQL queries.
8. Defects are reported in Jira-style format.

## What This Project Demonstrates

| Skill                 | Evidence                                              |
| --------------------- | ----------------------------------------------------- |
| Manual Testing        | Checklists, test cases, regression checklist          |
| SQL                   | Database schema, test data, SQL validation queries    |
| Test Data Preparation | Customers, tariffs, subscriptions, invoices, payments |
| Bug Management        | Jira-style bug reports                                |
| Change Management     | Change request examples                               |
| Regression Testing    | Regression checklist and test summary                 |
| QA Communication      | Daily QA reports and clarification questions          |
| English Communication | QA reports and documentation in English               |

## Repository Structure

```text
Telecom-QA-Manual-SQL-Project/
│
├── README.md
├── 01_Project_Overview.md
├── 02_Requirements.md
├── 03_Test_Data.md
├── 04_Checklist.md
├── 05_Test_Cases.md
├── 06_SQL_Checks.md
├── 07_Bug_Reports.md
├── 08_Change_Requests.md
├── 09_Regression_Checklist.md
├── 10_Daily_QA_Reports.md
├── 11_Test_Summary.md
├── 12_Questions_to_BA_and_Dev.md
│
├── sql/
│   ├── schema.sql
│   ├── test_data.sql
│   └── qa_checks.sql
│
└── evidence/
    └── README.md


Important Note

This is a self-practice QA portfolio project.
It does not represent commercial experience.
The project is designed to simulate real QA tasks and demonstrate practical readiness for a Junior QA Engineer role.
```
