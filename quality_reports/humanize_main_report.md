# Humanize Audit — `paper/main.tex`

**Date:** 2026-06-12
**Auditor:** humanize-auditor (fresh context)
**Prose audited:** ~2,050 words (abstract + 4 sections + conclusion; excl. preamble/math/inputs/TODO).
**Findings:** 7 total — **0 HIGH, 5 MED, 2 LOW**. **HIGH per 1,000 words: 0.0.**
**Recommendation: cosmetic cleanup** (no rewrite/strip warranted).

## Per-category counts
| Cat | HIGH | MED | LOW |
|---|--:|--:|--:|
| 1 Boilerplate transitions | 0 | 0 | 0 |
| 2 AI-cliché lexicon | 0 | 1 | 0 |
| 3 Em-dash / punctuation | 0 | 3 | 0 |
| 4 Symmetric paragraphs | 0 | 0 | 0 |
| 5 Tricolon abuse | 0 | 0 | 1 |
| 6 Hedging stacking | 0 | 0 | 0 |
| 7 "Not only X but also Y" | 0 | 0 | 0 |
| 8 Formulaic openers | 0 | 1 | 1 |
| 9 Hyphenation excess | 0 | 0 | 0 |
| 10 Sycophancy | 0 | 0 | 0 |

## Findings (author edits manually — skill does not rewrite)
| Line | Cat | Sev | Issue | Suggested fix |
|--:|---|---|---|---|
| 108–114 | 2 | MED | "providing a template for…" + "a useful benchmark for…" — soft self-promo that understates the result | State the contribution directly; replace "a useful benchmark" with the precise null. |
| 51/59/64 | 3 | MED | Abstract carries **3 em-dashes in ~9 sentences** | Convert two sandwiches to comma-parentheticals, e.g. line 51 `---a major but legally contested mandate` → ", a mandate whose legality was immediately contested,". |
| 237–238 | 3 | MED | Longest em-dash sandwich (six-item list inside dashes) | Use a colon, or move the list to the prior sentence. |
| 280–282 | 3 | MED | Third double-em-dash sandwich in Results → patterned, not deliberate | Rephrase to a colon + a second sentence. |
| 130–133 | 8 | MED→LOW | Four-sentence roadmap; "Section X concludes" is empty | Drop the final roadmap item (field-normal otherwise). |
| 108/116 | 8 | LOW | Two consecutive paragraphs open "This paper…" | Vary one opener. |
| 56–58 | 5 | LOW | Abstract lists 5 outcomes; intro lists 4 — unsignalled mismatch | Make the two lists consistent. |

## Top tell-concentrated paragraphs
1. **Abstract (47–70)** — em-dash density (3) + list-consistency. Highest-priority (first thing a referee reads).
2. **Contribution paragraph (108–114)** — soft cliché + formulaic opener.
3. **Heterogeneity paragraph (277–297)** — the em-dash pattern's confirming instance.

## Bottom line
Clean by the skill's thresholds: disciplined hedging, accurate quantitative reporting, **no AI-lexicon contamination**, no boilerplate transitions, no sycophancy. The four MED items are punctuation/phrasing polish, not voice contamination.
