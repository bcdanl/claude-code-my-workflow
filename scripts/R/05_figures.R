# =============================================================================
# 05_figures.R — Publication figures (PDF + PNG) for paper/main.tex.
#
# Reads the model-ready frame (df) + _outputs/iv_results.rds from the pipeline.
# All figures use theme_paper() (serif, white bg) at LaTeX column dimensions
# (6.5 x 4 in, 300 dpi) — INV-11/12 + r-code-conventions.md §4.
#
#   fig_first_stage.{pdf,png} — instrument strength (shift-share vs dummy)
#   fig_coef_iv.{pdf,png}     — IV (S,G) coefficients: 2SLS Wald + Anderson-Rubin CIs
#   fig_esg_change.{pdf,png}  — distribution of d_E/d_S/d_G, 2024->2025
# =============================================================================

suppressPackageStartupMessages({
  library(here)
  library(dplyr)
  library(tidyr)
  library(ggplot2)
})

if (!exists("df", inherits = FALSE)) {
  stop("05_figures.R: df missing. Run 00_run_all.R (not this script directly).")
}
OUT_DIR <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else here::here("scripts", "R", "_outputs")
if (exists("PROJECT_SEED", inherits = FALSE)) set.seed(PROJECT_SEED) else set.seed(20260413L)

res   <- readRDS(file.path(OUT_DIR, "iv_results.rds"))
coefs <- res$coefs
fs    <- res$first_stage

# ---- Project palette + paper theme (mirrors r-code-conventions.md §4) -------
primary_navy <- "#1f2a44"; neutral_gray <- "#6b6f76"
pillar_cols  <- c(E = "#117733", S = "#2c7fb8", G = "#88419d")

theme_paper <- function(base_size = 11) {
  theme_minimal(base_size = base_size, base_family = "serif") +
    theme(
      plot.title       = element_text(face = "bold", color = primary_navy, size = rel(1.05)),
      plot.subtitle    = element_text(color = neutral_gray),
      axis.title       = element_text(color = primary_navy),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "grey90", linewidth = 0.3),
      legend.position  = "bottom", legend.title = element_blank(),
      plot.margin      = margin(4, 6, 4, 4)
    )
}

# Save every figure at paper dimensions, PDF (vector) + PNG (preview), white bg.
save_fig <- function(plot, stem, w = 6.5, h = 4) {
  ggsave(file.path(OUT_DIR, paste0(stem, ".pdf")), plot, width = w, height = h, units = "in", bg = "white")
  ggsave(file.path(OUT_DIR, paste0(stem, ".png")), plot, width = w, height = h, units = "in", dpi = 300, bg = "white")
  message("Wrote ", stem, ".{pdf,png}")
}

# ASCII labels (no literal Unicode -> portable across PDF/PNG devices; the delta
# is conveyed by axis titles via plotmath where needed).
outcome_lab <- c(d_controversy = "Controversy", d_leverage = "Leverage",
                 d_ln_assets = "ln(Assets)", capex_intensity_base = "Capex/Assets",
                 net_debt_issuance_assets = "Net debt iss./Assets", buyback_assets = "Buybacks/Assets")

# =============================================================================
# F1. First-stage strength (shift-share vs provisional dummy)
# =============================================================================
fs_long <- fs |>
  select(pillar, `Shift-share` = F_shift_share, `Dummy` = F_dummy) |>
  pivot_longer(-pillar, names_to = "instrument", values_to = "F")

f1 <- ggplot(fs_long, aes(x = pillar, y = F, fill = instrument)) +
  geom_col(position = position_dodge(width = 0.7), width = 0.62) +
  geom_hline(yintercept = 10, linetype = "dashed", color = neutral_gray) +
  annotate("text", x = 0.6, y = 11.2, label = "F = 10", hjust = 0, size = 3, color = neutral_gray) +
  scale_fill_manual(values = c(`Shift-share` = primary_navy, `Dummy` = "#c4cad6")) +
  labs(title = "First-stage instrument strength",
       x = "ESG pillar (endogenous risk change)", y = "Robust first-stage F") +
  theme_paper()
save_fig(f1, "fig_first_stage")

# =============================================================================
# F2. IV coefficients (S, G) with 2SLS Wald + Anderson-Rubin CIs
# =============================================================================
iv <- coefs |>
  filter(method == "IV-shiftshare") |>
  mutate(outcome_lab = factor(outcome_lab[outcome], levels = unname(outcome_lab)),
         wald_lo = estimate - 1.96 * se, wald_hi = estimate + 1.96 * se,
         ar_lo = ifelse(ar_unbounded == 1, NA, ar_low),
         ar_hi = ifelse(ar_unbounded == 1, NA, ar_high))

f2 <- ggplot(iv, aes(x = estimate, y = outcome_lab, color = pillar)) +
  geom_vline(xintercept = 0, color = neutral_gray, linewidth = 0.3) +
  # Anderson-Rubin CI (wider, lighter) behind the Wald CI
  geom_linerange(aes(xmin = ar_lo, xmax = ar_hi), position = position_dodge(width = 0.6),
                 linewidth = 0.6, alpha = 0.35) +
  geom_linerange(aes(xmin = wald_lo, xmax = wald_hi), position = position_dodge(width = 0.6),
                 linewidth = 1.1) +
  geom_point(position = position_dodge(width = 0.6), size = 1.9) +
  scale_color_manual(values = pillar_cols[c("S", "G")],
                     labels = c(S = "Social (IV)", G = "Governance (IV)")) +
  labs(title = "Shift-share IV estimates with weak-IV-robust intervals",
       subtitle = "Thick = 2SLS Wald 95% CI; thin/light = Anderson-Rubin 95% CI",
       x = "Effect of pillar-risk change on outcome", y = NULL) +
  theme_paper()
save_fig(f2, "fig_coef_iv")

# =============================================================================
# F3. Distribution of ESG-risk changes, 2024 -> 2025
# =============================================================================
chg <- df |>
  select(d_E, d_S, d_G) |>
  pivot_longer(everything(), names_to = "pillar", values_to = "change") |>
  filter(!is.na(change)) |>
  mutate(pillar = recode(pillar, d_E = "E", d_S = "S", d_G = "G"))

f3 <- ggplot(chg, aes(x = change, fill = pillar, color = pillar)) +
  geom_vline(xintercept = 0, color = neutral_gray, linewidth = 0.3) +
  geom_density(alpha = 0.25, linewidth = 0.6) +
  scale_fill_manual(values = pillar_cols) +
  scale_color_manual(values = pillar_cols) +
  coord_cartesian(xlim = c(-6, 6)) +
  labs(title = "Within-firm change in ESG risk, 2024 to 2025",
       subtitle = "Higher Sustainalytics score = higher risk",
       x = expression(Delta ~ "pillar risk (2025 - 2024)"), y = "Density") +
  theme_paper()
save_fig(f3, "fig_esg_change")

# =============================================================================
# F4. Heterogeneity: ΔE x rule-exposure interaction coefficients
# =============================================================================
het <- res$het |>
  filter(pillar == "E", method == "OLS-int",
         outcome %in% c("d_leverage", "capex_intensity_base", "d_ln_assets", "net_debt_issuance_assets")) |>
  mutate(outcome_lab = factor(outcome_lab[outcome], levels = unname(outcome_lab)),
         moderator = recode(moderator, large = "Large filer", climate_sec = "Climate sector"),
         lo = estimate - 1.96 * se, hi = estimate + 1.96 * se,
         sig = !is.na(q_bh) & q_bh < 0.10)

f4 <- ggplot(het, aes(x = estimate, y = outcome_lab, color = moderator)) +
  geom_vline(xintercept = 0, color = neutral_gray, linewidth = 0.3) +
  geom_linerange(aes(xmin = lo, xmax = hi), position = position_dodge(width = 0.55), linewidth = 1) +
  geom_point(aes(shape = sig), position = position_dodge(width = 0.55), size = 2.2) +
  scale_shape_manual(values = c(`FALSE` = 16, `TRUE` = 18), guide = "none") +
  scale_color_manual(values = c(`Large filer` = primary_navy, `Climate sector` = "#117733")) +
  labs(title = "Heterogeneity: change in environmental risk and real behavior",
       subtitle = "Interaction coefficient on dE x moderator (OLS); diamonds = BH q<0.10",
       x = "Interaction coefficient", y = NULL) +
  theme_paper()
save_fig(f4, "fig_heterogeneity")

message("")
message("Figures written to ", OUT_DIR, " (PDF + PNG, 6.5x4in, white bg, theme_paper).")
