# Problem One-Pager — Broker portal showing wrong commission rates

_Classification: Internal Use Only_
_Problem ID: PS-2026-06-04-broker-portal-wrong-commission-rates_
_Date: 2026-06-04_
_Mode used: warn_

## Background
Three weeks ago, brokers began reporting that commission rates displayed in the broker portal did not match the commission actually paid out after policy issuance. The broker support team has logged ~15 complaints in that period. The displayed rates are too high in all 15 reported cases, meaning brokers quoted customers based on the portal and were short-changed at payout. The affected products are all in one product family that received a rate-table update approximately 3-4 weeks ago — timing aligns with symptom onset. The user declined to name the product family or the specific update.

## Business Goal

*Why this problem matters at the business level — beyond the immediate symptom.*

- **Strategic driver:** Broker trust in the portal. If brokers cannot rely on displayed rates, they will either start double-checking every rate against another source (slow) or stop using the portal (defeats its purpose).
- **Value at stake:** Loss of broker engagement with the portal as a primary channel; degraded broker-quoting workflow. [Assumption — magnitude not quantified.] Regulatory exposure on commission disclosure accuracy is also flagged. [Open question — applicable regulation and risk-of-finding not confirmed.]
- **Time sensitivity:** Symptom is active and complaints are accumulating. No external deadline stated.

## Current Condition
What is observably happening today.

- **Who is affected:** Brokers using the broker portal to quote customers on products in the affected product family. The broker support team handling the inbound complaints.
- **How often / how much:** ~15 broker complaints in the last ~3 weeks. All 15 in the same direction: portal displayed a rate higher than the rate that actually paid out. Unknown whether unreported cases of under-display exist.
- **Concrete pattern:** Broker reads rate from portal → quotes customer → policy is issued → actual commission paid is lower than displayed rate → broker feels short-changed and complains.
- **Current workaround:** _None provided._ [Open question — whether brokers are already manually verifying rates against another source was not confirmed.]

## Target Condition
Single tier (minimum acceptable; user did not provide a stretch tier).

- **Minimum acceptable:** Portal-displayed rate matches the rate that actually pays out. Zero new complaints of this type in a 4-week observation window after the fix. Brokers do not need to manually verify rates against another source.

## Suspected Causes (hypotheses, not conclusions)
- [Hypothesis] Wrong values were entered into the rate table during the update that went live ~3-4 weeks ago. Timing alignment between the update and symptom onset is the basis. Not tested — would require comparing the live table values against source-of-truth rates.

## Scope
**In scope:** Wrong commission rates displayed in the broker portal for the affected product family; restoration of rate-display correctness to baseline.

**Out of scope:** _None provided._ [Open question — explicit out-of-scope items were not discussed in this session.]

## Constraints
_None provided._

## Stakeholders
*Who is involved in the problem and its resolution.*

_None provided._

## Impacted Capabilities & Systems

*Free-text, no formal taxonomy required.*

**Capabilities:**
_None provided._

**Systems:**
_None provided._

## Likely next step
Spike. Half a day to compare the rate-table values against the correct rates and confirm or refute the hypothesis. If confirmed, next step is a Standard fix (correct values, re-deploy). If refuted, return to broader investigation.

## Open Questions & Assumptions
- [Open question] Which product family is affected (user declined to name).
- [Open question] Which specific rate-table update is suspected, and who pushed it.
- [Open question] Are there unreported cases of *under*-display (portal rate lower than actual payout)?
- [Open question] What is the applicable regulation on commission disclosure accuracy, and what is the risk of a finding?
- [Open question] Are brokers already manually verifying rates against another source as an informal workaround?
- [Open question] Stakeholder names, owning teams, and decision authorities.
- [Open question] Which systems sit behind the broker portal (rate table, pricing engine, payout system).
- [Open question] What constraints apply (regulatory, contractual, technical, organisational).
- [Hypothesis] Wrong values in the new rate table is the leading hypothesis; not tested.
- [Assumption] The timing alignment between the rate-table update and symptom onset is sufficient to flag the update as the leading suspect; this is a circumstantial inference, not a verified causal link.

## Coaching Notes
- Tier-3 flag: Out-of-scope is empty. Rendered `_None provided._` with [Open question] entry.
- Tier-3 flag: Stakeholders, Constraints, and Impacted Capabilities & Systems sections were not populated because the user explicitly stated "nothing to add" for all three. Per spec, the coach did not probe further or invent content.
- The session produced a tightly scoped problem with clean trigger, magnitude, target, and one testable hypothesis. Ready for handoff to a Spike-led investigation.
