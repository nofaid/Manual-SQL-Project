# 10. Daily QA Reports

## Daily Report Format

Each report contains:

| Section      | Purpose                   |
| ------------ | ------------------------- |
| Date         | Report date               |
| Project      | Project name              |
| Completed    | What was done             |
| Found Issues | Bugs or defect candidates |
| Blockers     | What blocks testing       |
| Risks        | Quality or delivery risks |
| Next Steps   | Planned next actions      |

---

## Daily QA Report — Day 1

| Field       | Value                           |
| ----------- | ------------------------------- |
| Date        | 2026-04-27                      |
| Project     | Telecom QA Manual + SQL Project |
| Reported By | QA Engineer                     |
| Reported To | QA Lead                         |

### Completed

- Reviewed project scope and business context.
- Prepared initial requirements for telecom billing flow.
- Defined main modules:
  - customers;
  - tariff plans;
  - subscriptions;
  - invoices;
  - payments;
  - additional services;
  - support tickets.
- Prepared first version of test data documentation.
- Identified key billing risks.

### Found Issues

- No defects found yet.
- Requirements review identified areas that may require clarification later.

### Blockers

- No blockers.

### Risks

- Suspended subscription billing behavior may require clarification.
- Payment amount validation may be business-critical.
- SQL data consistency should be verified carefully.

### Next Steps

- Prepare database schema.
- Prepare SQL test data.
- Create SQL validation checks.
- Start checklist and test case design.

---

## Daily QA Report — Day 2

| Field       | Value                           |
| ----------- | ------------------------------- |
| Date        | 2026-04-28                      |
| Project     | Telecom QA Manual + SQL Project |
| Reported By | QA Engineer                     |
| Reported To | QA Lead                         |

### Completed

- Created database schema for billing entities.
- Prepared SQL test data for:
  - active customers;
  - suspended customers;
  - deactivated customers;
  - active subscriptions;
  - cancelled subscriptions;
  - unpaid invoices;
  - paid invoices;
  - successful payments;
  - failed payments.
- Created SQL validation queries.
- Started functional checklist.

### Found Issues

- Potential issue found: invoices exist for non-active subscriptions.
- Potential issue found: successful payment amount does not match invoice amount.
- Potential issue found: invoice status remains unpaid after successful full payment.

### Blockers

- No technical blockers.

### Risks

- Billing data consistency issues may affect financial accuracy.
- Some scenarios require BA clarification before final expected result can be confirmed.

### Next Steps

- Complete functional checklist.
- Create detailed test cases.
- Document SQL check results.
- Prepare Jira-style bug reports.

---

## Daily QA Report — Day 3

| Field       | Value                           |
| ----------- | ------------------------------- |
| Date        | 2026-04-29                      |
| Project     | Telecom QA Manual + SQL Project |
| Reported By | QA Engineer                     |
| Reported To | QA Lead                         |

### Completed

- Completed functional checklist.
- Created detailed test cases for:
  - customer creation;
  - tariff plan assignment;
  - invoice generation;
  - payment processing;
  - additional service activation;
  - support ticket creation;
  - SQL data consistency;
  - regression checks.
- Linked test cases to requirements and checklist items.
- Executed SQL validation analysis.

### Found Issues

- BUG-001: Invoices are generated for non-active subscriptions.
- BUG-002: Successful payment exists with incorrect amount.
- BUG-003: Invoice status is not updated after successful full payment.
- BUG-004: Full billing flow shows incorrect invoice status.

### Blockers

- No blockers.

### Risks

- BUG-001, BUG-002 and BUG-003 are critical because they may affect billing accuracy.
- BUG-004 may be related to BUG-003 and should be reviewed together.

### Next Steps

- Prepare Jira-style bug reports.
- Prepare change request examples.
- Prepare regression checklist.
- Prepare questions for BA/Dev.

---

## Daily QA Report — Day 4

| Field       | Value                           |
| ----------- | ------------------------------- |
| Date        | 2026-04-30                      |
| Project     | Telecom QA Manual + SQL Project |
| Reported By | QA Engineer                     |
| Reported To | QA Lead                         |

### Completed

- Created Jira-style bug reports:
  - BUG-001;
  - BUG-002;
  - BUG-003;
  - BUG-004.
- Added SQL evidence to each bug report.
- Created change request examples:
  - partial payment support;
  - invoice status history;
  - suspended customer billing clarification;
  - payment amount validation;
  - daily billing job report.
- Created regression checklist.

### Found Issues

- No new defects found.
- Existing billing defects documented and linked to SQL checks.

### Blockers

- Clarification needed from BA/Product Owner about suspended customer billing behavior.

### Risks

- If suspended billing rules are not clarified, QA may validate against wrong expected behavior.
- If payment amount validation is not added, similar defects may appear again.

### Next Steps

- Prepare clarification questions for BA/Dev.
- Prepare final test summary.
- Review project documentation and links.
- Prepare portfolio summary for resume.

---

## Daily QA Report — Day 5

| Field       | Value                           |
| ----------- | ------------------------------- |
| Date        | 2026-05-01                      |
| Project     | Telecom QA Manual + SQL Project |
| Reported By | QA Engineer                     |
| Reported To | QA Lead                         |

### Completed

- Prepared clarification questions for BA/Dev.
- Completed final test summary.
- Reviewed requirement coverage.
- Reviewed SQL validation coverage.
- Reviewed bug reports and change requests.
- Prepared evidence folder description.

### Found Issues

- No new issues found.
- Previously found issues remain open in documentation:
  - BUG-001;
  - BUG-002;
  - BUG-003;
  - BUG-004.

### Blockers

- No blockers for portfolio project completion.
- BA clarification is still needed for suspended customer billing rules in a real project.

### Risks

- Critical billing issues should be fixed before release in a real environment.
- Regression testing must be executed after any fix in invoice generation or payment processing.

### Next Steps

- Finalize repository structure.
- Add GitHub repository description and topics.
- Link project in resume.
- Prepare interview explanation for project decisions.

---

## QA Communication Notes

Good daily QA report should be:

- short;
- factual;
- linked to work items;
- focused on risks and blockers;
- clear for QA Lead, BA and Dev team.

Bad daily QA report:

- too vague;
- no progress details;
- no blockers;
- no risks;
- no next steps;
- no links to bugs or test results.

---

## Example Short Daily Update

Today I completed SQL validation checks for the telecom billing flow.  
Found three critical defect candidates related to invoice generation, payment amount validation and invoice status update after successful payment.  
No technical blockers.  
Next step: prepare Jira-style bug reports and regression checklist.
