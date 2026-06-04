# Spec Patch v2 — Change Log

_Classification: Internal Use Only_
_Source: Decisions on the 10 Open Spec Questions from `problem-statements/spec-iteration-v2-findings-from-test-plan.md`._
_Target file: `.claude/agents/problem-framing-coach.md`._
_Date: 2026-06-04._

This change log lists every spec change in the patch, in finding-ID order. Each entry shows the section of the spec touched, a Before/After excerpt, and a one-line rationale referencing the test-plan source.

A high-level summary of the patch is also included as an HTML comment at the top of the patched spec file (after the frontmatter).

---

## Tier 1 changes

### T1.1 — Fact-density tripwire axis

- **Section:** Context-Length Tripwire
- **Decision applied:** N=3, M=15. Facts counted after deduplication. Counter resets at re-derivation. `[explicit-absence]` entries DO count toward density.
- **Before:**
  > Tripwires fire on (a) turn count, (b) ledger-membership lookup failure, (c) prior user-flagged fabrication.
- **After (excerpt):**
  > **Fact-density tripwire (additive trigger):** Re-derive the Fact Ledger when 3 consecutive user turns each carry more than 15 extracted facts (deduplicated). … Counter resets at re-derivation. `[explicit-absence]` entries DO count toward density.
  > Tripwires fire on (a) turn count, (b) ledger-membership lookup failure, (c) prior user-flagged fabrication, (d) fact-density.
- **Rationale:** Scenario B accumulated ~290 facts across 11 turns; without the user correction at turn 8 and under 8 turns, density alone would not have fired any tripwire (test-plan §T1.1).

### T1.2 — Atomic-commitment hold rule

- **Section:** Coaching flow → new subsection "Atomic question commitment (T1.2)"
- **Decision applied:** User can release atomic mid-dialogue, but release MUST be explicit.
- **Before:** No spec rule on atomic-commitment hold.
- **After (excerpt):**
  > The coach MUST hold to atomic until the user releases the commitment. Release MUST be explicit (e.g. *"you can bundle questions again"*). Implicit release (user answering a compound question without complaint) is NOT a release. Failure to hold is logged in `Coaching Notes`.
- **Rationale:** Scenario B turn 8 — coach pre-committed to atomic, drifted to compound 5-sub-option question carrying inferences user had not stated; user caught both the inferences and the discipline drift in the same turn (test-plan §T1.2).

---

## Tier 2 changes

### T2.A.1 — Re-derivation extraction window

- **Section:** Context-Length Tripwire → "Re-derivation extraction window"
- **Decision applied:** Adopt "extract through pre-write" reading; snapshot at file-write time.
- **Before:** Spec was silent on whether re-derivation re-extracts through pre-write or freezes at trigger time.
- **After (excerpt):**
  > When a tripwire fires mid-session, re-derivation re-extracts the Fact Ledger from the full raw dialogue up to and including the most recent user turn before file write. Re-derivation is a snapshot at file-write time, NOT at trigger-event time. All user-stated facts through pre-write receive sequential F-indices.
- **Rationale:** Scenario B turns 9-11 — user-stated facts post-tripwire were traced as "turn-N user statement" rather than as F-entries; functional but spec-non-compliant (test-plan §T2.A.1).

### T2.A.2 — Purged-fabrication audit placement

- **Section:** Indexed Provenance Check → Part A; Coaching Notes content rule
- **Decision applied:** Correction events live in Coaching Notes, not Part A.
- **Before:** Spec was silent on placement; Scenario C used Part A, Scenario B used Coaching Notes.
- **After (excerpt, Part A):**
  > **Purged-fabrication placement.** Correction events (user-flagged fabrications and their purging) are recorded in `Coaching Notes`, NOT in Part A of the Provenance Check. Part A remains a positive-fact ledger.
- **After (excerpt, Coaching Notes content rule):**
  > Coaching Notes collects (in this order, one line each): … 3. Correction events — user-flagged fabrications and their purging (T2.A.2). Note the corrected name(s) and the variants immunised; do NOT re-render the corrected names in any other provenance context.
- **Rationale:** Avoids re-presenting the fabricated names in any provenance context (test-plan §T2.A.2).

### T2.A.3 — Pre-write tripwire summary discipline

- **Section:** Context-Length Tripwire → "Pre-write tripwire summary discipline"
- **Decision applied:** Audit-completeness over brevity. List ALL in-session fires.
- **Before:** Spec named only the on-fire announcement; no rule on summary completeness.
- **After (excerpt):**
  > When fires have occurred, the pre-write summary lists ALL in-session tripwire fires (both closed and currently-firing), each as one factual line. Tripwire events are session-level audit artifacts; brevity is the wrong optimisation. Each line names the trigger axis and the turn at which it fired.
- **Rationale:** Scenario B explicit user decision: audit-completeness preferred (test-plan §T2.A.3).

### T2.B.1 — Positive (no-fire) tripwire-status announcement

- **Section:** Context-Length Tripwire → "Visibility rule for ALL tripwires"
- **Decision applied:** Promote emergent positive-case announcement to mandatory rule.
- **Before:**
  > Whenever any tripwire fires …, the coach MUST acknowledge the re-derivation in the chat output before continuing.
- **After (excerpt):**
  > Before every file write, the coach announces tripwire status in chat regardless of whether any tripwire has fired. Format: one factual line stating turn count, threshold status, and any prior-in-session fires.
- **Rationale:** Cross-scenario stable behaviour (E, C, B); strengthens auditability at zero cost (test-plan §T2.B.1, §T3.2).

### T2.B.2 — Predictive (armed) tripwire announcement

- **Section:** Context-Length Tripwire → "Predictive (armed) tripwire announcement (optional)"
- **Decision applied:** Optional; coach discretion.
- **Before:** Spec did not name this behaviour.
- **After (excerpt):**
  > The coach MAY announce armed-but-not-yet-fired tripwires when contextually useful. … This is discretionary, not required. Predictive announcement is appropriate when the user might benefit from choosing to wrap up before re-derivation; it is inappropriate as boilerplate noise.
- **Rationale:** Scenario B turn 8 — coach announced armed tripwire usefully, but boilerplate predictive announcements would be noise (test-plan §T2.B.2).

### T2.C.1 — `[explicit-absence]` Fact Ledger type

- **Section:** Fact Ledger → "What goes in the ledger" + "Format"; Indexed Provenance Check → Part A grouping
- **Decision applied:** Approved as 8th F-type. Format identical to other F-types. Appended as 8th group in Part A reproduction (after `constraint`).
- **Before:**
  > where `<type>` is one of: `number` | `entity` | `event` | `quote` | `relationship` | `date` | `constraint`
- **After (excerpt):**
  > where `<type>` is one of: `number` | `entity` | `event` | `quote` | `relationship` | `date` | `constraint` | `explicit-absence`
  > The `[explicit-absence]` type is used when the user explicitly states something is not known, not present, not measured, not stated, or explicitly disclaimed. … `[explicit-absence]` entries DO count toward fact-density tripwire calibration.
- **After (Part A grouping):**
  > entries are printed grouped by type in this order: `number`, `entity`, `event`, `quote`, `relationship`, `date`, `constraint`, `explicit-absence`.
- **Rationale:** Without this type, many `_None provided._` placeholders become un-traceable to the Provenance Check, breaking the Tier 2 ledger-membership invariant (test-plan §T2.C.1).

### T2.C.2 — Eigenname-Guard scope (parenthetical examples)

- **Section:** Domain-Eigenname Guard → "Eigenname-Guard scope (parenthetical-example exemption)"
- **Decision applied:** One-line clarification — parenthetical illustrative examples exempt; illustrative function must be syntactically explicit.
- **Before:** Rule literally applied to "every domain eigenname in the file"; did not distinguish illustrative parentheticals.
- **After (excerpt):**
  > The Guard applies to body-fact claims and stakeholder/system enumerations. … It does NOT apply to parenthetical illustrative examples ("e.g. ...", "(such as ...)") that make no claim about the user's environment. The illustrative function MUST be syntactically explicit; a bare list without "e.g." marker is treated as an enumeration claim.
- **Rationale:** Scenario D Open Questions used parenthetical examples ("CSAT survey, NPS, ...") illustratively; Guard's spirit was satisfied but literal rule did not distinguish (test-plan §T2.C.2).

### T2.D.1 — Constraint vs. Concern distinction

- **Section:** New section "Scope-Boundary Distinctions" → "Constraint vs. Concern (T2.D.1)"; Constraints template note
- **Decision applied:** Approved as worded in iteration document.
- **Before:** Spec was implicit on this distinction; Constraints section had no guidance on what does NOT belong.
- **After (excerpt):**
  > Constraints are what BINDINGLY limits solution design — known rules, contracts, technical boundaries, organisational mandates that any solution MUST respect. Concerns and risks without binding force … belong in Business Goal (as value-at-stake) or Open Questions, not in Constraints. The Constraints section must be readable as: "any solution must satisfy these bindings."
- **Rationale:** Scenario E F28 — user named regulatory dimension generically without specific applicable rule; coach correctly logged under Business Goal not Constraints (test-plan §T2.D.1).

### T2.D.2 — Place-of-symptom vs. system enumeration

- **Section:** New section "Scope-Boundary Distinctions" → "Place-of-symptom vs. system enumeration (T2.D.2)"; Impacted Capabilities & Systems template note
- **Decision applied:** Approved as worded in iteration document.
- **Before:** Spec did not distinguish place-of-symptom from system enumeration.
- **After (excerpt):**
  > The Impacted Systems sub-heading lists systems the user has explicitly enumerated as relevant. A place-of-symptom (the application, portal, or surface where the symptom appears) is recorded in Background or Current Condition WITHOUT automatic promotion to Systems. If the user declines to enumerate underlying systems, Systems renders `_None provided._` — even when a place-of-symptom is named.
- **Rationale:** Scenario E broker-portal handling — coach took conservative reading; spec did not mandate it (test-plan §T2.D.2).

### T2.E.1 — Step 12 (Capabilities & Systems) handling

- **Section:** Coaching flow → step 12
- **Decision applied:** Discretionary. Coach MAY skip when both sub-sections can be populated or rendered `_None provided._` from existing context. Deliberate skip must be logged in Coaching Notes.
- **Before:**
  > 12. **Capabilities & Systems (ask exactly once, accept skip)** …
- **After (excerpt):**
  > 12. **Capabilities & Systems (discretionary probe)** … The explicit probe is discretionary. The coach MAY skip the probe entirely when both sub-sections can already be populated (or rendered `_None provided._`) from existing dialogue context. Skipping the probe must be a deliberate choice, not silent omission. When skipped, log the choice in `Coaching Notes`.
- **Rationale:** Scenario A skipped probe with Systems extracted from prior context; functionally correct but defined coaching step was implicitly dropped (test-plan §T2.E.1).

### T2.E.2 — Stakeholder-table provenance discipline

- **Section:** Stakeholders template; Tier 2 self-check
- **Decision applied:** Tag with `[Coach-inferred]` when role-mapping is not user-stated.
- **Before:** Stakeholders table had no provenance discipline noted.
- **After (excerpt, template):**
  > One row per role. The "Decision power" column carries `[Coach-inferred]` when the role-mapping is not user-stated (T2.E.2).
- **After (excerpt, Tier 2 self-check):**
  > [ ] Stakeholders "Decision power" column: any non-user-stated role-mapping carries `[Coach-inferred]`.
- **Rationale:** Scenario A stakeholder table populated with coach-inferred mappings without tagging (test-plan §T2.E.2).

### T2.E.3 — Vague-input stop threshold

- **Section:** Coaching flow → new subsection "Vague-input stop threshold (T2.E.3)"
- **Decision applied:** N=3.
- **Before:** Implicit rule ("no 5th probing question after 2 vague answers"); not explicit.
- **After (excerpt):**
  > When 3 consecutive user answers fail to provide quantification, named entities, or concrete observation, the coach STOPS probing the same dimension and accepts-and-tags. The remaining open items go to `Open Questions & Assumptions` in the file rather than back into the dialogue. This is a hard threshold, not a heuristic.
- **Rationale:** Scenario D coach stopped at 3, well within tolerance; rule made explicit (test-plan §T2.E.3).

### T2.E.4 — Concern-not-problem early write

- **Section:** Coaching flow → new subsection "Concern-not-problem early write (T2.E.4)"
- **Decision applied:** Promote emergent behaviour to spec rule (3+ consecutive `_None provided._` projections trigger recommendation).
- **Before:** Spec implied but did not explicitly enable this behaviour.
- **After (excerpt):**
  > If the coaching dialogue produces 3+ consecutive `_None provided._` projections for mandatory sections (typically Current Condition, Target Condition, Stakeholders), the coach SHOULD recommend ending the session and writing a concern-not-problem one-pager rather than mechanically completing the flow. … The Likely Next Step is "just-share" or "baseline-gathering before further framing".
- **Rationale:** Scenario D coach proactively wrote concern-not-problem file rather than mechanically completing flow (test-plan §T2.E.4 / §T3.6).

---

## Tier 3 documentation additions

A new section "Documented Expected Behaviours" was added near the end of the spec (before the TODO section). This is descriptive — it documents validated stable behaviours, not new rules.

### T3.1 — Variant-immunisation after correction

- **Section:** Documented Expected Behaviours → T3.1
- **Type:** Documentation (no rule change).
- **Rationale:** Cross-scenario stable behaviour (C, B); coach proactively names related variants (plural forms, abbreviations, synonyms, parent/child labels) excluded from the file (test-plan §T3.1).

### T3.2 — Pre-write tripwire-status announcement (positive case)

- **Section:** Documented Expected Behaviours → T3.2 (cross-references the T2.B.1 rule)
- **Type:** Documentation; T2.B.1 promoted from emergent to mandatory rule.
- **Rationale:** Cross-scenario stable behaviour (E, C, B) (test-plan §T3.2).

### T3.3 — Atomic-vs-compound question-density calibration heuristic

- **Section:** Documented Expected Behaviours → T3.3
- **Type:** Documentation. Calibration heuristic for the no-commitment case (T1.2 covers the violated-commitment case).
- **Rationale:** Cross-scenario stable behaviour (A, D, E, C); pattern: rich-input → compound, vague-input → atomic (test-plan §T3.3).

### T3.4 — User-position reconstruction after correction

- **Section:** Documented Expected Behaviours → T3.4
- **Type:** Documentation.
- **Rationale:** Cross-scenario stable behaviour (C, B); after correction, coach replaces fabrication with user's actual position, not silence (test-plan §T3.4).

### T3.5 — Acknowledge corrections without apology

- **Section:** Documented Expected Behaviours → T3.5; cross-referenced from Context-Length Tripwire / "Correction acknowledgements (cross-reference to Communication Style)"
- **Type:** Documentation; cross-references existing Communication Style rule. Per the patching brief, T3.5 is co-located with the tripwire visibility rule.
- **Rationale:** Already in spec (Communication Style); cross-reference makes the co-location explicit per patching brief instruction (test-plan §T3.5).

### T3.6 — Coach proactive abort to "concern-not-problem"

- **Section:** Documented Expected Behaviours → T3.6 (cross-references the T2.E.4 rule)
- **Type:** Documentation; T2.E.4 promoted to spec rule.
- **Rationale:** Scenario D positive emergent behaviour (test-plan §T3.6 / §T2.E.4).

### T3.7 — Provenance Check fact reproduction grouped by type

- **Section:** Documented Expected Behaviours → T3.7
- **Type:** Documentation; Part A grouping order updated as part of T2.C.1.
- **Rationale:** Cross-scenario stable behaviour (all five); 8th group (`explicit-absence`) appended (test-plan §T3.7).

### T3.8 — File delivery on Tier 2 cascade rule (a)

- **Section:** Documented Expected Behaviours → T3.8
- **Type:** Documentation.
- **Rationale:** Cross-scenario stable behaviour (D, E); validates existing cascade rule (a) (test-plan §T3.8).

---

## Cross-cutting changes

These changes touch multiple sections in service of the findings above and do not have their own finding ID:

- **Coaching Notes content rule** updated to enumerate the six categories of content that may appear (red flags, Tier-3 failures, correction events, atomic-commitment violations, step-12 deliberate-skip notes, concern-not-problem flag), with `_None provided._` only when none apply.
- **Tier 2 self-check** extended with: fact-density window check (T1.1), pre-write announcement preparation (T2.B.1), Stakeholders provenance check (T2.E.2).
- **High-level patch summary** added as an HTML comment block immediately after the frontmatter, listing all rules added and notable rule edits with one-line before/after.

---

## Internal consistency review

No internal inconsistencies between the applied decisions and existing spec rules outside the review scope were detected.

The following adjacencies were verified:

- T1.2 (atomic commitment) coexists cleanly with the Communication Style rule "Ask exactly one focused question per coaching turn unless the user explicitly invites multiple". The Communication Style rule is the soft default; T1.2 is the harder rule that activates once a commitment is made.
- T2.E.1 (step-12 discretionary) coexists with the Binding Template Philosophy. The discretion is over the dialogue probe, not over the file output. The file ALWAYS includes the Impacted Capabilities & Systems section per the binding template — unchanged.
- T2.E.2 (`[Coach-inferred]` on Decision power column) coexists with the existing inline-tag rule. The tag is inline as required.
- T2.A.2 (purged-fabrication audit in Coaching Notes) coexists with the existing Coaching Notes "flags-not-praise" rule — correction events are now an explicit category, replacing the implicit gap.
- T2.C.1 (`[explicit-absence]`) and the existing Tier 2 ledger-membership invariant: the new type closes the previous gap where `_None provided._` placeholders could be un-traceable.

No questions are flagged for human resolution.

---

## Readiness summary — Tier 1 re-validation

The two Tier 1 findings should be re-validated by re-running these test scenarios after this patch is approved:

- **T1.1 (fact-density tripwire)** — re-run **Scenario B** (long, very rich, ~290 facts across 11 turns) AND construct a NEW high-density-but-short scenario: ≥3 consecutive turns each carrying >15 distinct facts, total ≤8 turns, no user correction, no ledger-membership lookup failure. The new scenario specifically tests the density axis in isolation; Scenario B alone cannot, because turn count and density confound. Verify:
  - Tripwire fires on density alone in the new scenario.
  - Counter resets at re-derivation (subsequent density window starts fresh).
  - `[explicit-absence]` entries count toward density.

- **T1.2 (atomic-commitment hold rule)** — re-run **Scenario B** with explicit atomic pre-commitment at Q1, plus a new **Scenario B-prime**: same long-dialogue regime but user explicitly releases the atomic commitment at turn N (e.g. "you can bundle questions again from now on"). Verify:
  - Coach holds atomic in Scenario B for the full session; any compound drift logged in Coaching Notes as an atomic-commitment violation.
  - In B-prime, coach holds atomic until turn N, then resumes calibrated-compound behaviour (T3.3) without logging a violation.
  - Implicit release (user simply answering a compound question without complaint) does NOT release the commitment.

Tier 2 and Tier 3 findings do not require dedicated re-validation runs; they will be exercised passively in the next regression run of Scenarios A, D, E, C, B alongside the Tier 1 re-validation above.

---

---

# Spec Patch v2.1 — Micro-Patch (post-v2 corrections)

_Applied before validation begins. Two corrections, both flagged during human review of v2._

## Correction 1 — Visibility-rule preservation

- **Finding ID:** Visibility-rule-preservation (corrects an over-reach in the v2 application of T2.B.1 and T2.A.3).
- **Issue identified during review:** The v2 patch replaced the validated visibility-rule header (`**Visibility rule for ALL tripwires:**`) with a modified version (`**Visibility rule for ALL tripwires (announce on every write):**`) and embedded the validated lead sentence inside the new T2.A.3 sub-rule, modifying its wording ("Whenever" → "When", "One line" → "One line per fire"). The patching brief explicitly required preservation of the validated visibility rule.
- **Decision applied (pragmatic reading):**
  - Line 540 closing list-extension (adding ", (d) fact-density") remains acceptable — the closing summary list must enumerate all axes if a fourth axis exists.
  - The validated header is restored verbatim.
  - The validated lead sentence is restored verbatim, with one minimal extension: the in-line axis list reads "(turn-count, ledger-membership lookup failure, user-flagged fabrication, **or fact-density**)" — the only delta from the validated wording, and only because the new fourth axis must be enumerable here.
  - T2.B.1 (positive announcement) is re-framed as a NEW sub-rule sited IMMEDIATELY ABOVE the restored validated rule, under the heading **"Pre-write tripwire-status announcement (positive case):"** — distinct from the validated header.
  - T2.A.3 (pre-write summary discipline) is re-framed as a NEW sub-rule sited IMMEDIATELY BELOW the restored validated rule, under the heading **"Pre-write tripwire summary discipline (audit-completeness over brevity):"** — distinct from the validated header. The pre-write summary's "When fires have occurred" content is kept; the original "Whenever any tripwire fires" sentence is restored to its validated home above.
- **Result structure (Context-Length Tripwire section, after v2.1):**
  1. Primary rule (turn-count) — pre-existing, unchanged.
  2. Mechanical ledger-membership test — pre-existing, unchanged.
  3. Fact-density tripwire — T1.1 (with Correction 2 wording tightenings applied).
  4. Additional trigger (user correction) — pre-existing, unchanged.
  5. Tripwire summary list — T1.1.
  6. First-write fallback for density — T1.1 (Correction 2 Fix 6).
  7. Re-derivation extraction window — T2.A.1.
  8. **Pre-write tripwire-status announcement (positive case)** — T2.B.1, NEW sub-rule above the validated rule.
  9. **Visibility rule for ALL tripwires** — VALIDATED, restored intact (with the minimal in-line list extension).
  10. **Pre-write tripwire summary discipline (audit-completeness over brevity)** — T2.A.3, NEW sub-rule below the validated rule.
  11. Predictive (armed) tripwire announcement — T2.B.2.
  12. Correction acknowledgements (cross-reference to Communication Style) — T3.5.
  13. Closing line ("No 'could not quote verbatim'…") — pre-existing, with (d) fact-density appended to the closing axis list.
- **Rationale:** The pragmatic reading of the patching brief permits list-extension when a new axis exists, but the validated header and lead sentence must be preserved. This restructure satisfies both: the validated rule sits intact in position 9, with new sub-rules adjacent (positions 8 and 10). The user who validated the rule before Scenario A would still recognise their wording verbatim.

## Correction 2 — T1.1 wording tightenings

- **Finding ID:** T1.1-wording-tightening (×7) — closes substance-verification gaps surfaced during human review of v2.
- **Source of fixes:** Substance verification of lines 481–500 by reviewer; seven distinct ambiguities identified.

### Fix 1 — Line 487 comparator clarity

- **Before:** `**M = 15** facts per turn.`
- **After:** `**M = 15** facts per turn (strict inequality: a turn must carry MORE than 15 facts to count toward the density window — exactly 15 does not count).`
- **Rationale:** Closes the off-by-one ambiguity between "M = 15" (could be read as the threshold value) and the headline rule's "more than 15" (strict inequality).

### Fix 2 — Definition anchor for "extracted facts"

- **Before:** No definition anchor.
- **After (new bullet):** `**Definition:** "Extracted facts" means items that would qualify as F-entries under a fresh extraction of the turn — i.e. any of the 8 F-types (number, entity, event, quote, relationship, date, constraint, explicit-absence). Raw utterances or stylistic content do not count.`
- **Rationale:** Closes the implicit-definition gap. A future reader could otherwise count raw user utterances rather than ledger-eligible facts.

### Fix 3 — Dedup contradiction fix

- **Before:** `Facts are counted after deduplication (a fact appearing in multiple turns counts once toward density per occurrence-turn, but duplicates of the same fact across turns count once total — only distinct extracted facts contribute).`
- **After:** `Facts are counted after deduplication across the session: a fact stated by the user in turn 3 and re-stated in turn 5 counts ONCE toward density (in the turn of first appearance). Only distinct extracted facts contribute to the density count of any given turn.`
- **Rationale:** The pre-correction wording contained two contradictory clauses ("counts once per occurrence-turn" vs. "counts once total across turns"). The user's original decision was "duplicates across turns count once total"; the fix retains only that reading, with an explicit example.

### Fix 4 — Sub-threshold window-break semantics

- **Before:** No rule on what happens when a turn carries ≤15 facts after one or two armed turns.
- **After (new bullet):** `**Sub-threshold turns break the window.** A user turn carrying ≤15 facts breaks the consecutive window. The counter resets to zero, and the next >15 turn starts a fresh window at count = 1.`
- **Rationale:** Closes the "what does 'consecutive' mean across a sub-threshold turn" gap. The "consecutive" wording implied reset-to-zero but did not state it.

### Fix 5 — Reset rule strengthening

- **Before:** `The counter resets at re-derivation: after a re-derivation fires, the next density window starts from the following user turn.`
- **After:** `The counter resets at re-derivation, regardless of which axis triggered the re-derivation. After ANY tripwire fires (turn-count, density, lookup-failure, user correction), ALL tripwire counters reset — turn-count window, density window. The next session segment is a fresh post-derivation window.`
- **Rationale:** Closes the cross-axis interaction gap. Previously implied but not stated: a turn-count-axis re-derivation also resets the density counter, and vice versa.

### Fix 6 — First-write fallback for density

- **Before:** No first-write callout for the density axis (only the turn-count axis had one).
- **After (new paragraph after the axis-summary line):** `**First-write fallback for density.** Unlike the turn-count axis (which has an explicit first-write fallback), the density axis fires on its own merit at any write — including the first write of a long session if 3+ consecutive turns each carry >15 facts before the first write occurs.`
- **Rationale:** Closes the asymmetry between turn-count (which has an explicit first-write clause) and density (which did not). A 7-turn session with 3+ density-armed turns would otherwise be ambiguous on whether density fires on first write.

### Fix 7 — Arm/fire semantics

- **Before:** No statement of arm/fire semantics inside T1.1; the arm concept was only implicit in T2.B.2 (predictive announcement).
- **After (new paragraph after the headline density sentence):** `**Arm/fire semantics:** Turns 1 and 2 of a >15-fact run are an *armed* state. Turn 3 with >15 facts *fires* the tripwire. The arm state is what permits the predictive announcement under T2.B.2.`
- **Rationale:** Closes the arm/fire gap inside T1.1 itself. Without it, a reader could plausibly read "3 consecutive turns" as a rolling-window check rather than an armed-state-then-fire mechanic, and would not know that the arm state is what T2.B.2 hooks into.

## Readiness summary — v2.1

After v2.1, both corrections are applied and the v2 readiness summary remains valid:

- **T1.1 re-validation** still requires Scenario B re-run plus a NEW high-density-but-short scenario (≥3 consecutive turns of >15 facts, total ≤8 turns, no user correction, no lookup failure). With the v2.1 wording tightenings, the re-validation can additionally test:
  - Comparator behaviour at exactly 15 facts (should NOT count toward density window — Fix 1).
  - Sub-threshold-turn window break: a sequence of (16, 16, 14, 16, 16) facts should NOT fire (turn 3's 14 breaks the window) — Fix 4.
  - Cross-axis reset: a turn-count re-derivation should reset the density counter to zero — Fix 5.
  - First-write density fire on a 4-turn session with (16, 16, 16, 16) — Fix 6.
- **T1.2 re-validation** is unaffected by v2.1; same plan as v2.

After v2.1 corrections, the patch is ready for validation. No further pre-validation corrections are pending.

---

_End of change log._
