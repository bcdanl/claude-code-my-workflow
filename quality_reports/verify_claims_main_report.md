# /verify-claims — `paper/main.tex` (Chain-of-Verification)

**Date:** 2026-06-12 · **Verifier:** claim-verifier (fresh context, never saw the draft)
**Claims extracted:** 12 (10 citation-appropriateness + 2 external facts)
**Initial outcome:** FAIL — 1 HIGH-WARN, 1 MED-WARN, 10 PASS → **both fixed → now PASS.**

> Numeric claims (88.9%, F=9.5/15.0/5.2, the 0.019 estimate, heterogeneity p-values) are
> own-computed and trace to `scripts/R/_outputs/` — out of CoVe scope; covered by `/audit-reproducibility`.

## Fixed
- **C7 (HIGH-WARN, mis-attribution):** Lee, McCrary, Moreira & Porter (2022) — the *tF* paper — was
  cited for "Anderson–Rubin intervals valid under weak identification." AR validity is Anderson–Rubin
  (1949) / Andrews-Stock-Sun (2019). **Fixed:** AR-validity sentence now cites
  `AndrewsStockSun2019_weak_iv`. (Lee et al. remains cited once, correctly, as general
  weak-IV-robust inference.)
- **C11 (MED-WARN, imprecise pairing):** footnote paired the adoption release (33-11275) with the
  stay release (34-99908) across two SEC actions. **Fixed:** "final rule (Release No. 33-11275) …
  stayed … (Release Nos. 33-11280 and 34-99908)." Dates (Mar 6 / Apr 4, 2024) were already correct.

## Verified PASS (10)
Berg-Kölbel-Rigobon (divergence), Berg-Fabisik-Sautner (retroactive revision), **Rzeźnik et al.**
(2018 Sustainalytics overhaul as shock → prices via investor reliance — confirmed verbatim from the
PDF), Christensen-Hail-Leuz (disclosure regulation), Kim 2024 (SEC proposal reaction), Goldsmith-
Pinkham et al. + Borusyak-Hull-Jaravel (shift-share), Galema-Gerritsen (rating changes move returns),
Pástor-Stambaugh-Taylor 2021/2022 + Pedersen et al. (green-asset pricing), and the Sustainalytics
Sept-2018 / Oct-2019 dissemination dates (confirmed from the PDF).

## Status
0 HIGH-WARN remaining → the `/verify-claims` gate now passes. Citation attributions hold; external
facts confirmed against primary/corroborating sources.
