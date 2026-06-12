# Reproducibility Audit: ESG Risk and Regulatory Uncertainty (`paper/main.tex`)

**Date:** 2026-06-12 · **Outputs:** `scripts/R/_outputs/` (fresh; `sessionInfo.txt` present)
**Tolerance source:** `.claude/rules/replication-protocol.md`

## Summary
| Status | Count |
|---|--:|
| PASS | 17 |
| FAIL (no named alternative) | 1 → **fixed (PAPER-CORRECTED)** |
| EXPLAINED | 0 |
| UNMATCHED | 0 |
| **Verdict** | **PASS after fix** |

## FAIL → fixed (PAPER-CORRECTED)
| Claim | Reported (text) | Computed | Resolution |
|---|---|---|---|
| Dummy first-stage F "near zero" (Instrument-strength ¶) | "(first-stage $F$ near zero)" | dummy F = **0.03 (E), 0.34 (S), 9.84 (G)** | Text contradicted the paper's own Table~1 for governance (9.84 ≠ "near zero"). Computed value correct → text rewritten to "negligible for E and S ($F=0.03$, $0.34$) and moderate for governance ($F=9.8$)." |

## PASS (within tolerance)
| Claim | Reported | Computed | OK |
|---|---|---|---|
| Governance fell for 88.9% | 88.9% | 88.889% | ✓ |
| Gov mean change | −1.19 | −1.1877 | ✓ |
| Environmental % up / mean | 55.6% / +0.38 | 55.556% / 0.3773 | ✓ |
| Social mean | +0.02 | 0.0221 | ✓ |
| Controversy unchanged | 80.1% | 80.073% | ✓ |
| Balanced panel N | 625 | 625 | ✓ |
| Firms w/ financials | 613 | 613 | ✓ |
| First-stage F (shift-share) E/S/G | 5.2 / 9.5 / 15.0 | 5.24 / 9.52 / 14.95 | ✓ |
| Stock–Yogo threshold | 16.4 | (literature constant) | ✓ |
| No IV coefficient significant | (all p>0.05) | min p = 0.16 | ✓ |
| All AR intervals contain 0 | yes | yes (all rows) | ✓ |
| ΔE×large → leverage | +0.006, p<0.01 | 0.0062, p=0.0055 | ✓ |
| ΔE×large → capex | +0.005, p<0.05 | 0.0045, p=0.015 | ✓ |
| ΔE×climate → net debt iss. | −0.005, p<0.05 | −0.0049, p=0.021 | ✓ |
| 3 interactions survive BH q<0.10 | 3 | 3 (q=0.065, 0.085, 0.085) | ✓ |
| Gov→leverage benchmark | 0.019, AR [−0.005, 0.058] | 0.01918, [−0.00548, 0.05753] | ✓ |
| Benchmark magnitudes | 1.9pp / ~6pp / ~1.2 pts / ~−2pp | 0.019 / 0.058 / 1.19 / −0.023 | ✓ |

## Environment
`scripts/R/_outputs/sessionInfo.txt` (R 4.5.3; fixest 0.14.0; tidyverse 2.0.0). Seed 20260413.

## Verdict
After the one PAPER-CORRECTED fix, **0 FAIL / 0 UNMATCHED** → the manuscript's numeric claims
reproduce from the pipeline outputs within tolerance. Replication-ready on the numbers.
