# 03. Test Data

## Document Purpose

This document describes test data prepared for validating the telecom billing flow.

The test data is used for:

- functional testing;
- negative testing;
- regression testing;
- SQL validation;
- bug reporting;
- change request analysis.

The goal is to prepare different data states before test execution.

---

## Test Data Strategy

The project uses test data for both positive and negative scenarios.

Positive test data is used to verify that the system works correctly under valid business conditions.

Negative test data is used to verify that the system correctly rejects invalid or forbidden business operations.

---

## Customers

| Customer ID | First Name | Last Name | Email                | Phone        | Status      | Purpose                                        |
| ----------- | ---------- | --------- | -------------------- | ------------ | ----------- | ---------------------------------------------- |
| CUST-001    | John       | Smith     | john.smith@test.com  | +77010000001 | ACTIVE      | Positive flow: active customer with valid data |
| CUST-002    | Anna       | Brown     | anna.brown@test.com  | +77010000002 | SUSPENDED   | Negative flow: suspended customer              |
| CUST-003    | Mark       | Wilson    | mark.wilson@test.com | +77010000003 | DEACTIVATED | Negative flow: deactivated customer            |
| CUST-004    | Sara       | Miller    | sara.miller@test.com | +77010000004 | ACTIVE      | Regression flow: second active customer        |
| CUST-005    | David      | Clark     | david.clark@test.com | +77010000005 | ACTIVE      | Additional service activation flow             |

---

## Tariff Plans

| Tariff ID | Tariff Name     | Monthly Fee | Minutes | SMS | Internet GB | Status   | Purpose                                           |
| --------- | --------------- | ----------: | ------: | --: | ----------: | -------- | ------------------------------------------------- |
| TAR-001   | Basic Mobile    |        5000 |     100 |  50 |          10 | ACTIVE   | Positive flow: basic active tariff                |
| TAR-002   | Standard Mobile |        8000 |     300 | 100 |          30 | ACTIVE   | Regression flow: active tariff                    |
| TAR-003   | Premium Mobile  |       12000 |    1000 | 300 |         100 | ACTIVE   | High-value tariff scenario                        |
| TAR-004   | Archived Start  |        3000 |      50 |  20 |           5 | ARCHIVED | Negative flow: archived tariff cannot be assigned |

---

## Subscriptions

| Subscription ID | Customer ID | Tariff ID | Status    | Start Date | Purpose                     |
| --------------- | ----------- | --------- | --------- | ---------- | --------------------------- |
| SUB-001         | CUST-001    | TAR-001   | ACTIVE    | 2026-04-01 | Positive billing flow       |
| SUB-002         | CUST-002    | TAR-002   | SUSPENDED | 2026-04-01 | Negative invoice generation |
| SUB-003         | CUST-003    | TAR-001   | CANCELLED | 2026-03-15 | Negative invoice generation |
| SUB-004         | CUST-004    | TAR-002   | ACTIVE    | 2026-04-10 | Regression testing          |
| SUB-005         | CUST-005    | TAR-003   | ACTIVE    | 2026-04-15 | Additional service testing  |

---

## Invoices

| Invoice ID | Customer ID | Subscription ID | Amount | Status | Invoice Date | Purpose                                      |
| ---------- | ----------- | --------------- | -----: | ------ | ------------ | -------------------------------------------- |
| INV-001    | CUST-001    | SUB-001         |   5000 | UNPAID | 2026-04-25   | Positive payment flow                        |
| INV-002    | CUST-004    | SUB-004         |   8000 | PAID   | 2026-04-25   | Negative flow: already paid invoice          |
| INV-003    | CUST-002    | SUB-002         |   8000 | UNPAID | 2026-04-25   | Data issue candidate: suspended subscription |
| INV-004    | CUST-003    | SUB-003         |   5000 | UNPAID | 2026-04-25   | Data issue candidate: cancelled subscription |
| INV-005    | CUST-005    | SUB-005         |  12000 | UNPAID | 2026-04-25   | Additional service billing flow              |

---

## Payments

| Payment ID | Invoice ID | Amount | Status  | Payment Date | Purpose                                 |
| ---------- | ---------- | -----: | ------- | ------------ | --------------------------------------- |
| PAY-001    | INV-001    |   5000 | SUCCESS | 2026-04-26   | Positive payment flow                   |
| PAY-002    | INV-002    |   8000 | SUCCESS | 2026-04-26   | Already paid invoice validation         |
| PAY-003    | INV-005    |  10000 | SUCCESS | 2026-04-26   | Negative flow: payment amount mismatch  |
| PAY-004    | INV-005    |  12000 | FAILED  | 2026-04-26   | Failed payment should not close invoice |

---

## Additional Services

| Service ID | Service Name        | Price | Status   | Purpose                          |
| ---------- | ------------------- | ----: | -------- | -------------------------------- |
| SRV-001    | Extra Internet 10GB |  1500 | ACTIVE   | Positive additional service flow |
| SRV-002    | International Calls |  2500 | ACTIVE   | Additional billing validation    |
| SRV-003    | Legacy Roaming      |  3000 | ARCHIVED | Negative flow: archived service  |

---

## Support Tickets

| Ticket ID | Customer ID | Subject                      | Status      | Purpose                         |
| --------- | ----------- | ---------------------------- | ----------- | ------------------------------- |
| TCK-001   | CUST-001    | Invoice amount clarification | OPEN        | Support ticket positive flow    |
| TCK-002   | CUST-002    | Service unavailable          | IN_PROGRESS | Suspended customer support flow |
| TCK-003   | CUST-004    | Payment confirmation request | RESOLVED    | Regression support scenario     |

---

## Positive Test Data Set

This data set is used for the main successful billing flow.

| Entity       | Test Data |
| ------------ | --------- |
| Customer     | CUST-001  |
| Tariff Plan  | TAR-001   |
| Subscription | SUB-001   |
| Invoice      | INV-001   |
| Payment      | PAY-001   |

Expected result:

- customer is active;
- subscription is active;
- invoice is unpaid before payment;
- payment amount matches invoice amount;
- after successful payment, invoice status should become `PAID`.

---

## Negative Test Data Set

This data set is used for validating forbidden or incorrect business scenarios.

| Scenario                           | Test Data                  | Expected Result                              |
| ---------------------------------- | -------------------------- | -------------------------------------------- |
| Invoice for suspended subscription | CUST-002, SUB-002, INV-003 | Invoice should not be generated              |
| Invoice for cancelled subscription | CUST-003, SUB-003, INV-004 | Invoice should not be generated              |
| Payment for already paid invoice   | INV-002, PAY-002           | New payment should be rejected               |
| Payment amount mismatch            | INV-005, PAY-003           | Payment should be rejected or marked invalid |
| Failed payment                     | INV-005, PAY-004           | Invoice should remain `UNPAID`               |
| Archived tariff assignment         | TAR-004                    | Tariff should not be assigned                |
| Archived service activation        | SRV-003                    | Service should not be activated              |

---

## Regression Test Data Set

This data set is used after changes in tariff price, invoice generation or payment processing logic.

| Entity         | Test Data |
| -------------- | --------- |
| Customer       | CUST-004  |
| Tariff Plan    | TAR-002   |
| Subscription   | SUB-004   |
| Invoice        | INV-002   |
| Support Ticket | TCK-003   |

Regression areas:

- subscription remains active;
- invoice amount matches tariff monthly fee;
- paid invoice remains paid;
- no duplicate payment is created;
- customer data remains unchanged;
- SQL relationships remain valid.

---

## Test Data Risks

| Risk                                       | Impact                                   | Mitigation                                             |
| ------------------------------------------ | ---------------------------------------- | ------------------------------------------------------ |
| Test data does not match requirements      | Test results may be invalid              | Review test data against requirements before execution |
| Invoice amount differs from tariff fee     | Billing validation may fail              | Add SQL check for invoice and tariff amount            |
| Payment amount differs from invoice amount | Incorrect invoice status may be assigned | Add SQL check for payment mismatch                     |
| Invalid subscription status is used        | Negative scenario may be unclear         | Document expected behavior before execution            |
| Test data is modified during testing       | Regression results may become unreliable | Keep stable regression data set                        |
