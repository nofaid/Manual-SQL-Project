DROP TABLE IF EXISTS customer_services;
DROP TABLE IF EXISTS support_tickets;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS additional_services;
DROP TABLE IF EXISTS tariff_plans;
DROP TABLE IF EXISTS customers;

-- Customers

CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(30) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('ACTIVE', 'SUSPENDED', 'DEACTIVATED')),
    created_at DATE NOT NULL
);

-- Tariff Plans

CREATE TABLE tariff_plans (
    tariff_id VARCHAR(20) PRIMARY KEY,
    tariff_name VARCHAR(100) NOT NULL UNIQUE,
    monthly_fee DECIMAL(10, 2) NOT NULL CHECK (monthly_fee > 0),
    included_minutes INTEGER NOT NULL CHECK (included_minutes >= 0),
    included_sms INTEGER NOT NULL CHECK (included_sms >= 0),
    internet_gb INTEGER NOT NULL CHECK (internet_gb >= 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('ACTIVE', 'ARCHIVED'))
);

-- Subscriptions

CREATE TABLE subscriptions (
    subscription_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    tariff_id VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('ACTIVE', 'SUSPENDED', 'CANCELLED')),
    start_date DATE NOT NULL,
    end_date DATE,

    CONSTRAINT fk_subscription_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_subscription_tariff
        FOREIGN KEY (tariff_id)
        REFERENCES tariff_plans(tariff_id)
);

-- Invoices

CREATE TABLE invoices (
    invoice_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    subscription_id VARCHAR(20) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('UNPAID', 'PAID', 'CANCELLED')),
    invoice_date DATE NOT NULL,

    CONSTRAINT fk_invoice_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_invoice_subscription
        FOREIGN KEY (subscription_id)
        REFERENCES subscriptions(subscription_id)
);

-- Payments

CREATE TABLE payments (
    payment_id VARCHAR(20) PRIMARY KEY,
    invoice_id VARCHAR(20) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('SUCCESS', 'FAILED', 'REFUNDED')),
    payment_date DATE NOT NULL,

    CONSTRAINT fk_payment_invoice
        FOREIGN KEY (invoice_id)
        REFERENCES invoices(invoice_id)
);

-- Additional Services

CREATE TABLE additional_services (
    service_id VARCHAR(20) PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('ACTIVE', 'ARCHIVED'))
);

-- Customer Services

CREATE TABLE customer_services (
    customer_service_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    subscription_id VARCHAR(20) NOT NULL,
    service_id VARCHAR(20) NOT NULL,
    activation_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('ACTIVE', 'CANCELLED')),

    CONSTRAINT fk_customer_service_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_customer_service_subscription
        FOREIGN KEY (subscription_id)
        REFERENCES subscriptions(subscription_id),

    CONSTRAINT fk_customer_service_service
        FOREIGN KEY (service_id)
        REFERENCES additional_services(service_id)
);

-- Support Tickets

CREATE TABLE support_tickets (
    ticket_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')),
    created_at DATE NOT NULL,

    CONSTRAINT fk_ticket_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);