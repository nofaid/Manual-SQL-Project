# 04. Functional Checklist

## Checklist Legend

| Status              | Meaning                                                      |
| ------------------- | ------------------------------------------------------------ |
| Not Run             | Check has not been executed yet                              |
| Passed              | Actual result matches expected result                        |
| Failed              | Actual result does not match expected result                 |
| Blocked             | Check cannot be executed due to blocker                      |
| Needs Clarification | Expected result is unclear and requires BA/Dev clarification |

---

## Customer Management

| ID      | Check                                                                                        | Requirement | Priority | Status  |
| ------- | -------------------------------------------------------------------------------------------- | ----------- | -------- | ------- |
| CHK-001 | Verify that a customer can be created with valid required fields                             | REQ-001     | High     | Not Run |
| CHK-002 | Verify that customer email must be unique                                                    | REQ-001     | High     | Not Run |
| CHK-003 | Verify that customer cannot be created without email                                         | REQ-001     | High     | Not Run |
| CHK-004 | Verify that customer cannot be created without phone number                                  | REQ-001     | High     | Not Run |
| CHK-005 | Verify that new customer status is `ACTIVE` by default                                       | REQ-001     | Medium   | Not Run |
| CHK-006 | Verify that only allowed customer statuses can be used: `ACTIVE`, `SUSPENDED`, `DEACTIVATED` | REQ-001     | High     | Not Run |

---

## Tariff Plan Management

| ID      | Check                                                             | Requirement | Priority | Status  |
| ------- | ----------------------------------------------------------------- | ----------- | -------- | ------- |
| CHK-007 | Verify that tariff plan can be created with valid data            | REQ-002     | High     | Not Run |
| CHK-008 | Verify that tariff plan name must be unique                       | REQ-002     | Medium   | Not Run |
| CHK-009 | Verify that monthly fee must be greater than 0                    | REQ-002     | High     | Not Run |
| CHK-010 | Verify that tariff status can be only `ACTIVE` or `ARCHIVED`      | REQ-002     | High     | Not Run |
| CHK-011 | Verify that archived tariff plan cannot be assigned to a customer | REQ-002     | High     | Not Run |

---

## Subscription Activation

| ID      | Check                                                                                          | Requirement | Priority | Status              |
| ------- | ---------------------------------------------------------------------------------------------- | ----------- | -------- | ------------------- |
| CHK-012 | Verify that active customer can receive active tariff plan                                     | REQ-003     | High     | Not Run             |
| CHK-013 | Verify that deactivated customer cannot receive new subscription                               | REQ-003     | High     | Not Run             |
| CHK-014 | Verify that suspended customer cannot receive new subscription without clarification           | REQ-003     | Medium   | Needs Clarification |
| CHK-015 | Verify that subscription is linked to correct customer                                         | REQ-003     | High     | Not Run             |
| CHK-016 | Verify that subscription is linked to correct tariff plan                                      | REQ-003     | High     | Not Run             |
| CHK-017 | Verify that new subscription status is `ACTIVE`                                                | REQ-003     | High     | Not Run             |
| CHK-018 | Verify that only allowed subscription statuses can be used: `ACTIVE`, `SUSPENDED`, `CANCELLED` | REQ-003     | High     | Not Run             |

---

## Invoice Generation

| ID      | Check                                                                                | Requirement | Priority | Status  |
| ------- | ------------------------------------------------------------------------------------ | ----------- | -------- | ------- |
| CHK-019 | Verify that invoice can be generated for active subscription                         | REQ-004     | High     | Not Run |
| CHK-020 | Verify that invoice is linked to existing customer                                   | REQ-004     | High     | Not Run |
| CHK-021 | Verify that invoice is linked to active subscription                                 | REQ-004     | High     | Not Run |
| CHK-022 | Verify that invoice amount matches tariff monthly fee                                | REQ-004     | High     | Not Run |
| CHK-023 | Verify that new invoice status is `UNPAID`                                           | REQ-004     | High     | Not Run |
| CHK-024 | Verify that invoice cannot be generated for `SUSPENDED` subscription                 | REQ-004     | High     | Not Run |
| CHK-025 | Verify that invoice cannot be generated for `CANCELLED` subscription                 | REQ-004     | High     | Not Run |
| CHK-026 | Verify that only allowed invoice statuses can be used: `UNPAID`, `PAID`, `CANCELLED` | REQ-004     | High     | Not Run |

---

## Payment Processing

| ID      | Check                                                                                  | Requirement | Priority | Status  |
| ------- | -------------------------------------------------------------------------------------- | ----------- | -------- | ------- |
| CHK-027 | Verify that payment can be registered for unpaid invoice                               | REQ-005     | High     | Not Run |
| CHK-028 | Verify that payment is linked to existing invoice                                      | REQ-005     | High     | Not Run |
| CHK-029 | Verify that payment amount matches invoice amount                                      | REQ-005     | High     | Not Run |
| CHK-030 | Verify that invoice status becomes `PAID` after successful payment                     | REQ-005     | Critical | Not Run |
| CHK-031 | Verify that payment cannot be registered for already `PAID` invoice                    | REQ-005     | High     | Not Run |
| CHK-032 | Verify that payment cannot be registered for `CANCELLED` invoice                       | REQ-005     | High     | Not Run |
| CHK-033 | Verify that failed payment does not change invoice status to `PAID`                    | REQ-005     | Critical | Not Run |
| CHK-034 | Verify that only allowed payment statuses can be used: `SUCCESS`, `FAILED`, `REFUNDED` | REQ-005     | High     | Not Run |

---

## Additional Service Activation

| ID      | Check                                                                           | Requirement | Priority | Status  |
| ------- | ------------------------------------------------------------------------------- | ----------- | -------- | ------- |
| CHK-035 | Verify that active additional service can be activated for active subscription  | REQ-006     | Medium   | Not Run |
| CHK-036 | Verify that additional service cannot be activated for `SUSPENDED` subscription | REQ-006     | High     | Not Run |
| CHK-037 | Verify that additional service cannot be activated for `CANCELLED` subscription | REQ-006     | High     | Not Run |
| CHK-038 | Verify that archived service cannot be activated                                | REQ-006     | High     | Not Run |
| CHK-039 | Verify that service price is greater than 0                                     | REQ-006     | Medium   | Not Run |
| CHK-040 | Verify that activated service price is included in the next invoice             | REQ-006     | High     | Not Run |

---

## Support Ticket Creation

| ID      | Check                                                                                             | Requirement | Priority | Status  |
| ------- | ------------------------------------------------------------------------------------------------- | ----------- | -------- | ------- |
| CHK-041 | Verify that support ticket can be created for existing customer                                   | REQ-007     | Medium   | Not Run |
| CHK-042 | Verify that support ticket must have subject                                                      | REQ-007     | Medium   | Not Run |
| CHK-043 | Verify that support ticket must have description                                                  | REQ-007     | Medium   | Not Run |
| CHK-044 | Verify that new support ticket status is `OPEN` by default                                        | REQ-007     | Medium   | Not Run |
| CHK-045 | Verify that only allowed ticket statuses can be used: `OPEN`, `IN_PROGRESS`, `RESOLVED`, `CLOSED` | REQ-007     | Medium   | Not Run |

---

## SQL Data Consistency

| ID      | Check                                                            | Requirement | Priority | Status  |
| ------- | ---------------------------------------------------------------- | ----------- | -------- | ------- |
| CHK-046 | Verify that every subscription is linked to existing customer    | REQ-009     | Critical | Not Run |
| CHK-047 | Verify that every subscription is linked to existing tariff plan | REQ-009     | Critical | Not Run |
| CHK-048 | Verify that every invoice is linked to existing customer         | REQ-009     | Critical | Not Run |
| CHK-049 | Verify that every invoice is linked to existing subscription     | REQ-009     | Critical | Not Run |
| CHK-050 | Verify that every payment is linked to existing invoice          | REQ-009     | Critical | Not Run |
| CHK-051 | Verify that paid invoice has at least one successful payment     | REQ-009     | Critical | Not Run |
| CHK-052 | Verify that successful payment amount matches invoice amount     | REQ-009     | Critical | Not Run |
| CHK-053 | Verify that unpaid invoice does not have successful full payment | REQ-009     | Critical | Not Run |

---

## Regression Checks

| ID      | Check                                                                          | Requirement | Priority | Status  |
| ------- | ------------------------------------------------------------------------------ | ----------- | -------- | ------- |
| CHK-054 | Verify customer creation after billing logic changes                           | REQ-008     | High     | Not Run |
| CHK-055 | Verify subscription activation after billing logic changes                     | REQ-008     | High     | Not Run |
| CHK-056 | Verify invoice generation after tariff price change                            | REQ-008     | Critical | Not Run |
| CHK-057 | Verify payment processing after payment logic change                           | REQ-008     | Critical | Not Run |
| CHK-058 | Verify invoice status update after successful payment                          | REQ-008     | Critical | Not Run |
| CHK-059 | Verify SQL consistency between customers, subscriptions, invoices and payments | REQ-008     | Critical | Not Run |
| CHK-060 | Verify that already paid invoices remain `PAID` after regression changes       | REQ-008     | High     | Not Run |

---

## Notes

- Checks marked as `Critical` or `High` should be executed first.
- Checks with `Needs Clarification` status should be discussed with BA/Dev before final test execution.
- SQL-related checks should be executed using queries from `sql/qa_checks.sql`.
- Failed checks should be documented as Jira-style bug reports.
