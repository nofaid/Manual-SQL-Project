# 01. Project Overview

## Project Name

Telecom QA Manual + SQL Project

## Project Type

Self-practice QA portfolio project based on a simulated telecom billing system.

## Business Context

A telecom company uses a billing system to manage customers, tariff plans, subscriptions, invoices, payments and additional services.

The billing system is important because it directly affects:

- customer service activation;
- invoice generation;
- payment processing;
- customer account status;
- financial data consistency;
- customer support operations.

Incorrect billing logic may lead to financial losses, customer complaints, incorrect service access or wrong account status.

## QA Context

The QA engineer is responsible for verifying that the billing flow works correctly from the business and data consistency perspective.

The main QA focus is not only to check individual screens or fields, but also to verify that related business entities remain consistent across the system.

For example:

- an active customer should be able to have an active subscription;
- an invoice should be generated only for an active subscription;
- a successful payment should update invoice status;
- payment amount should match invoice amount;
- cancelled subscriptions should not receive new invoices.

## QA Scope

The testing scope includes:

- requirements analysis;
- test data preparation;
- functional testing;
- negative testing;
- regression testing;
- SQL data validation;
- defect reporting;
- change request analysis;
- daily QA reporting;
- clarification questions to BA/Dev.

## Out of Scope

The following areas are not covered in this project:

- performance testing;
- security testing;
- automation testing;
- real integration with external payment providers;
- real telecom infrastructure;
- production data;
- UI testing of a real application.

## Main System Modules

| Module              | Description                                                      |
| ------------------- | ---------------------------------------------------------------- |
| Customers           | Stores customer profile, contact data and account status         |
| Tariff Plans        | Stores available telecom tariff plans and monthly fees           |
| Subscriptions       | Links customers with tariff plans and stores subscription status |
| Invoices            | Stores billing documents generated for customers                 |
| Payments            | Stores customer payments linked to invoices                      |
| Additional Services | Stores optional paid services                                    |
| Support Tickets     | Stores customer support requests                                 |

## Main Business Flow

The main business flow tested in this project:

1. A customer is created.
2. A tariff plan is assigned to the customer.
3. A subscription becomes active.
4. An invoice is generated for the active subscription.
5. A payment is registered for the invoice.
6. Invoice status is updated from `UNPAID` to `PAID`.
7. QA validates business and data consistency using SQL checks.
8. Defects or change requests are documented in Jira-style format.

## QA Objective

The main QA objective is to verify that telecom billing data remains correct and consistent after key business operations.

Special attention is paid to:

- customer status;
- subscription status;
- invoice status;
- payment amount;
- relationship between customers, subscriptions, invoices and payments;
- negative business scenarios;
- regression risks after changes;
- defect and change management.

## Key Risks

| Risk                                           | Possible Impact                             |
| ---------------------------------------------- | ------------------------------------------- |
| Invoice is generated for inactive subscription | Customer may be charged incorrectly         |
| Payment does not update invoice status         | Financial data becomes inconsistent         |
| Payment amount differs from invoice amount     | Billing records may be incorrect            |
| Cancelled subscription remains billable        | Customer may receive invalid charges        |
| Test data is incomplete or incorrect           | QA results may be unreliable                |
| Requirements are unclear                       | QA may test against wrong expected behavior |
