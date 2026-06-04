# Problem One-Pager — Underwriting time on small commercial submissions

_Classification: Internal Use Only_
_Problem ID: PS-2026-06-04-underwriting-time-on-small-commercial-submissions_
_Date: 2026-06-04_
_Mode used: warn_

## Background
The underwriting team has been spending what the team lead considers excessive time processing small commercial submissions. Approximately 60% of these submissions take more than 4 hours to process. The team lead has been tracking handling times for the last six months and observed the >4-hour cluster building up; the 4-hour mark is his working pain-point benchmark, not a contractual SLA. No specific incident or change triggered the framing; this is a slow build that the team lead judged ready to flag.

## Business Goal

*Why this problem matters at the business level — beyond the immediate symptom.*

- **Strategic driver:** Underwriting capacity and throughput. Each underwriter has finite weekly capacity; a high share of submissions consuming >4 hours drops the team's total throughput. The team lead is concerned about a trajectory toward burnout or backlog (neither materialised yet) given that volume on this type of work is growing.
- **Value at stake:** Throughput on small commercial submissions matters because volume is growing. [Assumption — magnitude of growth not quantified.] Profit-margin framing was explicitly disclaimed by the user — not asserted in this framing.
- **Time sensitivity:** No external deadline. Slow-build trajectory over the last six months.

## Current Condition
What is observably happening today.

- **Who is affected:** The underwriting team (primary). The broker community feels the wait through informal pings asking for status — tension, no formal complaint. Customers feel it indirectly via their brokers. Portfolio managers wait on bound business for monthly numbers — they have grumbled but not escalated.
- **How often / how much:** ~60% of small commercial submissions take more than 4 hours to process.
- **Concrete case (one submission, last week):** ~6 hours total. Time breakdown: ~30 min intake/triage; ~90 min risk assessment, of which a chunk was chasing missing info from the broker; ~45 min pricing; ~2 hours waiting in referral queue (submission breached an authority limit) plus ~30 min handling the returned referral; ~30 min final sign-off and binding.
- **Bottleneck pattern:** The bottleneck is not risk assessment itself — it is referral wait time and back-and-forth with brokers on incomplete submissions.
- **Current workaround:** _None provided._ [Open question — whether underwriters batch referrals or pre-screen broker submissions informally was not confirmed.]

## Target Condition
Tiered targets. Primary commitment: realistic tier. No ideal tier provided.

- **Minimum acceptable:** Share of small commercial submissions taking >4 hours drops from ~60% to under 30%. Bottlenecks identified and at least one structurally addressed (likely candidates: referral wait time and broker-incompleteness back-and-forth).
- **Realistic (primary target):** <20% of small commercial submissions exceed 4 hours. Median handling time documented and tracked, giving the team a measured baseline going forward. Referral wait time has a defined SLA. Broker submission completeness is improved through clearer intake requirements (template, checklist, or whatever fits).

## Suspected Causes (hypotheses, not conclusions)
- [Hypothesis] Referral queue wait time is a primary bottleneck — submissions breaching authority limits sit in a queue. Based on one observed case (~2 hours of the ~6 hours).
- [Hypothesis] Broker submission incompleteness drives back-and-forth that consumes risk-assessment time. Based on the same observed case and the team lead's hunch that submission completeness has been declining. Not measured.
- [Hypothesis] No documented "small" threshold means underwriters apply judgment per submission, possibly inconsistent. Not tested.

## Scope
**In scope:** Time consumed by the underwriting team in processing small commercial submissions; identification and structural treatment of the bottlenecks within that handling cycle.

**Out of scope:**
- Profit-margin analysis on small commercial submissions (whether underwriting effort exceeds premium economics) — explicitly disclaimed by the user; no data, no claim.
- Formalisation of the "small" threshold itself — talked about in the team but not part of this framing.
- Underwriting authority-limit changes — governed separately by underwriting governance.

## Constraints
- Underwriting authority limits cannot be changed unilaterally; adjustments require formal sign-off via underwriting governance.
- No specific regulatory constraint identified for this framing; general regulatory environment applies. [Open question — confirm whether any prudential or conduct rule changes in the horizon affect underwriting handling time.]

## Stakeholders
*Who is involved in the problem and its resolution.*

| Role | Person / Team | Decision power |
|---|---|---|
| Underwriting team lead | (name to be confirmed) | Escalator; owner of the handling-time tracking; pain-point benchmark setter |
| Underwriting team | (members not named) | Producers of the handling time; subject of any process or tooling change |
| Brokers | (broker community; not enumerated) | Source of submission completeness; affected by referral and chase-back delays |
| Portfolio managers | (team confirmed; specific contacts not named) | Downstream consumers of bound business for monthly numbers |
| Underwriting governance | (body confirmed; specific contacts not named) | Authority over underwriting authority limits |

## Impacted Capabilities & Systems

*Free-text, no formal taxonomy required.*

**Capabilities:**
_None provided._ [Open question — capabilities mapping was not part of this dialogue.]

**Systems:**
_None provided._ [Open question — the user did not enumerate systems involved in submission handling. The walk-through referenced "our system" generically for intake/logging, but no specific system was named.]

## Likely next step
Spike. Two-week measurement effort to instrument actual handling-time stages (intake, risk, pricing, referral wait, sign-off) on ~30-50 submissions and confirm where the time concentrates. Decision between a Standard (process-shaped fix: intake checklist, referral SLA) and a Tool-Eval (tooling-shaped fix: workflow tooling, broker submission improvements) deferred until the measurement is in.

## Open Questions & Assumptions
- [Open question] Formal threshold for "small" — is the team going to define one, and if so when?
- [Open question] Whether submission completeness is genuinely declining (team-lead hunch, not measured).
- [Open question] Whether underwriters already use informal workarounds (batching referrals, pre-screening broker submissions).
- [Open question] Whether portfolio managers' grumbling has surfaced anywhere formally, or whether it remains informal.
- [Open question] Stakeholder names for team lead, portfolio managers, underwriting governance contacts.
- [Open question] Specific systems used in submission handling (intake/logging system, referral routing, sign-off path).
- [Assumption — magnitude of submission-volume growth not quantified] User stated volume is growing but did not provide a number.
- [Hypothesis] Three hypotheses logged under Suspected Causes; none tested.

## Coaching Notes
- User correction at turn 4: coach had introduced "small-commercial book" and "small-commercial underwriting team" — neither user-stated. User explicitly corrected both. Ledger re-derivation triggered and acknowledged in chat. Both phrasings purged from the working ledger and from the file. No related variants introduced.
- Tier-3 flag: Profit-margin framing was explicitly disclaimed by the user. Logged as out-of-scope to prevent it re-entering downstream framings.
- Tier-3 flag: "Small" threshold is informal and undocumented. Logged as [Open question] rather than treated as a fact.
- The session produced a tightly framed problem with quantified symptom, anchor, tiered target, identified bottlenecks (hypothesized), and a clean decision direction (Spike-first).
