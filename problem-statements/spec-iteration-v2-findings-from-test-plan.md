# Spec Iteration v2 — Findings from Hardened-Coach Test Plan

_Classification: Internal Use Only_
_Source: Test plan run on 2026-06-04 against `.claude/agents/problem-framing-coach.md` after the visibility-rule mini-patch._
_Status: Findings inventory only. No spec changes. Human review decides which findings get patched._

---

## Executive Summary

Five scenarios (A, D, E, C, B) were run sequentially against the hardened problem-framing-coach. All five passed their primary pass criteria. Anti-fabrication mechanisms — Fact Ledger, Domain-Eigenname Guard, Tier 2 cascade rules, Indexed Provenance Check, the patched tripwire visibility rule — held across rich, vague, medium-rich, correction-triggered, and long-dialogue regimes.

The test plan surfaced **18 spec findings** plus one positive validation of the pre-Scenario-A visibility-rule patch.

**One implementation gap is reproducible and consequential**: the fact-density tripwire axis is described in the spec but not exhibited in coach behaviour. Across all five scenarios the coach tracked only the turn-count axis. In Scenario B (~290 facts across 11 turns), the tripwire fired only via turn-count and only because the dialogue crossed turn 9. Without the user correction at turn 8 and under 8 turns, density alone would not have fired.

**One coaching-quality issue is real**: atomic-commitment drift correlated with input-richness peaks. When the coach pre-committed to atomic single-question turns at the start of a long dialogue (Scenario B), it drifted to compound sub-optioned questions by turn 8 — exactly when atomic discipline mattered most.

**Three behaviours emerged as stable across scenarios** and should be documented as expected, not emergent: variant-immunisation after correction (Scenarios C and B), pre-write tripwire-status announcement even when no fire (Scenarios E, C, B), and atomic-vs-compound question calibration to input richness (Scenarios A, D, E, C).

The remaining findings cluster into spec clarifications around re-derivation timing, visibility-rule completeness, type-system gaps in the Fact Ledger, scope-boundary distinctions (constraint vs. concern; place-of-symptom vs. system), and dialogue-flow rules.

Recommended patching sequence: Tier 1 first (fact-density axis + atomic-commitment-drift rule), then Tier 2 clarifications grouped by topic cluster, then Tier 3 documentation of expected behaviours.

---

## Tier 1 — Must Fix

### T1.1 — Fact-density tripwire axis not implemented

- **Source:** Scenario B (cross-checked against A, D, E, C).
- **Reproduction status:** Cross-scenario. Confirmed not-tracked in all five scenarios; consequential only in B.
- **Description:** The Context-Length Tripwire spec section names a turn-count axis (>8 user turns) and a mechanical ledger-membership lookup-failure axis. It does NOT name a fact-density axis as a primary trigger. The test plan's Scenario B watch points anticipated a density axis ("push past 12 user turns ... ~3 numbers per turn, ~2 named entities per turn"). Coach behaviour matched the spec literally — only turn-count and ledger-lookup-failure axes were tracked.
- **Why this matters:** In a production session under 8 turns with high per-turn fact density and no user correction, drift would be entirely undetected by tripwires. Scenario B accumulated ~290 facts; the tripwire fired only because the turn count crossed 9.
- **Spec wording suggestion (open):**
  > **Fact-density tripwire (additive trigger):** Re-derive the Fact Ledger when N consecutive user turns each carry more than M extracted facts, where N and M are calibration parameters. Suggested initial calibration: N=3, M=15 (i.e. three consecutive turns of >15 facts each). The threshold should be empirically tuned; conservative values prefer false-positive re-derivations over silent drift.
- **Open calibration questions:** Initial N and M values; whether facts are counted post-deduplication; whether the threshold resets at re-derivation.

### T1.2 — Atomic-commitment drift on long dialogue

- **Source:** Scenario B, turn 8 (user meta-observation alongside fact corrections).
- **Reproduction status:** Single-source (B), but consistent with the A/D/E/C compound-ask pattern.
- **Description:** When the coach pre-commits to atomic single-question turns at the start of a dialogue (because the dialogue is expected to be long, e.g. tripwire test), drift to compound sub-optioned questions is a coaching-quality failure, not emergent calibration. In Scenario B the coach committed to atomic in Q1 and drifted by Q8, where one question carried five sub-categories, two of which contained inferences the user had not stated. The user caught both the inferences and the discipline drift in the same turn.
- **Distinction from A/D/E/C compound-ask pattern:** In scenarios without an atomic pre-commitment, compound asking emerged as a calibration heuristic (more bundled when input is structured, more atomic when input is sparse). That is emergent calibration. In Scenario B it was a violated commitment.
- **Why this matters:** Discipline drift correlated with extracted-fact volume — exactly the conditions where atomic discipline matters most for fact-fabrication risk.
- **Spec wording suggestion (open):**
  > **Atomic question commitment.** When the coach pre-commits to atomic single-question turns for a specific dialogue (e.g. when the user signals that the dialogue will be long, complex, or fact-rich), drift to compound multi-part questions is a coaching-quality failure. The coach MUST hold to atomic until the user releases the commitment. Failure to hold is logged in Coaching Notes. This rule does NOT apply when no commitment was made — in such dialogues, compound asking calibrated to input richness is acceptable (see T3.3).

---

## Tier 2 — Should Clarify

Eleven findings, grouped by topic cluster.

### Cluster A — Re-derivation timing and completeness

#### T2.A.1 — Re-derivation triggered mid-session: extraction window

- **Source:** Scenario B, turns 9-11 (post-correction, post-tripwire write).
- **Reproduction status:** Single-source.
- **Description:** When re-derivation is triggered mid-session (e.g. by a user correction at turn 8 or by the long-dialogue tripwire firing at turn 9), the spec does not specify whether re-derivation re-extracts facts from ALL turns through the pre-write step, or freezes at trigger-event time. In Scenario B the coach acknowledged both tripwires at the pre-write step but did not assign F-indices to user-stated facts from turns 9-11 (target-condition tier statements, out-of-scope items, decision direction). Part B traced these as "turn-N user statement" rather than as F-entries. Functional but spec-non-compliant.
- **Spec wording suggestion (open):**
  > **Re-derivation extraction window.** When a tripwire fires mid-session, re-derivation re-extracts the Fact Ledger from the full raw dialogue up to and including the most recent user turn before file write. Re-derivation is a snapshot at file-write time, not at trigger-event time. All user-stated facts through pre-write receive sequential F-indices.
- **Recommendation:** Adopt the "extract through pre-write" reading.

#### T2.A.2 — Audit-annotation placement for purged fabrications

- **Source:** Scenario C, post-write.
- **Reproduction status:** Single-source (C); resolved by coach's own iteration note in Scenario B (Part A clean of purged content).
- **Description:** In Scenario C, the coach introduced a "Purged at re-derivation" annotation in Part A of the Provenance Check, listing the corrected fabrications outside the active ledger for audit transparency. In Scenario B the coach moved the equivalent audit content to Coaching Notes, leaving Part A clean. Spec is silent on placement.
- **Spec wording suggestion (open):**
  > **Purged-fabrication audit placement.** Correction events (user-flagged fabrications and their purging) are recorded in Coaching Notes, NOT in Part A of the Provenance Check. Part A remains a positive-fact ledger; the audit value of the correction is preserved through Coaching Notes' explicit log. This avoids re-presenting the fabricated names in any provenance context.
- **Recommendation:** Adopt; matches the Scenario B handling.

#### T2.A.3 — Pre-write tripwire summary: brevity vs. audit-completeness

- **Source:** Scenario B, pre-write summary.
- **Reproduction status:** Single-source (B), with B asking the question explicitly.
- **Description:** Coach asked whether the pre-write tripwire summary should prefer brevity ("ledger re-derivation triggered (turn 9 long-dialogue)") or audit-completeness ("turn 8 correction tripwire fired and was actioned; turn 9 long-dialogue tripwire fires now; re-deriving from raw dialogue"). User answered: audit-completeness.
- **Spec wording suggestion:**
  > **Pre-write tripwire summary.** The pre-write summary lists ALL in-session tripwire fires (both closed and currently-firing), each as one factual line. Tripwire events are session-level audit artifacts; brevity is the wrong optimisation. Each line names the trigger (turn-count, ledger-membership lookup failure, user correction, fact-density) and the turn at which it fired.

### Cluster B — Visibility rule extensions

#### T2.B.1 — Pre-write tripwire-status announcement (positive case)

- **Source:** Scenario E (proactive announcement when no fire), reinforced by C and B.
- **Reproduction status:** Cross-scenario (E, C, B).
- **Description:** The patched visibility rule (applied before Scenario A) mandates announcement only WHEN a tripwire fires. In Scenarios E, C, and B, the coach proactively announced tripwire status before each write regardless of whether a fire had occurred ("4 user turns since session start; under 8-turn threshold; no tripwire fires"). This exceeds the patched rule's requirement.
- **Spec wording suggestion:**
  > **Positive tripwire-status announcement.** The pre-write step announces tripwire status in chat regardless of whether any tripwire has fired. Format: one factual line stating turn count, threshold status, and any prior-in-session fires. This strengthens auditability at zero cost.
- **Recommendation:** Promote the emergent positive-case announcement to a spec rule.

#### T2.B.2 — Predictive tripwire-announcement at threshold edge

- **Source:** Scenario B, turn 8 (coach announced "Long-dialogue tripwire armed at >8 — next user turn will trigger it").
- **Reproduction status:** Single-source (B).
- **Description:** The coach announced a tripwire was armed and would trigger on the next turn, before the trigger occurred. Spec does not name this behaviour. It is a useful auditability extension but may be over-eager in some dialogues (e.g. predicting a tripwire that never fires because the user ends the session at turn 8).
- **Spec open question:**
  > Should the coach announce armed-but-not-yet-fired tripwires? Pro: audit transparency, user can choose to wrap up before re-derivation. Con: noise when the dialogue ends without crossing the threshold.
- **Recommendation:** Make optional; allow coach discretion.

### Cluster C — Type system gaps

#### T2.C.1 — `[explicit-absence]` Fact Ledger type

- **Source:** Scenario D, reinforced by E and B.
- **Reproduction status:** Cross-scenario.
- **Description:** Vague-input sessions (D) and mixed sessions (E, B) produce ledger-bearing user statements that are *facts about what is NOT known or NOT present*. Examples: "no OKR", "no formal SLA", "user explicitly disclaimed profit-margin framing". The seven defined F-types (number, entity, event, quote, relationship, date, constraint) do not cover these cleanly. Coach introduced an ad-hoc `[explicit-absence]` tag in Scenario D and used it consistently in E and B.
- **Why dropping is wrong:** Without these entries, many `_None provided._` placeholders in the file body become un-traceable to the Provenance Check, breaking the Tier 2 ledger-membership invariant.
- **Why folding into [quote] is wrong:** It distorts the [quote] type, which is for verbatim user speech, not for facts-about-absence.
- **Spec wording suggestion:**
  > **Fact Ledger type — `[explicit-absence]`.** Add as the eighth F-type. Used when the user explicitly states that something is not known, not present, not measured, not stated, or explicitly disclaimed. Format identical to other F-types: `F<n>. [explicit-absence] "<verbatim or paraphrase>" — turn <n>`.
- **Recommendation:** Formalise as 8th type.

#### T2.C.2 — Domain-Eigenname Guard scope: parenthetical examples

- **Source:** Scenario D, Open Questions section ("CSAT survey, NPS, complaint log, support ticket review").
- **Reproduction status:** Single-source (D); latent risk in any session.
- **Description:** The Domain-Eigenname Guard rule says "every domain eigenname in the file traces to an F-entry". In Scenario D the coach used parenthetical examples ("CSAT survey, NPS, ...") in an Open Question to illustrate *types of channels the user could consult*, not to claim those channels exist in the user's organisation. The Guard's spirit is satisfied (no claim is made about the user's environment), but the literal rule does not distinguish.
- **Spec wording suggestion:**
  > **Eigenname-Guard scope.** The Guard applies to body-fact claims and stakeholder/system enumerations. It does NOT apply to parenthetical examples used in coaching questions, Open Questions, or scaffolding text where the parenthetical is clearly illustrative ("e.g. ...", "(such as ...)") and makes no claim about the user's environment. The illustrative function must be syntactically explicit.
- **Recommendation:** One-line clarification.

### Cluster D — Scope-boundary distinctions

#### T2.D.1 — Constraint vs. Concern distinction

- **Source:** Scenario E, F28 ("commission disclosure has to be accurate").
- **Reproduction status:** Single-source (E); coach handled correctly without spec guidance.
- **Description:** The user named a regulatory dimension ("commission disclosure has to be accurate") but did not state it as a binding constraint on solution design (the applicable regulation was unknown, F30). The coach logged it under Business Goal regulatory-exposure rather than Constraints. Spec is implicit on this distinction.
- **Spec wording suggestion:**
  > **Constraint vs. Concern.** Constraints are what BINDINGLY limits solution design — known rules, contracts, technical boundaries, organisational mandates that any solution must respect. Concerns and risks without binding force (named regulation unknown; potential exposure not quantified) belong in Business Goal (as value-at-stake) or Open Questions, not in Constraints. The Constraints section should be readable as "any solution must satisfy these bindings"; if a candidate item does not satisfy that read, it is not a Constraint.
- **Recommendation:** One-line clarification.

#### T2.D.2 — Place-of-symptom vs. system enumeration under Impacted Capabilities & Systems

- **Source:** Scenario E (broker portal as place-of-symptom, declined enumeration of underlying systems).
- **Reproduction status:** Single-source (E); latent in any session where user declines system enumeration.
- **Description:** The user named "broker portal" as the location-of-symptom but explicitly declined to enumerate the systems behind the portal. The coach chose the conservative reading: place-of-symptom stayed in Background and Current Condition; the Systems sub-heading rendered `_None provided._`. Spec did not mandate this reading.
- **Spec wording suggestion:**
  > **Place-of-symptom vs. system enumeration.** The Impacted Systems sub-heading lists systems the user has explicitly enumerated as relevant. A place-of-symptom (the application, portal, or surface where the symptom appears) is recorded in Background or Current Condition without automatically being promoted to the Systems sub-heading. If the user declines to enumerate underlying systems, Systems renders `_None provided._` — even when a place-of-symptom is named. This matches the Eigenname-Guard's spirit: the user's enumeration is authoritative, not the coach's inference of what counts as a system.
- **Recommendation:** One-line clarification.

### Cluster E — Capabilities and dialogue flow

#### T2.E.1 — Step 12 (Capabilities) dialogue probe handling

- **Source:** Scenario A, post-run.
- **Reproduction status:** Single-source (A); recurred implicitly in B (Capabilities populated by inference rather than explicit probe).
- **Description:** Coaching-flow step 12 ("Capabilities & Systems — ask exactly once, accept skip") was skipped as an explicit dialogue question in Scenario A. The Capabilities sub-heading rendered `_None provided._` while Systems was extracted from earlier dialogue context. Functionally correct, but a defined coaching step was implicitly dropped. In Scenario B, Capabilities was populated by coach inference from the dialogue without an explicit probe.
- **Spec open question:**
  > Should step 12 always be asked once explicitly, even when Systems content has already emerged from the dialogue? Or is it acceptable to skip the explicit probe when both sub-sections can be populated (or rendered `_None provided._`) from existing context?
- **Recommendation:** Decide explicitly. If the explicit probe is required, the spec should say so; if discretionary, the spec should say that too.

#### T2.E.2 — Stakeholder-table provenance discipline

- **Source:** Scenario A.
- **Reproduction status:** Single-source (A); not retested in later scenarios.
- **Description:** The Stakeholders table includes a "Decision power" column populated by coach inference (e.g. "None on the reporting design; producers of the data" for handlers in Scenario A). This is coach-inferred mapping, not user-stated, and was not tagged `[Coach-inferred]` in the file. Spec is ambivalent on whether stakeholder-role mapping requires the same provenance discipline as body-fact sentences.
- **Spec open question:**
  > Should stakeholder-role mappings (the "Decision power" column) carry `[Coach-inferred]` tags in the file when not user-stated, or is the table format itself a sufficient signal that role-mapping is editorial?
- **Recommendation:** Decide explicitly. If role-mappings must be tagged, update the template; if the table format is sufficient signal, document that exemption.

#### T2.E.3 — Coach-stop threshold for vague-input dialogues

- **Source:** Scenario D (coach stopped at 3 questions / 3 vague answers, well within tolerance).
- **Reproduction status:** Single-source (D); behaviour was correct.
- **Description:** Spec rule is implicit: "no 5th probing question after 2 vague answers". Coach stopped earlier (after 3 vague answers). Tightening the rule to explicit "stop after N consecutive vague answers, recommend N=3" would be clearer and prescriptive.
- **Spec wording suggestion:**
  > **Vague-input stop threshold.** When N consecutive user answers fail to provide quantification, named entities, or concrete observation (i.e. are "vague" per the red-flag detector), the coach stops probing the same dimension and accepts-and-tags. Recommended N=3. The remaining Open Questions are logged in the file rather than asked again.

#### T2.E.4 — Concern-vs-problem early-abort behaviour

- **Source:** Scenario D (coach proactively wrote a "concern, not problem" file rather than mechanically completing the flow).
- **Reproduction status:** Single-source (D); positive emergent behaviour.
- **Description:** Coach proactively committed to ending the session and writing a concern-not-problem file when 3+ consecutive `_None provided._` projections for mandatory sections were imminent. This is coaching-flow strength that the spec implies but does not explicitly enable.
- **Spec wording suggestion:**
  > **Concern-not-problem early write.** If the coaching dialogue produces 3+ consecutive `_None provided._` projections for mandatory sections (typically Current Condition, Target Condition, Stakeholders), the coach SHOULD recommend ending the session and writing a concern-not-problem one-pager rather than mechanically completing the flow. The file body documents what is not yet known; the Coaching Notes flag the session as concern-staged. The Likely Next Step is "just-share" or "baseline-gathering before further framing".

---

## Tier 3 — Document as Expected (Stable Behaviours)

Eight findings of behaviours that emerged consistently across scenarios. They are not bugs and not gaps; they are correct behaviours the spec does not currently document. Promoting them to documented expected behaviours strengthens predictability.

### T3.1 — Variant-immunisation after correction

- **Source:** Scenarios C and B (both with explicit user corrections).
- **Reproduction status:** Cross-scenario; stable.
- **Description:** When a user corrects a fabricated domain eigenname, the coach proactively lists specific *related variants* that will not appear in the file (5 variants in C, 6 variants in B). All commitments held in both runs. This is exactly what the rebuild-from-scratch patch was meant to achieve.
- **Documentation suggestion:**
  > **Expected behaviour — variant-immunisation.** When a user corrects a fabricated name, the coach proactively names related variants (plural forms, abbreviations, synonyms, parent/child labels) that will also be excluded from the file. Variant-immunisation is part of the re-derivation acknowledgement; the coach does not wait for the user to flag each variant separately.

### T3.2 — Pre-write tripwire-status announcement (positive case)

- See T2.B.1. Promoting from emergent to documented.
- **Documentation suggestion:** Same as T2.B.1.

### T3.3 — Atomic-vs-compound question calibration heuristic

- **Source:** Scenarios A, D, E, C (calibrated to input richness without explicit commitment).
- **Reproduction status:** Cross-scenario; stable.
- **Description:** When the coach has not pre-committed to atomic, it calibrates question density to input richness — atomic when input is sparse or vague, compound when input is structured and rich. Pattern: A (rich) 3x compound, D (vague) 0x compound, E (medium) 3x compound, C (medium-high) near-total compound.
- **Distinction from T1.2:** T1.2 covers the violated-commitment case (Scenario B). T3.3 covers the no-commitment case (A/D/E/C).
- **Documentation suggestion:**
  > **Expected behaviour — question-density calibration.** Absent an explicit atomic commitment, the coach calibrates question density to input richness. Compound multi-part questions are acceptable when the user's prior answer is structured and rich enough that bundled probing accelerates without sacrificing precision. Atomic questions are preferred when input is vague, sparse, or when the user has signalled discipline-first dialogue. The calibration is heuristic, not deterministic.

### T3.4 — User-position reconstruction after correction

- **Source:** Scenarios C and B.
- **Reproduction status:** Cross-scenario.
- **Description:** After a user correction, the coach reconstructs the user's actual position (rather than only deleting the fabrication). In C, "small-commercial book" was replaced with the user's actual phrasing "small commercial submissions (a category of work, not a portfolio)". In B, "can't be reopened" / "can't accommodate" were replaced with Open Questions reflecting the user's actual position that reopenability and window-accommodation are open questions for the structural review.
- **Documentation suggestion:**
  > **Expected behaviour — user-position reconstruction.** When a fabrication is purged, the coach replaces it with the user's actual stated position, not with silence. If the user's position is "this is an open question, not a foreclosure", the file reflects that as an Open Question. If the user's position is "I said X, not Y", the file reflects X.

### T3.5 — Acknowledge-correction-without-apology

- **Source:** Scenarios C and B.
- **Reproduction status:** Cross-scenario.
- **Description:** Both correction acknowledgements were one sentence, factual, no apology padding. Pattern matches the Communication Style spec rule ("Acknowledge user corrections in one sentence maximum, then act on them").
- **Documentation suggestion:** Already in spec (Communication Style). Worth cross-referencing from the tripwire visibility rule so the two co-locate.

### T3.6 — Coach proactive abort to "concern-not-problem"

- See T2.E.4. Behaviour was correct and proactive; spec did not mandate.
- **Documentation suggestion:** Same as T2.E.4 (this finding sits in both T2 and T3 because it is both a spec gap and a stable behaviour).

### T3.7 — Provenance Check fact reproduction grouped by type

- **Source:** All five scenarios.
- **Reproduction status:** Cross-scenario; matches spec.
- **Description:** The spec specifies type-grouped reproduction in Part A (number, entity, event, quote, relationship, date, constraint). Coach applied this consistently. Worth noting as a stable behaviour, particularly since the eighth type (`[explicit-absence]`, T2.C.1) will need to be added to the grouping order if formalised.
- **Documentation suggestion:** When `[explicit-absence]` is added (T2.C.1), append it as the eighth group in Part A reproduction order.

### T3.8 — File delivery on Tier 2 cascade rule (a) (empty-from-start sections)

- **Source:** Scenarios D and E (multiple sections empty-from-start).
- **Reproduction status:** Cross-scenario.
- **Description:** When sections are empty from the start of drafting (because the user explicitly declined or did not provide content), the coach correctly applied Tier 2 cascade rule (a) — render `_None provided._`, no "N sentences removed" line in Part B, file is delivered (not blocked). This is correct per spec; worth documenting that the test plan validates the cascade-rule (a) behaviour explicitly.
- **Documentation suggestion:** Reference the test plan's Scenarios D and E as validation evidence in any future spec revision.

---

## Patching Sequence Recommendation

**Phase 1 — Tier 1 (highest priority):**
1. T1.1 Fact-density tripwire axis. Most consequential gap. Requires calibration decisions on N and M.
2. T1.2 Atomic-commitment-drift rule. Smaller spec change, but addresses a real coaching-quality regression mode.

**Phase 2 — Tier 2 clarifications grouped by topic:**
3. Cluster A (re-derivation): T2.A.1, T2.A.2, T2.A.3 — three small clarifications that share the re-derivation context.
4. Cluster B (visibility extensions): T2.B.1, T2.B.2 — promoting emergent positive-case announcement to spec; deciding on predictive announcements.
5. Cluster C (type system): T2.C.1 (8th F-type), T2.C.2 (Eigenname-Guard scope). T2.C.1 is the more substantive change because it adds a type and changes Part A grouping.
6. Cluster D (scope distinctions): T2.D.1, T2.D.2 — both are one-line clarifications.
7. Cluster E (dialogue flow): T2.E.1 through T2.E.4 — four discrete decisions.

**Phase 3 — Tier 3 documentation:**
8. T3.1, T3.2 (= T2.B.1 promoted), T3.3, T3.4, T3.5 (cross-reference), T3.6 (= T2.E.4 promoted), T3.7, T3.8.

Phases can be done in separate spec revisions if the patch surface is large.

---

## Open Spec Questions for Human Decision

These require explicit decisions before any patching can be drafted. Listed by Tier in priority order.

**Tier 1:**
1. **T1.1 calibration:** Initial values for fact-density tripwire (N consecutive turns of >M facts each). Suggested starting points: N=3, M=15. Empirical tuning to follow.
2. **T1.1 counting rules:** Are facts counted before or after deduplication? Does the count reset at re-derivation? Do `[explicit-absence]` entries count toward density?
3. **T1.2 release mechanism:** Can the user release an atomic commitment mid-dialogue? If yes, must the release be explicit?

**Tier 2:**
4. **T2.A.1 extraction window:** Confirm that re-derivation extracts through pre-write, not at trigger time.
5. **T2.B.2 predictive announcements:** Mandatory, optional, or forbidden?
6. **T2.C.1 type-system change:** Approve adding `[explicit-absence]` as the 8th F-type? If approved, decide grouping order in Part A reproduction.
7. **T2.D.1 / T2.D.2:** Approve the proposed wording for constraint-vs-concern and place-of-symptom-vs-system?
8. **T2.E.1 step-12 handling:** Always-ask, or discretionary?
9. **T2.E.2 stakeholder-role provenance:** Tag with `[Coach-inferred]`, or document role-mapping as exempt from the provenance discipline?
10. **T2.E.3 vague-input stop N:** Confirm N=3 as the recommended threshold?

**Tier 3:**
11. None require decisions; all are documentation of validated behaviours.

---

## Out of Scope for This Iteration

The following are explicitly NOT findings and NOT recommended for patching:

- **Confluence template integration** for the one-pager (already in the spec's TODO section; not a v2 finding).
- **Solution-design-assistant handoff format** beyond Problem ID propagation (out of problem-framing scope).
- **Multi-language coaching** (not exercised in the test plan; no findings).
- **Block-mode behaviour** (not exercised in the test plan; no findings).

---

## Test Plan Coverage Summary

| Scenario | Input regime | Tripwire fires | Pass criteria | Findings |
|---|---|---|---|---|
| A | Rich, structured | None | All | 3 |
| D | Vague, sparse | None | All | 4 |
| E | Medium, partial | None | All | 3 |
| C | Medium-high, with mid-dialogue user correction | Correction tripwire (turn 4) | All | 3 |
| B | Long, very rich, with mid-dialogue correction | Correction (turn 8) + long-dialogue (turn 9) | All | 5 |

**Total findings: 18.** All five scenarios passed all primary pass criteria. No fail indicators triggered in any scenario.

---

_End of report. No spec changes made. Awaiting human review for patching decisions._
