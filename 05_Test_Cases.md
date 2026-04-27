# 05. Test Cases

## Test Case Status Legend

| Status              | Meaning                                      |
| ------------------- | -------------------------------------------- |
| Not Run             | Test case has not been executed yet          |
| Passed              | Actual result matches expected result        |
| Failed              | Actual result does not match expected result |
| Blocked             | Test case cannot be executed                 |
| Needs Clarification | Expected behavior requires clarification     |

---

## TC-001: Create Customer with Valid Required Data

| Field        | Value                                    |
| ------------ | ---------------------------------------- |
| Test Case ID | TC-001                                   |
| Title        | Create customer with valid required data |
| Requirement  | REQ-001                                  |
| Checklist ID | CHK-001, CHK-005                         |
| Priority     | High                                     |
| Type         | Positive                                 |
| Status       | Not Run                                  |

### Preconditions

- Customer creation functionality is available.
- Customer email does not already exist in the system.
- Customer data is valid.

### Test Data

| Field      | Value               |
| ---------- | ------------------- |
| First Name | John                |
| Last Name  | Smith               |
| Email      | john.smith@test.com |
| Phone      | +77010000001        |
| Status     | ACTIVE              |

### Steps

1. Create a new customer with valid required fields.
2. Save the customer.
3. Check that the customer record is created.
4. Verify customer data in the database.

### Expected Result

- Customer is created successfully.
- Customer has status `ACTIVE`.
- Customer email is unique.
- Customer record exists in the `customers` table.

### SQL Validation

    SELECT customer_id, email, phone, status
    FROM customers
    WHERE email = 'john.smith@test.com';

### Expected SQL Result

- Query returns one customer.
- Customer status is `ACTIVE`.

---

## TC-002: Create Customer Without Email

| Field        | Value                         |
| ------------ | ----------------------------- |
| Test Case ID | TC-002                        |
| Title        | Create customer without email |
| Requirement  | REQ-001                       |
| Checklist ID | CHK-003                       |
| Priority     | High                          |
| Type         | Negative                      |
| Status       | Not Run                       |

### Preconditions

- Customer creation functionality is available.

### Test Data

| Field      | Value        |
| ---------- | ------------ |
| First Name | Test         |
| Last Name  | User         |
| Email      | empty        |
| Phone      | +77019999999 |
| Status     | ACTIVE       |

### Steps

1. Try to create a customer without email.
2. Save the customer.
3. Check validation behavior.
4. Verify that no customer without email exists in the database.

### Expected Result

- Customer is not created.
- Validation error is shown or returned.
- No customer record without email exists in the database.

### SQL Validation

    SELECT customer_id, first_name, last_name, email
    FROM customers
    WHERE email IS NULL OR email = '';

### Expected SQL Result

- Query returns `0 rows`.

---

## TC-003: Assign Active Tariff Plan to Active Customer

| Field        | Value                                        |
| ------------ | -------------------------------------------- |
| Test Case ID | TC-003                                       |
| Title        | Assign active tariff plan to active customer |
| Requirement  | REQ-003                                      |
| Checklist ID | CHK-012, CHK-015, CHK-016, CHK-017           |
| Priority     | High                                         |
| Type         | Positive                                     |
| Status       | Not Run                                      |

### Preconditions

- Customer `CUST-001` exists and has status `ACTIVE`.
- Tariff plan `TAR-001` exists and has status `ACTIVE`.

### Test Data

| Entity       | Value    |
| ------------ | -------- |
| Customer     | CUST-001 |
| Tariff Plan  | TAR-001  |
| Subscription | SUB-001  |

### Steps

1. Assign tariff plan `TAR-001` to customer `CUST-001`.
2. Create subscription.
3. Verify subscription status.
4. Verify subscription data in the database.

### Expected Result

- Subscription is created successfully.
- Subscription is linked to customer `CUST-001`.
- Subscription is linked to tariff plan `TAR-001`.
- Subscription status is `ACTIVE`.

### SQL Validation

    SELECT subscription_id, customer_id, tariff_id, status
    FROM subscriptions
    WHERE subscription_id = 'SUB-001';

### Expected SQL Result

- Query returns subscription `SUB-001`.
- `customer_id` is `CUST-001`.
- `tariff_id` is `TAR-001`.
- Subscription status is `ACTIVE`.

---

## TC-004: Assign Archived Tariff Plan to Customer

| Field        | Value                                   |
| ------------ | --------------------------------------- |
| Test Case ID | TC-004                                  |
| Title        | Assign archived tariff plan to customer |
| Requirement  | REQ-002, REQ-003                        |
| Checklist ID | CHK-011                                 |
| Priority     | High                                    |
| Type         | Negative                                |
| Status       | Not Run                                 |

### Preconditions

- Customer `CUST-001` exists and has status `ACTIVE`.
- Tariff plan `TAR-004` exists and has status `ARCHIVED`.

### Test Data

| Entity      | Value    |
| ----------- | -------- |
| Customer    | CUST-001 |
| Tariff Plan | TAR-004  |

### Steps

1. Try to assign archived tariff plan `TAR-004` to active customer `CUST-001`.
2. Save subscription.
3. Check validation behavior.
4. Verify that subscription with archived tariff plan was not created.

### Expected Result

- Subscription is not created.
- Archived tariff plan cannot be assigned to customer.
- Error message or validation response is returned.

### SQL Validation

    SELECT s.subscription_id, s.customer_id, s.tariff_id, t.status AS tariff_status
    FROM subscriptions s
    JOIN tariff_plans t
        ON s.tariff_id = t.tariff_id
    WHERE t.status = 'ARCHIVED';

### Expected SQL Result

- Query returns `0 rows`.

---

## TC-005: Generate Invoice for Active Subscription

| Field        | Value                                       |
| ------------ | ------------------------------------------- |
| Test Case ID | TC-005                                      |
| Title        | Generate invoice for active subscription    |
| Requirement  | REQ-004                                     |
| Checklist ID | CHK-019, CHK-020, CHK-021, CHK-022, CHK-023 |
| Priority     | Critical                                    |
| Type         | Positive                                    |
| Status       | Not Run                                     |

### Preconditions

- Customer `CUST-001` exists and has status `ACTIVE`.
- Subscription `SUB-001` exists and has status `ACTIVE`.
- Tariff plan `TAR-001` has monthly fee `5000`.

### Test Data

| Entity                  | Value    |
| ----------------------- | -------- |
| Customer                | CUST-001 |
| Subscription            | SUB-001  |
| Tariff Plan             | TAR-001  |
| Expected Invoice Amount | 5000     |
| Expected Invoice Status | UNPAID   |

### Steps

1. Generate invoice for subscription `SUB-001`.
2. Check that invoice is created.
3. Check invoice amount.
4. Check invoice status.
5. Verify invoice data in the database.

### Expected Result

- Invoice is generated successfully.
- Invoice is linked to customer `CUST-001`.
- Invoice is linked to subscription `SUB-001`.
- Invoice amount is `5000`.
- Invoice status is `UNPAID`.

### SQL Validation

    SELECT invoice_id, customer_id, subscription_id, amount, status
    FROM invoices
    WHERE customer_id = 'CUST-001'
      AND subscription_id = 'SUB-001';

### Expected SQL Result

- Query returns invoice for `CUST-001` and `SUB-001`.
- Invoice amount is `5000`.
- Invoice status is `UNPAID`.

---

## TC-006: Generate Invoice for Suspended Subscription

| Field        | Value                                       |
| ------------ | ------------------------------------------- |
| Test Case ID | TC-006                                      |
| Title        | Generate invoice for suspended subscription |
| Requirement  | REQ-004                                     |
| Checklist ID | CHK-024                                     |
| Priority     | Critical                                    |
| Type         | Negative                                    |
| Status       | Not Run                                     |

### Preconditions

- Customer `CUST-002` exists and has status `SUSPENDED`.
- Subscription `SUB-002` exists and has status `SUSPENDED`.

### Test Data

| Entity            | Value    |
| ----------------- | -------- |
| Customer          | CUST-002 |
| Subscription      | SUB-002  |
| Invoice Candidate | INV-003  |

### Steps

1. Try to generate invoice for suspended subscription `SUB-002`.
2. Check whether invoice is created.
3. Verify result in the database.

### Expected Result

- Invoice is not generated.
- System prevents invoice generation for suspended subscription.
- No invoice exists for subscription `SUB-002`.

### SQL Validation

    SELECT i.invoice_id, i.subscription_id, s.status AS subscription_status
    FROM invoices i
    JOIN subscriptions s
        ON i.subscription_id = s.subscription_id
    WHERE s.status = 'SUSPENDED';

### Expected SQL Result

- Query returns `0 rows`.

---

## TC-007: Generate Invoice for Cancelled Subscription

| Field        | Value                                       |
| ------------ | ------------------------------------------- |
| Test Case ID | TC-007                                      |
| Title        | Generate invoice for cancelled subscription |
| Requirement  | REQ-004                                     |
| Checklist ID | CHK-025                                     |
| Priority     | Critical                                    |
| Type         | Negative                                    |
| Status       | Not Run                                     |

### Preconditions

- Customer `CUST-003` exists and has status `DEACTIVATED`.
- Subscription `SUB-003` exists and has status `CANCELLED`.

### Test Data

| Entity            | Value    |
| ----------------- | -------- |
| Customer          | CUST-003 |
| Subscription      | SUB-003  |
| Invoice Candidate | INV-004  |

### Steps

1. Try to generate invoice for cancelled subscription `SUB-003`.
2. Check whether invoice is created.
3. Verify result in the database.

### Expected Result

- Invoice is not generated.
- System prevents invoice generation for cancelled subscription.
- No invoice exists for subscription `SUB-003`.

### SQL Validation

    SELECT i.invoice_id, i.subscription_id, s.status AS subscription_status
    FROM invoices i
    JOIN subscriptions s
        ON i.subscription_id = s.subscription_id
    WHERE s.status = 'CANCELLED';

### Expected SQL Result

- Query returns `0 rows`.

---

## TC-008: Register Successful Payment for Unpaid Invoice

| Field        | Value                                          |
| ------------ | ---------------------------------------------- |
| Test Case ID | TC-008                                         |
| Title        | Register successful payment for unpaid invoice |
| Requirement  | REQ-005                                        |
| Checklist ID | CHK-027, CHK-028, CHK-029, CHK-030             |
| Priority     | Critical                                       |
| Type         | Positive                                       |
| Status       | Not Run                                        |

### Preconditions

- Invoice `INV-001` exists.
- Invoice `INV-001` has status `UNPAID`.
- Payment amount matches invoice amount.

### Test Data

| Entity         | Value   |
| -------------- | ------- |
| Invoice        | INV-001 |
| Payment        | PAY-001 |
| Invoice Amount | 5000    |
| Payment Amount | 5000    |
| Payment Status | SUCCESS |

### Steps

1. Register successful payment `PAY-001` for invoice `INV-001`.
2. Check payment status.
3. Check invoice status after payment.
4. Verify invoice/payment consistency in the database.

### Expected Result

- Payment is registered successfully.
- Payment has status `SUCCESS`.
- Payment amount matches invoice amount.
- Invoice status changes from `UNPAID` to `PAID`.

### SQL Validation

    SELECT i.invoice_id, i.status AS invoice_status,
           p.payment_id, p.status AS payment_status,
           i.amount AS invoice_amount, p.amount AS payment_amount
    FROM invoices i
    JOIN payments p
        ON i.invoice_id = p.invoice_id
    WHERE i.invoice_id = 'INV-001';

### Expected SQL Result

- Query returns invoice `INV-001` and payment `PAY-001`.
- Payment status is `SUCCESS`.
- Payment amount equals invoice amount.
- Invoice status is `PAID`.

---

## TC-009: Register Payment with Amount Mismatch

| Field        | Value                                 |
| ------------ | ------------------------------------- |
| Test Case ID | TC-009                                |
| Title        | Register payment with amount mismatch |
| Requirement  | REQ-005, REQ-009                      |
| Checklist ID | CHK-029, CHK-052                      |
| Priority     | Critical                              |
| Type         | Negative                              |
| Status       | Not Run                               |

### Preconditions

- Invoice `INV-005` exists.
- Invoice amount is `12000`.
- Payment amount is `10000`.

### Test Data

| Entity         | Value   |
| -------------- | ------- |
| Invoice        | INV-005 |
| Payment        | PAY-003 |
| Invoice Amount | 12000   |
| Payment Amount | 10000   |
| Payment Status | SUCCESS |

### Steps

1. Try to register successful payment with amount lower than invoice amount.
2. Check payment processing result.
3. Verify invoice/payment consistency in the database.

### Expected Result

- Payment with incorrect amount is rejected or marked invalid.
- Invoice status remains `UNPAID`.
- System does not treat mismatched payment as successful full payment.

### SQL Validation

    SELECT p.payment_id, p.amount AS payment_amount,
           i.amount AS invoice_amount,
           p.status AS payment_status,
           i.status AS invoice_status
    FROM payments p
    JOIN invoices i
        ON p.invoice_id = i.invoice_id
    WHERE p.status = 'SUCCESS'
      AND p.amount <> i.amount;

### Expected SQL Result

- Query returns `0 rows`.

---

## TC-010: Register Payment for Already Paid Invoice

| Field        | Value                                     |
| ------------ | ----------------------------------------- |
| Test Case ID | TC-010                                    |
| Title        | Register payment for already paid invoice |
| Requirement  | REQ-005                                   |
| Checklist ID | CHK-031                                   |
| Priority     | High                                      |
| Type         | Negative                                  |
| Status       | Not Run                                   |

### Preconditions

- Invoice `INV-002` exists.
- Invoice `INV-002` has status `PAID`.
- Successful payment already exists for this invoice.

### Test Data

| Entity           | Value   |
| ---------------- | ------- |
| Invoice          | INV-002 |
| Existing Payment | PAY-002 |
| Invoice Status   | PAID    |

### Steps

1. Try to register another successful payment for invoice `INV-002`.
2. Check payment processing result.
3. Verify that duplicate successful payment is not created.

### Expected Result

- New payment is rejected.
- System does not allow duplicate successful payment for already paid invoice.
- No duplicate successful payments exist for the same invoice.

### SQL Validation

    SELECT invoice_id, COUNT(*) AS successful_payment_count
    FROM payments
    WHERE status = 'SUCCESS'
    GROUP BY invoice_id
    HAVING COUNT(*) > 1;

### Expected SQL Result

- Query returns `0 rows`.

---

## TC-011: Failed Payment Does Not Close Invoice

| Field        | Value                                 |
| ------------ | ------------------------------------- |
| Test Case ID | TC-011                                |
| Title        | Failed payment does not close invoice |
| Requirement  | REQ-005                               |
| Checklist ID | CHK-033                               |
| Priority     | Critical                              |
| Type         | Negative                              |
| Status       | Not Run                               |

### Preconditions

- Invoice `INV-005` exists.
- Invoice `INV-005` has status `UNPAID`.

### Test Data

| Entity         | Value   |
| -------------- | ------- |
| Invoice        | INV-005 |
| Payment        | PAY-004 |
| Payment Status | FAILED  |
| Invoice Status | UNPAID  |

### Steps

1. Register failed payment for invoice `INV-005`.
2. Check payment status.
3. Check invoice status after failed payment.

### Expected Result

- Payment has status `FAILED`.
- Invoice status remains `UNPAID`.
- Failed payment does not close invoice.

### SQL Validation

    SELECT i.invoice_id, i.status AS invoice_status,
           p.payment_id, p.status AS payment_status
    FROM invoices i
    JOIN payments p
        ON i.invoice_id = p.invoice_id
    WHERE i.invoice_id = 'INV-005'
      AND p.payment_id = 'PAY-004';

### Expected SQL Result

- Query returns invoice `INV-005` and payment `PAY-004`.
- Payment status is `FAILED`.
- Invoice status remains `UNPAID`.

---

## TC-012: Activate Additional Service for Active Subscription

| Field        | Value                                               |
| ------------ | --------------------------------------------------- |
| Test Case ID | TC-012                                              |
| Title        | Activate additional service for active subscription |
| Requirement  | REQ-006                                             |
| Checklist ID | CHK-035                                             |
| Priority     | Medium                                              |
| Type         | Positive                                            |
| Status       | Not Run                                             |

### Preconditions

- Customer `CUST-005` exists and has status `ACTIVE`.
- Subscription `SUB-005` exists and has status `ACTIVE`.
- Additional service `SRV-001` exists and has status `ACTIVE`.

### Test Data

| Entity           | Value    |
| ---------------- | -------- |
| Customer         | CUST-005 |
| Subscription     | SUB-005  |
| Service          | SRV-001  |
| Customer Service | CSRV-001 |

### Steps

1. Activate additional service `SRV-001` for subscription `SUB-005`.
2. Check customer service record.
3. Verify service status and subscription status in the database.

### Expected Result

- Additional service is activated successfully.
- Customer service record is created.
- Customer service status is `ACTIVE`.
- Service is linked to active subscription.

### SQL Validation

    SELECT cs.customer_service_id, cs.subscription_id,
           s.status AS subscription_status,
           cs.service_id,
           ads.status AS service_status,
           cs.status AS customer_service_status
    FROM customer_services cs
    JOIN subscriptions s
        ON cs.subscription_id = s.subscription_id
    JOIN additional_services ads
        ON cs.service_id = ads.service_id
    WHERE cs.customer_service_id = 'CSRV-001';

### Expected SQL Result

- Query returns customer service `CSRV-001`.
- Subscription status is `ACTIVE`.
- Service status is `ACTIVE`.
- Customer service status is `ACTIVE`.

---

## TC-013: Activate Archived Additional Service

| Field        | Value                                |
| ------------ | ------------------------------------ |
| Test Case ID | TC-013                               |
| Title        | Activate archived additional service |
| Requirement  | REQ-006                              |
| Checklist ID | CHK-038                              |
| Priority     | High                                 |
| Type         | Negative                             |
| Status       | Not Run                              |

### Preconditions

- Subscription exists and has status `ACTIVE`.
- Additional service `SRV-003` exists and has status `ARCHIVED`.

### Test Data

| Entity       | Value   |
| ------------ | ------- |
| Subscription | SUB-005 |
| Service      | SRV-003 |

### Steps

1. Try to activate archived service `SRV-003` for active subscription `SUB-005`.
2. Save service activation.
3. Verify that service activation was not created.

### Expected Result

- Archived service is not activated.
- System returns validation error or rejects operation.
- No active customer service record exists for archived service.

### SQL Validation

    SELECT cs.customer_service_id, cs.service_id,
           ads.status AS service_status,
           cs.status AS customer_service_status
    FROM customer_services cs
    JOIN additional_services ads
        ON cs.service_id = ads.service_id
    WHERE ads.status = 'ARCHIVED'
      AND cs.status = 'ACTIVE';

### Expected SQL Result

- Query returns `0 rows`.

---

## TC-014: Create Support Ticket for Existing Customer

| Field        | Value                                       |
| ------------ | ------------------------------------------- |
| Test Case ID | TC-014                                      |
| Title        | Create support ticket for existing customer |
| Requirement  | REQ-007                                     |
| Checklist ID | CHK-041, CHK-044                            |
| Priority     | Medium                                      |
| Type         | Positive                                    |
| Status       | Not Run                                     |

### Preconditions

- Customer `CUST-001` exists.

### Test Data

| Entity   | Value                        |
| -------- | ---------------------------- |
| Customer | CUST-001                     |
| Ticket   | TCK-001                      |
| Subject  | Invoice amount clarification |

### Steps

1. Create support ticket for customer `CUST-001`.
2. Fill in subject and description.
3. Save ticket.
4. Verify ticket status.

### Expected Result

- Support ticket is created successfully.
- Ticket is linked to existing customer.
- Ticket status is `OPEN` by default.

### SQL Validation

    SELECT ticket_id, customer_id, subject, status
    FROM support_tickets
    WHERE ticket_id = 'TCK-001';

### Expected SQL Result

- Query returns ticket `TCK-001`.
- Ticket is linked to `CUST-001`.
- Ticket status is `OPEN`.

---

## TC-015: Validate Full Billing Flow for Customer

| Field        | Value                                                         |
| ------------ | ------------------------------------------------------------- |
| Test Case ID | TC-015                                                        |
| Title        | Validate full billing flow for customer                       |
| Requirement  | REQ-003, REQ-004, REQ-005, REQ-009                            |
| Checklist ID | CHK-046, CHK-047, CHK-048, CHK-049, CHK-050, CHK-052, CHK-053 |
| Priority     | Critical                                                      |
| Type         | End-to-End                                                    |
| Status       | Not Run                                                       |

### Preconditions

- Customer `CUST-001` exists.
- Subscription `SUB-001` exists.
- Invoice `INV-001` exists.
- Payment `PAY-001` exists.

### Test Data

| Entity       | Value    |
| ------------ | -------- |
| Customer     | CUST-001 |
| Subscription | SUB-001  |
| Tariff       | TAR-001  |
| Invoice      | INV-001  |
| Payment      | PAY-001  |

### Steps

1. Verify customer status.
2. Verify subscription status.
3. Verify tariff monthly fee.
4. Verify invoice amount and status.
5. Verify payment amount and status.
6. Verify full data chain using SQL.

### Expected Result

- Customer has status `ACTIVE`.
- Subscription has status `ACTIVE`.
- Invoice amount matches tariff monthly fee.
- Successful payment amount matches invoice amount.
- Invoice status is updated to `PAID` after successful payment.
- All related records are correctly linked.

### SQL Validation

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

### Expected SQL Result

- Query returns full billing chain for `CUST-001`.
- Customer status is `ACTIVE`.
- Subscription status is `ACTIVE`.
- Invoice amount equals tariff monthly fee.
- Payment amount equals invoice amount.
- Payment status is `SUCCESS`.
- Invoice status is `PAID`.

---

## TC-016: Validate Paid Invoice Has Successful Payment

| Field        | Value                                        |
| ------------ | -------------------------------------------- |
| Test Case ID | TC-016                                       |
| Title        | Validate paid invoice has successful payment |
| Requirement  | REQ-009                                      |
| Checklist ID | CHK-051                                      |
| Priority     | Critical                                     |
| Type         | Data Consistency                             |
| Status       | Not Run                                      |

### Preconditions

- Invoice data exists.
- Payment data exists.

### Test Data

| Entity  | Value   |
| ------- | ------- |
| Invoice | INV-002 |
| Payment | PAY-002 |

### Steps

1. Find invoices with status `PAID`.
2. Check whether each paid invoice has at least one successful payment.
3. Verify result using SQL.

### Expected Result

- Every paid invoice has at least one successful payment.
- No paid invoice exists without successful payment.

### SQL Validation

    SELECT i.invoice_id, i.status AS invoice_status, i.amount AS invoice_amount
    FROM invoices i
    LEFT JOIN payments p
        ON i.invoice_id = p.invoice_id
        AND p.status = 'SUCCESS'
    WHERE i.status = 'PAID'
      AND p.payment_id IS NULL;

### Expected SQL Result

- Query returns `0 rows`.

---

## TC-017: Validate No Invoice Exists for Non-Active Subscription

| Field        | Value                                                  |
| ------------ | ------------------------------------------------------ |
| Test Case ID | TC-017                                                 |
| Title        | Validate no invoice exists for non-active subscription |
| Requirement  | REQ-004, REQ-009                                       |
| Checklist ID | CHK-024, CHK-025                                       |
| Priority     | Critical                                               |
| Type         | Data Consistency                                       |
| Status       | Not Run                                                |

### Preconditions

- Subscription data exists.
- Invoice data exists.

### Test Data

| Entity                 | Value            |
| ---------------------- | ---------------- |
| Suspended Subscription | SUB-002          |
| Cancelled Subscription | SUB-003          |
| Invoice Candidates     | INV-003, INV-004 |

### Steps

1. Find invoices linked to suspended subscriptions.
2. Find invoices linked to cancelled subscriptions.
3. Verify result using SQL.

### Expected Result

- No invoice exists for suspended subscription.
- No invoice exists for cancelled subscription.

### SQL Validation

    SELECT i.invoice_id, i.customer_id, i.subscription_id,
           s.status AS subscription_status,
           i.amount,
           i.status AS invoice_status
    FROM invoices i
    JOIN subscriptions s
        ON i.subscription_id = s.subscription_id
    WHERE s.status IN ('SUSPENDED', 'CANCELLED');

### Expected SQL Result

- Query returns `0 rows`.

---

## TC-018: Regression Check After Tariff Price Change

| Field        | Value                                      |
| ------------ | ------------------------------------------ |
| Test Case ID | TC-018                                     |
| Title        | Regression check after tariff price change |
| Requirement  | REQ-008                                    |
| Checklist ID | CHK-056, CHK-059, CHK-060                  |
| Priority     | Critical                                   |
| Type         | Regression                                 |
| Status       | Not Run                                    |

### Preconditions

- Tariff plan data exists.
- Invoice data exists.
- Payment data exists.
- Billing logic was changed or tariff price was updated.

### Test Data

| Entity       | Value    |
| ------------ | -------- |
| Customer     | CUST-004 |
| Tariff Plan  | TAR-002  |
| Subscription | SUB-004  |
| Invoice      | INV-002  |
| Payment      | PAY-002  |

### Steps

1. Check tariff monthly fee.
2. Check invoice amount.
3. Check invoice status.
4. Check successful payment.
5. Verify that already paid invoice remains `PAID`.
6. Verify that invoice amount still matches tariff monthly fee.

### Expected Result

- Existing paid invoice remains `PAID`.
- Invoice amount matches tariff monthly fee.
- Payment remains linked to invoice.
- No duplicate payment is created.
- No data inconsistency is found after regression change.

### SQL Validation

    SELECT i.invoice_id, i.customer_id, i.subscription_id,
           i.amount AS invoice_amount,
           i.status AS invoice_status,
           t.monthly_fee,
           p.payment_id,
           p.status AS payment_status
    FROM invoices i
    JOIN subscriptions s
        ON i.subscription_id = s.subscription_id
    JOIN tariff_plans t
        ON s.tariff_id = t.tariff_id
    LEFT JOIN payments p
        ON i.invoice_id = p.invoice_id
    WHERE i.invoice_id = 'INV-002';

### Expected SQL Result

- Invoice `INV-002` exists.
- Invoice status is `PAID`.
- Invoice amount equals tariff monthly fee.
- Successful payment exists.
- No duplicate successful payment exists.

---

## Execution Notes

- Test cases with `Critical` priority should be executed first.
- SQL validation should be used as evidence for data-related checks.
- Failed test cases should be documented in `07_Bug_Reports.md`.
- Unclear expected behavior should be documented in `12_Questions_to_BA_and_Dev.md`.
- Regression-related scenarios should be reused in `09_Regression_Checklist.md`.

---

## Coverage Summary

| Area                    | Covered By                     |
| ----------------------- | ------------------------------ |
| Customer creation       | TC-001, TC-002                 |
| Tariff plan assignment  | TC-003, TC-004                 |
| Subscription activation | TC-003                         |
| Invoice generation      | TC-005, TC-006, TC-007, TC-017 |
| Payment processing      | TC-008, TC-009, TC-010, TC-011 |
| Additional services     | TC-012, TC-013                 |
| Support tickets         | TC-014                         |
| End-to-end billing flow | TC-015                         |
| SQL data consistency    | TC-016, TC-017                 |
| Regression testing      | TC-018                         |
