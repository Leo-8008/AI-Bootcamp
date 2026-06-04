# Validation Plan v2-final — Patched problem-framing-coach (Spec Patch v2.1)

_Classification: Internal Use Only_
_Document version: **v2-final** (incorporates four review decisions + two additions)._
_Target spec: `.claude/agents/problem-framing-coach.md` after Spec Patch v2 + v2.1 micro-patch._
_Source decisions: `spec-patch-v2-changelog.md` (v2 + v2.1 sections)._
_Source findings: `problem-statements/spec-iteration-v2-findings-from-test-plan.md`._
_Status: Plan finalised. No validation runs initiated. Awaiting human approval to begin Wave 1._
_Date: 2026-06-04._

---

## 0. v2-final review decisions (binding for execution)

The following four decisions from human review are binding for the validation execution. They override any earlier recommendation in this plan where contradictions arise.

- **Decision 1 — Scenarios K and L are sub-checks, not standalone:** K is a sub-check within A'; L is a sub-check within D'. Standalone runs ONLY IF A' or D' does not naturally exercise the respective sub-check (e.g. if A' produces a Stakeholders table without any coach-inferred Decision-power mappings, K must then be run standalone to validate T2.E.2; if D' fails to produce explicit-absence statements from the user, L must be run standalone to validate T2.C.1's 8th-group rendering).
- **Decision 2 — Scenario I correction-axis sub-variant is optional:** Run only if the turn-count variant of I, or Scenario C', surfaces cross-axis reset ambiguity. Do not pre-schedule.
- **Decision 3 — Single shared synthetic domain across F, G, H, I, J:** Fictional Marine Cargo Hull Insurance line for a fictitious shipping operator (suggested name: "MeridianMar"). The coach is free to instantiate specific facts, figures, vessel names, route/port names, claim amounts, etc. within this shape. **Boundary tests (G, H, J) must use distinct, discrete-sentence facts** — one fact per sentence — to eliminate fact-extraction ambiguity (per Risk #2 in Section 9).
- **Decision 4 — Soft-fail blocking discipline (three-tier):**
  - **BLOCKING:** If discretionary rules T2.B.2 (predictive announcement), T2.E.1 (step-12 deliberate skip), or T2.E.4 (concern-not-problem early write) are unexercised across **ALL** 13 scenarios, the patch is NOT declared validated. Either add a targeted scenario to exercise the discretion, or mark the rule "spec-only, behaviour-unvalidated" with explicit human acknowledgement.
  - **NON-BLOCKING:** `[explicit-absence]` Part A grouping order incorrect → document and review.
  - **NON-BLOCKING:** Coaching Notes category ordering deviation → document and review.
  - **NON-BLOCKING:** All other soft-fails as listed in Section 5, unless explicitly escalated by the validator on review.

---

## 1. Scope & Goals

### Primary goals (must pass before patch is declared validated)

1. **Tier 1 findings exhibit corrected behaviour.** T1.1 (fact-density tripwire) and T1.2 (atomic-commitment hold) must be observed firing/holding correctly in dedicated scenarios.
2. **Validated visibility rule still holds.** The pre-Scenario-A visibility-rule wording (preserved verbatim by v2.1 Correction 1) must continue to behave as it did in the original Scenario A run — i.e. announces re-derivation in the chat, one line per fire, no apology padding.
3. **No Tier 2 / Tier 3 regression.** The 11 Tier 2 clarifications and 8 Tier 3 documented behaviours must not regress. They will be exercised passively during Tier 1 re-validation runs.

### Secondary goals (nice-to-have; document if observed)

4. **Calibration evidence for T1.1.** N=3 / M=15 was set conservatively. Each scenario that exercises density should record actual extracted-fact counts so future calibration tuning has data.
5. **Variant-immunisation (T3.1) re-confirmed.** Re-runs of correction-bearing scenarios (B, C) should re-exhibit variant-immunisation; if they don't, this is a regression.
6. **Discretionary behaviours observed in practice.** T2.B.2 (predictive announcement), T2.E.1 (step-12 deliberate skip), T2.E.4 (concern-not-problem early write) are coach-discretion rules. Document when/why the coach exercised the discretion or did not.

### Out of scope for v2 validation

- Block-mode behaviour (not exercised in original test plan; not exercised here).
- Multi-language coaching.
- Confluence-template integration (still in spec TODO).
- Solution-design-assistant handoff format beyond Problem ID propagation.

---

## 2. Scenario Inventory

| ID | Type | Source | Purpose | Required |
|---|---|---|---|---|
| **A'** | Re-run | original Scenario A | Confirm visibility-rule preservation; passive Tier 2/3 regression check on rich-input regime | Yes |
| **B'** | Re-run | original Scenario B | Confirm T1.1 still fires on long-dialogue + high-density; T1.2 commitment-hold; passive Tier 2/3 check | Yes |
| **B-prime** | New | derived from B | Validate T1.2 explicit-release behaviour | Yes |
| **C'** | Re-run | original Scenario C | Confirm correction-tripwire + variant-immunisation (T3.1) + user-position reconstruction (T3.4) still work | Yes |
| **D'** | Re-run | original Scenario D | Confirm vague-input / `[explicit-absence]` / concern-not-problem (T2.E.4) still work; T2.E.3 stop threshold | Yes |
| **E'** | Re-run | original Scenario E | Confirm constraint-vs-concern (T2.D.1) + place-of-symptom-vs-system (T2.D.2) + step-12 discretionary skip (T2.E.1) | Yes |
| **F** | New | targeted | T1.1 density-axis isolation: high-density-but-short, ≤8 turns, no correction, no lookup-failure | **Critical** |
| **G** | New | targeted | T1.1 Fix 1 boundary: turn at exactly M=15 facts must NOT count | Yes |
| **H** | New | targeted | T1.1 Fix 4 window-break: sequence (16, 16, 14, 16, 16) must NOT fire | Yes |
| **I** | New | targeted | T1.1 Fix 5 cross-axis reset: turn-count tripwire fires, density counter resets | Yes |
| **J** | New | targeted | T1.1 Fix 6 first-write density: 4-turn session (16, 16, 16, 16) — fires on first write | Yes |
| **K** | New | targeted | T2.E.2 stakeholder-table provenance: `[Coach-inferred]` tag on Decision-power column | Yes |
| **L** | New | targeted | T2.C.1 `[explicit-absence]` 8th F-type appears in Part A as 8th group | Yes |

Total: 13 scenarios — 5 re-runs (A'-E'), 1 derived re-run (B-prime), 7 new targeted (F-L).

---

## 3. Re-runs of original scenarios — what changes vs. original plan

The original test plan defined Scenarios A, D, E, C, B in that sequence. The re-runs (A', D', E', C', B', B-prime) preserve original inputs verbatim and watch for the same primary pass criteria, plus the additional v2/v2.1 expectations below.

### Common additions to ALL re-runs

For every re-run, the coach is now expected to additionally exhibit:

| Expectation | Source | Pass condition |
|---|---|---|
| Pre-write tripwire-status announcement appears in chat regardless of fire | T2.B.1 | One factual line stating turn count, threshold status, and any prior-in-session fires, BEFORE the file write |
| 8th F-type `[explicit-absence]` available and used where applicable | T2.C.1 | If the user explicitly states absences, ledger contains `[explicit-absence]` entries; Part A reproduces them as the 8th group |
| Stakeholders Decision-power column carries `[Coach-inferred]` when role-mapping is not user-stated | T2.E.2 | All non-user-stated role-mappings tagged inline `[Coach-inferred]` |
| Place-of-symptom does NOT auto-promote to Systems | T2.D.2 | Systems renders `_None provided._` unless user explicitly enumerates systems |
| Constraint-vs-Concern distinction respected | T2.D.1 | Generic regulatory concerns without specific applicable rule appear in Business Goal or Open Questions, not Constraints |
| Validated visibility rule (lines 528–535) wording preserved | v2.1 Correction 1 | When a tripwire fires, coach output matches the validated wording (lead sentence + 4 example bullets including the new fact-density one + warn/block applicability sentence) |

### Per-scenario delta to original

#### A' (re-run of Scenario A) — Required

- **Original input:** rich, structured (sales-reporting / claims-handler reporting context).
- **Original expected:** all primary pass criteria pass; 0 tripwires fire; 3 findings observed (one of which was T2.E.1 step-12 implicit skip).
- **v2 delta:**
  - Pre-write tripwire-status announcement now expected (T2.B.1) — *no fires* line.
  - Step-12 skip is now explicit-discretionary (T2.E.1): if the coach skips, it MUST log the choice in Coaching Notes. **Pass criterion:** Coaching Notes contains a step-12 skip note OR the coach asks the probe explicitly. If neither, fail.
  - Stakeholders Decision-power column: `[Coach-inferred]` tags must appear (T2.E.2). **Pass criterion:** any non-user-stated role-mapping is tagged inline.
- **Pass criteria (additive to original):** original pass criteria + the three v2 deltas above + the common additions.
- **Fail indicators:**
  - Validated visibility rule wording deviates from lines 528–535.
  - Step-12 deliberately skipped without note in Coaching Notes.
  - Decision-power column carries non-user-stated mappings without `[Coach-inferred]`.
- **Estimated effort:** Same as original Scenario A.

#### D' (re-run of Scenario D) — Required

- **Original input:** vague, sparse (support-team / customer-satisfaction concern).
- **Original expected:** all primary pass criteria pass; 0 tripwires fire; 4 findings observed (T2.C.1 `[explicit-absence]` introduction; T2.C.2 parenthetical examples; T2.E.3 vague-stop; T2.E.4 concern-not-problem).
- **v2 delta:**
  - `[explicit-absence]` is now formal 8th F-type (T2.C.1). **Pass criterion:** ledger uses `[explicit-absence]` entries (not ad-hoc); Part A reproduces them as 8th group.
  - T2.E.3 vague-stop is now N=3 hard threshold. **Pass criterion:** coach stops probing the same dimension after 3 consecutive vague answers; remaining items go to Open Questions in the file (NOT back into the dialogue).
  - T2.E.4 concern-not-problem early write is now a SHOULD rule. **Pass criterion:** if 3+ consecutive `_None provided._` projections occur for mandatory sections, coach offers to write a concern-not-problem one-pager.
  - T2.C.2 Eigenname-Guard parenthetical-example exemption: parentheticals MUST be syntactically explicit ("e.g.", "such as"). **Pass criterion:** illustrative parentheticals carry an explicit "e.g." marker.
- **Pass criteria (additive to original):** original pass criteria + the four v2 deltas above + the common additions.
- **Fail indicators:**
  - `[explicit-absence]` entries missing from ledger when user explicitly stated absences.
  - Coach probes a dimension a 4th time after 3 vague answers.
  - 3+ consecutive `_None provided._` projections without concern-not-problem offer.
  - Parenthetical example without "e.g." marker treated as illustrative.
- **Estimated effort:** Same as original Scenario D.

#### E' (re-run of Scenario E) — Required

- **Original input:** medium / partial (broker-portal / commission-rate scenario).
- **Original expected:** all primary pass criteria pass; 0 tripwires fire; 3 findings observed (T2.D.1 constraint-vs-concern; T2.D.2 place-of-symptom-vs-system; step-12 capabilities probe).
- **v2 delta:**
  - T2.D.1 distinction is now codified. **Pass criterion:** generic regulatory concerns without specific applicable rule appear in Business Goal or Open Questions, NOT in Constraints. Constraints section reads as "any solution must satisfy these bindings".
  - T2.D.2 distinction is now codified. **Pass criterion:** broker-portal stays in Background/Current Condition; Systems renders `_None provided._` unless user explicitly enumerates systems.
  - T2.E.1 step-12 deliberate skip with Coaching Notes log (as in A').
- **Pass criteria (additive to original):** original pass criteria + the three v2 deltas above + the common additions.
- **Fail indicators:**
  - "Commission disclosure has to be accurate" or similar generic regulatory concern lands in Constraints.
  - Broker-portal auto-promoted to Systems sub-heading.
  - Step-12 deliberate skip without Coaching Notes log.
- **Estimated effort:** Same as original Scenario E.

#### C' (re-run of Scenario C) — Required

- **Original input:** medium-high with mid-dialogue user correction (~turn 4).
- **Original expected:** correction-tripwire fires at turn 4; ledger rebuilt; variant-immunisation observed; all primary pass criteria pass; 3 findings observed.
- **v2 delta:**
  - T2.A.2: purged-fabrication audit now lives in Coaching Notes (NOT Part A). **Pass criterion:** Part A is clean of purged content; Coaching Notes carries the correction-event log with corrected name(s) and immunised variants.
  - Validated visibility rule (lines 528–535) wording must appear verbatim when the correction tripwire fires. **Pass criterion:** correction-fire chat output reads "Whenever any tripwire fires (turn-count, ledger-membership lookup failure, user-flagged fabrication, or fact-density)…" — or the lead sentence + 4 example bullets including the user-correction bullet at line 531.
  - T3.1 variant-immunisation (re-confirm).
  - T3.4 user-position reconstruction (re-confirm).
- **Pass criteria (additive to original):** original pass criteria + the four v2 deltas above + the common additions.
- **Fail indicators:**
  - Purged content appears anywhere in Part A.
  - Validated visibility-rule wording altered.
  - Variant-immunisation absent (regression on T3.1).
  - Fabrication replaced with silence rather than user-position reconstruction (regression on T3.4).
- **Estimated effort:** Same as original Scenario C.

#### B' (re-run of Scenario B) — Required

- **Original input:** long, very rich, with mid-dialogue user correction at turn 8 + long-dialogue tripwire at turn 9 (~290 facts across 11 turns).
- **Original expected:** turn-count tripwire fires at turn 9; user-correction tripwire fired at turn 8; all primary pass criteria pass; 5 findings observed (including T1.1 density-axis gap and T1.2 atomic-commitment drift).
- **v2 delta:**
  - **T1.1 density-axis tripwire is now expected to fire** (the original gap). With ~290 facts across 11 turns, the 3-consecutive->15-facts window will almost certainly cross before turn 9 — likely earlier than the turn-count axis. **Pass criterion:** density tripwire fires on the third consecutive >15-fact turn, BEFORE the turn-count axis would have fired.
  - **T1.2 atomic-commitment hold:** if the coach pre-commits to atomic at Q1, it MUST hold to atomic for the entire dialogue (until explicit release, which does not occur in B'). Drift to compound questions is now a logged failure. **Pass criterion:** zero compound multi-part questions after a Q1 atomic commitment; if any drift occurs, Coaching Notes contains an atomic-commitment-violation flag.
  - **T2.A.1 re-derivation extraction window:** facts from turns 9-11 (post-tripwire) MUST receive proper F-indices in the re-derived ledger (NOT traced as "turn-N user statement" outside the ledger).
  - **T2.A.3 pre-write summary:** when both the turn-8 correction and turn-9 long-dialogue tripwires have fired, pre-write summary lists BOTH as separate factual lines.
  - All common additions.
- **Pass criteria (additive to original):** original pass criteria + the four v2 deltas above + the common additions.
- **Fail indicators:**
  - Density tripwire does NOT fire despite ~290 facts crossing the threshold (regression on T1.1; this is the most consequential v2 fix — if B' fails this, the patch has not delivered).
  - Compound multi-part question observed after a Q1 atomic commitment without an explicit user release (T1.2 violation).
  - Post-tripwire facts (turns 9-11) traced as "turn-N user statement" rather than as F-entries (T2.A.1 violation).
  - Pre-write summary collapses both fires into a single line or omits one (T2.A.3 violation).
- **Estimated effort:** Same as original Scenario B (long, fact-rich; budget for the longest run of the suite).

#### B-prime (derived from B) — Required

- **Input:** Same long-dialogue regime as B', with two additional injections:
  1. At Q1, the coach pre-commits to atomic single-question turns (or the user requests it).
  2. At a designated mid-dialogue turn (e.g. turn 6), the user **explicitly releases** the atomic commitment with phrasing equivalent to *"you can bundle questions again"* or *"compound is fine now"*.
- **Purpose:** Validate T1.2 explicit-release behaviour. Confirms that release IS recognised when explicit, and that compound questions become permissible after release without logging a violation.
- **Expected behaviour:**
  - Turns Q1 through Q5: coach holds atomic strictly.
  - Turn 6: user releases.
  - Turns Q7+: coach exercises calibrated-compound behaviour per T3.3 (compound when input is rich, atomic when input is sparse). No violation logged.
- **Sub-test — implicit release MUST NOT release:** at a designated turn (e.g. turn 4), introduce a soft compound-friendly cue from the user (e.g. user answers a single-question turn with a list of three sub-points) WITHOUT explicit release language. Coach MUST continue holding atomic. **Pass criterion:** no compound questions issued in turn 5 despite the soft cue.
- **Pass criteria:**
  - Coach holds atomic for all turns ≤ release turn.
  - Coach issues calibrated-compound questions in at least one post-release turn (proving release was recognised).
  - Coaching Notes contains NO atomic-commitment-violation flag for B-prime.
  - Implicit-release sub-test: coach continues atomic past the soft cue.
- **Fail indicators:**
  - Coach drifts to compound before the explicit release turn.
  - Coach continues atomic after the explicit release (treating the release as ineffective).
  - Coach drifts to compound after the soft (implicit) cue without explicit release.
  - Coaching Notes logs a violation despite the release being explicit.
- **Estimated effort:** Same as B' (long, fact-rich); inputs are largely the same as B' with the release injection at turn 6.

---

## 4. New targeted scenarios (F-L)

### Scenario F — T1.1 density-axis isolation — **CRITICAL**

- **Type:** Synthetic, targeted.
- **Purpose:** Demonstrate that the density tripwire fires on its own, independent of turn-count and correction axes.
- **Input regime:** Very rich, structured. Each turn carries ≥16 distinct extracted facts (well above M=15). Total session ≤8 user turns. NO user correction at any point. NO ledger-membership lookup failure (every fact the coach intends to write IS user-stated).
- **Suggested input shape:** 5-turn synthetic dialogue, each turn containing ~20 distinct facts (numbers, named entities, dated events). Domain doesn't matter — could be a fictional Zurich line-of-business with synthetic but plausible figures.
- **Expected behaviour:**
  - Turn 1: 20 facts → density window armed at count = 1.
  - Turn 2: 20 facts → armed at count = 2.
  - Turn 3: 20 facts → density tripwire FIRES. Coach announces re-derivation per validated visibility rule (line 533 example: *"Ledger re-derivation triggered (fact-density: 3 consecutive turns >15 facts)."*).
  - Turn-count axis at this point: 3 user turns, well under 8 — must NOT fire.
  - User has not corrected anything — correction axis must NOT fire.
  - Coach has not been asked to write a fact absent from the ledger — lookup-failure axis must NOT fire.
- **Pass criteria:**
  - Density tripwire fires AT turn 3 (not earlier, not later).
  - Validated visibility-rule wording appears in chat (lead sentence verbatim + the fact-density example bullet from line 533).
  - Pre-write tripwire-status announcement (T2.B.1) shows the fire correctly.
  - Counter resets after re-derivation: turn 4 with 20 facts → density window count = 1 (not 4).
  - Final file generated successfully with full ledger of all 100+ facts.
- **Fail indicators:**
  - Density tripwire does NOT fire at turn 3 (T1.1 fundamental regression).
  - Density tripwire fires at turn 1 or 2 (arm/fire semantics misimplemented).
  - Coach announces a different axis (e.g. "turn-count tripwire") when only density should have fired.
  - Counter does not reset after re-derivation (T1.1 Fix 5 regression).
- **Why isolated:** Scenario B confounds turn-count + correction + density. Scenario F isolates density.

### Scenario G — T1.1 Fix 1 boundary: exactly M=15 facts must NOT count — Required

- **Type:** Synthetic, targeted.
- **Purpose:** Validate the strict-inequality semantics of Fix 1 ("a turn must carry MORE than 15 facts").
- **Input regime:** 5 consecutive user turns each carrying EXACTLY 15 distinct extracted facts. Total ≤8 turns, no correction, no lookup failure.
- **Expected behaviour:**
  - Each turn carries exactly 15 facts → none cross the strict-inequality threshold → density window count never increments → density tripwire NEVER fires.
- **Pass criteria:**
  - Density tripwire does NOT fire at any point.
  - Pre-write announcement reads "no fact-density window crossed" or equivalent.
  - File generated successfully without re-derivation due to density.
- **Fail indicators:**
  - Density tripwire fires (off-by-one error: coach counts ≥15 instead of >15).
  - Coach reports "fact-density window crossed" when no turn exceeded 15.
- **Why needed:** Scenario F establishes that >15 fires; G establishes that exactly 15 does not. Together they pin down the comparator.

### Scenario H — T1.1 Fix 4 window-break: (16, 16, 14, 16, 16) — Required

- **Type:** Synthetic, targeted.
- **Purpose:** Validate that a sub-threshold turn (≤15) breaks the consecutive window and resets the counter.
- **Input regime:** 5-turn dialogue with extracted-fact counts 16, 16, 14, 16, 16. Total 5 turns, no correction, no lookup failure.
- **Expected behaviour:**
  - Turn 1: 16 facts → armed, count = 1.
  - Turn 2: 16 facts → armed, count = 2.
  - Turn 3: 14 facts → window BREAKS, count resets to 0.
  - Turn 4: 16 facts → armed, count = 1.
  - Turn 5: 16 facts → armed, count = 2 (still armed, not fired — only 2 consecutive >15 turns post-reset).
  - Density tripwire NEVER fires in this session.
- **Pass criteria:**
  - Density tripwire does NOT fire at any point.
  - If coach announces tripwire status pre-write, it shows window broken at turn 3 and re-armed at turn 4.
- **Fail indicators:**
  - Density tripwire fires at turn 5 (coach treated the window as cumulative across the 14-fact turn instead of resetting).
  - Density tripwire fires at any earlier point.
- **Why needed:** Confirms "consecutive" means strictly consecutive with reset-on-break, not "any 3 of the last N".

### Scenario I — T1.1 Fix 5 cross-axis reset — Required

- **Type:** Synthetic, targeted.
- **Purpose:** Validate that re-derivation triggered by ANY axis resets ALL counters (turn-count window AND density window).
- **Input regime:** Two-phase dialogue:
  - **Phase 1 (turns 1–9):** moderate density (~10 facts per turn — well below M=15) for 9 turns. Triggers turn-count tripwire at turn 9 (>8 turns since session start). Density tripwire does NOT fire (counts never exceed 15).
  - **Phase 2 (turns 10–12):** high density (~20 facts per turn) for 3 turns.
- **Expected behaviour:**
  - Turn 9: turn-count tripwire fires; coach re-derives ledger; density-window counter resets to 0 (was 0 anyway in this scenario, but the reset is explicit per Fix 5).
  - Turns 10–11: density window arms (count = 1, count = 2).
  - Turn 12: density window count = 3 → density tripwire fires.
- **Pass criteria:**
  - Turn-count tripwire fires at turn 9.
  - Density tripwire fires at turn 12 (NOT earlier, even though turns 10–12 are the third density window position when counted from turn 1; the reset must take effect).
  - Pre-write announcements correctly attribute the fires to the correct axes.
- **Fail indicators:**
  - Density tripwire does NOT fire at turn 12 (counter not reset properly).
  - Density tripwire fires at turn 11 or earlier (coach is counting density across the re-derivation boundary).
- **Why needed:** Without this scenario, the cross-axis-reset rule (Fix 5) is asserted in spec but unproven in behaviour.
- **Sub-variant (optional):** Trigger a correction-axis tripwire instead of turn-count, then test the same density-reset behaviour. Useful but not strictly required for v2.1 validation.

### Scenario J — T1.1 Fix 6 first-write density: (16, 16, 16, 16) — Required

- **Type:** Synthetic, targeted.
- **Purpose:** Validate that the density axis fires on FIRST write of a long-density session, mirroring the turn-count axis's first-write fallback behaviour.
- **Input regime:** 4-turn dialogue, each turn carrying ~16 extracted facts. NO prior re-derivation (this is the first write of the session).
- **Expected behaviour:**
  - Turn 1: armed, count = 1.
  - Turn 2: armed, count = 2.
  - Turn 3: density tripwire FIRES.
  - Coach re-derives the ledger from turns 1–3 (and turn 4 if the user adds it before file write, per T2.A.1).
- **Pass criteria:**
  - Density tripwire fires at turn 3, even though no prior write has occurred.
  - Re-derived ledger contains all facts from turns 1–N (where N is the most recent user turn before file write — per T2.A.1).
- **Fail indicators:**
  - Density tripwire does NOT fire because "no prior derivation to compare against" (would mean coach is incorrectly treating density like turn-count's "since last derivation" semantics — but density resets only AT re-derivation, not as a "since last derivation" comparison).
  - Re-derived ledger truncates at turn 3 (trigger time) instead of extending through pre-write turn N (T2.A.1 regression).
- **Why needed:** Closes the asymmetry between turn-count's explicit first-write fallback and density's behaviour on first write.

### Scenario K — T2.E.2 stakeholder-table provenance — Required

- **Type:** Synthetic, targeted (lightweight; can also be a sub-check on A').
- **Purpose:** Validate that the Stakeholders table's "Decision power" column carries `[Coach-inferred]` tags when role-mapping is not user-stated.
- **Input regime:** A short scenario (~5 turns) where the user names stakeholders ("the underwriting team", "the head of broker relations") but does NOT explicitly state their decision power on the problem.
- **Expected behaviour:**
  - Stakeholders table is populated with the named stakeholders.
  - Each Decision-power cell either:
    - Quotes a user statement verbatim with F-index, OR
    - Carries inline `[Coach-inferred]` tag with explanatory phrasing.
- **Pass criteria:**
  - Every non-user-stated Decision-power cell carries `[Coach-inferred]`.
  - Provenance Check Part B traces each Decision-power cell to either an F-index or a `[Coach-inferred from F#, F#]` line.
- **Fail indicators:**
  - Decision-power cell with coach-inferred content but no `[Coach-inferred]` tag.
  - Decision-power cell with content that cannot be traced to either an F-index or a `[Coach-inferred]` derivation.
- **Why needed:** Original Scenario A exhibited this gap; it must be confirmed closed.
- **Note:** This scenario can be merged into A' as a sub-check rather than run as a standalone scenario, if the original Scenario A inputs already produce a Stakeholders table with non-user-stated Decision-power inferences.

### Scenario L — T2.C.1 `[explicit-absence]` 8th F-type as 8th Part A group — Required

- **Type:** Synthetic, targeted (lightweight; can also be a sub-check on D').
- **Purpose:** Validate that `[explicit-absence]` entries appear as the 8th group in Part A reproduction (after `constraint`).
- **Input regime:** Short dialogue (~5 turns) where the user explicitly states multiple absences ("we don't measure that", "no formal SLA", "I haven't checked the audit trail").
- **Expected behaviour:**
  - Ledger contains `[explicit-absence]` entries for each user-stated absence.
  - Part A reproduction prints groups in order: `number`, `entity`, `event`, `quote`, `relationship`, `date`, `constraint`, `explicit-absence`.
- **Pass criteria:**
  - At least 3 `[explicit-absence]` entries in the ledger.
  - Part A reproduction shows them as the 8th and final group, in correct order relative to the other 7 groups.
- **Fail indicators:**
  - `[explicit-absence]` entries treated as `[quote]` or some other type.
  - `[explicit-absence]` group appears earlier in the ordering (e.g. before `constraint`) — this would not break correctness but would violate the spec's documented ordering.
- **Why needed:** Original Scenario D used an ad-hoc `[explicit-absence]` tag; v2 formalised it. Validate the formalisation is honoured.
- **Note:** Can be merged into D' as a sub-check.

---

## 5. Pass / fail criteria summary

### Hard-fail conditions (any of these in any scenario fails the patch validation)

1. The validated visibility rule wording (lines 528–535 of the patched spec) appears with any wording deviation other than the in-line axis list extension.
2. The density tripwire (T1.1) does NOT fire in Scenario F (the isolated density scenario) — this is the consequential gap that v2 was meant to close.
3. The atomic-commitment hold rule (T1.2) is broken in B' WITHOUT being logged in Coaching Notes as a violation.
4. Re-derivation in B' fails to assign F-indices to post-tripwire facts (T2.A.1 violation).
5. Any scenario produces fabricated content (a fact-bearing sentence in the file body that traces to neither an F-index nor a `[Coach-inferred]` tag).

### Soft-fail conditions (regression flags; investigate but may be patch-acceptable on review)

1. Discretionary behaviours (T2.B.2 predictive announcement; T2.E.1 step-12 deliberate skip; T2.E.4 concern-not-problem early write) not exercised at all across the suite. Discretionary rules need at least one positive observation in the suite to confirm they are reachable.
2. `[explicit-absence]` entries used but Part A grouping order incorrect (functional but not spec-compliant).
3. Coaching Notes content rule categories (correction events, atomic violations, step-12 skip notes, concern-not-problem flag) used but ordering in the file diverges from the 6-category order in the rule.

### Discretionary rules that MUST be exercised at least once across the suite

Per Decision 4 (Section 0), the following discretionary rules require at least one positive observation across the 13 scenarios. Failure to exercise any of them across the entire suite is **BLOCKING**.

| Rule | Description | Naturally exercised by | If not naturally triggered, action |
|---|---|---|---|
| **T2.B.2** | Predictive announcement (coach pre-warns when a tripwire fire is imminent) | B', I, B-prime (long / multi-axis dialogues approaching thresholds) | Add a targeted scenario in which the coach is approaching a known threshold (e.g. turn 7 of an 8-turn-window, or a 2-of-3 density window). If still unexercised, mark "spec-only, behaviour-unvalidated" with explicit human acknowledgement. |
| **T2.E.1** | Step-12 deliberate skip (coach skips capabilities probe with logged rationale) | A', E' (rich / medium scenarios where step-12 is plausibly redundant) | Add a targeted scenario where step-12 is clearly redundant given prior turns. If still unexercised, mark "spec-only, behaviour-unvalidated" with explicit human acknowledgement. |
| **T2.E.4** | Concern-not-problem early write (coach offers concern-not-problem one-pager after 3+ consecutive `_None provided._` projections) | D' (vague-input regime) | Add a targeted scenario with even-more-vague input than D'. If still unexercised, mark "spec-only, behaviour-unvalidated" with explicit human acknowledgement. |

**Action sequence if a discretionary rule is unexercised after Wave 1–4 completion:**

1. Validator records the unexercised rule in the validation-result document.
2. Validator proposes a targeted scenario (≤5 turns, synthetic) that would naturally trigger the discretion.
3. Run the targeted scenario. If discretion exercised → rule validated. If still not exercised → escalate to spec-author for explicit "spec-only, behaviour-unvalidated" acknowledgement.
4. Patch is NOT declared validated until this loop closes for all three discretionary rules.

### Per-scenario pass criteria

See sections 3 and 4 above for per-scenario detail. Aggregate: each scenario passes if (a) its primary pass criteria are met, (b) no hard-fail conditions occur, (c) common additions are observed.

---

## 6. Sequencing recommendation

### Critical path (must run, in this order)

1. **Scenario F** — first. **Why first:** F is the most isolated test of the most consequential v2 fix (T1.1 density axis). If F fails, the patch has not delivered the headline Tier 1 finding and downstream scenarios are not worth running. Cheap to run (~5 turns, synthetic), highest-value signal.
2. **Scenario G** — second. **Why second:** Boundary test for Fix 1. If G fails (density fires on exactly-15), the strict-inequality semantics are wrong and Scenarios H, I, J, B' all need re-interpretation.
3. **Scenario H** — third. **Why third:** Window-break semantics. Independent of G's result; cheap; pins down the "consecutive" reading.
4. **Scenario J** — fourth. **Why fourth:** First-write fallback. Cheap. Confirms density behaves correctly on first write.
5. **Scenario I** — fifth. **Why fifth:** Cross-axis reset. Slightly more complex setup (two-phase dialogue, ≥12 turns). Run after F-J have established baseline correctness.
6. **Scenario B'** — sixth. **Why sixth:** Highest-effort scenario. Should only be run after F, G, H, J, I have established that density behaves correctly in isolation. B' validates density firing in the high-confound original-test regime; if F-J have already passed, B' becomes a regression check on the original behaviour rather than a fundamental discovery test.
7. **Scenario B-prime** — seventh. **Why seventh:** Atomic-release validation. Builds directly on B'; same input shape with release injection. Run immediately after B' while the dialogue regime is fresh.

### Parallel-eligible path (can run independently of the critical path)

8. **Scenario A'** — can run any time. Cheap, validates visibility-rule preservation on a no-fire scenario plus T2.E.1 / T2.E.2.
9. **Scenario D'** — can run any time after the patch is loaded. Cheap, validates T2.C.1 / T2.C.2 / T2.E.3 / T2.E.4 in their original regime.
10. **Scenario E'** — can run any time. Cheap, validates T2.D.1 / T2.D.2 / T2.E.1.
11. **Scenario C'** — recommended after C-axis confidence from F-J. Cheap, validates correction-axis tripwire wording preservation + T2.A.2 + T3.1 + T3.4.
12. **Scenarios K, L** — can be merged into A' and D' respectively as sub-checks. If merged, no separate runs needed. If run standalone, can run any time.

### Recommended sequencing — Wave plan

- **Wave 1 (Tier 1 core):** F → G → H → J → I (in order; each gates the next). All synthetic, all cheap. Establishes that all 7 v2.1 wording fixes for T1.1 behave correctly in isolation.
- **Wave 2 (regression):** A' → D' → E' (parallel-eligible; can run in any order). Confirms no Tier 2/3 regression in the original input regimes.
- **Wave 3 (correction axes):** C' → B' → B-prime (in this order). C' validates the correction tripwire and visibility-rule wording on a single-correction scenario; B' validates the multi-axis (correction + turn-count + density) confound; B-prime validates atomic-release.
- **Wave 4 (sub-checks if not merged):** K → L. Standalone if not merged into A' / D'.

If the patch fails at any point in Wave 1, halt and return to spec patching before proceeding. Failures in Waves 2-4 may be patch-acceptable depending on the specific finding and human judgement.

### Dependencies

- **F gates everything in Waves 1, 3.** If T1.1 doesn't work in isolation, B' and B-prime cannot meaningfully validate it.
- **G, H gate Fix 1 / Fix 4 interpretation in I, J, B'.** If the comparator or window-break semantics are wrong, the count-bookkeeping in later scenarios is unreliable.
- **B' gates B-prime.** B-prime is a derivative of B'; running B-prime first would not establish a baseline for the release behaviour to be measured against.
- **C' is independent of F-J** (different axis tested), but logically belongs in Wave 3 because it shares the visibility-rule-wording-preservation pass criterion with B'.
- **A', D', E', K, L are independent of the critical path.** Can run in any wave; placed in Wave 2 / 4 as a matter of convenience.

### Effort estimate per wave

Rough hourly bands per wave (validator effort: scenario setup, run, transcript capture, pass/fail determination, narrative). Bands are deliberately wide; they are planning numbers, not commitments.

| Wave | Scenarios | Effort band | Notes |
|---|---|---|---|
| **Wave 1** (Tier 1 core) | F, G, H, J, I | **3–5 hours** | F, G, H, J each ~30–45 min (short synthetic dialogues, ≤5 turns). I longer (~1–1.5 h) due to two-phase 12-turn setup. |
| **Wave 2** (regression) | A', D', E' | **2–3 hours** | Each ~45–60 min; original inputs already defined; main effort is observing the v2 deltas (common additions, T2.B.1, etc.). |
| **Wave 3** (correction axes) | C', B', B-prime | **3–5 hours** | C' ~45–60 min. B' is the longest single scenario (~1.5–2 h, fact-rich, ~11 turns + multi-fire observation). B-prime ~1–1.5 h (re-uses B' regime). |
| **Wave 4** (sub-checks if not merged) | K, L (standalone only if needed) | **0–1 hour** | Likely 0 if K and L are absorbed into A' / D' per Decision 1. Up to ~30 min each if standalone. |
| **Discretionary follow-up** (per Decision 4) | Up to 3 targeted scenarios | **0–2 hours** | Only triggered if T2.B.2 / T2.E.1 / T2.E.4 are unexercised after Waves 1–4. |
| **Aggregation & write-up** | n/a | **1–2 hours** | Validation-result document, go/no-go recommendation. |

**Aggregate total: ~9–18 hours.** Most-likely band: **~12 hours** spread across the validator's calendar (e.g. 2–3 working days at ~4 focused hours per day). Real elapsed time depends on coach response latency and on how many scenarios surface follow-ups that lengthen subsequent runs.

---

## 7. Coverage summary

| Finding ID | v2.1 fix? | Validated by scenarios |
|---|---|---|
| T1.1 (fact-density tripwire) | Yes (7 wording fixes) | **F** (primary), G (Fix 1), H (Fix 4), I (Fix 5), J (Fix 6), B' (in confound), and arm/fire semantics (Fix 7) implicit across all density scenarios |
| T1.2 (atomic-commitment hold) | No | B', B-prime (release), B-prime sub-test (implicit-release) |
| T2.A.1 (re-derivation extraction window) | No | B' (post-tripwire facts must get F-indices) |
| T2.A.2 (purged-fabrication audit in Coaching Notes) | No | C' |
| T2.A.3 (pre-write summary discipline) | No | B' (multi-fire summary) |
| T2.B.1 (positive announcement) | No | All scenarios (common addition) |
| T2.B.2 (predictive announcement) | No | Discretionary; observe if exercised in B', B-prime, I |
| T2.C.1 (`[explicit-absence]` 8th F-type) | No | D', L |
| T2.C.2 (Eigenname-Guard parenthetical exemption) | No | D' |
| T2.D.1 (Constraint vs. Concern) | No | E' |
| T2.D.2 (Place-of-symptom vs. system) | No | E' |
| T2.E.1 (step-12 discretionary) | No | A', E' |
| T2.E.2 (Stakeholders Decision-power `[Coach-inferred]`) | No | A', K |
| T2.E.3 (vague-input stop N=3) | No | D' |
| T2.E.4 (concern-not-problem early write) | No | D' |
| T3.1 (variant-immunisation) | No | C', B' |
| T3.2 (positive announcement, doc) | No | All scenarios (= T2.B.1) |
| T3.3 (atomic-vs-compound calibration) | No | A', D', E', C' (no atomic commitment); B-prime post-release |
| T3.4 (user-position reconstruction) | No | C', B' |
| T3.5 (acknowledge corrections without apology) | No | C', B' |
| T3.6 (concern-not-problem early write, doc) | No | = T2.E.4 |
| T3.7 (Part A type-grouping) | No | All scenarios |
| T3.8 (Tier 2 cascade rule (a)) | No | D', E' |
| Visibility-rule preservation (v2.1 Correction 1) | Yes | C' (correction fire), B' (multi-fire), F (density fire) — all must show validated wording |

All findings are covered. No finding is unvalidated.

---

## 8. Out of scope for this validation pass

- **Calibration tuning of N=15 / M=15.** The values are conservative; tuning is a follow-up activity informed by data from this validation pass.
- **Block-mode behaviour.** Original test plan did not exercise block mode; this plan does not either.
- **Multi-language coaching.** Out of scope.
- **Confluence template integration.** Still in spec TODO.
- **Solution-design-assistant downstream integration.** Out of scope; only Problem ID propagation is observed.
- **Performance / latency.** Not a validation criterion for this pass.

---

## 9. Risks & open questions

### Risks

- **Synthetic input quality.** Scenarios F, G, H, I, J use synthetic input regimes in the shared MeridianMar Marine Cargo Hull domain (Decision 3). If the synthetic facts are not plausible enough for that shape (vessel names, route/port names, claim amounts, premium figures, treaty references), the coach may behave differently than it would on real input. Mitigation: instantiate facts that resemble real Marine Cargo Hull data shapes — avoid abstract or obviously placeholder numbers.
- **Density-counting ambiguity.** The coach's internal fact-extraction is the basis for density counts. If the coach extracts facts differently than the validator expects (e.g. counts a multi-clause sentence as one fact vs. multiple), the threshold tests (G in particular) become noisy. Mitigation per Decision 3: in boundary-sensitive scenarios (G, H, J), give each "fact" its own discrete sentence so extraction is unambiguous. Document any ambiguous extractions in the validation result.
- **Discretionary-rule observability.** T2.B.2, T2.E.1, T2.E.4 are coach-discretion rules. If the coach happens not to exercise the discretion in any of the 13 scenarios, the rules are unvalidated-in-behaviour (though the spec still contains them). Mitigation: design at least one scenario per discretionary rule where the discretion is the natural choice, and document if the coach makes the expected choice.

### Open questions — RESOLVED by v2-final review decisions

The four open questions from the earlier draft are now resolved. Recorded here for traceability:

1. ~~K and L: standalone or sub-check?~~ → **Resolved by Decision 1.** Sub-checks within A' / D'; standalone only if A' / D' do not naturally exercise the respective check.
2. ~~Scenario I correction-axis sub-variant?~~ → **Resolved by Decision 2.** Optional; run only if turn-count variant or C' surfaces cross-axis reset ambiguity.
3. ~~Single shared domain for F, G, H, I, J or vary?~~ → **Resolved by Decision 3.** Single shared synthetic domain: fictional Marine Cargo Hull Insurance line for "MeridianMar". Boundary tests (G, H, J) use one-fact-per-sentence to eliminate extraction ambiguity.
4. ~~Soft-fail blocking threshold?~~ → **Resolved by Decision 4.** Three-tier handling (see Section 0). Discretionary-rule non-exercise across all 13 scenarios is BLOCKING; `[explicit-absence]` ordering and Coaching Notes ordering deviations are NON-BLOCKING; other soft-fails NON-BLOCKING unless explicitly escalated.

---

## 10. Deliverable per validation run

For each scenario, the validator produces:

- The full chat transcript (input + coach output, all turns).
- The generated one-pager file content.
- The Provenance Check (Parts A and B) emitted by the coach.
- Pass/fail determination per pass criterion in this plan.
- A short narrative noting any unexpected behaviour, discretionary-rule exercises, and soft-fail observations.

After all 13 scenarios complete, a single validation-result document aggregates the results, with go/no-go recommendation on the patch.

---

_End of validation plan v2-final. Four review decisions and two additions integrated. Awaiting human approval to begin Wave 1._
