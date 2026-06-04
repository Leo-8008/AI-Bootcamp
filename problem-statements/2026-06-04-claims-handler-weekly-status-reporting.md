# Problem One-Pager — Claims-handler weekly status reporting

_Classification: Internal Use Only_
_Problem ID: PS-2026-06-04-claims-handler-weekly-status-reporting_
_Date: 2026-06-04_
_Mode used: warn_

## Background
On the Friday before this framing, the claims-operations head escalated to the team lead asking for weekly handler-utilization numbers. Compiling them surfaced that the team lead spends most of Friday afternoon stitching the data together by hand from five different exports. The team lead raised this in Monday's stand-up and asked the team to scope it. The trigger is the escalation, not a single incident.

## Business Goal

*Why this problem matters at the business level — beyond the immediate symptom.*

- **Strategic driver:** Year-end resourcing review. The claims-operations head needs to defend or expand handler headcount for next year and show the board where handler time actually goes (claim-touching work vs admin vs reporting). Status reporting is currently lumped into "admin overhead" — a category seen as inflatable.
- **Value at stake:** A defensible breakdown of handler time enables headcount decisions to be made on evidence rather than on the inflatable "admin overhead" line. [Assumption — magnitude of headcount impact not quantified.]
- **Time sensitivity:** November resourcing review. The claims-operations head wants "something visible" by then — evidence of progress, not a full solution. [Assumption — strategic anchor (specific KPI name) not confirmed; could be utilization rate or productive-hour ratio. [Open question]]

## Current Condition
What is observably happening today.

- **Who is affected:** 24 claims handlers, the team lead, the claims-operations head, a finance partner for claims operations (name to be confirmed), and the workforce planning team at group level (specific contact not confirmed).
- **How often / how much:** Each handler spends ~3 hours per week compiling their weekly status report. The team lead spends ~4 hours every Friday afternoon stitching handler submissions and writing the narrative for the operations head.
- **Concrete case:** One handler's Friday routine — ~10 min export from claims management system, ~10 min export from workflow tool, ~5 min pull from SLA tracker spreadsheet, ~20 min screenshot-and-paste from customer-feedback dashboard (no export available), ~10 min export from HR time-tracking system. Then ~90 min reconciling case IDs that disagree across systems and making judgment calls on mismatches. Then ~30 min formatting and narrative. Last week one handler spent 25 min resolving a single reopened-case double-count between two systems.
- **Current workaround:** Manual reconciliation by handlers and the team lead. The team lead has been absorbing the integration cost informally.

## Target Condition
Tiered targets. Primary commitment: realistic tier.

- **Minimum acceptable:** Handler time on weekly status reports drops from ~3 hours to under 30 minutes. Team-lead Friday stitching drops from ~4 hours to under 1 hour. Achievable through better tooling around the existing five sources; no source consolidation needed.
- **Realistic (primary target):** Under 15 minutes per handler. Under 30 minutes for the team lead. Case-ID reconciliation structurally addressed via a single canonical case ID across at least four of the five sources. Operations head receives numbers Friday end-of-day instead of Monday morning.
- **Ideal (north star, ~18+ months out, dependent on broader data initiatives outside this team's control):** Zero handler time on compilation; auto-generated status report from a single integrated view. Team-lead role shifts from compilation to interpretation and narrative. Self-service dashboard with on-demand drill-down for the operations head. Continuous feed instead of weekly snapshot for the workforce planning team.

## Suspected Causes (hypotheses, not conclusions)
- [Hypothesis] No canonical case ID was ever defined across the five systems. Each system was built or procured at a different time by different teams; the case-ID format mismatch is the symptom. Not tested — would require a data-architecture review.
- [Hypothesis] The status report template was designed when the team had 6 handlers, not 24. Manual stitching scaled linearly while the team grew ~4x. Not tested; based on team-lead recollection, no documentation.
- The customer-feedback dashboard has no export API. Confirmed by three handlers; vendor docs state screenshot-only. (Stated as tested fact, not hypothesis.)
- [Hypothesis] No one owns the end-to-end status reporting process. Five sources, five owners, a sixth-party consumer, and the team lead absorbing integration cost informally. Consistent with the escalation pattern.
- [Hypothesis] Reconciliation judgment calls reflect genuine business-logic ambiguity, not just data quality. E.g. the reopened-case double-count may be "correct" under one accounting rule and "wrong" under another. Not tested.

## Scope
**In scope:** The weekly status reporting cycle that consumes the ~3 hours per handler and ~4 hours per team lead. Integration-and-reporting layer over the five existing sources.

**Out of scope:**
- Broader data-architecture overhaul of the five source systems.
- SLA-tracker ownership renegotiation (owned by the quality-assurance team).
- Replacing the customer-feedback dashboard vendor (~14 months left on contract; not the cost driver here).
- Fixing the operations transformation programme's roadmap conflicts (work around, not through).
- Headcount decisions for the 24-handler team (operations head's question; this work just provides better data for it).
- Reporting cycles beyond weekly: monthly board reports, ad-hoc deep-dives, year-end aggregated view.

## Constraints
- Customer-feedback dashboard is provided by an external vendor (name to be confirmed) under a 3-year contract running until end of next year. Replacement and contract-amendment-driven export additions are not viable in the relevant horizon.
- HR time-tracking system is owned by Group HR. Read-access changes route through their data-governance board, typically a 3-month process.
- SLA tracker spreadsheet is owned by the quality-assurance team. They have explicitly stated they will not move it into a system; they want manual control over SLA definitions.
- Regulatory: claim-handling data is under FINMA conduct supervision and FADP. Audit trail must be preserved for any data movement or transformation. No customer-identifiable data may leave Switzerland.
- Political: any solution touching the workflow tool requires sign-off from the operations transformation programme, which is mid-stream on a separate roadmap and has historically blocked side-initiatives.
- Year-end resourcing review in November sets a "visible progress" expectation from the claims-operations head.

## Stakeholders
*Who is involved in the problem and its resolution.*

| Role | Person / Team | Decision power |
|---|---|---|
| Claims handler | 24 handlers in the claims-handling team | None on the reporting design; producers of the data |
| Team lead, claims-handling team | (name to be confirmed) | Escalator; current owner of Friday stitching and narrative |
| Claims-operations head | (name to be confirmed) | Primary consumer; driver of year-end resourcing review |
| Finance partner for claims operations | (name to be confirmed) | Monthly consumer for cost allocation [Open question — confirm scope of related reports consumed] |
| Workforce planning team (group level) | Workforce planning team (specific contact not confirmed) | Year-end aggregated-view consumer; has flagged data-quality concerns twice in the last six months |
| Quality-assurance team | (team confirmed; specific contact not confirmed) | Owner of SLA tracker; will not give up manual control |
| Group HR | Group HR data-governance board | Owner of HR time-tracking system; gates read-access changes |
| Operations transformation programme | (team confirmed; specific contact not confirmed) | Sign-off authority on workflow-tool changes |

## Impacted Capabilities & Systems

*Free-text, no formal taxonomy required.*

**Capabilities:**
_None provided._

**Systems:**
- Claims management system (saved-query export to Excel).
- Workflow tool (task-completion log export).
- SLA tracker spreadsheet (shared drive, owned by quality-assurance team, weekly manual update).
- Customer-feedback dashboard (external vendor, screenshot-only, no export API).
- HR time-tracking system (owned by Group HR).

## Likely next step
Software/Tool Evaluation, scoped to the integration-and-reporting layer over the five existing sources. A follow-up ADR on canonical case-ID strategy is likely if Hypothesis 1 holds. Solution Blueprint deferred until evaluation shows whether existing tooling can hit the realistic tier without larger commitments.

## Open Questions & Assumptions
- [Open question] Specific KPI name the claims-operations head will use in the board deck (utilization rate? productive-hour ratio? other?).
- [Open question] Whether the finance partner for claims operations consumes related reports beyond the monthly cost-allocation use.
- [Open question] Vendor name behind the customer-feedback dashboard and exact contract end date.
- [Open question] Names of the team lead, claims-operations head, finance partner, workforce planning contact, quality-assurance contact, and operations transformation programme contact.
- [Assumption] The "(role to be confirmed whether claims-operations head also consumes related reports)" branch reflects user uncertainty, not a fact.
- [Assumption] Magnitude of headcount-decision impact from a defensible time breakdown is not quantified.
- [Assumption — strategic anchor not confirmed] Year-end resourcing review is the dominant strategic driver; KPI name pending.
- [Hypothesis] Five hypotheses listed under Suspected Causes; only the customer-feedback-export limitation has been tested.

## Coaching Notes
_None provided._
