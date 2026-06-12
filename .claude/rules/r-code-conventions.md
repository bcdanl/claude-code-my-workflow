---
paths:
  - "Figures/**/*.R"
  - "scripts/**/*.R"
  - "explorations/**/*.R"
---

# R Code Standards

**Standard:** Senior Principal Data Engineer + PhD researcher quality

> **Scope:** These standards apply to **analysis scripts** — data work, simulations, figure generation (a top-level `set.seed()`, `library()` at the top, relative output paths). For R **package source** (`R/`, `tests/`, `DESCRIPTION`, `NAMESPACE`, `man/`), see [`r-package-conventions.md`](r-package-conventions.md), which has different rules (roxygen-generated `NAMESPACE`, no `library()` in `R/`, CRAN policy). The numerical discipline in §8 applies to both.

---

## 1. Reproducibility

- `set.seed()` called ONCE at top (YYYYMMDD format)
- All packages loaded at top via `library()` (not `require()`)
- All paths relative to repository root
- `dir.create(..., recursive = TRUE)` for output directories

## 2. Function Design

- `snake_case` naming, verb-noun pattern
- Roxygen-style documentation
- Default parameters, no magic numbers
- Named return values (lists or tibbles)

## 3. Domain Correctness

<!-- Customize for your field's known pitfalls -->
- Verify estimator implementations match slide formulas
- Check known package bugs (document below in Common Pitfalls)

## 4. Visual Identity

**This is a paper project: figures are for LaTeX inclusion and must be
publication-ready on the first pass.** Restrained, print-safe, colorblind-aware.

```r
# --- ESG-paper palette (print-safe; Okabe–Ito-derived) ---
primary_navy   <- "#1f2a44"   # main series / axis emphasis
accent_teal    <- "#2c7fb8"   # secondary series
accent_amber   <- "#d9883b"   # third series / highlight
neutral_gray   <- "#6b6f76"   # gridlines, de-emphasis
positive_green <- "#117733"   # gains / "good" annotations (colorblind-safe)
negative_red   <- "#cc6677"   # losses / "bad" annotations (colorblind-safe)

# Pillar colors (E/S/G) — used consistently across every figure in the paper.
pillar_cols <- c(E = "#117733", S = "#2c7fb8", G = "#88419d")
```

### Paper Theme
```r
theme_paper <- function(base_size = 11) {     # 11pt ≈ paper body text
  theme_minimal(base_size = base_size, base_family = "serif") +
    theme(
      plot.title       = element_text(face = "bold", color = primary_navy, size = rel(1.05)),
      plot.subtitle    = element_text(color = neutral_gray),
      axis.title       = element_text(color = primary_navy),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "grey90", linewidth = 0.3),
      legend.position  = "bottom",
      legend.title     = element_blank(),
      plot.margin      = margin(4, 6, 4, 4)
    )
}
```

### Figure Dimensions for the Paper (default)
```r
# Single-column LaTeX figure: ~6.5 in usable text width, 300 dpi for print.
# White (not transparent) bg — figures sit on a white page, not a dark slide.
ggsave(filepath, width = 6.5, height = 4, units = "in", dpi = 300, bg = "white")

# Dormant teaching path (Beamer slides) — transparent, wide — only if revived:
# ggsave(filepath, width = 12, height = 5, bg = "transparent")
```

## 5. RDS Data Pattern

**Heavy computations saved as RDS; slide rendering loads pre-computed data.**

```r
saveRDS(result, file.path(out_dir, "descriptive_name.rds"))
```

## 6. Common Pitfalls

<!-- Add your field-specific pitfalls here -->
| Pitfall | Impact | Prevention |
|---------|--------|------------|
| Hardcoded paths | Breaks on other machines | Use `here::here()` / relative paths |
| Reading from `data/` not `data/raw/` | File-not-found (the `esg-messy.R` bug) | All raw reads go through `data/raw/` |
| Two-period panel: unbalanced firms | Δ undefined for firms in one year only | Keep only firms present in both 2024 and 2025 |
| `controversy` parsed as character in 2025 | Silent join/type errors | Coerce with `as.numeric()` at load, check NAs |
| `ivreg` default (classical) SEs | Wrong inference | Always `vcovHC(type = "HC1")` for IV summaries |

## 7. Line Length & Mathematical Exceptions

**Standard:** Keep lines <= 100 characters.

**Exception: Mathematical Formulas** -- lines may exceed 100 chars **if and only if:**

1. Breaking the line would harm readability of the math (influence functions, matrix ops, finite-difference approximations, formula implementations matching paper equations)
2. An inline comment explains the mathematical operation:
   ```r
   # Sieve projection: inner product of residuals onto basis functions P_k
   alpha_k <- sum(r_i * basis[, k]) / sum(basis[, k]^2)
   ```
3. The line is in a numerically intensive section (simulation loops, estimation routines, inference calculations)

**Quality Gate Impact:**
- Long lines in non-mathematical code: minor penalty (-1 to -2 per line)
- Long lines in documented mathematical sections: no penalty

## 8. Numerical Discipline

See [`r-reviewer.md`](../agents/r-reviewer.md) Category 11 ("Numerical Discipline") for the full checklist. Headline rules:

- **No float equality.** Never use `==` on doubles. Use `all.equal()` or `abs(a - b) < tol`.
- **CDF clamping** to an OPEN interval. Exact 0 or 1 passed to `qnorm()` / `pbinom()` etc. produces `±Inf`. Project-wide epsilon:

  ```r
  eps <- 1e-12
  p <- pmin(1 - eps, pmax(eps, p))   # now safe for qnorm(p)
  ```

- **Integer literals for counts.** `nrow <- 1000L` (not `1000`), `for (i in 1L:nL)` — avoids silent promotion.
- **Pre-allocate vectors** before loops (`numeric(n)`, `vector("list", n)`), never grow with `c()`.
- **Deterministic bootstrap seeding.** Set seed before the bootstrap, and if the bootstrap is nested, set per-replicate seeds as `seed_base + b`.
- **Explicit `na.rm = TRUE/FALSE`.** Never rely on defaults for `mean()`, `sd()`, `sum()` on data with potential NAs.
- **No `T` / `F`.** They're variables, not constants — write `TRUE` / `FALSE`.

## 9. Code Quality Checklist

```
[ ] Packages at top via library()
[ ] set.seed() once at top (YYYYMMDD)
[ ] All paths relative
[ ] Functions documented (Roxygen)
[ ] Figures: transparent bg, explicit dimensions
[ ] RDS: every computed object saved
[ ] Comments explain WHY not WHAT
[ ] Numerical discipline: no float ==, CDF clamping with eps, pre-allocated vectors
```
