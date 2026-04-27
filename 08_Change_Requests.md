# 08. Change Requests

## Document Purpose

This document contains Jira-style change request examples for the telecom billing system.

The goal is to demonstrate understanding of Change Management and the difference between:

- bug;
- change request;
- requirement clarification;
- improvement.

Change requests are based on possible business needs discovered during QA analysis.

---

## Difference Between Bug and Change Request

| Type           | Meaning                                                 | Example                                           |
| -------------- | ------------------------------------------------------- | ------------------------------------------------- |
| Bug            | System does not work according to existing requirements | Invoice remains `UNPAID` after successful payment |
| Change Request | Business wants to change or extend current behavior     | Add partial payment support                       |
| Clarification  | Expected behavior is unclear                            | Should suspended customers receive invoices?      |
| Improvement    | Current behavior works, but can be improved             | Add clearer invoice status history                |

---

## CR-001: Add Partial Payment Support

| Field               | Value                        |
| ------------------- | ---------------------------- |
| Change Request ID   | CR-001                       |
| Type                | Change Request               |
| Status              | Open                         |
| Priority            | Medium                       |
| Module              | Billing / Payment Processing |
| Related Requirement | REQ-005                      |
| Related Bug         | BUG-002                      |
| Requested By        | Business / Product Owner     |
| QA Impact           | High                         |

### Summary

Add support for partial payments for invoices.

### Current Behavior

According to current requirements, payment amount must match invoice amount.

If invoice amount is `12000`, payment amount must also be `12000`.

### Requested Change

Allow customers to pay invoice amount partially.

Example:

- invoice amount: `12000`;
- first payment: `5000`;
- second payment: `7000`;
- invoice becomes `PAID` only when total successful payments equal invoice amount.

### Business Reason

Partial payments may be useful for customers who cannot pay the full amount at once.

This feature may improve customer experience and reduce payment delays.

### Proposed Acceptance Criteria

- Invoice can receive multiple successful payments.
- Total successful payment amount can be less than invoice amount.
- If total successful payment amount is less than invoice amount, invoice status should be `PARTIALLY_PAID`.
- If total successful payment amount equals invoice amount, invoice status should become `PAID`.
- If total successful payment amount exceeds invoice amount, system should reject the last payment or require business clarification.
- Failed payments should not affect paid amount.

### QA Impact

QA should update or add:

- requirements;
- test data;
- SQL checks;
- test cases;
- regression checklist;
- bug validation logic.

### Suggested New Status

Add new invoice status:

- `PARTIALLY_PAID`

### Suggested SQL Validation

    SELECT
        i.invoice_id,
        i.amount AS invoice_amount,
        SUM(p.amount) AS total_successful_payment_amount,
        i.status AS invoice_status
    FROM invoices i
    JOIN payments p
        ON i.invoice_id = p.invoice_id
    WHERE p.status = 'SUCCESS'
    GROUP BY i.invoice_id, i.amount, i.status;

### QA Comment

This is not a bug under current requirements.

This is a business logic extension and should be handled as a change request.

---

## CR-002: Add Invoice Status History

| Field               | Value                        |
| ------------------- | ---------------------------- |
| Change Request ID   | CR-002                       |
| Type                | Change Request               |
| Status              | Open                         |
| Priority            | Medium                       |
| Module              | Billing / Invoice Management |
| Related Requirement | REQ-004, REQ-005             |
| Related Bug         | BUG-003                      |
| Requested By        | QA / Support                 |
| QA Impact           | Medium                       |

### Summary

Add invoice status history to track status changes.

### Current Behavior

The system stores only the current invoice status.

Example:

- invoice status: `UNPAID`;
- invoice status changes to `PAID`;
- previous status is not visible.

### Requested Change

Add status history for invoices.

The system should store:

- previous status;
- new status;
- change date;
- change reason;
- user or system action that changed the status.

### Business Reason

Invoice status history helps with:

- defect investigation;
- customer support;
- financial audit;
- payment issue analysis;
- QA validation.

### Proposed Acceptance Criteria

- Every invoice status change is logged.
- Status history contains previous status and new status.
- Status history contains change date/time.
- Status history contains change source: user/system/API/job.
- QA can verify status history through UI or database.
- Status history cannot be manually deleted by regular users.

### QA Impact

QA should add checks for:

- invoice status transition from `UNPAID` to `PAID`;
- status history after successful payment;
- status history after invoice cancellation;
- SQL validation of status history records;
- regression testing of invoice status logic.

### Suggested New Table

Possible table:

- `invoice_status_history`

Suggested fields:

- `history_id`;
- `invoice_id`;
- `old_status`;
- `new_status`;
- `changed_at`;
- `change_source`;
- `change_reason`.

### QA Comment

This change would make billing defects easier to investigate and would improve auditability.

---

## CR-003: Add Clear Business Rule for Suspended Customers

| Field               | Value                                      |
| ------------------- | ------------------------------------------ |
| Change Request ID   | CR-003                                     |
| Type                | Requirement Clarification / Change Request |
| Status              | Open                                       |
| Priority            | High                                       |
| Module              | Billing / Invoice Generation               |
| Related Requirement | REQ-004                                    |
| Related Bug         | BUG-001                                    |
| Requested By        | QA                                         |
| QA Impact           | High                                       |

### Summary

Clarify whether suspended customers should receive invoices.

### Current Behavior

Requirement `REQ-004` says that invoice cannot be generated for `SUSPENDED` subscriptions.

However, business behavior for suspended customers may require clarification.

### Requested Clarification

Clarify the expected behavior for suspended customers and suspended subscriptions.

Questions:

1. Should suspended customers receive invoices for the current billing period?
2. Should invoice generation stop immediately after suspension?
3. Should suspension date affect invoice amount?
4. Should previously generated unpaid invoices remain payable?
5. Should suspended subscription be reactivated after payment?

### Business Reason

Suspension rules may be complex in telecom systems.

A customer may be suspended because of:

- unpaid invoice;
- fraud check;
- manual support action;
- technical issue;
- contract limitation.

Different reasons may require different billing behavior.

### Proposed Acceptance Criteria

To be confirmed by BA/Product Owner.

Possible rules:

- invoices are not generated for suspended subscriptions;
- existing unpaid invoices remain visible and payable;
- new invoices are generated only after subscription becomes active again;
- suspension reason should be stored and visible.

### QA Impact

QA cannot fully validate suspended billing behavior without clarification.

Affected areas:

- invoice generation;
- payment processing;
- subscription status;
- customer support scenarios;
- regression testing;
- SQL checks.

### QA Comment

This item should be discussed with BA before finalizing test cases for suspended subscriptions.

---

## CR-004: Add Validation for Payment Amount Before Saving Payment

| Field               | Value                        |
| ------------------- | ---------------------------- |
| Change Request ID   | CR-004                       |
| Type                | Change Request               |
| Status              | Open                         |
| Priority            | High                         |
| Module              | Billing / Payment Processing |
| Related Requirement | REQ-005                      |
| Related Bug         | BUG-002                      |
| Requested By        | QA                           |
| QA Impact           | High                         |

### Summary

Add validation to prevent saving successful payment with amount different from invoice amount.

### Current Behavior

Test data shows that payment `PAY-003` has status `SUCCESS`, but payment amount does not match invoice amount.

### Requested Change

Before saving payment with status `SUCCESS`, the system should validate that payment amount matches invoice amount.

### Business Reason

Payment amount mismatch may lead to incorrect billing status and financial inconsistency.

### Proposed Acceptance Criteria

- If payment amount equals invoice amount, payment can be saved with status `SUCCESS`.
- If payment amount is lower than invoice amount, payment should be rejected or saved with another status depending on business rules.
- If payment amount is higher than invoice amount, payment should be rejected or require special handling.
- System should return clear validation message.
- Invoice status should not become `PAID` if payment amount is incorrect.
- Validation should be covered by regression tests.

### QA Impact

QA should add or update:

- negative payment test cases;
- SQL validation checks;
- bug regression tests;
- test data for lower, equal and higher payment amounts.

### Suggested Validation Message

Payment amount must match invoice amount.

### QA Comment

This change can prevent billing data defects before they are saved in the database.

---

## CR-005: Add Daily Billing Job Execution Report

| Field               | Value               |
| ------------------- | ------------------- |
| Change Request ID   | CR-005              |
| Type                | Improvement         |
| Status              | Open                |
| Priority            | Medium              |
| Module              | Billing / Reporting |
| Related Requirement | REQ-008, REQ-009    |
| Related Bug         | BUG-001             |
| Requested By        | QA / Operations     |
| QA Impact           | Medium              |

### Summary

Add a daily billing job execution report.

### Current Behavior

There is no visible report showing invoice generation results for the billing job.

### Requested Change

After daily invoice generation, the system should provide a report with:

- number of processed subscriptions;
- number of generated invoices;
- number of skipped subscriptions;
- number of failed records;
- failure reasons;
- execution date/time.

### Business Reason

Billing job report helps QA, support and operations teams identify invoice generation issues faster.

### Proposed Acceptance Criteria

- Report is generated after each billing job execution.
- Report shows total number of processed subscriptions.
- Report shows generated invoice count.
- Report shows skipped subscription count.
- Report shows failed record count.
- Report includes failure reasons.
- Report can be filtered by date.
- Report can be exported or viewed by authorized users.

### QA Impact

QA should verify:

- report generation;
- report accuracy;
- skipped subscriptions;
- failed records;
- invoice generation count;
- SQL consistency between report and database.

### Suggested SQL Validation

    SELECT
        COUNT(*) AS generated_invoice_count
    FROM invoices
    WHERE invoice_date = '2026-04-25';

### QA Comment

This improvement would help detect billing issues earlier and support regression testing after billing logic changes.

---

## Change Request Summary

| Change Request ID | Summary                                                 | Type                           | Priority | Status |
| ----------------- | ------------------------------------------------------- | ------------------------------ | -------- | ------ |
| CR-001            | Add partial payment support                             | Change Request                 | Medium   | Open   |
| CR-002            | Add invoice status history                              | Change Request                 | Medium   | Open   |
| CR-003            | Clarify business rule for suspended customers           | Clarification / Change Request | High     | Open   |
| CR-004            | Add validation for payment amount before saving payment | Change Request                 | High     | Open   |
| CR-005            | Add daily billing job execution report                  | Improvement                    | Medium   | Open   |

---

## QA Summary

The change requests were created based on QA analysis of billing requirements, SQL validation and defect candidates.

The most important change requests are:

1. `CR-003` because suspended customer billing rules require clarification.
2. `CR-004` because payment amount validation can prevent critical billing defects.
3. `CR-002` because invoice status history can improve investigation and auditability.

These items should be reviewed with BA, Dev and QA Lead before implementation.

---

## Notes

- Change requests should not be mixed with bugs.
- If current behavior violates an existing requirement, it should be reported as a bug.
- If expected behavior is unclear, it should be discussed as clarification.
- If business wants to extend system behavior, it should be handled as change request.
- QA should update test cases and regression checks after approved changes.
