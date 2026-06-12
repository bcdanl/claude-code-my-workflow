# `paper/` — LaTeX manuscript

The research paper for **"ESG Risk and Regulatory Uncertainty: Evidence from U.S.
Climate-Disclosure Shocks"** (Byeong-Hak Choe, SUNY Geneseo).

## Conventions

- **Main file:** `main.tex` (single-authored — "I" voice; see
  `.claude/rules/writing-style-choe.md`).
- **Build order:** `main.tex` `\input`s tables and `\includegraphics`es figures from the
  **gitignored** `../scripts/R/_outputs/` (via `\graphicspath`). Run the pipeline first, then
  compile: `Rscript scripts/R/00_run_all.R` → `cd paper && pdflatex main.tex` (2 passes for refs).
  A fresh clone has no `_outputs/`, so the pipeline must run before the paper compiles.
- **Draft status:** prose is a working draft; `\TODO{...}` (red) marks every place needing a real
  citation or a magnitude benchmark. No references are fabricated (bib is empty).
- **Bibliography:** the repo-root `Bibliography_base.bib` is canonical. No per-paper `.bib`.
- **Tables and figures are generated, never hand-typed.** They are produced by the R
  pipeline and live in `scripts/R/_outputs/`. `main.tex` `\input{}`s tables and
  `\includegraphics{}`s figures from there. Every number traces to code (INV-13) and is
  logged in `quality_reports/passports/esg-risk.yaml`.
- **Compile:** `latexmk -pdf main.tex` (or `xelatex -interaction=nonstopmode main.tex`).
- **Before submission:** `/audit-reproducibility paper/main.tex`, then `/verify-claims`,
  `/review-paper --peer`.

Manuscript drafting has not started — this directory is a placeholder until the data
pipeline produces results.
