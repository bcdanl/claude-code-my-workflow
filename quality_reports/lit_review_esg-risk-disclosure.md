# Literature Review: ESG Risk Ratings, Climate-Disclosure Regulation, and Rating-Change Identification

**Date:** 2026-06-12
**Query:** `/lit-review` (topic inferred from the project — "ESG Risk and Regulatory Uncertainty:
Evidence from U.S. Climate-Disclosure Shocks")

**Confidence tags:** [WEB-VERIFIED] = title/authors/venue confirmed via web search this session;
[UNVERIFIED] = drawn from prior knowledge, **author/year/venue must be checked before citing**.
The CoVe Post-Flight block at the bottom records the independent verifier's findings.

## Summary

This paper sits at the intersection of four literatures. (1) The **ESG-ratings measurement**
literature documents that ESG ratings diverge sharply across providers and are retroactively
revised, which both motivates studying *changes* in a single provider's ratings and supplies the
identification idea — a methodology overhaul as a source of quasi-exogenous variation. (2) The
**climate-disclosure-regulation** literature studies how mandates like the SEC's rule move firm
value and behavior; the existing work is mostly event studies around the 2022 *proposal*, leaving
the 2024 final-rule episode largely open. (3) The **real and pricing effects of ESG/climate risk**
literature asks whether ESG and carbon risk are priced and whether they change corporate behavior —
the outcome side of this paper. (4) The **shift-share / weak-IV econometrics** literature provides
the instrument construction (Bartik/shift-share) and the weak-identification-robust inference
(first-stage F thresholds, tF, Anderson–Rubin) that this paper's design requires.

The clearest gap this project fills: prior work treats ESG-rating revisions as a *nuisance*
(measurement error, look-ahead bias) rather than as *identifying variation*, and the SEC 2024
final-rule window has not been paired with a rating-methodology shock to study within-firm changes
in measured ESG risk and their real-behavior consequences.

## Key Papers

### Berg, Kölbel & Rigobon (2022) — "Aggregate Confusion: The Divergence of ESG Ratings" [WEB-VERIFIED]
- **Contribution:** Decomposes ESG-rating disagreement across six providers (incl. Sustainalytics).
- **Finding:** Measurement drives 56% of divergence, scope 38%, weight 6%; pairwise correlations
  0.38–0.71; a "rater effect" exists. *Review of Finance* 26(6):1315–1344.
- **Relevance:** Establishes that the *level* of ESG risk is provider-specific and noisy — the core
  reason to study within-firm *changes* in one provider (Sustainalytics) rather than cross-sections.

### Berg, Fabisik & Sautner (2021) — "Is History Repeating Itself? The (Un)Predictable Past of ESG Ratings" [WEB-VERIFIED]
- **Contribution:** Documents widespread *retroactive* rewriting of Refinitiv/ASSET4 ESG scores.
- **Finding:** Across two data vintages, ~87% of firm-year scores were downgraded; ESG–return
  relationships flip between vintages. ECGI/SSRN WP 3722087.
- **Relevance:** Direct precedent that rating-methodology revisions mechanically move measured ESG —
  the foundation of this paper's instrument; also a caution on data-vintage sensitivity.

### Kim (2024) — "The market reaction of S&P 500 firms to the SEC's mandatory climate disclosure proposal" [WEB-VERIFIED]
- **Method:** 3-day event study around the March 21, 2022 SEC proposal.
- **Finding:** ≈ −1.1% average abnormal return; better ESG performers, higher sales growth, and
  higher Tobin's Q firms saw attenuated negative reactions. *Journal of Corporate Accounting &
  Finance*.
- **Relevance:** Closest existing study of the SEC climate-rule episode; this paper extends from the
  2022 *proposal* reaction to within-firm ESG-risk and real-behavior changes around the 2024 *final*
  rule, and from average effects to rule-exposure heterogeneity.

### Goldsmith-Pinkham, Sorkin & Swift (2020) — "Bartik Instruments: What, When, Why, and How" [WEB-VERIFIED]
- **Contribution:** Clarifies that a shift-share (Bartik) instrument identifies under exogeneity of
  the *shares*, in a pooled-exposure design. *AER* 110(8):2586–2624.
- **Relevance:** Methodological backbone — this paper's leave-one-out industry-mean instrument is a
  shift-share; GPSS frames the exclusion restriction (cross-industry exogeneity) I must defend.

### Lee, McCrary, Moreira & Porter (2022) — "Valid t-Ratio Inference for IV" [WEB-VERIFIED]
- **Contribution:** The **tF** procedure: a first-stage-F-dependent SE adjustment for the single-IV
  model; shows conventional t-ratio inference is badly distorted at moderate F. *AER* 112(10):3260–90.
- **Finding:** tF CIs are shorter than Anderson–Rubin when both are bounded.
- **Relevance:** Directly governs this paper's inference — first-stage F of 9.5 (S) and 15.0 (G) sit
  in the range where tF/AR corrections matter; supports reporting AR intervals (which I do) and
  suggests adding tF as a complement.

### Borusyak, Hull & Jaravel (2022) — "Quasi-Experimental Shift-Share Research Designs" [UNVERIFIED]
- **Contribution (to confirm):** Identification from exogeneity of the *shocks* (vs. shares);
  shock-level inference. *Review of Economic Studies* (year/volume to verify).
- **Relevance:** The complementary "shocks" view of shift-share; relevant because this paper's
  identifying variation is the common rating-methodology *shock*.

### Andrews, Stock & Sun (2019) — "Weak Instruments in IV Regression: Theory and Practice" [UNVERIFIED]
- **Contribution (to confirm):** Survey of weak-IV diagnostics and robust inference. *Annual Review
  of Economics* (vol. to verify).
- **Relevance:** Anchors the weak-IV-robust reporting (effective F, AR) used here.

### Galema & Gerritsen (2025) — "ESG rating changes and stock returns" [WEB-VERIFIED; corrected]
- **Correction (CoVe):** I had mis-attributed a *Sustainalytics-methodology / temporary-effect*
  finding to this article id. It is in fact about **MSCI** ESG *score-change* events producing a
  **prolonged** (multi-month) price adjustment (≈3% annualized abnormal return over 6-month holds
  after downgrades). *Journal of International Money and Finance* 154:103309 (2025).
- **Relevance:** Evidence that *rating changes* (not levels) move prices — the outcome-side analogue
  of this paper, for a different provider and on returns rather than real behavior.

### Rzeźnik, Weiss Hanley & Pelizzon (2025/2026) — "Investor Reliance on ESG Ratings and Stock Price Performance" [PDF-VERIFIED — author copy in `references/`]
- **Confirmed from the PDF** (SAFE WP No. 310, dated Aug 20 2025; *Management Science*, online May 29
  2026). Authors: **Aleksandra Rzeźnik (York), Kathleen Weiss Hanley (Lehigh), Loriana Pelizzon
  (Leibniz SAFE / Goethe Frankfurt / Ca' Foscari / CEPR).** Previously circulated as "The Salience
  of ESG Ratings for Stock Pricing: Evidence From (Potentially) Confused Investors" (same paper).
- **Design:** Exploits **Sustainalytics' Sept-2018 methodology change** (disseminated to retail via
  Morningstar/Yahoo! Finance in Oct 2019) as an exogenous shock to how ESG risk is *measured*,
  independent of fundamentals. The revision moved from **managed** risk (relative to industry peers)
  to **unmanaged** risk (absolute exposure), which **inverted the 0–100 scale** (old: higher = better
  ESG; new: higher = more risk). They **decompose each firm's rating change into three components**:
  (i) the mechanical *inversion* (no info), (ii) the *methodology-driven* component, (iii) *firm
  fundamentals*.
- **Finding:** Changes in the new ratings are positively associated with future abnormal returns;
  larger rating declines (increases) → lower (higher) subsequent abnormal returns. Retail investors
  misread the change; 13F institutions and short-sellers trade against them. Blind reliance generates
  mispricing.
- **Relevance to this paper (three load-bearing links):**
  1. **The direct precedent for the identification** — Sustainalytics methodology change as
     quasi-exogenous variation in measured ESG. Position explicitly.
  2. **Distinct contribution:** their channel is investor *confusion / pricing*; this paper studies
     the *within-firm risk change* and its *real-behavior* consequences — a different outcome side.
  3. **Their three-way decomposition** (inversion / methodology / fundamentals) is the template for
     this paper's shift-share instrument, which isolates the common *methodology-driven* component.
     Also: they note the post-2018 framework scores **absolute, cross-industry-comparable** risk —
     a substantive reason this paper identifies *across* industries (no industry FE).
  - **NB on vintage:** their shock is the **2018** transition; this project's instrument is a
    **later (2024–25)** Sustainalytics change on the post-2018 *risk* scale. Same provider, same
    idea, different vintage — make that explicit so the contribution is not mistaken for a replication.

### Christensen, Hail & Leuz (2021) — mandatory CSR / sustainability-reporting review [UNVERIFIED]
- **Contribution (to confirm):** Survey of the economic consequences of mandatory CSR/sustainability
  disclosure. *Review of Accounting Studies* (to verify).
- **Relevance:** Frames the disclosure-regulation literature this paper contributes to.

### Pricing-of-climate-risk cluster [UNVERIFIED — verify each before citing]
- **Bolton & Kacperczyk (2021), *JFE*** — a carbon premium in the cross-section of returns.
- **Pástor, Stambaugh & Taylor (2021/2022), *JFE*** — sustainable investing in equilibrium / green
  returns.
- **Pedersen, Fitzgibbons & Pomorski (2021), *JFE*** — the ESG-efficient frontier.
- **Krueger, Sautner & Starks (2020), *RFS*** — climate risks for institutional investors.
- **Relevance:** The market-outcome side (cost of capital, returns) this paper flags as the
  first-order open question once market data are added.

## Thematic Organization

**Theoretical/measurement.** Berg–Kölbel–Rigobon and Berg–Fabisik–Sautner establish that ESG levels
are noisy and revisable; Pástor–Stambaugh–Taylor and Pedersen et al. give equilibrium frameworks for
why ESG/green characteristics would be priced.

**Empirical — disclosure regulation.** Kim (2024) and (pending) Christensen–Hail–Leuz are the
disclosure-effects anchors; the 2024 *final*-rule window is largely unstudied.

**Empirical — real/pricing effects of ESG & climate risk.** Bolton–Kacperczyk, Krueger–Sautner–Starks,
and the ESG-rating-change/return paper supply the outcome-side priors (mostly pricing; real-behavior
effects of *measured-risk changes* are thinner — this paper's contribution).

**Methodological.** Goldsmith-Pinkham–Sorkin–Swift and Borusyak–Hull–Jaravel for shift-share
identification; Lee et al. (tF) and Andrews–Stock–Sun for weak-IV-robust inference.

## Gaps and Opportunities

1. **Rating revisions as identification, not nuisance.** The measurement literature treats
   methodology changes as a data problem; none (to my knowledge) uses a provider's overhaul as an
   instrument for within-firm ESG-risk changes. **Verify this negative claim** before asserting it.
2. **The 2024 *final*-rule window.** Existing event studies stop at the 2022 proposal; the final-rule
   episode + its legal stay (a clean "salience-with-uncertainty" shock) is open.
3. **Real-behavior (not just pricing) outcomes.** Most evidence is on returns/cost of capital; the
   pass-through of measured-ESG changes to financing/investment — and its heterogeneity by
   rule-exposure — is underexplored (this paper's heterogeneity result speaks here).

## Suggested Next Steps

- Obtain and read the JIMF (2025) Sustainalytics-rating-change paper and Kim (2024) in full to
  position the contribution precisely.
- Verify Borusyak–Hull–Jaravel, Andrews–Stock–Sun, Christensen–Hail–Leuz, and the pricing cluster
  cites (years/venues) before they enter `Bibliography_base.bib`.
- Add **tF** inference (Lee et al.) alongside the existing Anderson–Rubin intervals.
- Run `/verify-claims` on the manuscript once these enter the bib; populate the 8 `\TODO` markers in
  `paper/main.tex`.

## BibTeX Entries

> Only [WEB-VERIFIED] entries carry full confidence. [UNVERIFIED] entries are placeholders with a
> `note = {VERIFY ...}` field — do not cite until checked.

```bibtex
@article{BergKolbelRigobon2022_aggregate_confusion,
  author  = {Berg, Florian and K{\"o}lbel, Julian F. and Rigobon, Roberto},
  title   = {Aggregate Confusion: The Divergence of {ESG} Ratings},
  journal = {Review of Finance},
  volume  = {26}, number = {6}, pages = {1315--1344}, year = {2022}
}

@article{BergFabisikSautner2021_rewriting_history,
  author = {Berg, Florian and Fabisik, Kornelia and Sautner, Zacharias},
  title  = {Is History Repeating Itself? The (Un)Predictable Past of {ESG} Ratings},
  journal = {ECGI Finance Working Paper / SSRN 3722087}, year = {2021},
  note = {Working paper; confirm latest version/venue.}
}

@article{Kim2024_sec_climate_reaction,
  author = {Kim, [first name to confirm]},
  title  = {The Market Reaction of {S\&P} 500 Firms to the {SEC}'s Mandatory Climate Disclosure Proposal},
  journal = {Journal of Corporate Accounting \& Finance}, year = {2024},
  note = {Confirm author first name, volume, pages.}
}

@article{GoldsmithPinkhamSorkinSwift2020_bartik,
  author = {Goldsmith-Pinkham, Paul and Sorkin, Isaac and Swift, Henry},
  title  = {Bartik Instruments: What, When, Why, and How},
  journal = {American Economic Review}, volume = {110}, number = {8},
  pages = {2586--2624}, year = {2020}
}

@article{LeeMcCraryMoreiraPorter2022_valid_tratio,
  author = {Lee, David S. and McCrary, Justin and Moreira, Marcelo J. and Porter, Jack},
  title  = {Valid $t$-Ratio Inference for {IV}},
  journal = {American Economic Review}, volume = {112}, number = {10},
  pages = {3260--3290}, year = {2022}
}

% ---- UNVERIFIED — confirm before citing ----
@article{BorusyakHullJaravel2022_shift_share,
  author = {Borusyak, Kirill and Hull, Peter and Jaravel, Xavier},
  title  = {Quasi-Experimental Shift-Share Research Designs},
  journal = {Review of Economic Studies}, year = {2022},
  note = {VERIFY volume/issue/pages.}
}
@article{AndrewsStockSun2019_weak_iv,
  author = {Andrews, Isaiah and Stock, James H. and Sun, Liyang},
  title  = {Weak Instruments in Instrumental Variables Regression: Theory and Practice},
  journal = {Annual Review of Economics}, year = {2019},
  note = {VERIFY volume/pages.}
}
```

(Additional [UNVERIFIED] entries — Christensen–Hail–Leuz, Bolton–Kacperczyk, Pástor–Stambaugh–Taylor,
Pedersen et al., Krueger–Sautner–Starks, and the JIMF 2025 rating-change paper — to be added after
verification.)

## Post-Flight Verification (CoVe) — claim-verifier, fresh context

**Outcome:** FAIL → **resolved**. 1 HIGH-WARN (C13 misattribution, corrected above); 12/13 PASS,
several with volume/page details filled. The verifier never saw this draft — only the claim list.

**The error caught:** C13 attached a "Sustainalytics-methodology / temporary-effect" finding to
JIMF article S0261560625000440, which is actually Galema & Gerritsen (2025) on **MSCI** score
changes with **prolonged** effects — a wrong-author + wrong-direction attribution. Fixed in the
Key Papers section; the Sustainalytics result is now attributed to Rzeźnik–Scholtens–Shen (flagged
for independent confirmation).

**Verified BibTeX (ready for `Bibliography_base.bib` — all details confirmed by the verifier):**

```bibtex
@article{BergKolbelRigobon2022_aggregate_confusion,
  author = {Berg, Florian and K{\"o}lbel, Julian F. and Rigobon, Roberto},
  title = {Aggregate Confusion: The Divergence of {ESG} Ratings},
  journal = {Review of Finance}, volume = {26}, number = {6}, pages = {1315--1344}, year = {2022}}

@unpublished{BergFabisikSautner2021_rewriting_history,
  author = {Berg, Florian and Fabisik, Kornelia and Sautner, Zacharias},
  title = {Is History Repeating Itself? The (Un)Predictable Past of {ESG} Ratings},
  note = {ECGI Finance Working Paper; SSRN 3722087}, year = {2021}}

@article{Kim2024_sec_climate_reaction,
  author = {Kim, Martin M.},
  title = {The Market Reaction of {S\&P} 500 Firms to the {SEC}'s Mandatory Climate Disclosure Proposal},
  journal = {Journal of Corporate Accounting \& Finance}, volume = {35}, number = {4},
  pages = {110--120}, year = {2024}}

@article{GoldsmithPinkhamSorkinSwift2020_bartik,
  author = {Goldsmith-Pinkham, Paul and Sorkin, Isaac and Swift, Henry},
  title = {Bartik Instruments: What, When, Why, and How},
  journal = {American Economic Review}, volume = {110}, number = {8}, pages = {2586--2624}, year = {2020}}

@article{LeeMcCraryMoreiraPorter2022_valid_tratio,
  author = {Lee, David S. and McCrary, Justin and Moreira, Marcelo J. and Porter, Jack},
  title = {Valid $t$-Ratio Inference for {IV}},
  journal = {American Economic Review}, volume = {112}, number = {10}, pages = {3260--3290}, year = {2022}}

@article{BorusyakHullJaravel2022_shift_share,
  author = {Borusyak, Kirill and Hull, Peter and Jaravel, Xavier},
  title = {Quasi-Experimental Shift-Share Research Designs},
  journal = {Review of Economic Studies}, volume = {89}, number = {1}, pages = {181--213}, year = {2022}}

@article{AndrewsStockSun2019_weak_iv,
  author = {Andrews, Isaiah and Stock, James H. and Sun, Liyang},
  title = {Weak Instruments in Instrumental Variables Regression: Theory and Practice},
  journal = {Annual Review of Economics}, volume = {11}, pages = {727--753}, year = {2019}}

@article{ChristensenHailLeuz2021_mandatory_csr,
  author = {Christensen, Hans B. and Hail, Luzi and Leuz, Christian},
  title = {Mandatory {CSR} and Sustainability Reporting: Economic Analysis and Literature Review},
  journal = {Review of Accounting Studies}, volume = {26}, number = {3}, pages = {1176--1248}, year = {2021}}

@article{BoltonKacperczyk2021_carbon_risk,
  author = {Bolton, Patrick and Kacperczyk, Marcin},
  title = {Do Investors Care about Carbon Risk?},
  journal = {Journal of Financial Economics}, volume = {142}, number = {2}, pages = {517--549}, year = {2021}}

@article{PastorStambaughTaylor2021_sustainable_equilibrium,
  author = {P{\'a}stor, {\v L}ubo{\v s} and Stambaugh, Robert F. and Taylor, Lucian A.},
  title = {Sustainable Investing in Equilibrium},
  journal = {Journal of Financial Economics}, volume = {142}, number = {2}, pages = {550--571}, year = {2021}}

@article{PastorStambaughTaylor2022_green_returns,
  author = {P{\'a}stor, {\v L}ubo{\v s} and Stambaugh, Robert F. and Taylor, Lucian A.},
  title = {Dissecting Green Returns},
  journal = {Journal of Financial Economics}, volume = {146}, number = {2}, pages = {403--424}, year = {2022}}

@article{PedersenFitzgibbonsPomorski2021_esg_frontier,
  author = {Pedersen, Lasse Heje and Fitzgibbons, Shaun and Pomorski, Lukasz},
  title = {Responsible Investing: The {ESG}-Efficient Frontier},
  journal = {Journal of Financial Economics}, volume = {142}, number = {2}, pages = {572--597}, year = {2021}}

@article{KruegerSautnerStarks2020_climate_institutional,
  author = {Krueger, Philipp and Sautner, Zacharias and Starks, Laura T.},
  title = {The Importance of Climate Risks for Institutional Investors},
  journal = {Review of Financial Studies}, volume = {33}, number = {3}, pages = {1067--1111}, year = {2020}}

@article{GalemaGerritsen2025_esg_rating_changes,
  author = {Galema, Rients and Gerritsen, Dirk},
  title = {{ESG} Rating Changes and Stock Returns},
  journal = {Journal of International Money and Finance}, volume = {154}, pages = {103309}, year = {2025}}

@article{RzeznikWeissHanleyPelizzon2026_investor_reliance,
  author  = {Rze{\'z}nik, Aleksandra and Weiss Hanley, Kathleen and Pelizzon, Loriana},
  title   = {Investor Reliance on {ESG} Ratings and Stock Price Performance},
  journal = {Management Science}, year = {2026},
  note    = {Published online 29 May 2026; SAFE Working Paper No. 310 (Aug 2025).
             Previously circulated as ``The Salience of ESG Ratings for Stock Pricing.''}
}
```

Still [UNVERIFIED] (confirm before citing): **Rzeźnik, Scholtens & Shen** (Sustainalytics 2018–2019
methodology overhaul) — the single most relevant precedent; pull its exact reference next.

## Sources (web searches this session)
- [Aggregate Confusion — Oxford Academic](https://academic.oup.com/rof/article/26/6/1315/6590670)
- [Kim (2024), JCAF — Wiley](https://onlinelibrary.wiley.com/doi/10.1002/jcaf.22719)
- [SEC final rule / delay — Federal Register](https://www.federalregister.gov/documents/2024/04/12/2024-07648/the-enhancement-and-standardization-of-climate-related-disclosures-for-investors-delay-of-effective)
- [ESG rating changes and stock returns — ScienceDirect](https://www.sciencedirect.com/science/article/pii/S0261560625000440)
- [Bartik Instruments — AEA](https://www.aeaweb.org/articles?id=10.1257/aer.20181047)
- [Valid t-Ratio Inference for IV — AEA](https://www.aeaweb.org/articles?id=10.1257/aer.20211063)
- [Is History Repeating Itself? — SSRN 3722087](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3722087)
