-- ============================================================
-- Telecom QA Manual + SQL Project
-- Test Data
-- ============================================================

-- This file contains test data for validating telecom billing flows.
-- The data includes positive, negative and regression test scenarios.

-- ============================================================
-- Customers
-- ============================================================

INSERT INTO customers (
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    status,
    created_at
)
VALUES
    ('CUST-001', 'John', 'Smith', 'john.smith@test.com', '+77010000001', 'ACTIVE', '2026-04-01'),
    ('CUST-002', 'Anna', 'Brown', 'anna.brown@test.com', '+77010000002', 'SUSPENDED', '2026-04-01'),
    ('CUST-003', 'Mark', 'Wilson', 'mark.wilson@test.com', '+77010000003', 'DEACTIVATED', '2026-03-15'),
    ('CUST-004', 'Sara', 'Miller', 'sara.miller@test.com', '+77010000004', 'ACTIVE', '2026-04-10'),
    ('CUST-005', 'David', 'Clark', 'david.clark@test.com', '+77010000005', 'ACTIVE', '2026-04-15');

-- ============================================================
-- Tariff Plans
-- ============================================================

INSERT INTO tariff_plans (
    tariff_id,
    tariff_name,
    monthly_fee,
    included_minutes,
    included_sms,
    internet_gb,
    status
)
VALUES
    ('TAR-001', 'Basic Mobile', 5000.00, 100, 50, 10, 'ACTIVE'),
    ('TAR-002', 'Standard Mobile', 8000.00, 300, 100, 30, 'ACTIVE'),
    ('TAR-003', 'Premium Mobile', 12000.00, 1000, 300, 100, 'ACTIVE'),
    ('TAR-004', 'Archived Start', 3000.00, 50, 20, 5, 'ARCHIVED');

-- ============================================================
-- Subscriptions
-- ============================================================

INSERT INTO subscriptions (
    subscription_id,
    customer_id,
    tariff_id,
    status,
    start_date,
    end_date
)
VALUES
    ('SUB-001', 'CUST-001', 'TAR-001', 'ACTIVE', '2026-04-01', NULL),
    ('SUB-002', 'CUST-002', 'TAR-002', 'SUSPENDED', '2026-04-01', NULL),
    ('SUB-003', 'CUST-003', 'TAR-001', 'CANCELLED', '2026-03-15', '2026-04-10'),
    ('SUB-004', 'CUST-004', 'TAR-002', 'ACTIVE', '2026-04-10', NULL),
    ('SUB-005', 'CUST-005', 'TAR-003', 'ACTIVE', '2026-04-15', NULL);

-- ============================================================
-- Invoices
-- ============================================================

INSERT INTO invoices (
    invoice_id,
    customer_id,
    subscription_id,
    amount,
    status,
    invoice_date
)
VALUES
    -- Positive payment flow: active subscription, unpaid invoice
    ('INV-001', 'CUST-001', 'SUB-001', 5000.00, 'UNPAID', '2026-04-25'),

    -- Regression flow: already paid invoice
    ('INV-002', 'CUST-004', 'SUB-004', 8000.00, 'PAID', '2026-04-25'),

    -- Data issue candidate: invoice should not exist for suspended subscription
    ('INV-003', 'CUST-002', 'SUB-002', 8000.00, 'UNPAID', '2026-04-25'),

    -- Data issue candidate: invoice should not exist for cancelled subscription
    ('INV-004', 'CUST-003', 'SUB-003', 5000.00, 'UNPAID', '2026-04-25'),

    -- Additional service billing flow
    ('INV-005', 'CUST-005', 'SUB-005', 12000.00, 'UNPAID', '2026-04-25');

-- ============================================================
-- Payments
-- ============================================================

INSERT INTO payments (
    payment_id,
    invoice_id,
    amount,
    status,
    payment_date
)
VALUES
    -- Positive payment flow
    ('PAY-001', 'INV-001', 5000.00, 'SUCCESS', '2026-04-26'),

    -- Already paid invoice validation
    ('PAY-002', 'INV-002', 8000.00, 'SUCCESS', '2026-04-26'),

    -- Data issue candidate: payment amount does not match invoice amount
    ('PAY-003', 'INV-005', 10000.00, 'SUCCESS', '2026-04-26'),

    -- Failed payment should not close invoice
    ('PAY-004', 'INV-005', 12000.00, 'FAILED', '2026-04-26');

-- ============================================================
-- Additional Services
-- ============================================================

INSERT INTO additional_services (
    service_id,
    service_name,
    price,
    status
)
VALUES
    ('SRV-001', 'Extra Internet 10GB', 1500.00, 'ACTIVE'),
    ('SRV-002', 'International Calls', 2500.00, 'ACTIVE'),
    ('SRV-003', 'Legacy Roaming', 3000.00, 'ARCHIVED');

-- ============================================================
-- Customer Services
-- ============================================================

INSERT INTO customer_services (
    customer_service_id,
    customer_id,
    subscription_id,
    service_id,
    activation_date,
    status
)
VALUES
    -- Positive additional service flow
    ('CSRV-001', 'CUST-005', 'SUB-005', 'SRV-001', '2026-04-20', 'ACTIVE'),

    -- Second active service for additional billing validation
    ('CSRV-002', 'CUST-005', 'SUB-005', 'SRV-002', '2026-04-21', 'ACTIVE');

-- ============================================================
-- Support Tickets
-- ============================================================

INSERT INTO support_tickets (
    ticket_id,
    customer_id,
    subject,
    description,
    status,
    created_at
)
VALUES
    ('TCK-001', 'CUST-001', 'Invoice amount clarification', 'Customer asks why the invoice amount is 5000.', 'OPEN', '2026-04-26'),
    ('TCK-002', 'CUST-002', 'Service unavailable', 'Suspended customer reports unavailable service.', 'IN_PROGRESS', '2026-04-26'),
    ('TCK-003', 'CUST-004', 'Payment confirmation request', 'Customer asks to confirm successful payment.', 'RESOLVED', '2026-04-26');