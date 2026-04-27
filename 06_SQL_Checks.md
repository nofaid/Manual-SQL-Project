# 06. SQL Checks

## SQL Check Status Legend

| Status       | Meaning                                                 |
| ------------ | ------------------------------------------------------- |
| Passed       | Actual result matches expected result                   |
| Failed       | Actual result does not match expected result            |
| Needs Review | Result may be valid but requires business clarification |
| Not Run      | SQL check has not been executed yet                     |

---

## CHECK-001: Show All Active Customers

| Field               | Value     |
| ------------------- | --------- |
| Check ID            | CHECK-001 |
| Related Requirement | REQ-001   |
| Related Test Case   | TC-001    |
| Priority            | Medium    |
| Status              | Passed    |

### Purpose

Verify that active customers exist and can be used for positive test scenarios.

### SQL Query

    SELECT
        customer_id,
        first_name,
        last_name,
        email,
        phone,
        status
    FROM customers
    WHERE status = 'ACTIVE';

### Expected Result

- Query returns customers with status `ACTIVE`.

### Actual Result

- Query returns active customers: `CUST-001`, `CUST-004`, `CUST-005`.

### QA Conclusion

Passed. Active customers are available for positive and regression test scenarios.

---

## CHECK-002: Show Active Subscriptions with Customer and Tariff Data

| Field               | Value     |
| ------------------- | --------- |
| Check ID            | CHECK-002 |
| Related Requirement | REQ-003   |
| Related Test Case   | TC-003    |
| Priority            | High      |
| Status              | Passed    |

### Purpose

Verify that active subscriptions are linked to customers and tariff plans.

### SQL Query

    SELECT
        s.subscription_id,
        c.customer_id,
        c.email,
        c.status AS customer_status,
        t.tariff_id,
        t.tariff_name,
        t.monthly_fee,
        t.status AS tariff_status,
        s.status AS subscription_status
    FROM subscriptions s
    JOIN customers c
        ON s.customer_id = c.customer_id
    JOIN tariff_plans t
        ON s.tariff_id = t.tariff_id
    WHERE s.status = 'ACTIVE';

### Expected Result

- Active subscriptions are linked to existing customers.
- Active subscriptions are linked to existing tariff plans.
- Active subscriptions use active tariff plans.

### Actual Result

- Query returns active subscriptions: `SUB-001`, `SUB-004`, `SUB-005`.
- All returned subscriptions are linked to existing customers and active tariff plans.

### QA Conclusion

Passed. Active subscription data is consistent.

---

## CHECK-003: Find Invoices Created for Non-Active Subscriptions

| Field               | Value                  |
| ------------------- | ---------------------- |
| Check ID            | CHECK-003              |
| Related Requirement | REQ-004                |
| Related Test Case   | TC-006, TC-007, TC-017 |
| Priority            | Critical               |
| Status              | Failed                 |
| Related Bug         | BUG-001                |

### Purpose

Verify that invoices are not generated for `SUSPENDED` or `CANCELLED` subscriptions.

### SQL Query

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

- Query returns `0 rows`.

### Actual Result

- Query returns:
  - `INV-003` linked to `SUB-002` with status `SUSPENDED`;
  - `INV-004` linked to `SUB-003` with status `CANCELLED`.

### QA Conclusion

Failed. Invoices were created for subscriptions that should not be billable.

This is a defect candidate because requirement `REQ-004` says that invoice cannot be generated for `SUSPENDED` or `CANCELLED` subscriptions.

---

## CHECK-004: Find Invoices Where Amount Does Not Match Tariff Monthly Fee

| Field               | Value          |
| ------------------- | -------------- |
| Check ID            | CHECK-004      |
| Related Requirement | REQ-004        |
| Related Test Case   | TC-005, TC-018 |
| Priority            | Critical       |
| Status              | Passed         |

### Purpose

Verify that invoice amount matches the monthly fee of the related tariff plan.

### SQL Query

    SELECT
        i.invoice_id,
        i.amount AS invoice_amount,
        t.monthly_fee AS tariff_monthly_fee,
        s.subscription_id,
        t.tariff_name
    FROM invoices i
    JOIN subscriptions s
        ON i.subscription_id = s.subscription_id
    JOIN tariff_plans t
        ON s.tariff_id = t.tariff_id
    WHERE i.amount <> t.monthly_fee;

### Expected Result

- Query returns `0 rows`.

### Actual Result

- Query returns `0 rows`.

### QA Conclusion

Passed. Invoice amounts match tariff monthly fees.

---

## CHECK-005: Find Successful Payments Where Payment Amount Does Not Match Invoice Amount

| Field               | Value            |
| ------------------- | ---------------- |
| Check ID            | CHECK-005        |
| Related Requirement | REQ-005, REQ-009 |
| Related Test Case   | TC-009           |
| Priority            | Critical         |
| Status              | Failed           |
| Related Bug         | BUG-002          |

### Purpose

Verify that successful payment amount matches invoice amount.

### SQL Query

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

- Query returns `0 rows`.

### Actual Result

- Query returns payment `PAY-003`.
- `PAY-003` has amount `10000`.
- Related invoice `INV-005` has amount `12000`.
- Payment status is `SUCCESS`.

### QA Conclusion

Failed. Successful payment with incorrect amount exists in the system.

This is a defect candidate because requirement `REQ-005` says that payment amount must match invoice amount.

---

## CHECK-006: Find Unpaid Invoices with Successful Full Payment

| Field               | Value          |
| ------------------- | -------------- |
| Check ID            | CHECK-006      |
| Related Requirement | REQ-005        |
| Related Test Case   | TC-008, TC-015 |
| Priority            | Critical       |
| Status              | Failed         |
| Related Bug         | BUG-003        |

### Purpose

Verify that invoice status changes to `PAID` after successful full payment.

### SQL Query

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

- Query returns `0 rows`.

### Actual Result

- Query returns invoice `INV-001`.
- Invoice `INV-001` has status `UNPAID`.
- Payment `PAY-001` has status `SUCCESS`.
- Payment amount equals invoice amount.

### QA Conclusion

Failed. Invoice status was not updated to `PAID` after successful full payment.

This is a critical billing defect candidate.

---

## CHECK-007: Find Paid Invoices Without Successful Payment

| Field               | Value     |
| ------------------- | --------- |
| Check ID            | CHECK-007 |
| Related Requirement | REQ-009   |
| Related Test Case   | TC-016    |
| Priority            | Critical  |
| Status              | Passed    |

### Purpose

Verify that every paid invoice has at least one successful payment.

### SQL Query

    SELECT
        i.invoice_id,
        i.status AS invoice_status,
        i.amount AS invoice_amount
    FROM invoices i
    LEFT JOIN payments p
        ON i.invoice_id = p.invoice_id
        AND p.status = 'SUCCESS'
    WHERE i.status = 'PAID'
      AND p.payment_id IS NULL;

### Expected Result

- Query returns `0 rows`.

### Actual Result

- Query returns `0 rows`.

### QA Conclusion

Passed. No paid invoice without successful payment was found.

---

## CHECK-008: Find Duplicate Successful Payments for the Same Invoice

| Field               | Value     |
| ------------------- | --------- |
| Check ID            | CHECK-008 |
| Related Requirement | REQ-005   |
| Related Test Case   | TC-010    |
| Priority            | High      |
| Status              | Passed    |

### Purpose

Verify that the system does not allow duplicate successful payments for the same invoice.

### SQL Query

    SELECT
        invoice_id,
        COUNT(*) AS successful_payment_count
    FROM payments
    WHERE status = 'SUCCESS'
    GROUP BY invoice_id
    HAVING COUNT(*) > 1;

### Expected Result

- Query returns `0 rows`.

### Actual Result

- Query returns `0 rows`.

### QA Conclusion

Passed. No duplicate successful payments were found.

---

## CHECK-009: Show Full Billing Flow for Specific Customer

| Field               | Value                              |
| ------------------- | ---------------------------------- |
| Check ID            | CHECK-009                          |
| Related Requirement | REQ-003, REQ-004, REQ-005, REQ-009 |
| Related Test Case   | TC-015                             |
| Priority            | Critical                           |
| Status              | Failed                             |
| Related Bug         | BUG-003                            |

### Purpose

Verify full customer billing chain:

- customer;
- subscription;
- tariff plan;
- invoice;
- payment.

### SQL Query

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
- Invoice status is `PAID` after successful payment.

### Actual Result

- Customer status is `ACTIVE`.
- Subscription status is `ACTIVE`.
- Payment status is `SUCCESS`.
- Payment amount equals invoice amount.
- Invoice status remains `UNPAID`.

### QA Conclusion

Failed. Full billing flow is broken because invoice status is not updated after successful payment.

---

## CHECK-010: Find Active Additional Services Linked to Non-Active Subscriptions

| Field               | Value     |
| ------------------- | --------- |
| Check ID            | CHECK-010 |
| Related Requirement | REQ-006   |
| Related Test Case   | TC-012    |
| Priority            | High      |
| Status              | Passed    |

### Purpose

Verify that additional services are activated only for active subscriptions.

### SQL Query

    SELECT
        cs.customer_service_id,
        cs.customer_id,
        cs.subscription_id,
        s.status AS subscription_status,
        cs.service_id,
        ads.service_name,
        ads.status AS service_status,
        cs.status AS customer_service_status
    FROM customer_services cs
    JOIN subscriptions s
        ON cs.subscription_id = s.subscription_id
    JOIN additional_services ads
        ON cs.service_id = ads.service_id
    WHERE s.status <> 'ACTIVE'
      AND cs.status = 'ACTIVE';

### Expected Result

- Query returns `0 rows`.

### Actual Result

- Query returns `0 rows`.

### QA Conclusion

Passed. No active additional service linked to non-active subscription was found.

---

## CHECK-011: Find Active Customer Services Linked to Archived Services

| Field               | Value     |
| ------------------- | --------- |
| Check ID            | CHECK-011 |
| Related Requirement | REQ-006   |
| Related Test Case   | TC-013    |
| Priority            | High      |
| Status              | Passed    |

### Purpose

Verify that archived services cannot be activated.

### SQL Query

    SELECT
        cs.customer_service_id,
        cs.customer_id,
        cs.subscription_id,
        cs.service_id,
        ads.service_name,
        ads.status AS service_status,
        cs.status AS customer_service_status
    FROM customer_services cs
    JOIN additional_services ads
        ON cs.service_id = ads.service_id
    WHERE ads.status = 'ARCHIVED'
      AND cs.status = 'ACTIVE';

### Expected Result

- Query returns `0 rows`.

### Actual Result

- Query returns `0 rows`.

### QA Conclusion

Passed. No active customer service linked to archived service was found.

---

## CHECK-012: Show Support Tickets with Customer Status

| Field               | Value     |
| ------------------- | --------- |
| Check ID            | CHECK-012 |
| Related Requirement | REQ-007   |
| Related Test Case   | TC-014    |
| Priority            | Medium    |
| Status              | Passed    |

### Purpose

Verify support tickets and customer relationship.

### SQL Query

    SELECT
        st.ticket_id,
        st.subject,
        st.status AS ticket_status,
        c.customer_id,
        c.email,
        c.status AS customer_status
    FROM support_tickets st
    JOIN customers c
        ON st.customer_id = c.customer_id;

### Expected Result

- Support tickets are linked to existing customers.

### Actual Result

- Query returns existing support tickets linked to valid customers.

### QA Conclusion

Passed. Support ticket data is consistent.

---

## CHECK-013: Find Customers Without Subscriptions

| Field               | Value        |
| ------------------- | ------------ |
| Check ID            | CHECK-013    |
| Related Requirement | REQ-003      |
| Related Test Case   | Not linked   |
| Priority            | Low          |
| Status              | Needs Review |

### Purpose

Identify customers who do not have any subscription.

This may be valid in some systems, but should be reviewed depending on business requirements.

### SQL Query

    SELECT
        c.customer_id,
        c.email,
        c.status
    FROM customers c
    LEFT JOIN subscriptions s
        ON c.customer_id = s.customer_id
    WHERE s.subscription_id IS NULL;

### Expected Result

- Depends on business rules.
- If every customer must have a subscription, query should return `0 rows`.
- If customers may exist without subscriptions, returned rows are acceptable.

### Actual Result

- No unexpected issue identified in the current test data set.

### QA Conclusion

Needs Review. Expected behavior should be clarified with BA if this rule becomes relevant.

---

## CHECK-014: Find Subscriptions Linked to Archived Tariff Plans

| Field               | Value            |
| ------------------- | ---------------- |
| Check ID            | CHECK-014        |
| Related Requirement | REQ-002, REQ-003 |
| Related Test Case   | TC-004           |
| Priority            | High             |
| Status              | Passed           |

### Purpose

Verify that only active tariff plans can be assigned to customers.

### SQL Query

    SELECT
        s.subscription_id,
        s.customer_id,
        s.tariff_id,
        t.tariff_name,
        t.status AS tariff_status,
        s.status AS subscription_status
    FROM subscriptions s
    JOIN tariff_plans t
        ON s.tariff_id = t.tariff_id
    WHERE t.status = 'ARCHIVED';

### Expected Result

- Query returns `0 rows`.

### Actual Result

- Query returns `0 rows`.

### QA Conclusion

Passed. No subscription linked to archived tariff plan was found.

---

## CHECK-015: Regression Check for Paid Invoice Stability

| Field               | Value     |
| ------------------- | --------- |
| Check ID            | CHECK-015 |
| Related Requirement | REQ-008   |
| Related Test Case   | TC-018    |
| Priority            | Critical  |
| Status              | Passed    |

### Purpose

Verify that already paid invoices remain `PAID` after billing logic changes.

### SQL Query

    SELECT
        i.invoice_id,
        i.customer_id,
        i.subscription_id,
        i.amount,
        i.status,
        p.payment_id,
        p.status AS payment_status
    FROM invoices i
    LEFT JOIN payments p
        ON i.invoice_id = p.invoice_id
    WHERE i.invoice_id = 'INV-002';

### Expected Result

- Invoice `INV-002` exists.
- Invoice status is `PAID`.
- Successful payment exists.
- Payment remains linked to invoice.

### Actual Result

- Invoice `INV-002` exists.
- Invoice status is `PAID`.
- Payment `PAY-002` exists and has status `SUCCESS`.

### QA Conclusion

Passed. Paid invoice remained stable after regression check.

---

## Failed SQL Checks Summary

| Check ID  | Issue                                                          | Related Bug |
| --------- | -------------------------------------------------------------- | ----------- |
| CHECK-003 | Invoices exist for suspended and cancelled subscriptions       | BUG-001     |
| CHECK-005 | Successful payment amount does not match invoice amount        | BUG-002     |
| CHECK-006 | Invoice remains unpaid after successful full payment           | BUG-003     |
| CHECK-009 | Full billing flow shows incorrect invoice status after payment | BUG-003     |

---

## Passed SQL Checks Summary

| Check ID  | Area                                         |
| --------- | -------------------------------------------- |
| CHECK-001 | Active customers                             |
| CHECK-002 | Active subscriptions                         |
| CHECK-004 | Invoice amount vs tariff fee                 |
| CHECK-007 | Paid invoice has successful payment          |
| CHECK-008 | No duplicate successful payments             |
| CHECK-010 | Additional services for active subscriptions |
| CHECK-011 | Archived services are not active             |
| CHECK-012 | Support tickets linked to customers          |
| CHECK-014 | No archived tariff assigned                  |
| CHECK-015 | Paid invoice regression stability            |

---

## QA Summary

SQL validation found three main defect candidates:

1. Invoices are generated for non-active subscriptions.
2. Successful payment with incorrect amount exists in the system.
3. Invoice status is not updated to `PAID` after successful full payment.

These issues should be documented as Jira-style bug reports in:

- `07_Bug_Reports.md`

The SQL checks also confirmed that several areas work correctly:

- active customer data;
- active subscription relationships;
- invoice amount and tariff fee consistency;
- paid invoice payment relationship;
- additional service activation rules;
- support ticket relationships.

---

## Notes

- SQL checks marked as `Failed` should be linked to bug reports.
- SQL checks marked as `Needs Review` should be clarified with BA.
- SQL results can be used as evidence in Jira-style defect reports.
- These checks can be reused during regression testing.
