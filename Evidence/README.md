# Evidence

## Folder Purpose

This folder is intended for QA evidence collected during test execution.

Evidence may include:

- screenshots;
- screen recordings;
- SQL query results;
- exported CSV files;
- logs;
- test execution results;
- bug reproduction evidence;
- regression evidence.

---

## Evidence Types

| Evidence Type         | Example                                                          |
| --------------------- | ---------------------------------------------------------------- |
| SQL Result Screenshot | Screenshot from DBeaver, DataGrip, pgAdmin or another SQL client |
| SQL Export            | CSV file with query result                                       |
| Bug Screenshot        | Screenshot showing actual result                                 |
| Video Evidence        | Screen recording of defect reproduction                          |
| Logs                  | Application or database logs                                     |
| Test Run Result       | Screenshot or export from test management tool                   |

---

## Planned Evidence for This Project

| Evidence ID | Related Item         | Description                                                | Status  |
| ----------- | -------------------- | ---------------------------------------------------------- | ------- |
| EVD-001     | BUG-001              | SQL result showing invoices for non-active subscriptions   | Planned |
| EVD-002     | BUG-002              | SQL result showing successful payment amount mismatch      | Planned |
| EVD-003     | BUG-003              | SQL result showing unpaid invoice after successful payment | Planned |
| EVD-004     | BUG-004              | SQL result showing full billing flow inconsistency         | Planned |
| EVD-005     | Regression Checklist | SQL result after regression checks                         | Planned |

---

## Naming Convention

Recommended evidence file naming format:

    BUG-001_invoice_for_non_active_subscription.png
    BUG-002_payment_amount_mismatch.png
    BUG-003_invoice_status_not_updated.png
    BUG-004_full_billing_flow_inconsistent.png
    REG-001_billing_regression_result.png

---

## Evidence Rules

Good QA evidence should be:

- clear;
- readable;
- linked to bug or test case;
- easy to reproduce;
- not contain sensitive production data;
- stored with meaningful file names.

---

## Important Note

This is a self-practice QA portfolio project.

The current folder describes planned evidence structure.

If SQL scripts are executed locally, screenshots or exported query results can be added here as additional proof of test execution.
