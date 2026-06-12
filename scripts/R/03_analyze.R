# =============================================================================
# 03_analyze.R — Estimation: shift-share IV (S, G) + reduced-form / OLS (E).
#
# Design: within-firm first differences (March 2024 -> March 2025) around the
# SEC 2024 climate-disclosure rule. Endogenous = Delta measured pillar risk.
# Instrument = leave-one-out industry-mean Delta pillar (Z_*_ss, built in
# 02_clean.R) — the common, industry-level component of the Sustainalytics 2024
# rating-system change.
#
# Instrument strength (verified): the provisional exposure dummies are WEAK
# (first-stage F < 5). The shift-share instrument reaches F > 10 for S and G;
# d_E stays weak under every candidate -> reported as OLS/reduced-form only.
# Exclusion restriction + caveats: quality_reports/decisions/2026-06-11_shift-share-instrument.md
#
# Persists fitted models + a tidy coefficient table to _outputs/ for 04/05.
# =============================================================================

suppressPackageStartupMessages({
  library(fixest)
  library(dplyr)
})

# Estimation here is deterministic (no RNG). Re-seed defensively anyway, so a
# direct run matches the orchestrator and any future bootstrap is reproducible.
if (exists("PROJECT_SEED", inherits = FALSE)) set.seed(PROJECT_SEED) else set.seed(20260413L)

if (!exists("df", inherits = FALSE)) {
  stop("03_analyze.R: df not found in the pipeline env. Run 00_run_all.R, not this script directly.")
}
OUT_DIR <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else here::here("scripts", "R", "_outputs")

# Parsimonious baseline controls (op_margin dropped: ~91 NA would shrink the
# sample). All predetermined at the baseline fiscal year.
controls <- c("size_ln_assets", "leverage", "roa", "log_mktcap_2024")
ctrl_rhs <- paste(controls, collapse = " + ")
outcomes <- c("d_controversy", "d_leverage", "d_ln_assets",
              "capex_intensity_base", "net_debt_issuance_assets", "buyback_assets")

# Pull (estimate, se, p, n) for a named coefficient from a fixest model.
grab <- function(m, coef_name) {
  cf <- coef(m); if (!coef_name %in% names(cf)) return(c(est = NA, se = NA, p = NA, n = nobs(m)))
  c(est = unname(cf[coef_name]), se = unname(se(m)[coef_name]),
    p = unname(pvalue(m)[coef_name]), n = nobs(m))
}

# Robust first-stage (effective) F for a single instrument given controls:
# F = (robust t-stat on the instrument)^2.
# IMPORTANT: NO sector/industry FE here. The shift-share instrument IS
# industry-level variation, so group FE mechanically absorb it (with sector FE
# the first-stage F collapses to < 2). Identification is therefore cross-industry,
# conditional on firm-level controls — a stronger exclusion restriction, flagged
# in the decision record and the report below.
first_stage_F <- function(endog, instr) {
  f <- as.formula(paste0(endog, " ~ ", instr, " + ", ctrl_rhs))
  m <- tryCatch(feols(f, data = df, vcov = "hetero"), error = function(e) NULL)
  if (is.null(m) || !instr %in% names(coef(m))) return(c(F = NA_real_, n = NA_real_))
  t <- coef(m)[instr] / se(m)[instr]
  c(F = unname(t^2), n = nobs(m))
}

# Anderson-Rubin weak-IV-robust 95% CI by grid inversion (single instrument).
# AR(b0) = hetero-robust Wald on gamma in (O - b0*D) ~ Z + X. The CI is the set
# of b0 with AR(b0) <= qchisq(.95,1) = 3.84. Robust to weak identification: the
# set can be wide, unbounded, or disconnected — those are the honest signals.
ar_ci <- function(O, endog, instr, center, spread, n_grid = 801L) {
  vars <- c(O, endog, instr, controls)
  d2 <- df[stats::complete.cases(df[, vars]), ]
  if (nrow(d2) < 20 || is.na(center) || is.na(spread) || spread <= 0) {
    return(c(low = NA_real_, high = NA_real_, unbounded = NA_real_))
  }
  half <- max(60 * spread, 5 * abs(center) + 1)        # generous span
  grid <- seq(center - half, center + half, length.out = n_grid)
  crit <- stats::qchisq(0.95, 1)
  rhs  <- paste(c(instr, controls), collapse = " + ")
  not_rej <- vapply(grid, function(b0) {
    d2$.y0 <- d2[[O]] - b0 * d2[[endog]]
    m0 <- tryCatch(feols(stats::as.formula(paste0(".y0 ~ ", rhs)), data = d2, vcov = "hetero"),
                   error = function(e) NULL)
    if (is.null(m0) || !instr %in% names(coef(m0))) return(FALSE)
    (coef(m0)[instr] / se(m0)[instr])^2 <= crit
  }, logical(1))
  if (!any(not_rej)) return(c(low = NA_real_, high = NA_real_, unbounded = 0))  # empty set
  kept <- grid[not_rej]
  unb  <- as.numeric(not_rej[1] || not_rej[n_grid])     # hit a grid edge -> unbounded
  c(low = min(kept), high = max(kept), unbounded = unb)
}

# =============================================================================
# A. Descriptive — how ESG risk moved 2024 -> 2025
# =============================================================================
desc <- lapply(c("d_E", "d_S", "d_G", "d_controversy"), function(v) {
  x <- df[[v]]; x <- x[!is.na(x)]
  data.frame(variable = v, n = length(x),
             mean = mean(x), sd = sd(x),
             pct_up = mean(x > 0) * 100, pct_down = mean(x < 0) * 100,
             pct_zero = mean(x == 0) * 100)
}) |> bind_rows()
write.csv(desc, file.path(OUT_DIR, "esg_change_summary.csv"), row.names = FALSE)

# =============================================================================
# B. First-stage strength table (shift-share vs provisional dummy)
# =============================================================================
fs_rows <- lapply(c("E", "S", "G"), function(p) {
  ss <- first_stage_F(paste0("d_", p), paste0("Z_", p, "_ss"))
  du <- first_stage_F(paste0("d_", p), paste0("Z_", p, "_dummy"))
  data.frame(pillar = p,
             F_shift_share = ss["F"], n_ss = ss["n"],
             F_dummy = du["F"], n_dummy = du["n"],
             strong_ss = ss["F"] > 10)
}) |> bind_rows()
rownames(fs_rows) <- NULL
write.csv(fs_rows, file.path(OUT_DIR, "first_stage_strength.csv"), row.names = FALSE)

# =============================================================================
# C. Estimation across outcomes
#    S, G -> 2SLS (shift-share IV);  E -> OLS + reduced form (no valid IV)
# =============================================================================
models <- list()
rows <- list()

for (O in outcomes) {
  # --- S and G: shift-share 2SLS -----------------------------------------
  for (p in c("S", "G")) {
    endog <- paste0("d_", p); instr <- paste0("Z_", p, "_ss")
    # No sector FE: it would absorb the industry-level shift-share instrument.
    f <- as.formula(paste0(O, " ~ ", ctrl_rhs, " | ", endog, " ~ ", instr))
    m <- tryCatch(feols(f, data = df, vcov = "hetero"), error = function(e) NULL)
    if (!is.null(m)) {
      models[[paste0(O, "__", p, "_IV")]] <- m
      g <- grab(m, paste0("fit_", endog))
      fF <- first_stage_F(endog, instr)["F"]
      ar <- ar_ci(O, endog, instr, center = unname(g["est"]), spread = unname(g["se"]))
      rows[[length(rows) + 1]] <- data.frame(
        outcome = O, pillar = p, method = "IV-shiftshare",
        estimate = g["est"], se = g["se"], p = g["p"], n = g["n"],
        first_stage_F = unname(fF),
        ar_low = unname(ar["low"]), ar_high = unname(ar["high"]),
        ar_unbounded = unname(ar["unbounded"]))
    }
  }
  # --- E: OLS (primary) + reduced form (no valid instrument) -------------
  m_ols <- tryCatch(feols(as.formula(paste0(O, " ~ d_E + ", ctrl_rhs)),
                          data = df, vcov = "hetero"), error = function(e) NULL)
  if (!is.null(m_ols)) {
    models[[paste0(O, "__E_OLS")]] <- m_ols
    g <- grab(m_ols, "d_E")
    rows[[length(rows) + 1]] <- data.frame(
      outcome = O, pillar = "E", method = "OLS",
      estimate = g["est"], se = g["se"], p = g["p"], n = g["n"], first_stage_F = NA_real_)
  }
  m_rf <- tryCatch(feols(as.formula(paste0(O, " ~ Z_E_ss + ", ctrl_rhs)),
                         data = df, vcov = "hetero"), error = function(e) NULL)
  if (!is.null(m_rf)) {
    models[[paste0(O, "__E_RF")]] <- m_rf
    g <- grab(m_rf, "Z_E_ss")
    rows[[length(rows) + 1]] <- data.frame(
      outcome = O, pillar = "E", method = "reduced-form", estimate = g["est"],
      se = g["se"], p = g["p"], n = g["n"], first_stage_F = NA_real_)
  }
}

coefs <- bind_rows(rows)
rownames(coefs) <- NULL
write.csv(coefs, file.path(OUT_DIR, "iv_coefficients.csv"), row.names = FALSE)

# =============================================================================
# C2. Heterogeneity by rule exposure (interaction terms)
#   Moderators (predetermined): large filer (size phase-in), climate-sensitive
#   sector. ΔE -> OLS interaction (association; no valid IV for E). ΔS,ΔG ->
#   reduced-form interaction (instrument x moderator) + a full interacted-IV
#   attempt (two endogenous, two instruments; first stage expected weak).
# =============================================================================
get_int <- function(m, cands) {
  cn <- names(coef(m)); nm <- cands[cands %in% cn][1]
  if (is.na(nm)) return(NULL)
  c(est = unname(coef(m)[nm]), se = unname(se(m)[nm]), p = unname(pvalue(m)[nm]), n = nobs(m))
}
moderators <- c("large", "climate_sec")
het_rows <- list()
for (W in moderators) {
  dW <- df[!is.na(df[[W]]), ]
  for (O in outcomes) {
    # ΔE: OLS interaction (association)
    mE <- tryCatch(feols(as.formula(sprintf("%s ~ d_E*%s + %s", O, W, ctrl_rhs)),
                         data = dW, vcov = "hetero"), error = function(e) NULL)
    gE <- if (!is.null(mE)) get_int(mE, c(paste0("d_E:", W), paste0(W, ":d_E"))) else NULL
    if (!is.null(gE)) het_rows[[length(het_rows) + 1]] <- data.frame(
      outcome = O, pillar = "E", moderator = W, method = "OLS-int",
      estimate = gE["est"], se = gE["se"], p = gE["p"], n = gE["n"], first_stage_F = NA_real_)
    for (p in c("S", "G")) {
      instr <- paste0("Z_", p, "_ss"); endog <- paste0("d_", p)
      # reduced-form interaction (instrument x moderator)
      mRF <- tryCatch(feols(as.formula(sprintf("%s ~ %s*%s + %s", O, instr, W, ctrl_rhs)),
                           data = dW, vcov = "hetero"), error = function(e) NULL)
      gRF <- if (!is.null(mRF)) get_int(mRF, c(paste0(instr, ":", W), paste0(W, ":", instr))) else NULL
      if (!is.null(gRF)) het_rows[[length(het_rows) + 1]] <- data.frame(
        outcome = O, pillar = p, moderator = W, method = "RF-int",
        estimate = gRF["est"], se = gRF["se"], p = gRF["p"], n = gRF["n"], first_stage_F = NA_real_)
      # interacted IV (two endogenous, two instruments) — caveated, may be weak
      mIV <- tryCatch(feols(as.formula(sprintf(
        "%s ~ %s + %s | %s + %s:%s ~ %s + %s:%s", O, W, ctrl_rhs, endog, endog, W, instr, instr, W)),
        data = dW, vcov = "hetero"), error = function(e) NULL)
      gIV <- if (!is.null(mIV)) get_int(mIV, c(paste0("fit_", endog, ":", W), paste0(W, ":fit_", endog),
                                               grep(paste0("^fit_.*", W, "$"), names(coef(mIV)), value = TRUE))) else NULL
      fF  <- if (!is.null(mIV)) tryCatch(as.numeric(fitstat(mIV, "ivf", simplify = TRUE)[1]),
                                         error = function(e) NA_real_) else NA_real_
      if (!is.null(gIV)) het_rows[[length(het_rows) + 1]] <- data.frame(
        outcome = O, pillar = p, moderator = W, method = "IV-int",
        estimate = gIV["est"], se = gIV["se"], p = gIV["p"], n = gIV["n"], first_stage_F = fF)
    }
  }
}
het_coefs <- bind_rows(het_rows)
rownames(het_coefs) <- NULL
# Benjamini-Hochberg q-values within each interaction family (method).
het_coefs <- het_coefs |> group_by(method) |> mutate(q_bh = p.adjust(p, method = "BH")) |> ungroup()
write.csv(het_coefs, file.path(OUT_DIR, "het_coefficients.csv"), row.names = FALSE)

saveRDS(list(models = models, coefs = coefs, het = het_coefs, first_stage = fs_rows,
             descriptive = desc, controls = controls, outcomes = outcomes,
             seed = if (exists("PROJECT_SEED")) PROJECT_SEED else NA),
        file.path(OUT_DIR, "iv_results.rds"))

# =============================================================================
# D. Report + inference-robustness note
# =============================================================================
message("")
message("================ ESG change, 2024 -> 2025 ================")
print(within(desc, { mean <- round(mean, 3); sd <- round(sd, 3)
                     pct_up <- round(pct_up, 1); pct_down <- round(pct_down, 1)
                     pct_zero <- round(pct_zero, 1) }), row.names = FALSE)

message("")
message("================ First-stage strength ====================")
print(transform(fs_rows, F_shift_share = round(F_shift_share, 2),
                F_dummy = round(F_dummy, 2)), row.names = FALSE)

message("")
message("================ Estimates (IV: S,G | OLS/RF: E) =========")
print(transform(coefs, estimate = round(estimate, 4), se = round(se, 4),
                p = round(p, 4), first_stage_F = round(first_stage_F, 2)), row.names = FALSE)

message("")
message("======== Weak-IV-robust: 2SLS Wald CI vs Anderson-Rubin CI (S, G) ========")
iv_rows <- coefs[coefs$method == "IV-shiftshare", ]
ar_cmp <- transform(iv_rows,
  wald_low  = round(estimate - 1.96 * se, 3),
  wald_high = round(estimate + 1.96 * se, 3),
  AR_low    = ifelse(ar_unbounded == 1, -Inf, round(ar_low, 3)),
  AR_high   = ifelse(ar_unbounded == 1,  Inf, round(ar_high, 3)))
print(ar_cmp[, c("outcome", "pillar", "wald_low", "wald_high", "AR_low", "AR_high", "first_stage_F")],
      row.names = FALSE)

message("")
message("======== Heterogeneity by rule exposure (interaction terms) ========")
message("ΔE x moderator — OLS associations (E has no valid instrument):")
het_E <- subset(het_coefs, pillar == "E")
print(transform(het_E[order(het_E$p), c("outcome","moderator","estimate","p","q_bh","n")],
                estimate = round(estimate, 4), p = round(p, 4), q_bh = round(q_bh, 3)),
      row.names = FALSE)
message("(S, G interaction terms — reduced-form + interacted-IV — in het_coefficients.csv;",
        " interacted-IV first stages are weak.)")

n_tests <- nrow(coefs[coefs$method != "reduced-form", ])
message("")
message("Inference notes:")
message("  * NO sector/industry FE in the IV: the shift-share instrument IS industry-level ",
        "variation and group FE absorb it (with sector FE first-stage F < 2). Identification ",
        "is cross-industry, conditional on firm controls -> the exclusion restriction must hold ",
        "ACROSS industries (industry-level confounds are the key threat). Documented in the ",
        "decision record.")
message("  * Shift-share effective F: S and G near/above 10 but below Stock-Yogo 16.4 ",
        "-> treat as MODERATE strength; weak-IV-robust CIs (Anderson-Rubin) recommended ",
        "before headline claims.")
message(sprintf("  * Multiple testing: %d primary tests (pillars x outcomes); p-values are ",
                n_tests), "UNADJUSTED. Romano-Wolf / BH q-values deferred to a robustness pass.")
message("  * d_E estimates are OLS associations only — NO valid instrument (first-stage F < 8).")
message("")
message("Saved: iv_results.rds, iv_coefficients.csv, first_stage_strength.csv, esg_change_summary.csv")
