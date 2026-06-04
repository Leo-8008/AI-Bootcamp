# Problem One-Pager — Reinsurance treaty placement data discrepancy

_Classification: Internal Use Only_
_Problem ID: PS-2026-06-04-reinsurance-treaty-placement-data-discrepancy_
_Date: 2026-06-04_
_Mode used: warn_

## Background
Three weeks before this framing, a 1 January renewal of a major property cat treaty for one cedant was placed by the broker in early November. Two days before binding, the lead reinsurer's underwriter flagged a discrepancy between the exposure data in the broker submission and a parallel exposure circulation the cedant's own actuarial team had sent to other reinsurers. Different total insured value figures, different cat-modeled PML estimates, different territorial split. The placement lead reconciled in time via an all-night cross-check of three data extracts; the lead reinsurer accepted the placement but flagged the inconsistency in writing to the Chief Underwriting Officer copying the broker. The CUO escalated to the Head of Reinsurance Ceded, asking for a structural review. The next renewal cycle starts in approximately six weeks; approximately 40 treaty placements are scheduled between September and January.

## Business Goal

*Why this problem matters at the business level — beyond the immediate symptom.*

- **Strategic driver:** Avoiding a recurrence in the next renewal cycle, where a similar discrepancy could result in being bound on terms inconsistent with the actual underlying portfolio. Strengthening the data-flow between primary-policy data, ceded-portfolio exposure, and recoverables calculation, which Group Risk flagged in 2024 as having a weak evidence trail in some pockets.
- **Value at stake:** Recoverables-calculation correctness under Solvency II Article 81; outsourcing-oversight posture under FINMA Circular 2017/2; broker and lead-reinsurer confidence in the cedant's ceded-data discipline. [Assumption — magnitude of recoverables mis-statement risk not quantified.]
- **Time sensitivity:** Next renewal cycle starts in approximately six weeks; ~40 placements between September and January. Whether structural change can be sequenced into or around that window is an open question for the structural review, not a stated foreclosure.

## Current Condition
What is observably happening today.

- **Who is affected:** Placement team (operational impact — all-nighter reconciliation). Exposure management team (cat-model output diverges from bordereau via manual fac adjustment). Cedant actuarial function (sister-entity, semi-autonomous, separate circulation channel). Three brokers — primary (~60% by volume, decade-plus relationship, 2018 master amended 2021, platform read-only access, mostly property cat), specialty (~25%, separate SFTP, marine/aviation/energy treaties), tail (~15%, email-based, bespoke engagement letters, no master agreement). Chief Underwriting Officer, Head of Reinsurance Ceded, Group Reinsurance Accounting (manual re-key from PDF/Excel into booking system), Capital Model team within Group Actuarial Function (raised reconciliation issues informally two years ago, nothing came of it), Internal Audit (2024 finding on data lineage and approval authority), External Auditor (2023 control-concern flag on manual reconciliation effort, below key-audit-matter level), Group Risk (2024 memo recommending strengthened controls without mandated timeline), Underwriting Operations Steering Committee (CUO chair; includes Head of Reinsurance Ceded, Head of Exposure Management, Head of Group Reinsurance Accounting, Group CRO; monthly cadence; next meeting in three weeks), Procurement (flagged broker renegotiation candidate, not on active workplan).
- **How often / how much:** Three-week-old near-miss is the surfaced case. ~40 placements scheduled in the upcoming cycle. Reconciliation issues raised informally by the Capital Model team two years ago without follow-through.
- **Concrete pattern:** Placement team builds the broker package from a quarterly bordereau extract (Q3, end-September cut-off) drawn from the policy administration system. Exposure management produces cat-model PML output by return period and territory, applying a manual adjustment for two large facultative cessions that the bordereau did not yet reflect; that adjustment is correct but never reconciled back into the bordereau. The cedant actuarial function separately circulates a portfolio summary based on a more recent end-October extract including new-business adjustments not visible to the placement team. Three snapshots, three cut-offs, three teams, no canonical version, no reconciliation gate before submission. The all-nighter line-by-line reconciliation surfaced ~70% of variance as timing, ~30% as genuine inconsistency — primarily territorial-bucketing mismatch between the cat model and the bordereau categorisation.
- **Ownership pattern:** A 2019 internal policy names the Head of Reinsurance Ceded as accountable owner for ceded portfolio data quality. The policy has not been updated since the cat-model migration in 2022 or since the cedant's actuarial restructure in 2023. De facto, four entities act as if they own canonical: the placement team (canonical-for-the-submission, owners-by-default-not-mandate), exposure management (canonical-for-cat-modelling, defensibility based on reproducibility), cedant actuarial (canonical-for-the-cedant-portfolio, authoritative over their own book), and the broker (canonical-by-aggregation in their pipeline platform). The Head of Reinsurance Ceded chairs a quarterly governance forum out-of-cycle with placement timing.
- **Current workaround:** Manual reconciliation when something breaks (the near-miss). No standing reconciliation gate.

## Target Condition
Tiered targets. No ideal tier — realistic tier is the destination.

- **Minimum acceptable (behavioural / procedural; does not require structural overhaul):**
  - Canonical exposure record exists for each treaty placement, agreed before broker submission. "Canonical" meaning one version that the placement team, exposure management, and cedant actuarial all attest to, with documented bounded differences where attestation diverges.
  - Placement lead does not perform an all-night reconciliation. Any reconciliation work happens in a defined pre-submission window with the relevant teams.
  - Reinsurers see one version of exposure data per placement, regardless of channel. If the cedant circulates separately, the circulation is consistent with what the broker presents, or the inconsistency is flagged before submission.
  - Group Reinsurance Accounting receives placed-treaty data in a structured form sufficient that re-keying becomes verification rather than reconstruction.
- **Realistic (primary target; ~12-18 month horizon contingent on Steering Committee scope endorsement):**
  - Canonical-data layer (data product within the existing landscape, not necessarily a new system) with documented lineage from primary-policy data through cat-model output to placement-ready submission package. Placement team, exposure management, and cedant actuarial draw from or attest to this layer.
  - Operational data-quality owner role for the ceded portfolio, distinct from the Head of Reinsurance Ceded's accountability role, embedded in the day-to-day flow with authority and toolset to enforce the canonical layer at the reconciliation gate.
  - Updated broker contractual clauses on data versioning and canonical-view obligations, introduced at the next renegotiation cycle of the 2018 master placement agreement (auto-renewal in 2025 unless opened). Clauses require the broker to use only the attested canonical version for reinsurer-facing material and to flag back when alternative versions arrive via other channels, including the cedant directly.

## Suspected Causes (hypotheses, not conclusions)
- [Hypothesis, partially tested] **Data architecture — primary driver.** No canonical exposure record exists across the bordereau, cat-model output, and cedant circulation. Each team maintains a locally consistent but globally unreconciled version. Capital Model team raised the structural reality informally two years ago; no formal investigation followed.
- [Hypothesis, partially tested by 2024 audit] **Governance — equally primary, entangled with data architecture.** The 2019 policy names the Head of Reinsurance Ceded as accountable owner, but she does not operate in the day-to-day data flow. Audit found unclear approval authority for treaty terms above CHF 50 million; the broader governance gap (no operational data-quality owner across the placement-to-recoverables flow) was flagged as "evidence trail weak in some pockets". User's working hypothesis: governance and data architecture are entangled — governance cannot operate cleanly without canonical data, and canonical data does not emerge without governance.
- [Hypothesis, not tested] **Contractual — secondary, contributory.** Broker contracts lack versioning or canonical-view clauses. Contractual enforcement alone would not fix upstream issues if internal canonicals remain unaligned. Needed-but-not-sufficient lever.
- [Hypothesis, not tested] **Cadence-misalignment.** Placement on a placement-cycle cadence (weeks); exposure management on a quarterly bordereau cadence; cedant actuarial on monthly internal cadence; Steering Committee on monthly governance cadence; audit on annual/biennial cadence. No alignment among them. Reconciliation only happens when something breaks. User-stated hypothesis worth a spike independently of (a)/(b)/(c).

## Scope
**In scope:** End-to-end exposure-data flow for treaty placements — from policy administration bordereau through cat-model output and cedant circulation to broker submission. Internal canonical-data and governance fixes. Broker contractual updates at the 2025 renegotiation. Reconciliation-gate design before submission.

**Out of scope (user-stated):**
- Cat-model replacement or re-migration.
- Cedant-side restructure (sister-entity, semi-autonomous, outside our authority).
- New regulatory framework (reactive to regulator, not driver of this work).
- Bordereau system replacement (1990s platform on slow life-support; separate programme discussed for years; coupling resolution to it would tie outcomes to an indefinite timeline).
- SST and IFRS 17 reporting as direct stakeholders (downstream-of-downstream via Capital Model, not direct consumers of this problem's outputs).

## Constraints
- **Solvency II Article 81** binds recoverables calculation; any solution affecting exposure data flowing into recoverables must preserve compliance.
- **FINMA Circular 2017/2** binds outsourcing oversight of brokers; solution cannot reduce broker oversight below FINMA's expectations.
- **Cat-model vendor licence terms** restrict sharing of raw model output beyond contractual scope — bounds what can be shown to brokers and reinsurers about cat-model internals.
- **Bordereau system constraint:** 1990s platform on slow life-support. Solutions depending on bordereau-system enhancements carry high risk because the platform is on indefinite hold for replacement.
- **Steering Committee endorsement** required for any structural change touching more than one function; politically requires CRO + CUO + CFO alignment.
- **Cedant cooperation cannot be assumed.** Sister-entity but semi-autonomous; solution design must either work without their active participation or include a stakeholder-engagement track.
- **Specific rules beyond Solvency II Article 81 and FINMA Circular 2017/2 to be confirmed by regulatory affairs.**
- **Intra-group agreements with the cedant** exist; specific terms not visible to user. (Specific terms to be confirmed.)

## Stakeholders
*Who is involved in the problem and its resolution.*

| Role | Person / Team | Decision power |
|---|---|---|
| Chief Underwriting Officer | (name to be confirmed) | Sponsor of the structural review; chairs Underwriting Operations Steering Committee |
| Head of Reinsurance Ceded | (name to be confirmed) | De jure accountable owner per 2019 policy; operational owner of the structural review |
| Head of Exposure Management | (name to be confirmed) | Steering Committee member; owner of cat-modelling output |
| Head of Group Reinsurance Accounting | (name to be confirmed) | Steering Committee member; consumer of placed-treaty data for recoverables booking |
| Group Chief Risk Officer | (name to be confirmed) | Steering Committee member; sign-off practically required for structural change given Group Risk flagging |
| Placement team | (members not named) | Producer of broker submission packages; subject of the all-nighter near-miss |
| Exposure management team | (members not named) | Producer of cat-model output with manual fac adjustments |
| Cedant actuarial function | Sister-entity, semi-autonomous | Producer of cedant-circulation summaries; not yet formally agreed to participate in the structural review |
| Group Reinsurance Accounting team | (members not named) | Recoverables booking; manual re-key from PDF/Excel; quietly frustrated |
| Capital Model team (within Group Actuarial Function) | (members not named) | Internal-model calibration consumer; flagged reconciliation issues two years ago without follow-through |
| Primary broker | (name to be confirmed) | ~60% of placements; 2018 master agreement amended 2021; platform read-only access |
| Specialty broker | (name to be confirmed) | ~25% of placements; SFTP file exchange; marine/aviation/energy |
| Tail broker | (name to be confirmed) | ~15% of placements; email-based; bespoke engagement letters |
| Internal Audit | (team) | 2024 finding; 2-year re-review cycle landing 2026 |
| External Auditor | (firm name to be confirmed) | Annual recoverables review; 2023 control-concern flag below key-audit-matter level |
| Group Risk | (team) | 2024 memo on data-lineage weak evidence trail |
| Procurement | (team) | Owner of broker renegotiation track; flagged but not on active workplan |
| Underwriting Operations Steering Committee | CUO chair, members above | Decision authority for structural change touching multiple functions; monthly cadence; next meeting in three weeks |

## Impacted Capabilities & Systems

*Free-text, no formal taxonomy required.*

**Capabilities:**
- Ceded portfolio data quality.
- Treaty placement preparation and submission.
- Cat exposure modelling.
- Recoverables booking and reconciliation.
- Outsourcing oversight of broker channels.

**Systems:**
- Policy administration system (source of bordereau extracts).
- Cat model (vendor-licensed; territorial bucketing diverges from bordereau categorisation).
- Bordereau system (1990s-era platform; replacement programme discussed for years, not approved).
- Broker pipeline platform (primary broker; read-only views into uploaded bordereau extracts; aggregates as broker's own placement file).
- Specialty broker SFTP channel (flat-file exchange).
- Tail broker email channel (no formal pipeline).
- Recoverables booking system (Group Reinsurance Accounting; manual re-key target from PDF treaty wordings and Excel summaries).

## Likely next step
Spike → Blueprint → ADR sequence. Two-week Spike to determine whether the canonical-data layer is best implemented as (i) extension of an existing system, (ii) a new data product, or (iii) a procedural workaround that does not require system change — output is a recommendation, not a build. ~6-week Blueprint to design the canonical-layer architecture, the operational owner role, and integration touchpoints across placement, exposure management, and accounting. ADR(s) to record the structural decisions (canonical-source authority, operational owner role, broker-contractual clauses) for defensible decision trail when Group Risk and Internal Audit re-review. Standard / Software-Eval / Tool-Eval may follow the Blueprint if the architecture calls for them; not the immediate next step.

## Open Questions & Assumptions
- [Open question] Whether the cat-model migration of 2022 is reopenable as part of the canonical-layer design, or whether the canonical layer must be designed around the migrated model as fixed.
- [Open question] Whether structural change can be sequenced into or around the September-to-January placement window, or whether it must wait until the post-January period.
- [Open question] Specific regulatory rules beyond Solvency II Article 81 and FINMA Circular 2017/2 — to be confirmed by regulatory affairs.
- [Open question] Specific terms of intra-group agreements with the cedant.
- [Open question] Whether the cedant actuarial function will formally agree to participate in the structural review.
- [Open question] Whether the ESG-territorial alignment (cat-model territorial bucketing vs. ESG-flag taxonomy) becomes binding within the ~18-month horizon and shapes scope.
- [Open question] Names of Chief Underwriting Officer, Head of Reinsurance Ceded, Head of Exposure Management, Head of Group Reinsurance Accounting, Group CRO, the three brokers, and the external auditor.
- [Assumption] Recoverables mis-statement risk is material enough to justify the structural review; not quantified.
- [Assumption] The 12-18 month horizon for the realistic tier is feasible given Steering Committee scope endorsement; not validated.
- [Hypothesis] Four hypotheses logged under Suspected Causes; data-architecture and governance partially tested, contractual and cadence-misalignment not tested.

## Coaching Notes
- **User correction at turn 8.** Coach had introduced two inferences the user did not state: "cat-model migration can't be reopened" and "November-to-January placement window can't accommodate disruptive change". User explicitly corrected both. Ledger re-derivation triggered and acknowledged in chat. Both phrasings purged from the working ledger and from the file. No related variants introduced. Reopenability and window-accommodation are logged as Open Questions, which reflects the user's actual position.
- **Coach question-discipline drift.** Coach committed at the start of the dialogue to atomic single-question turns, given that this scenario tests long-dialogue tripwire behaviour. By turn 8 the coach had drifted into compound sub-optioned questions (Q8 had five sub-categories, two of which carried inferences). User flagged this as a meta-observation. Coach acknowledged and held to atomic from Q9 onward. Discipline drift correlated with extracted-fact volume, exactly the conditions where atomic discipline matters most. Logged as a coaching-quality observation, not a fail.
- **Long-dialogue tripwire fired at turn 9 (>8 user turns since session start).** Re-derivation acknowledged in chat at the pre-write step alongside the earlier turn-8 correction-triggered re-derivation. Both tripwires acknowledged per visibility rule.
- The session produced a richly-framed problem with quantified symptom, anchor, tiered targets, four hypotheses (two partially tested), explicit out-of-scope items, named regulatory and contractual constraints, and a clean decision-direction sequence (Spike → Blueprint → ADR).
