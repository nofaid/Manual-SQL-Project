# 07. Bug Reports

## Document Purpose

This document contains Jira-style bug reports created during testing of the telecom billing flow.

The bug reports are based on:

- requirements;
- test cases;
- SQL validation checks;
- actual vs expected results.

The goal is to demonstrate practical defect reporting and bug management skills.

---

## Bug Report Status Legend

| Status           | Meaning                                |
| ---------------- | -------------------------------------- |
| Open             | Bug is created and waiting for review  |
| In Progress      | Bug is being analyzed or fixed         |
| Ready for Retest | Fix is ready and waiting for QA retest |
| Reopened         | Bug was not fixed correctly            |
| Closed           | Bug was fixed and verified             |
| Rejected         | Bug was rejected after analysis        |

---

## Severity and Priority

### Severity

| Severity | Meaning                                                              |
| -------- | -------------------------------------------------------------------- |
| Critical | Main business flow is broken or financial/data integrity risk exists |
| Major    | Important functionality works incorrectly                            |
| Minor    | Non-critical issue with limited impact                               |
| Trivial  | Cosmetic or very low impact issue                                    |

### Priority

| Priority | Meaning                             |
| -------- | ----------------------------------- |
| High     | Should be fixed as soon as possible |
| Medium   | Should be fixed in planned scope    |
| Low      | Can be fixed later                  |

---

## BUG-001: Invoices Are Generated for Non-Active Subscriptions

| Field              | Value                        |
| ------------------ | ---------------------------- |
| Bug ID             | BUG-001                      |
| Type               | Bug                          |
| Status             | Open                         |
| Severity           | Critical                     |
| Priority           | High                         |
| Module             | Billing / Invoice Generation |
| Requirement        | REQ-004                      |
| Related Test Cases | TC-006, TC-007, TC-017       |
| Related SQL Check  | CHECK-003                    |
| Environment        | Simulated QA database        |
| Reported By        | QA Engineer                  |

### Summary

Invoices are generated for subscriptions with `SUSPENDED` and `CANCELLED` statuses.

### Preconditions

- Customer `CUST-002` exists with status `SUSPENDED`.
- Subscription `SUB-002` exists with status `SUSPENDED`.
- Customer `CUST-003` exists with status `DEACTIVATED`.
- Subscription `SUB-003` exists with status `CANCELLED`.

### Steps to Reproduce

1. Prepare test data for suspended and cancelled subscriptions.
2. Check invoices linked to non-active subscriptions.
3. Execute SQL validation query for invoice generation rules.

### SQL Evidence

    SELECT
        i.invoice_id,
        i.customer_id,
        i.subscription_id,
        s.status AS subscription_status,
        i.amount,
        i.status AS invoice_status,
        i.invoice_date
    FROM invoices i
    JOIN subscriptions s
        ON i.subscription_id = s.subscription_id
    WHERE s.status IN ('SUSPENDED', 'CANCELLED');

### Expected Result

The query should return `0 rows`.

Invoices must not be generated for:

- `SUSPENDED` subscriptions;
- `CANCELLED` subscriptions.

### Actual Result

The query returns:

| Invoice ID | Subscription ID | Subscription Status | Invoice Status | Amount |
| ---------- | --------------- | ------------------- | -------------- | -----: |
| INV-003    | SUB-002         | SUSPENDED           | UNPAID         |   8000 |
| INV-004    | SUB-003         | CANCELLED           | UNPAID         |   5000 |

### Impact

This issue may cause incorrect billing.

Possible business impact:

- suspended customers may receive invalid invoices;
- cancelled subscriptions may still be billed;
- customer complaints may increase;
- financial data may become unreliable.

### QA Comment

This issue violates requirement `REQ-004`.

Invoice generation rules should prevent invoices for non-active subscriptions.

---

## BUG-002: Successful Payment Exists with Incorrect Amount

| Field             | Value                        |
| ----------------- | ---------------------------- |
| Bug ID            | BUG-002                      |
| Type              | Bug                          |
| Status            | Open                         |
| Severity          | Critical                     |
| Priority          | High                         |
| Module            | Billing / Payment Processing |
| Requirement       | REQ-005, REQ-009             |
| Related Test Case | TC-009                       |
| Related SQL Check | CHECK-005                    |
| Environment       | Simulated QA database        |
| Reported By       | QA Engineer                  |

### Summary

A payment with amount lower than invoice amount is stored with status `SUCCESS`.

### Preconditions

- Invoice `INV-005` exists.
- Invoice amount is `12000`.
- Payment `PAY-003` exists.
- Payment amount is `10000`.
- Payment status is `SUCCESS`.

### Steps to Reproduce

1. Prepare invoice `INV-005` with amount `12000`.
2. Register or check payment `PAY-003` with amount `10000`.
3. Verify payment status.
4. Execute SQL validation query for payment amount consistency.

### SQL Evidence

    SELECT
        p.payment_id,
        p.invoice_id,
        p.amount AS payment_amount,
        i.amount AS invoice_amount,
        p.status AS payment_status,
        i.status AS invoice_status
    FROM payments p
    JOIN invoices i
        ON p.invoice_id = i.invoice_id
    WHERE p.status = 'SUCCESS'
      AND p.amount <> i.amount;

### Expected Result

The query should return `0 rows`.

Successful payment amount must match invoice amount.

### Actual Result

The query returns:

| Payment ID | Invoice ID | Payment Amount | Invoice Amount | Payment Status |
| ---------- | ---------- | -------------: | -------------: | -------------- |
| PAY-003    | INV-005    |          10000 |          12000 | SUCCESS        |

### Impact

This issue may cause incorrect payment processing.

Possible business impact:

- invoice may be treated as paid with insufficient payment amount;
- billing data may become inconsistent;
- financial reports may be incorrect;
- customer balance may be calculated incorrectly.

### QA Comment

The system should reject payment with incorrect amount or mark it as invalid/failed.

Current behavior violates `REQ-005` and `REQ-009`.

---

## BUG-003: Invoice Status Is Not Updated After Successful Full Payment

| Field              | Value                        |
| ------------------ | ---------------------------- |
| Bug ID             | BUG-003                      |
| Type               | Bug                          |
| Status             | Open                         |
| Severity           | Critical                     |
| Priority           | High                         |
| Module             | Billing / Payment Processing |
| Requirement        | REQ-005                      |
| Related Test Cases | TC-008, TC-015               |
| Related SQL Checks | CHECK-006, CHECK-009         |
| Environment        | Simulated QA database        |
| Reported By        | QA Engineer                  |

### Summary

Invoice remains `UNPAID` after successful full payment.

### Preconditions

- Invoice `INV-001` exists.
- Invoice amount is `5000`.
- Invoice status is `UNPAID`.
- Payment `PAY-001` exists.
- Payment amount is `5000`.
- Payment status is `SUCCESS`.

### Steps to Reproduce

1. Prepare unpaid invoice `INV-001`.
2. Register successful payment `PAY-001`.
3. Verify payment amount and status.
4. Verify invoice status after payment.
5. Execute SQL validation query.

### SQL Evidence

    SELECT
        i.invoice_id,
        i.status AS invoice_status,
        i.amount AS invoice_amount,
        p.payment_id,
        p.status AS payment_status,
        p.amount AS payment_amount
    FROM invoices i
    JOIN payments p
        ON i.invoice_id = p.invoice_id
    WHERE i.status = 'UNPAID'
      AND p.status = 'SUCCESS'
      AND p.amount = i.amount;

### Expected Result

The query should return `0 rows`.

After successful full payment, invoice status must become `PAID`.

### Actual Result

The query returns:

| Invoice ID | Invoice Status | Invoice Amount | Payment ID | Payment Status | Payment Amount |
| ---------- | -------------- | -------------: | ---------- | -------------- | -------------: |
| INV-001    | UNPAID         |           5000 | PAY-001    | SUCCESS        |           5000 |

### Impact

This is a critical billing issue.

Possible business impact:

- customer may be asked to pay again;
- paid invoice may still appear as unpaid;
- support tickets may increase;
- financial data may become inconsistent;
- reporting and reconciliation may be incorrect.

### QA Comment

Payment was successful and full amount was paid, but invoice status was not updated.

This violates `REQ-005`.

---

## BUG-004: Full Billing Flow Shows Incorrect Invoice Status

| Field             | Value                              |
| ----------------- | ---------------------------------- |
| Bug ID            | BUG-004                            |
| Type              | Bug                                |
| Status            | Open                               |
| Severity          | Major                              |
| Priority          | High                               |
| Module            | Billing / End-to-End Flow          |
| Requirement       | REQ-003, REQ-004, REQ-005, REQ-009 |
| Related Test Case | TC-015                             |
| Related SQL Check | CHECK-009                          |
| Environment       | Simulated QA database              |
| Reported By       | QA Engineer                        |

### Summary

End-to-end billing flow for customer `CUST-001` shows incorrect invoice status after successful payment.

### Preconditions

- Customer `CUST-001` exists and has status `ACTIVE`.
- Subscription `SUB-001` exists and has status `ACTIVE`.
- Invoice `INV-001` exists.
- Payment `PAY-001` exists and has status `SUCCESS`.

### Steps to Reproduce

1. Verify customer `CUST-001`.
2. Verify active subscription `SUB-001`.
3. Verify tariff plan `TAR-001`.
4. Verify invoice `INV-001`.
5. Verify payment `PAY-001`.
6. Execute full billing flow SQL query.

### SQL Evidence

    SELECT
        c.customer_id,
        c.email,
        c.status AS customer_status,
        s.subscription_id,
        s.status AS subscription_status,
        t.tariff_name,
        t.monthly_fee,
        i.invoice_id,
        i.amount AS invoice_amount,
        i.status AS invoice_status,
        p.payment_id,
        p.amount AS payment_amount,
        p.status AS payment_status
    FROM customers c
    JOIN subscriptions s
        ON c.customer_id = s.customer_id
    JOIN tariff_plans t
        ON s.tariff_id = t.tariff_id
    LEFT JOIN invoices i
        ON s.subscription_id = i.subscription_id
    LEFT JOIN payments p
        ON i.invoice_id = p.invoice_id
    WHERE c.customer_id = 'CUST-001';

### Expected Result

- Customer status is `ACTIVE`.
- Subscription status is `ACTIVE`.
- Invoice amount equals tariff monthly fee.
- Payment amount equals invoice amount.
- Payment status is `SUCCESS`.
- Invoice status is `PAID`.

### Actual Result

- Customer status is `ACTIVE`.
- Subscription status is `ACTIVE`.
- Invoice amount equals tariff monthly fee.
- Payment amount equals invoice amount.
- Payment status is `SUCCESS`.
- Invoice status remains `UNPAID`.

### Impact

The full billing flow is inconsistent.

The issue may affect:

- customer account balance;
- invoice visibility;
- payment confirmation;
- financial reporting;
- customer support workload.

### QA Comment

This bug is related to `BUG-003`.

`BUG-004` describes the same issue from an end-to-end business flow perspective.

---

## Bug Summary

| Bug ID  | Summary                                                     | Severity | Priority | Status |
| ------- | ----------------------------------------------------------- | -------- | -------- | ------ |
| BUG-001 | Invoices are generated for non-active subscriptions         | Critical | High     | Open   |
| BUG-002 | Successful payment exists with incorrect amount             | Critical | High     | Open   |
| BUG-003 | Invoice status is not updated after successful full payment | Critical | High     | Open   |
| BUG-004 | Full billing flow shows incorrect invoice status            | Major    | High     | Open   |

---

## QA Notes

- `BUG-001`, `BUG-002` and `BUG-003` are critical because they may affect billing accuracy and financial data consistency.
- `BUG-004` is related to the end-to-end billing flow and may be linked to `BUG-003`.
- SQL evidence is included for each bug.
- All bugs should be reviewed by BA/Dev before fix implementation.
- After fixes, regression testing should cover invoice generation, payment processing and SQL data consistency.
