# 02. Requirements

## REQ-001: Customer Creation

The system shall allow creating a customer profile.

### Required Customer Fields

- first name;
- last name;
- email;
- phone number;
- customer status.

### Acceptance Criteria

- Customer must have a unique email.
- Customer cannot be created without email.
- Customer cannot be created without phone number.
- Customer status must be one of the following:
  - ACTIVE;
  - SUSPENDED;
  - DEACTIVATED.
- New customer status is `ACTIVE` by default.

---

## REQ-002: Tariff Plan Management

The system shall store available tariff plans.

### Tariff Plan Fields

- tariff plan name;
- monthly fee;
- included minutes;
- included SMS;
- included internet traffic;
- tariff status.

### Acceptance Criteria

- Tariff plan must have a unique name.
- Monthly fee must be greater than 0.
- Tariff status must be one of the following:
  - ACTIVE;
  - ARCHIVED.
- Only `ACTIVE` tariff plans can be assigned to customers.

---

## REQ-003: Subscription Activation

The system shall allow assigning an active tariff plan to an active customer.

### Acceptance Criteria

- Only `ACTIVE` customers can receive a new subscription.
- Only `ACTIVE` tariff plans can be assigned.
- Subscription must be linked to one customer.
- Subscription must be linked to one tariff plan.
- New subscription status must be `ACTIVE`.
- Subscription status must be one of the following:
  - ACTIVE;
  - SUSPENDED;
  - CANCELLED.
- A `DEACTIVATED` customer cannot receive a new subscription.

---

## REQ-004: Invoice Generation

The system shall generate invoices for active subscriptions.

### Acceptance Criteria

- Invoice must be linked to an existing customer.
- Invoice must be linked to an active subscription.
- Invoice amount must match the tariff plan monthly fee.
- New invoice status must be `UNPAID`.
- Invoice cannot be generated for `CANCELLED` subscriptions.
- Invoice cannot be generated for `SUSPENDED` subscriptions.
- Invoice status must be one of the following:
  - UNPAID;
  - PAID;
  - CANCELLED.

---

## REQ-005: Payment Processing

The system shall allow registering a payment for an unpaid invoice.

### Acceptance Criteria

- Payment must be linked to an existing invoice.
- Payment amount must match invoice amount.
- Payment cannot be registered for already `PAID` invoices.
- Payment cannot be registered for `CANCELLED` invoices.
- After successful payment, invoice status must become `PAID`.
- Payment status must be one of the following:
  - SUCCESS;
  - FAILED;
  - REFUNDED.

---

## REQ-006: Additional Service Activation

The system shall allow activating additional paid services for customers with active subscriptions.

### Acceptance Criteria

- Additional service can be activated only for `ACTIVE` subscriptions.
- Additional service must have a name and price.
- Service price must be greater than 0.
- Service cannot be activated for `CANCELLED` subscriptions.
- Service cannot be activated for `SUSPENDED` subscriptions.
- Activated service price must be included in the next invoice.

---

## REQ-007: Support Ticket Creation

The system shall allow creating support tickets for customers.

### Acceptance Criteria

- Support ticket must be linked to an existing customer.
- Ticket must have a subject and description.
- Ticket status must be one of the following:
  - OPEN;
  - IN_PROGRESS;
  - RESOLVED;
  - CLOSED.
- New ticket status must be `OPEN` by default.

---

## REQ-008: Regression Requirement

After any change in tariff price, invoice calculation or payment processing logic, regression testing must cover the following areas:

- customer creation;
- tariff plan assignment;
- subscription activation;
- invoice generation;
- payment processing;
- invoice status update;
- SQL data consistency between customers, subscriptions, invoices and payments.

---

## REQ-009: Data Consistency Requirement

The system data must remain consistent across related billing entities.

### Acceptance Criteria

- Every subscription must be linked to an existing customer.
- Every subscription must be linked to an existing tariff plan.
- Every invoice must be linked to an existing customer.
- Every invoice must be linked to an existing subscription.
- Every payment must be linked to an existing invoice.
- Paid invoice must have at least one successful payment.
- Payment amount must match invoice amount.
