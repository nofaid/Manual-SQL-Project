-- CHECK-001: Show all active customers
-- Purpose:
-- Verify that active customers exist and can be used for positive test scenarios.

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    status
FROM customers
WHERE status = 'ACTIVE';

-- CHECK-002: Show active subscriptions with customer and tariff data
-- Purpose:
-- Verify that active subscriptions are linked to active customers
-- and active tariff plans.

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

-- CHECK-003: Find invoices created for non-active subscriptions
-- Requirement:
-- Invoice cannot be generated for SUSPENDED or CANCELLED subscriptions.
--
-- Expected result:
-- Query should return 0 rows.
--
-- If rows are returned, this is a defect candidate.

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

-- CHECK-004: Find invoices where amount does not match tariff monthly fee
-- Requirement:
-- Invoice amount must match the tariff plan monthly fee.
--
-- Expected result:
-- Query should return 0 rows.
--
-- If rows are returned, invoice calculation may be incorrect.

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

-- CHECK-005: Find successful payments where payment amount
-- does not match invoice amount
--
-- Requirement:
-- Payment amount must match invoice amount.
--
-- Expected result:
-- Query should return 0 rows.
--
-- If rows are returned, this is a billing data defect candidate.

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

-- CHECK-006: Find unpaid invoices with successful full payment
--
-- Requirement:
-- After successful payment, invoice status must become PAID.
--
-- Expected result:
-- Query should return 0 rows.
--
-- If rows are returned, invoice status was not updated correctly.

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

-- CHECK-007: Find paid invoices without successful payment
--
-- Requirement:
-- Paid invoice must have at least one successful payment.
--
-- Expected result:
-- Query should return 0 rows.
--
-- If rows are returned, invoice status may be incorrect.

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

-- CHECK-008: Find duplicate successful payments for the same invoice
--
-- Requirement:
-- Payment cannot be registered for an already PAID invoice.
--
-- Expected result:
-- Query should return 0 rows.
--
-- If rows are returned, duplicate payment processing may be allowed.

SELECT
    invoice_id,
    COUNT(*) AS successful_payment_count
FROM payments
WHERE status = 'SUCCESS'
GROUP BY invoice_id
HAVING COUNT(*) > 1;

-- CHECK-009: Show full billing flow for a specific customer
--
-- Purpose:
-- Verify customer -> subscription -> tariff -> invoice -> payment chain.

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

-- CHECK-010: Find active additional services linked to non-active subscriptions
--
-- Requirement:
-- Additional service can be activated only for ACTIVE subscriptions.
--
-- Expected result:
-- Query should return 0 rows.
--
-- If rows are returned, additional service activation rules are violated.

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

-- CHECK-011: Find active customer services linked to archived services
--
-- Requirement:
-- Archived services cannot be activated.
--
-- Expected result:
-- Query should return 0 rows.

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

-- CHECK-012: Show support tickets with customer status
--
-- Purpose:
-- Verify support tickets and customer relationship.
-- Useful for support-related QA scenarios.

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

-- CHECK-013: Find customers without subscriptions
--
-- Purpose:
-- Identify customers who do not have any subscription.
--
-- This may be valid in some systems, but should be reviewed
-- depending on business requirements.

SELECT
    c.customer_id,
    c.email,
    c.status
FROM customers c
LEFT JOIN subscriptions s
    ON c.customer_id = s.customer_id
WHERE s.subscription_id IS NULL;

-- CHECK-014: Find subscriptions linked to archived tariff plans
--
-- Requirement:
-- Only ACTIVE tariff plans can be assigned to customers.
--
-- Expected result:
-- Query should return 0 rows.

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

-- CHECK-015: Regression check for paid invoice stability

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