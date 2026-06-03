# Problem One-Pager — Slow deploys driven by monolithic integration test suite

_Classification: Internal Use Only_
_Date: 2026-06-03_
_Mode used: warn_

## Background

The platform team's Jenkins-based deploy pipeline is shared across 3 squads (~40 developers). Manager surfaced the issue after observing a Jenkins build log showing a config-file-only change that took 47 minutes to deploy to staging, with 35 of those minutes spent in the integration test stage running the full suite. A separate, distinct concern about Friday-specific pipeline breakage was raised initially but is explicitly parked — this one-pager covers only the slow-deploy problem.

## Current Condition

Every deploy through the shared Jenkins pipeline runs the full integration test suite (~2,000 tests, [Assumption]) regardless of which code paths actually changed. This makes deploys disproportionately slow for small changes and creates productivity drag and incident-response risk.

- **Who is affected:**
  - Primary: the developer who pushed the change — blocked from finishing related work while waiting for verification.
  - Secondary: the wider 3-squad cohort (~40 devs) when deploys serialize during peak hours.
  - Indirect: customers affected by delayed hotfixes, since hotfixes flow through the same slow path.
  - Compliance/audit stakeholders — currently rely on the pipeline's test coverage as audit evidence.
- **How often / how much:**
  - 15–25 deploys/day across the 3 squads (weekdays; fewer on Fridays). [Assumption — rough estimate]
  - Typical deploy duration: 25–35 min. [Assumption]
  - Observed high-end: 47 min (one Jenkins log).
  - Of that, ~35 min is the test stage; secondary suspicion is ~8–10 min of repeated test fixture setup. [Assumption]
- **Current workarounds (all brittle):**
  - Informal batching of small changes into larger PRs to "earn" the deploy time → **side effect: bigger blast radius on failure**.
  - `--skip-integration-tests` flag used 2–3 times/week, mostly for hotfixes or end-of-day pressure. Officially discouraged. [Assumption]
  - Behavioral avoidance: some devs stop pushing small changes on Fridays and wait until Monday — invisible productivity tax.
  - A 2025 hackathon prototype of selective testing worked technically but was never productionized — **no owner emerged**.

## Target Condition

Tiered deploy-time targets, observable from Jenkins metrics:

- **P50 deploy time < 10 min** for typical changes.
- **P95 deploy time < 20 min**.
- **Config-only or doc-only changes deploy in under 5 min** (separate fast path).
- **Hotfixes have a guaranteed fast path under 8 min**, independent of regular pipeline load.
- **`--skip-integration-tests` usage drops to near zero** because the standard path is fast enough not to require workarounds.

## Suspected Causes (hypotheses, not conclusions)

- **[Hypothesis]** The integration test suite is monolithic — it has no notion of which tests apply to which code path, so it executes all ~2,000 tests on every change regardless of scope. Untested but matches the symptoms.
- **[Hypothesis]** Test data setup is repeated per test class instead of being shared, adding ~8–10 min of pure fixture overhead per run. Untested.

## Scope

**In scope:**
- The Jenkins pipeline shared by the platform team and 2 partner squads.
- The integration test stage and how it selects/runs tests.
- A scheme for differentiating typical / config-only / hotfix paths while preserving audit coverage.
- Ownership/sustainment of any new selective-testing mechanism (lessons from the failed 2025 hackathon attempt).

**Out of scope:**
- The Friday-specific pipeline breakage issue (parked — separate problem to be framed later).
- Replacing Jenkins (org has committed to Jenkins for at least 12–18 months post-migration).
- Org-wide pipeline standardization beyond the 3 squads currently sharing this pipeline.
- Unit-test stage performance.
- Production deploy stage (this is about staging deploy time and the test stage that gates it).

## Constraints

- **Compliance / audit:** every production deploy must show a successful test run covering the changed components. Skipping tests entirely is not allowed; **selective execution that demonstrably covers the change is acceptable**.
- **Tooling:** Jenkins for at least 12–18 months — no appetite for a CI platform migration.
- **Organisational:** no dedicated DevEx team. **Whoever proposes the solution will likely also have to own it** — this is the same gap that killed the 2025 hackathon prototype. Sustainment must be part of any proposal.
- **Budget:** no hard cap stated, but any solution requiring new licensed tooling will need a business case.

## Likely next step

**Software / Tool evaluation** — specifically test-impact-analysis or selective-testing tooling that integrates with Jenkins. Justification: hypothesis is concrete enough to evaluate against, the constraint set (Jenkins, audit-acceptable selectivity, sustainment) narrows the candidate space, and a prior in-house attempt failed on ownership rather than technology — so a structured evaluation that includes the sustainment dimension is the right next move. An ADR may follow once options are narrowed. Not a Standard yet — too early and scope is 3 squads, not org-wide.

## Open Questions & Assumptions

- **[Assumption]** Test suite size is ~2,000 tests — to be verified against the Jenkins config or test inventory.
- **[Assumption]** Typical deploy duration of 25–35 min — recommend pulling actual P50/P95 from Jenkins build history before evaluation kicks off, to set the baseline.
- **[Assumption]** Skip-integration-tests flag is used 2–3 times/week — verify by querying audit logs.
- **[Assumption]** Test fixture setup contributes ~8–10 min per run — verify by profiling one run before treating it as a primary lever.
- **[Open question]** What does the audit team consider sufficient evidence of "test coverage of changed components"? This shapes which selective-testing approaches are viable.
- **[Open question]** Will any of the 3 squads sharing the pipeline volunteer ownership, or does a cross-squad working group need to be formed first? This is the same failure mode that killed the 2025 attempt.
- **[Open question]** Is the parked Friday-breakage issue actually independent, or is it a downstream symptom of the slow-pipeline problem (e.g. end-of-week bunching)? To be re-examined after this problem is addressed.

## Coaching Notes

The following red flags came up during framing and were resolved during the conversation — recording them for transparency:

- **Conflated problems:** initial framing was "pipeline keeps breaking on Fridays"; concrete artifact was "deploy is slow". User caught the conflation after it was flagged. The Friday-breakage problem is now explicitly parked.
- **Passive 'someone said':** initial trigger was "my manager showed me the problem". Resolved by asking for the actual artifact (Jenkins log).
- **Magnitude initially missing:** magnitude (40 devs, 15–25 deploys/day, 25–35 min typical) was reconstructed via best-estimate assumptions, all labeled. Recommend backing these with real Jenkins metrics before committing to the evaluation scope.
