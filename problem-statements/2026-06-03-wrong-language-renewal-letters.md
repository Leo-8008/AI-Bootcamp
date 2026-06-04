# Problem One-Pager — Wrong-Language Renewal Letters

_Classification: Internal Use Only_
_Problem ID: PS-2026-06-03-wrong-language-renewal-letters_
_Date: 2026-06-03_
_Mode used: warn_

## Background

A customer in Ticino received a renewal letter in German last week and complained on Twitter; the post got ~30 retweets and was forwarded internally by the Head of Retail Operations, who asked for "a structured response by end of month." Customer Service has been logging similar cases for ~6 months at an estimated "handful per week", but no formal incident category for "wrong language letter" exists today; cases are filed under generic "letter complaint." The acute trigger is the Twitter incident; the underlying pattern has been simmering for ~6 months.

## Business Goal

*Why this problem matters at the business level — beyond the immediate symptom.*

- **Strategic driver:** Two anchors stated by the user, in order of confidence:
  1. Regulatory — Switzerland requires customer communication in the customer's official language of choice (FINMA conduct expectations + cantonal language rules in TI/VS); wrong-language letters are technically a conduct breach. No fines yet, but exposure exists. [Assumption — exact regulatory citation to be confirmed with Compliance.]
  2. Churn / NPS — Retail Operations has a Q3 OKR to reduce avoidable customer complaints by 20%. Letter-related complaints are roughly 8% of that complaint volume (rough share, not exact).
  Reputation is the catalyst (Twitter incident), not the underlying business case.
- **Value at stake:** Regulatory conduct exposure (no fines yet, exposure exists) and a measurable contribution to the Q3 OKR. Monetary exposure not quantified by the user.
- **Time sensitivity:** Head of Retail Operations requested a structured response by end of month. Q3 OKR cycle is the broader window.

## Current Condition

What is observably happening today.

- **Who is affected:** Retail Non-Life customers (primarily Motor and Property renewal correspondence). The Ticino reference case is a customer whose customer-master language flag is IT but whose policy record is DE; last policy edit was 4 months ago by a handler in Zurich. The edit log has not yet been pulled.
- **How often / how much:** ~180,000 renewal + correspondence letters/month across Retail Non-Life [Assumption — figure from the letter-generation team's last capacity review, ~9 months old]. Customer-master correspondence-language split: DE ~74%, FR ~19%, IT ~6%, EN ~1%. Customer Service team-lead estimate of "handful per week" of wrong-language incidents translates to ~20-30/month, i.e. ~0.01-0.02% of monthly volume — characterised as a lower bound, because customers in DE-speaking regions who receive a DE letter "by accident" never complain. True wrong-language rate is not measured.
- **Current workaround:** _None provided._

## Target Condition

Tiered target combining outcome / accuracy / measurement (all stated by the user):

1. **Pipeline accuracy (primary, hard target):** Customer-master language = letter language in ≥99.9% of sends within 9 months. Today: unknown — believed to be 99.0-99.5% based on internal estimates [Assumption]. Rationale: 99.9% on 180k/month = ~180 wrong letters/month maximum; below that, residual handled as edge cases.
2. **Complaint volume (secondary, observable):** Language-mismatch complaints reduced from current ~20-30/month estimate to ≤5/month within 9 months. Rationale: makes the improvement visible to Customer Service and Retail Operations COO without depending on pipeline-internal metrics.
3. **Measurement capability (enabling target, must come first):** Within 3 months, ground-truth sample audit running monthly — minimum 500 letters/month sampled and language-checked end-to-end. Audit is a prerequisite, not a nice-to-have; the 99.9% target cannot be defended without it.

## Suspected Causes (hypotheses, not conclusions)

User-described pipeline: customer master holds a `correspondence_language` field (DE / FR / IT / EN), set at policy onboarding from the broker submission form or self-service portal. The policy record (in the policy administration system, separate from the customer master) ALSO holds a language field. In ~95% of cases the two match; in the remaining ~5% they diverge [Assumption — 95/5 split is an estimate from the data team, not a measured figure]. The letter-generation pipeline reads from the policy record, not the customer master, so if the policy record is wrong, the letter is wrong even if the customer master is correct.

- [Hypothesis] During migration of acquired portfolios, the policy-record language field is sometimes defaulted to DE when the source system used a different schema.
- [Hypothesis] Manual policy edits by handlers occasionally overwrite the language field unintentionally (no validation against customer master).
- [Hypothesis] Some legacy products don't have the language field on the policy record at all, and the pipeline falls back to a hardcoded DE default.

## Scope

**In scope:**
- The letter-generation pipeline's language-resolution logic (read source, fallback / cross-check behaviour).
- Data-quality at the policy-record language field (consumption side).
- Establishing ground-truth measurement (monthly audit of ≥500 letters).
- Complaint sub-classification for language mismatches.
- Languages DE / FR / IT / EN.

**Out of scope:**
- Translation quality of letter content (already correct in all four languages; failure is selecting the wrong one).
- Customer master data quality cleanup — fixing the source rather than consuming it correctly. Out of reach for this team; would be a separate Group-level initiative.
- Broker submission form redesign — language is captured correctly there in 99%+ of cases. Not the failure point.
- Policy administration system's core logic — too large, separate initiative if ever needed.
- Multi-channel correspondence (email, portal). Scoped to printed/PDF letters generated by the letter pipeline; email and portal use different rendering paths and would need their own analysis.
- Languages beyond DE / FR / IT / EN — no other languages are supported in the pipeline today, and adding them is not in scope.

## Constraints

**Technical / system:**
- Customer master is owned by Group Data Management; the language field there is read-only for this team — consume only, no write. Any change to how language is stored at master level requires a separate cross-BU initiative, out of reach here.
- The policy administration system (name to be confirmed) is modifiable in principle, but releases are coordinated quarterly with the platform team; any change touching letter generation needs to clear their CAB.
- Letter-generation pipeline (Letter Operations / Marc Brunner) is modifiable on shorter cycles (~bi-weekly).

**Regulatory:**
- FINMA conduct expectations apply — any process change needs documentation suitable for a supervisory review.
- Customer-language preference handling falls under data-subject rights (GDPR-equivalent under Swiss FADP). Audit trail required for any automated language decision.

**Operational:**
- Year-end freeze: no production changes between mid-December and mid-January. For a Q1 deployment, design and CAB approval must be done by end-November.
- Marc Brunner's team has limited capacity in Q4 (year-end renewal volume peak). Active development feasible from Q1 onwards.

**Political:**
- Group Data Management has historically been slow to support BU-specific data-quality initiatives. If the solution requires master-data fixes, expect 3-6 month negotiation.
- Compliance must sign off the 99.9% target — historically conservative, may push for stricter.

## Stakeholders

| Role | Person / Team | Decision power |
|---|---|---|
| Escalation source | Head of Retail Operations | Forwarded the Twitter incident; requested structured response by end of month |
| Pipeline & data owner | Marc Brunner (Letter Operations team lead) | Owns letter-generation pipeline; data owner for the pipeline log; reports into Retail Operations COO |
| Customer master owner | Group Data Management | Owns customer master; read-only dependency for this team |
| OKR beneficiary | Retail Operations / Customer Service | Q3 OKR on complaint reduction (-20%); letter-related complaints ~8% of that volume |
| Regulatory sign-off | Compliance | Must approve the 99.9% target; historically conservative |

## Impacted Capabilities & Systems

**Capabilities:**
- Customer Communications (the affected capability).
- Customer Master Data Management (adjacent, not modified, but governs the upstream data).

**Systems:**
- Customer master (owned by Group Data Management) — read-only consumer.
- Policy administration system (name to be confirmed) — modifiable, quarterly release train.
- Letter-generation pipeline (Letter Operations / Marc Brunner) — modifiable, bi-weekly.
- Complaint logging / CRM — needed for the language-mismatch sub-classification tracking. Already exists, no change needed, but it is part of the measurement chain.

## Likely next step

ADR first ("Policy record vs. customer master as authoritative source for correspondence language"; owner: enterprise architecture, ~2-week turnaround) — the architectural root question. Then Software-Eval scoped to the letter pipeline's language-resolution logic, evaluating two candidate paths: (i) keep policy record as source but add a fallback / cross-check against customer master, or (ii) switch source to customer master with policy record as override-only. Then Solution Blueprint covering data flow, audit trail, exception handling, and monitoring for the 99.9% target — only after ADR + Software-Eval. A Group-wide Standard ("single source of truth for correspondence language across BU pipelines") is parked as possible Phase 2 if this fix proves the pattern.

## Open Questions & Assumptions

- [Assumption] ~180,000 letters/month figure is from the letter-generation team's last capacity review, ~9 months old.
- [Assumption] The 95/5 customer-master-vs-policy-record match split is a data-team estimate, not measured.
- [Assumption] "Handful per week" → ~20-30 wrong-language letters/month is a Customer Service team-lead estimate, almost certainly understated (DE-region recipients of accidental DE letters never complain).
- [Assumption] Current pipeline accuracy believed to be 99.0-99.5% based on internal estimates; not measured.
- [Assumption] Exact FINMA / cantonal regulatory citation to be confirmed with Compliance.
- [Open question] Whether Compliance signs off on 99.9% as adequate, or insists on a stricter target given the regulatory dimension. Needs a 30-min check with Compliance before locking the number.
- [Open question] True wrong-language rate (no ground-truth label exists today; complaints are a lower bound).
- [Open question] Edit log for the Ticino reference case (last policy edit 4 months ago by a Zurich handler) — what was changed?
- [Open question] Pipeline-log pull (letters where customer-master language ≠ policy-record language at send time, last 12 months) committed within 3-5 working days.
- [Open question] Complaint records tagged "letter" with language-mismatch sub-classification, last 6 months — committed within 3-5 working days.

## Coaching Notes

- Trigger-vs-trend distinction: the user explicitly separated the acute trigger (Twitter / Ticino, ~30 retweets, Head of Retail Operations forwarding) from the 6-month underlying pattern. Reputation logged as catalyst, not driver.
- Two coach near-miss inferences during the session: "Life & Pensions" was used as a candidate line-of-business label and "I-CH" as a candidate policy-administration-system name. Neither was stated by the user. Both were corrected mid-session and do not appear in this file. The line of business is Retail Non-Life (Motor and Property); the policy administration system is referenced as "(name to be confirmed)".
- A first version of this one-pager was rejected for fabricated numbers (e.g. "70-100 complaints/month", "85,000 letters/month", "1.5h handling time", "10-12 formal complaints", "2-3 FINMA letters") that were never stated by the user. This file is a full rewrite from the dialogue.
