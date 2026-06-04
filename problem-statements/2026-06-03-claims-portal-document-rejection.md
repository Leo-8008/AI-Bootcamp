# Problem One-Pager — Claims Portal Document Rejection Loop

_Classification: Internal Use Only_
_Problem ID: PS-2026-06-03-claims-portal-document-rejection_
_Date: 2026-06-03_
_Mode used: warn_

## Background
Claims handlers in the Retail Motor team report a recurring pattern where customer-uploaded supporting documents (photos, repair invoices, police reports) are rejected by the claims portal and re-requested via email, lengthening claim cycle time. The escalation surfaced after the Q1 operations review flagged a 12-day median cycle time for "simple" motor claims — up from a stated baseline of 8 days. [Assumption — Q1 baseline figure to be confirmed with Operations Analytics.]

## Current Condition
- Affected actors: Retail Motor claims handlers (~45 FTE) and the affected customer cohort.
- Volume: ~3,200 motor claims/month run through the portal. Of those, an estimated 18% trigger at least one document re-request loop. [Assumption — based on a 4-week handler-side tally; not yet validated against portal logs.]
- Each re-request adds ~2 working days of customer wait on average. [Hypothesis — derived from handler self-report, not measured end-to-end.]
- Current workaround: handlers email customers directly with a written list of accepted formats and resolution requirements, bypassing the portal's rejection messages.

## Target Condition
- Median cycle time for in-scope motor claims: 12 days → 9 days within 6 months.
- Document re-request rate: 18% → ≤8% within 6 months. [Coach-inferred sub-target; parent target is the cycle-time figure.]
- Handler-initiated email workarounds: visibly reduced (qualitative; tracked via handler survey at month 3 and month 6).

## Suspected Causes (hypotheses, not conclusions)
- [Hypothesis] Portal rejection messages are generic ("document not accepted") and do not state the specific failure (resolution, file size, format, missing page).
- [Hypothesis] Mobile photo uploads frequently exceed file-size limits silently; customers see a success toast but the document is queued in a rejected state.
- [Hypothesis] The accepted-format list is buried two clicks away from the upload widget.
- [Open question] Are rejections concentrated in a specific document type (e.g. police report scans) or spread evenly across types?

## Scope
**In scope:**
- Portal upload widget UX: error messaging, accepted-format visibility, file-size handling.
- Rejection-reason taxonomy and how it is surfaced to the customer.
- Instrumentation: per-document-type rejection rate, mobile vs. desktop split.

**Out of scope:**
- Underlying claims-handling backend (separate squad, separate roadmap).
- OCR / automated document validation rebuild — too large for this framing; if needed, separate initiative.
- Changes to which document types are required by Compliance.
- Identity / login flow.

## Constraints
- Document retention and handling must comply with EU GDPR and the Swiss Insurance Supervision Act (ISA).
- No changes to the document classification taxonomy without Compliance sign-off.
- Portal frontend release train is bi-weekly; larger changes require coordination with the platform team.

## Likely next step
Software-Eval — evaluate whether the existing upload component can be extended with richer client-side validation and rejection-reason rendering, or whether a replacement component is justified. The choice depends on the per-document-type rejection data still to be pulled.

## Open Questions & Assumptions
- [Assumption] Q1 baseline cycle time of 8 days is the right reference point. Source: Q1 operations review deck, to be reverified.
- [Assumption] 18% re-request rate (handler-side tally) generalises to the full claim population.
- [Open question] Distribution of rejection reasons by document type (data not yet extracted from portal logs).
- [Open question] Mobile vs. desktop split of re-request loops (instrumentation gap).
- [Open question] Does the Retail Motor squad have capacity to take this on at next quarter's planning, or does it need to compete in the broader Claims portfolio prioritisation?
