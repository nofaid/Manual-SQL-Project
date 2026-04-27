# 12. Questions to BA and Dev

## Question Status Legend

| Status                      | Meaning                                 |
| --------------------------- | --------------------------------------- |
| Open                        | Question is waiting for answer          |
| Answered                    | Answer was received                     |
| Needs Discussion            | Requires meeting or additional analysis |
| Closed                      | Question is resolved                    |
| Converted to Bug            | Question resulted in confirmed defect   |
| Converted to Change Request | Question resulted in change request     |

---

## Q-001: Should Suspended Subscriptions Receive New Invoices?

| Field                  | Value              |
| ---------------------- | ------------------ |
| Question ID            | Q-001              |
| Target Role            | BA / Product Owner |
| Related Requirement    | REQ-004            |
| Related Bug            | BUG-001            |
| Related Change Request | CR-003             |
| Priority               | High               |
| Status                 | Open               |

### Question

Should the system generate new invoices for subscriptions with status `SUSPENDED`?

### Context

Requirement `REQ-004` says that invoice cannot be generated for `SUSPENDED` subscriptions.

However, suspended billing behavior can be complex in telecom systems.

A customer can be suspended because of:

- unpaid invoice;
- fraud check;
- manual support action;
- technical issue;
- contract limitation.

### Why Clarification Is Needed

QA needs to understand whether suspension always stops billing or only stops service access.

### Impact

Without clarification, QA may validate suspended customer billing incorrectly.

### Proposed Expected Behavior

To be confirmed by BA/Product Owner.

Possible expected behavior:

- new invoices are not generated for suspended subscriptions;
- existing unpaid invoices remain payable;
- billing resumes after subscription becomes active again.

---

## Q-002: Should Existing Unpaid Invoices Remain Payable After Subscription Suspension?

| Field               | Value              |
| ------------------- | ------------------ |
| Question ID         | Q-002              |
| Target Role         | BA / Product Owner |
| Related Requirement | REQ-004, REQ-005   |
| Priority            | High               |
| Status              | Open               |

### Question

If a subscription becomes `SUSPENDED`, should previously generated unpaid invoices remain payable?

### Context

Invoice generation and payment processing are separate flows.

A suspended subscription may already have unpaid invoices.

### Why Clarification Is Needed

QA needs to verify payment behavior for suspended customers.

### Impact

This affects:

- payment processing;
- invoice visibility;
- customer balance;
- support scenarios;
- regression testing.

### Proposed Expected Behavior

Previously generated unpaid invoices should remain payable unless business rules say otherwise.

---

## Q-003: Should Partial Payments Be Supported?

| Field                  | Value              |
| ---------------------- | ------------------ |
| Question ID            | Q-003              |
| Target Role            | BA / Product Owner |
| Related Requirement    | REQ-005            |
| Related Change Request | CR-001             |
| Priority               | Medium             |
| Status                 | Open               |

### Question

Should the system support partial payments for invoices?

### Context

Current requirement says that payment amount must match invoice amount.

During testing, payment amount mismatch was identified as a defect candidate.

### Why Clarification Is Needed

If partial payments are planned, payment amount lower than invoice amount may not always be invalid.

### Impact

This affects:

- payment validation;
- invoice status;
- SQL checks;
- test cases;
- regression scenarios.

### Proposed Expected Behavior

If partial payments are not supported:

- payment amount must match invoice amount;
- mismatched payments should be rejected.

If partial payments are supported:

- invoice should receive status `PARTIALLY_PAID`;
- invoice becomes `PAID` only when total successful payments equal invoice amount.

---

## Q-004: What Should Happen If Payment Amount Is Higher Than Invoice Amount?

| Field                  | Value              |
| ---------------------- | ------------------ |
| Question ID            | Q-004              |
| Target Role            | BA / Product Owner |
| Related Requirement    | REQ-005            |
| Related Change Request | CR-004             |
| Priority               | Medium             |
| Status                 | Open               |

### Question

What should happen if payment amount is higher than invoice amount?

### Context

Current requirements mention that payment amount must match invoice amount, but do not describe overpayment behavior.

### Why Clarification Is Needed

QA needs to design negative and boundary test cases for payment amount validation.

### Impact

This affects:

- payment validation;
- customer balance;
- refund logic;
- financial reporting.

### Possible Expected Behavior

One of the following rules should be confirmed:

- overpayment is rejected;
- overpayment is accepted and stored as customer balance;
- overpayment requires manual review;
- overpayment triggers refund logic.

---

## Q-005: Should Invoice Status History Be Stored?

| Field                  | Value                    |
| ---------------------- | ------------------------ |
| Question ID            | Q-005                    |
| Target Role            | BA / Dev / Product Owner |
| Related Requirement    | REQ-004, REQ-005         |
| Related Change Request | CR-002                   |
| Priority               | Medium                   |
| Status                 | Open                     |

### Question

Should the system store invoice status history?

### Context

During testing, invoice status transition from `UNPAID` to `PAID` is critical.

Without status history, it may be difficult to investigate billing issues.

### Why Clarification Is Needed

QA and support may need to know:

- when invoice status changed;
- what changed it;
- whether change was triggered by payment, user action or background job.

### Impact

This affects:

- bug investigation;
- auditability;
- support troubleshooting;
- SQL validation;
- reporting.

### Proposed Expected Behavior

The system should store invoice status history with:

- old status;
- new status;
- change date/time;
- change source;
- change reason.

---

## Q-006: What Is the Source of Invoice Generation?

| Field               | Value    |
| ------------------- | -------- |
| Question ID         | Q-006    |
| Target Role         | Dev / BA |
| Related Requirement | REQ-004  |
| Priority            | Medium   |
| Status              | Open     |

### Question

Are invoices generated manually, by scheduled billing job, by API request, or by another service?

### Context

Invoice generation source affects testing approach.

### Why Clarification Is Needed

QA needs to know how to reproduce invoice generation and where to check failures.

### Impact

This affects:

- test execution steps;
- SQL validation;
- logging checks;
- daily billing job report;
- defect investigation.

### Possible Answers

- manual generation from UI;
- scheduled billing job;
- API endpoint;
- background service;
- external integration.

---

## Q-007: Are Failed Payments Stored in the Database?

| Field               | Value    |
| ------------------- | -------- |
| Question ID         | Q-007    |
| Target Role         | BA / Dev |
| Related Requirement | REQ-005  |
| Priority            | Medium   |
| Status              | Open     |

### Question

Should failed payments be stored in the database?

### Context

Test data includes failed payment `PAY-004`.

### Why Clarification Is Needed

Some systems store failed payment attempts for audit and support purposes. Other systems may store only successful payments.

### Impact

This affects:

- payment history;
- SQL checks;
- customer support;
- audit trail;
- test case expectations.

### Proposed Expected Behavior

Failed payment attempts may be stored, but they must not change invoice status to `PAID`.

---

## Q-008: Should Support Tickets Be Allowed for Deactivated Customers?

| Field               | Value              |
| ------------------- | ------------------ |
| Question ID         | Q-008              |
| Target Role         | BA / Product Owner |
| Related Requirement | REQ-007            |
| Priority            | Low                |
| Status              | Open               |

### Question

Should support tickets be allowed for customers with status `DEACTIVATED`?

### Context

Requirement says that support ticket must be linked to existing customer, but does not mention customer status restrictions.

### Why Clarification Is Needed

QA needs to design support ticket negative scenarios.

### Impact

This affects:

- support module testing;
- customer lifecycle rules;
- ticket visibility;
- access permissions.

### Possible Expected Behavior

One of the following rules should be confirmed:

- deactivated customers can create support tickets;
- deactivated customers cannot create support tickets;
- only internal support agents can create tickets for deactivated customers.

---

## Q-009: Should Archived Tariff Plans Remain Visible for Existing Subscriptions?

| Field               | Value              |
| ------------------- | ------------------ |
| Question ID         | Q-009              |
| Target Role         | BA / Product Owner |
| Related Requirement | REQ-002, REQ-003   |
| Priority            | Medium             |
| Status              | Open               |

### Question

If a tariff plan becomes `ARCHIVED`, should it remain visible for existing subscriptions that were created before archival?

### Context

Requirement says only `ACTIVE` tariff plans can be assigned to customers.

However, existing subscriptions may still use tariffs that later become archived.

### Why Clarification Is Needed

QA needs to distinguish between:

- assigning archived tariff to new customer;
- keeping archived tariff for existing customer.

### Impact

This affects:

- subscription management;
- tariff lifecycle;
- invoice calculation;
- regression testing.

### Proposed Expected Behavior

Archived tariff plans should not be assigned to new subscriptions, but may remain linked to existing subscriptions depending on business rules.

---

## Q-010: What Should Be Included in Daily Billing Job Report?

| Field                  | Value              |
| ---------------------- | ------------------ |
| Question ID            | Q-010              |
| Target Role            | BA / Dev / QA Lead |
| Related Change Request | CR-005             |
| Priority               | Medium             |
| Status                 | Open               |

### Question

What information should be included in daily billing job execution report?

### Context

A billing job report would help QA and support analyze invoice generation results.

### Why Clarification Is Needed

QA needs clear acceptance criteria if this report is implemented.

### Suggested Report Fields

- execution date/time;
- total processed subscriptions;
- generated invoice count;
- skipped subscription count;
- failed record count;
- failure reasons;
- job status;
- execution duration.

### Impact

This affects:

- reporting test cases;
- SQL validation;
- operations monitoring;
- support investigation.

---

## Questions Summary

| Question ID | Topic                                       | Target Role              | Priority | Status |
| ----------- | ------------------------------------------- | ------------------------ | -------- | ------ |
| Q-001       | Suspended subscriptions and invoices        | BA / Product Owner       | High     | Open   |
| Q-002       | Existing unpaid invoices after suspension   | BA / Product Owner       | High     | Open   |
| Q-003       | Partial payment support                     | BA / Product Owner       | Medium   | Open   |
| Q-004       | Overpayment behavior                        | BA / Product Owner       | Medium   | Open   |
| Q-005       | Invoice status history                      | BA / Dev / Product Owner | Medium   | Open   |
| Q-006       | Invoice generation source                   | Dev / BA                 | Medium   | Open   |
| Q-007       | Failed payment storage                      | BA / Dev                 | Medium   | Open   |
| Q-008       | Support tickets for deactivated customers   | BA / Product Owner       | Low      | Open   |
| Q-009       | Archived tariffs for existing subscriptions | BA / Product Owner       | Medium   | Open   |
| Q-010       | Daily billing job report fields             | BA / Dev / QA Lead       | Medium   | Open   |

---

## QA Summary

The main clarification areas are:

1. Billing behavior for suspended subscriptions.
2. Payment amount validation and partial payment support.
3. Invoice status history and auditability.
4. Invoice generation source.
5. Archived tariff plan lifecycle.

These questions should be discussed with BA, Dev and QA Lead before finalizing related test cases and regression coverage.

---

## QA Notes

- QA should not guess unclear business rules.
- Unclear behavior should be documented and escalated.
- Clarification results should update requirements, test cases and regression checklist.
- Some questions may become change requests.
- Some questions may confirm existing defects.
