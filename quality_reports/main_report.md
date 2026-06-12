# Proofreading Report — `paper/main.tex`

**Date:** 2026-06-12 · **Agent:** proofreader (read-only) · **Confirmed issues:** 12 (0 typos, 0 LaTeX errors)

## Counts
| Category | Count |
|---|--:|
| Grammar | 4 |
| Typo | 0 |
| Consistency | 5 |
| Academic quality | 3 |
| LaTeX-specific | 0 |

## Findings (author applies manually)
| Line | Cat | Sev | Current | Fix |
|--:|---|---|---|---|
| 267 | Consistency | MED | `weak-IV-robust intervals` (1 of 7; rest are "weak-instrument-robust") | `weak-instrument-robust intervals` |
| 60 | Consistency | MED | abstract: "instrument is **moderately strong** ($F=9.5$ and $15.0$)" — body says G strong, S moderate | "strong for governance and moderate for social risk ($F=15.0$ and $9.5$, respectively)" |
| 154 | Grammar | MED | `(income statement, balance sheet, and cash-flow)` — dangling modifier | `…and cash-flow statement)` |
| 258–259 | Grammar | MED | "the AR **interval still contains** zero" (singular; rest plural) | "the AR **intervals still contain** zero" |
| 82 | Terminology | MED | research Q uses "**carry through**"; paper's term is "pass-through" | "does any such movement **pass through** to…" |
| 148–150 | Grammar | MED | "revisions **applied**… they **generate** variation" (tense mix) | "they **generated** variation" |
| 65/279/281/291 | Consistency | MED | "climate-sensitive sectors" / "…industries" / "climate-sector" | standardize the full term (e.g., "climate-sensitive industries"); shorthand OK after intro |
| 269–271 | Academic | MED | "$0.019$ … moves leverage by $1.9$ percentage points" — scale implicit | state "leverage as a fraction" so the 0.019→1.9pp conversion verifies |
| 127 | Academic | MED | intro cites Pástor-Stambaugh-Taylor **2021** (equilibrium) for "ESG is priced" | the **2022** "Dissecting Green Returns" is the stronger cite for a pricing claim — verify intent |
| 142–143 | Grammar | LOW | footnote: "…March 6, 2024 and stayed it…" | comma before "and" (date clarity) |
| 236 | Consistency | LOW | lowercase `equation~\ref` (Table/Figure/Section capitalized) | `Equation~\ref{eq:instrument}` |
| 296 | Academic | LOW | "I **read this as**" (colloquial) | "I **interpret this as**" |

## Top 3
1. **Line 267** — `weak-IV-robust` → `weak-instrument-robust` (lone inconsistent instance).
2. **Line 60** — abstract mischaracterizes instrument strength vs. the body (a referee will spot the abstract↔body mismatch).
3. **Line 154** — `cash-flow` → `cash-flow statement` (dangling hyphenated modifier).

## Note
Cleared as non-issues on inspection: all `\citet`/`\citep` usages (grammatically correct), the instrument equation notation, hyphenation of "industry-mean" (correct per syntactic position), and the "four firms in five" ≈ 80.1% intentional rounding.
