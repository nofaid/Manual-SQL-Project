# 09. Regression Checklist

## Regression Checklist Status Legend

| Status              | Meaning                                      |
| ------------------- | -------------------------------------------- |
| Not Run             | Check has not been executed yet              |
| Passed              | Actual result matches expected result        |
| Failed              | Actual result does not match expected result |
| Blocked             | Check cannot be executed                     |
| Needs Clarification | Expected result requires clarification       |

---

## Regression Scope

Regression testing covers the following areas:

- customer data;
- tariff plan data;
- subscription activation;
- invoice generation;
- payment processing;
- invoice status update;
- additional service activation;
- SQL data consistency;
- previously found defects.

---

## Regression Trigger Examples

Regression testing should be executed after:

| Trigger                          | Reason                                     |
| -------------------------------- | ------------------------------------------ |
| Tariff price change              | Invoice amount calculation may be affected |
| Payment processing change        | Invoice status update may be affected      |
| Subscription status logic change | Invoice generation rules may be affected   |
| Invoice generation job update    | Incorrect invoices may be generated        |
| Bug fix for billing defects      | Related functionality may break            |
| Database schema change           | SQL relationships may be affected          |

---

## Critical Regression Checks

| ID      | Regression Check                                                               | Related Requirement                | Related Test Case | Priority | Status  |
| ------- | ------------------------------------------------------------------------------ | ---------------------------------- | ----------------- | -------- | ------- |
| REG-001 | Verify that active customer data remains valid                                 | REQ-001                            | TC-001            | High     | Not Run |
| REG-002 | Verify that active tariff plan can still be assigned                           | REQ-003                            | TC-003            | High     | Not Run |
| REG-003 | Verify that archived tariff plan cannot be assigned                            | REQ-002, REQ-003                   | TC-004            | High     | Not Run |
| REG-004 | Verify that invoice is generated for active subscription                       | REQ-004                            | TC-005            | Critical | Not Run |
| REG-005 | Verify that invoice is not generated for suspended subscription                | REQ-004                            | TC-006            | Critical | Not Run |
| REG-006 | Verify that invoice is not generated for cancelled subscription                | REQ-004                            | TC-007            | Critical | Not Run |
| REG-007 | Verify that payment can be registered for unpaid invoice                       | REQ-005                            | TC-008            | Critical | Not Run |
| REG-008 | Verify that invoice status becomes PAID after successful full payment          | REQ-005                            | TC-008, TC-015    | Critical | Not Run |
| REG-009 | Verify that payment amount must match invoice amount                           | REQ-005, REQ-009                   | TC-009            | Critical | Not Run |
| REG-010 | Verify that duplicate successful payment is not allowed                        | REQ-005                            | TC-010            | High     | Not Run |
| REG-011 | Verify that failed payment does not close invoice                              | REQ-005                            | TC-011            | Critical | Not Run |
| REG-012 | Verify that active additional service can be activated for active subscription | REQ-006                            | TC-012            | Medium   | Not Run |
| REG-013 | Verify that archived additional service cannot be activated                    | REQ-006                            | TC-013            | High     | Not Run |
| REG-014 | Verify that support ticket can be created for existing customer                | REQ-007                            | TC-014            | Medium   | Not Run |
| REG-015 | Verify full billing flow for active customer                                   | REQ-003, REQ-004, REQ-005, REQ-009 | TC-015            | Critical | Not Run |
| REG-016 | Verify that paid invoice has successful payment                                | REQ-009                            | TC-016            | Critical | Not Run |
| REG-017 | Verify that invoices do not exist for non-active subscriptions                 | REQ-004, REQ-009                   | TC-017            | Critical | Not Run |
| REG-018 | Verify paid invoice stability after tariff price change                        | REQ-008                            | TC-018            | Critical | Not Run |

---

## SQL Regression Checks

| ID          | SQL Check                                                       | Expected Result                            | Priority | Status  |
| ----------- | --------------------------------------------------------------- | ------------------------------------------ | -------- | ------- |
| SQL-REG-001 | Active customers exist for positive scenarios                   | Active customers returned                  | Medium   | Not Run |
| SQL-REG-002 | Active subscriptions are linked to active customers and tariffs | Valid active subscription records returned | High     | Not Run |
| SQL-REG-003 | Invoices for non-active subscriptions                           | 0 rows                                     | Critical | Not Run |
| SQL-REG-004 | Invoice amount differs from tariff monthly fee                  | 0 rows                                     | Critical | Not Run |
| SQL-REG-005 | Successful payment amount differs from invoice amount           | 0 rows                                     | Critical | Not Run |
| SQL-REG-006 | Unpaid invoice with successful full payment                     | 0 rows                                     | Critical | Not Run |
| SQL-REG-007 | Paid invoice without successful payment                         | 0 rows                                     | Critical | Not Run |
| SQL-REG-008 | Duplicate successful payments for same invoice                  | 0 rows                                     | High     | Not Run |
| SQL-REG-009 | Active additional services linked to non-active subscriptions   | 0 rows                                     | High     | Not Run |
| SQL-REG-010 | Active customer services linked to archived services            | 0 rows                                     | High     | Not Run |
| SQL-REG-011 | Subscriptions linked to archived tariff plans                   | 0 rows                                     | High     | Not Run |
| SQL-REG-012 | Paid invoice stability check                                    | Paid invoice remains PAID                  | Critical | Not Run |

---

## Bug Fix Regression Checks

These checks should be executed after fixes for existing bugs.

| Bug ID  | Regression Check                                                     | Expected Result                          | Priority | Status  |
| ------- | -------------------------------------------------------------------- | ---------------------------------------- | -------- | ------- |
| BUG-001 | Recheck invoice generation for suspended and cancelled subscriptions | No invoices for non-active subscriptions | Critical | Not Run |
| BUG-002 | Recheck payment amount validation                                    | Incorrect payment amount is rejected     | Critical | Not Run |
| BUG-003 | Recheck invoice status after successful full payment                 | Invoice status becomes PAID              | Critical | Not Run |
| BUG-004 | Recheck full billing flow for customer CUST-001                      | Full billing chain is consistent         | High     | Not Run |

---

## Regression Execution Order

Recommended execution order:

1. Critical SQL data consistency checks.
2. Payment processing checks.
3. Invoice generation checks.
4. Subscription and tariff checks.
5. Additional service checks.
6. Support ticket checks.
7. Full end-to-end billing flow.
8. Bug fix regression checks.

---

## Regression Risks

| Risk                                            | Impact                                             | Mitigation                            |
| ----------------------------------------------- | -------------------------------------------------- | ------------------------------------- |
| Payment fix breaks invoice status logic         | Paid customers may still see unpaid invoices       | Execute REG-007, REG-008, SQL-REG-006 |
| Tariff change breaks invoice amount             | Customers may be charged incorrectly               | Execute REG-004, SQL-REG-004          |
| Subscription status change breaks billing rules | Suspended/cancelled customers may receive invoices | Execute REG-005, REG-006, SQL-REG-003 |
| Database change breaks relationships            | Data consistency issues may appear                 | Execute all SQL regression checks     |
| Partial fix does not solve original bug         | Defect may remain unresolved                       | Execute bug fix regression checks     |

---

## Regression Summary Template

| Field           | Value                                              |
| --------------- | -------------------------------------------------- |
| Regression Date | To be filled                                       |
| Build / Version | To be filled                                       |
| Executed By     | QA Engineer                                        |
| Total Checks    | 18 functional + 12 SQL + 4 bug fix checks          |
| Passed          | To be filled                                       |
| Failed          | To be filled                                       |
| Blocked         | To be filled                                       |
| Not Run         | To be filled                                       |
| Main Risks      | Billing, payments, invoice status, SQL consistency |

---

## QA Notes

- Critical checks should be executed first.
- Failed regression checks should be linked to existing or new bug reports.
- SQL checks from `sql/qa_checks.sql` should be used as regression evidence.
- Any unclear expected behavior should be documented in `12_Questions_to_BA_and_Dev.md`.
- Regression results should be summarized in `11_Test_Summary.md`.
