# =============================================================================
# 02_clean.R — Clean, construct the model-ready frame, export to CSV.
#
# Consumes the raw objects from 01_load.R and produces:
#   df         — firm-level FIRST-DIFFERENCE frame (one row/firm) = the IV
#                estimation table: ESG deltas + instruments + characteristics
#                + baseline financial controls + real-behavior outcomes.
#   esg_panel  — long firm-year panel (two rows/firm) of ESG levels.
#
# Writes both to data/cleaned/ (CSV) and scripts/R/_outputs/ (RDS).
#
# Design notes:
#   * Two-period (March 2024 / March 2025) balanced panel; first differences
#     (2025 - 2024). Instruments = industry exposure to the Sustainalytics 2024
#     rating-system change (PROVISIONAL — ported from esg-messy.R; see Section B).
#   * Financial value columns are comma-formatted strings -> readr::parse_number.
#   * Deterministic: no RNG in this script.
# =============================================================================

suppressPackageStartupMessages({
  library(here)
  library(dplyr)
  library(tidyr)
  library(readr)
  library(stringr)
  library(janitor)
  library(skimr)
})

# ---- Guard: required inputs from 01_load.R ----------------------------------
# Check the pipeline environment (where 00_run_all.R sources scripts), not an
# inherited global — so a stale object in globalenv() can't satisfy the guard.
.env <- environment()
.required <- c("esg2024_raw", "esg2025_raw", "enh_raw",
               "fin_income_raw", "fin_balance_raw", "fin_cashflow_raw")
.missing <- .required[!vapply(.required, function(n) exists(n, envir = .env, inherits = FALSE),
                              logical(1))]
if (length(.missing)) {
  stop("02_clean.R: missing inputs from 01_load.R: ", paste(.missing, collapse = ", "),
       ". Run 00_run_all.R, not this script directly.")
}

OUT_DIR <- if (exists("OUT_DIR", inherits = FALSE)) OUT_DIR else here("scripts", "R", "_outputs")
CLEAN_DIR <- here("data", "cleaned")
dir.create(OUT_DIR,   showWarnings = FALSE, recursive = TRUE)
dir.create(CLEAN_DIR, showWarnings = FALSE, recursive = TRUE)

# Safe division: NA when denominator is NA, zero, or non-finite.
safe_div <- function(num, den) {
  ifelse(is.na(num) | is.na(den) | den == 0, NA_real_, num / den)
}

# =============================================================================
# A. ESG panel (balanced two-year panel of pillar scores)
# =============================================================================
esg2024 <- esg2024_raw |> clean_names()
esg2025 <- esg2025_raw |> clean_names()

# Firm characteristics come only from the 2024 file.
company_info <- esg2024 |>
  transmute(
    firm_id   = symbol,
    firm_name = name,
    sector, industry, country,
    market_cap = suppressWarnings(parse_number(as.character(market_cap))),
    ipo_year   = suppressWarnings(parse_number(as.character(ipo_year)))
  ) |>
  distinct(firm_id, .keep_all = TRUE)

scores_2024 <- esg2024 |>
  transmute(firm_id = symbol, year = 2024L,
            total_esg   = parse_number(as.character(total_esg)),
            E_score     = parse_number(as.character(environmental)),
            S_score     = parse_number(as.character(social)),
            G_score     = parse_number(as.character(governance)),
            controversy = parse_number(as.character(controversy)))

scores_2025_all <- esg2025 |>
  transmute(firm_id = symbol, year = 2025L,
            total_esg   = parse_number(as.character(total_esg)),
            E_score     = parse_number(as.character(environmental)),
            S_score     = parse_number(as.character(social)),
            G_score     = parse_number(as.character(governance)),
            controversy = parse_number(as.character(controversy)))

# Dedupe 2025: drop exact duplicates; if a symbol still has >1 distinct row,
# keep the first and report (esg-messy.R hit the same 4 symbols: A, AA, IMVT, IMXI).
scores_2025 <- scores_2025_all |> distinct()
dup_syms <- scores_2025 |> count(firm_id) |> filter(n > 1) |> pull(firm_id)
if (length(dup_syms)) {
  message("NOTE: ", length(dup_syms), " symbol(s) with non-identical 2025 rows; keeping first: ",
          paste(dup_syms, collapse = ", "))
  scores_2025 <- scores_2025 |> group_by(firm_id) |> slice(1) |> ungroup()
}

# Stack, keep only firms present in BOTH years (balanced panel).
balanced_ids <- intersect(scores_2024$firm_id, scores_2025$firm_id)
scores_long <- bind_rows(scores_2024, scores_2025) |>
  filter(firm_id %in% balanced_ids) |>
  arrange(firm_id, year)

# =============================================================================
# B. Exposure map -> instruments (PROVISIONAL — ported from esg-messy.R)
#    Industry exposure to the 2024 Sustainalytics rating enhancements.
#    Only deviation from the literal port: the bare "it" token (which matched
#    Hospital/Deposit/... as a substring) is fixed to a word-bounded form.
# =============================================================================
exposure_map <- tribble(
  ~industry_pattern,                                   ~water_exposed, ~cyber_exposed, ~stake_gov_exposed,
  "agri|farm|food|bev",                                        1,            0,               0,
  "mining|metals|oil|gas|chem|steel",                          1,            0,               0,
  "utilities|power|water",                                     1,            0,               0,
  "tech|software|semiconductor|\\bit\\b|information technolog", 0,            1,               0,  # was bare "it"
  "bank|financ|insur|broker|exchange",                         0,            1,               1,
  "health|pharma|biotech|medical",                             0,            1,               0,
  "retail|wholesale|apparel",                                  0,            1,               0,
  "telecom|media",                                             0,            1,               0
)

add_exposure_flags <- function(df_firms, industry_col = "industry") {
  out <- df_firms |> mutate(water_exposed = 0L, cyber_exposed = 0L, stake_gov_exposed = 0L)
  ind <- tolower(out[[industry_col]])
  for (i in seq_len(nrow(exposure_map))) {
    hit <- str_detect(ind, exposure_map$industry_pattern[i])
    hit[is.na(hit)] <- FALSE
    if (exposure_map$water_exposed[i] == 1)     out$water_exposed[hit]     <- 1L
    if (exposure_map$cyber_exposed[i] == 1)     out$cyber_exposed[hit]     <- 1L
    if (exposure_map$stake_gov_exposed[i] == 1) out$stake_gov_exposed[hit] <- 1L
  }
  out
}

exposure <- company_info |>
  select(firm_id, industry) |>
  add_exposure_flags(industry_col = "industry") |>
  select(firm_id, water_exposed, cyber_exposed, stake_gov_exposed)

# --- Instrument-provenance catalog: scan the rating-enhancement overview -----
# Keeps a documented record of which methodology changes drive the instruments.
enh <- enh_raw |> clean_names()
mei_keywords <- c("water","biodivers","emission","ghg","pollution","waste","resource","energy",
                  "corporate governance","stakeholder governance","ethics","corruption",
                  "cyber","data privacy","information security","privacy")
.text_cols <- intersect(c("fieldclustername","grouping","fieldname_current","fieldname_new",
                          "enhancement_detail","description"), names(enh))
if (length(.text_cols)) {
  mei_catalog <- enh |>
    mutate(text_blob = tolower(do.call(paste, c(across(all_of(.text_cols)), sep = " | ")))) |>
    filter(str_detect(text_blob, str_c(mei_keywords, collapse = "|"))) |>
    select(-text_blob)
  write_csv(mei_catalog, file.path(OUT_DIR, "sustainalytics_mei_change_catalog_clean.csv"))
  message("Instrument provenance: ", nrow(mei_catalog),
          " MEI-like rating-enhancement rows -> _outputs/sustainalytics_mei_change_catalog_clean.csv")
}

# =============================================================================
# C. Financial controls + real-behavior outcomes (Yahoo ANNUAL)
# =============================================================================
# Pull only the columns we use, parse comma-strings to numeric, parse the
# fiscal-period date (drop TTM). Then per firm pick the fiscal years aligned to
# the two ESG snapshots: base = latest FY-end < 2024-03-01; post = latest < 2025-03-01.
# Yahoo marks missing values with "--"; treat those (and blanks) as NA so
# parse_number coerces cleanly without warnings.
parse_fin_num <- function(x) parse_number(x, na = c("", "NA", "N/A", "--"))

prep_fin <- function(raw, value_cols) {
  raw |>
    clean_names() |>
    mutate(period_date = as.Date(period, format = "%m/%d/%Y")) |>
    filter(!is.na(period_date)) |>                       # drops "TTM"
    mutate(across(all_of(value_cols), parse_fin_num)) |>
    select(firm_id, period_date, all_of(value_cols))
}

inc <- prep_fin(fin_income_raw,
                c("total_revenue", "operating_income", "net_income_common_stockholders"))
bal <- prep_fin(fin_balance_raw,
                c("total_assets", "total_debt"))
cf  <- prep_fin(fin_cashflow_raw,
                c("capital_expenditure", "end_cash_position",
                  "issuance_of_debt", "repayment_of_debt", "repurchase_of_capital_stock"))

fin_long <- inc |>
  full_join(bal, by = c("firm_id", "period_date")) |>
  full_join(cf,  by = c("firm_id", "period_date"))

base_cut <- as.Date("2024-03-01")   # March 2024 ESG snapshot
post_cut <- as.Date("2025-03-01")   # March 2025 ESG snapshot

pick_fy <- function(df_long, cutoff) {
  df_long |>
    filter(period_date < cutoff) |>
    group_by(firm_id) |>
    slice_max(period_date, n = 1, with_ties = FALSE) |>
    ungroup()
}
fy_base <- pick_fy(fin_long, base_cut)
fy_post <- pick_fy(fin_long, post_cut)

# Baseline controls (levels at fy_base).
controls_base <- fy_base |>
  transmute(
    firm_id,
    fy_base_date   = period_date,
    size_ln_assets = ifelse(!is.na(total_assets) & total_assets > 0, log(total_assets), NA_real_),
    leverage       = safe_div(total_debt, total_assets),
    roa            = safe_div(net_income_common_stockholders, total_assets),
    op_margin      = safe_div(operating_income, total_revenue),
    cash_assets    = safe_div(end_cash_position, total_assets),
    .ta_base       = total_assets
  )

# Real-behavior outcomes: post-period behavior + level changes (fy_post - fy_base).
# Yahoo sign convention: capex and stock repurchases are negative cash outflows;
# debt repayment is negative. We report magnitudes for intensities.
post_vars <- fy_post |>
  transmute(
    firm_id,
    fy_post_date  = period_date,
    .ta_post      = total_assets,
    .lev_post     = safe_div(total_debt, total_assets),
    .capex_post   = capital_expenditure,
    .issue_post   = issuance_of_debt,
    .repay_post   = repayment_of_debt,
    .buyback_post = repurchase_of_capital_stock
  )

financials <- controls_base |>
  full_join(post_vars, by = "firm_id") |>
  mutate(
    has_fin_base = !is.na(.ta_base),
    has_fin_post = !is.na(fy_post_date) & !is.na(.ta_post) &
                   !is.na(fy_base_date) & fy_post_date > fy_base_date,
    d_leverage           = ifelse(has_fin_post, .lev_post - leverage, NA_real_),
    d_ln_assets          = ifelse(has_fin_post & !is.na(.ta_post) & .ta_post > 0 &
                                  !is.na(.ta_base) & .ta_base > 0,
                                  log(.ta_post) - log(.ta_base), NA_real_),
    capex_intensity_base = safe_div(abs(.capex_post), .ta_base),  # post-flow / base assets
    net_debt_issuance_assets = ifelse(has_fin_post,
                                  safe_div(coalesce(.issue_post, 0) + coalesce(.repay_post, 0), .ta_base),
                                  NA_real_),
    buyback_assets       = ifelse(has_fin_post, safe_div(abs(.buyback_post), .ta_base), NA_real_)
  ) |>
  select(firm_id, fy_base_date, fy_post_date, has_fin_base, has_fin_post,
         size_ln_assets, leverage, roa, op_margin, cash_assets,
         d_leverage, d_ln_assets, capex_intensity_base,
         net_debt_issuance_assets, buyback_assets)

# =============================================================================
# D. Assemble the long panel and the firm-level first-difference frame
# =============================================================================
esg_panel <- scores_long |>
  left_join(company_info, by = "firm_id") |>
  left_join(exposure,     by = "firm_id") |>
  mutate(post2025 = as.integer(year == 2025L)) |>
  relocate(firm_id, firm_name, sector, industry, country, ipo_year, market_cap,
           year, post2025, total_esg, E_score, S_score, G_score, controversy)

# Firm-level first differences (2025 - 2024) + baseline (2024) levels.
deltas <- scores_long |>
  group_by(firm_id) |>
  summarise(
    total_esg_2024 = total_esg[year == 2024L],
    E_2024 = E_score[year == 2024L], S_2024 = S_score[year == 2024L], G_2024 = G_score[year == 2024L],
    controversy_2024 = controversy[year == 2024L],
    d_total_esg = total_esg[year == 2025L] - total_esg[year == 2024L],
    d_E = E_score[year == 2025L] - E_score[year == 2024L],
    d_S = S_score[year == 2025L] - S_score[year == 2024L],
    d_G = G_score[year == 2025L] - G_score[year == 2024L],
    d_controversy = controversy[year == 2025L] - controversy[year == 2024L],
    .groups = "drop"
  )

# --- Shift-share instruments (PRIMARY) ---------------------------------------
# Leave-one-out group-mean of the pillar change: for firm i, the mean Δpillar of
# its industry-mates excluding i. Isolates the common, industry-level component
# of the 2024 Sustainalytics rating-system change as quasi-exogenous variation
# in measured E/S/G risk. The provisional industry-exposure dummies (Section B)
# are WEAK (first-stage F < 5); this construction reaches F > 10 for S and G.
# d_E remains weakly instrumented -> handled as OLS/reduced-form downstream.
#
# Exclusion restriction (documented; see quality_reports/decisions/): the common
# industry-level measured-risk shift affects firm outcomes only through the
# firm's own measured-risk change. F ~ 10-13 is moderate, not bulletproof
# (below Stock-Yogo 16.4) -> 03_analyze.R reports weak-IV-robust diagnostics.
loo_group_mean <- function(x, group) {
  ok <- !is.na(x)
  s  <- tapply(x[ok], group[ok], sum)[as.character(group)]
  n  <- tapply(x[ok], group[ok], length)[as.character(group)]
  s  <- as.numeric(s); n <- as.numeric(n)
  ifelse(!is.na(x) & !is.na(n) & n > 1, (s - x) / (n - 1),
         ifelse(is.na(x) & !is.na(n) & n >= 1, s / n, NA_real_))
}

ss <- deltas |>
  left_join(company_info |> select(firm_id, sector, industry), by = "firm_id") |>
  mutate(
    # primary: LOO industry-mean; fallback to LOO sector-mean, then global mean.
    glob_E = mean(d_E, na.rm = TRUE), glob_S = mean(d_S, na.rm = TRUE), glob_G = mean(d_G, na.rm = TRUE),
    Z_E_ind = loo_group_mean(d_E, industry), Z_E_sec = loo_group_mean(d_E, sector),
    Z_S_ind = loo_group_mean(d_S, industry), Z_S_sec = loo_group_mean(d_S, sector),
    Z_G_ind = loo_group_mean(d_G, industry), Z_G_sec = loo_group_mean(d_G, sector),
    Z_E_ss = coalesce(Z_E_ind, Z_E_sec, glob_E),
    Z_S_ss = coalesce(Z_S_ind, Z_S_sec, glob_S),
    Z_G_ss = coalesce(Z_G_ind, Z_G_sec, glob_G),
    ss_fallback = is.na(Z_E_ind) | is.na(Z_S_ind) | is.na(Z_G_ind)
  ) |>
  select(firm_id, Z_E_ss, Z_S_ss, Z_G_ss, ss_fallback)

df <- deltas |>
  left_join(company_info, by = "firm_id") |>
  left_join(exposure,     by = "firm_id") |>
  left_join(ss,           by = "firm_id") |>
  left_join(financials,   by = "firm_id") |>
  mutate(
    log_mktcap_2024 = ifelse(!is.na(market_cap) & market_cap > 0, log(market_cap), NA_real_),
    # Rule-exposure moderators (predetermined) for the heterogeneity layer:
    # the SEC 2024 climate-disclosure rule phases in by filer size and binds
    # harder on climate-sensitive sectors.
    large       = as.integer(size_ln_assets > stats::median(size_ln_assets, na.rm = TRUE)),
    climate_sec = as.integer(sector %in% c("Energy", "Utilities", "Basic Materials", "Industrials")),
    # Provisional exposure-dummy instruments (WEAK) — retained only as a
    # weak-instrument robustness contrast. Cyber loads on S by default; the
    # cyber_exposed flag is kept so a cyber->G switch is one line.
    Z_E_dummy = water_exposed,      # water enhancement -> E
    Z_S_dummy = cyber_exposed,      # cyber/data-privacy enhancement -> S (default)
    Z_G_dummy = stake_gov_exposed   # stakeholder-governance split -> G
  ) |>
  relocate(firm_id, firm_name, sector, industry, country, ipo_year,
           total_esg_2024, E_2024, S_2024, G_2024, controversy_2024,
           d_total_esg, d_E, d_S, d_G, d_controversy,
           Z_E_ss, Z_S_ss, Z_G_ss,
           water_exposed, cyber_exposed, stake_gov_exposed,
           Z_E_dummy, Z_S_dummy, Z_G_dummy)

# =============================================================================
# E. Export + report
# =============================================================================
write_csv(df,        file.path(CLEAN_DIR, "esg_model_ready_firmlevel.csv"))
write_csv(esg_panel, file.path(CLEAN_DIR, "esg_model_ready_panel.csv"))
saveRDS(df,        file.path(OUT_DIR, "esg_model_ready_firmlevel.rds"))
saveRDS(esg_panel, file.path(OUT_DIR, "esg_panel.rds"))

message("")
message("==================== model-ready frame ====================")
message(sprintf("Firms (balanced panel): %d  |  panel rows: %d", nrow(df), nrow(esg_panel)))
message(sprintf("Exposure (PROVISIONAL): water=%d  cyber=%d  stake_gov=%d  unexposed=%d",
                sum(df$water_exposed), sum(df$cyber_exposed), sum(df$stake_gov_exposed),
                sum(df$water_exposed == 0 & df$cyber_exposed == 0 & df$stake_gov_exposed == 0)))
message(sprintf("Financials: has_fin_base=%d  has_fin_post=%d  (of %d firms)",
                sum(df$has_fin_base, na.rm = TRUE), sum(df$has_fin_post, na.rm = TRUE), nrow(df)))
message("NA counts (key modeling columns):")
.na_report <- sapply(df[c("d_E","d_S","d_G","d_controversy","size_ln_assets","leverage",
                          "roa","op_margin","d_leverage","d_ln_assets","capex_intensity_base",
                          "net_debt_issuance_assets","buyback_assets","log_mktcap_2024")],
                     function(x) sum(is.na(x)))
print(.na_report)
message("")
message("First-stage signal (classical F; robust table in 03_analyze.R):")
fs_quick <- function(endog, instr) {
  d2 <- df[stats::complete.cases(df[, c(endog, instr)]), ]
  fa <- summary(stats::lm(stats::reformulate(instr, endog), data = d2))$fstatistic
  if (is.null(fa)) NA_real_ else unname(fa[1])
}
for (p in c("E", "S", "G")) {
  message(sprintf("  d_%s: shift-share F=%6.2f  |  dummy F=%6.2f", p,
                  fs_quick(paste0("d_", p), paste0("Z_", p, "_ss")),
                  fs_quick(paste0("d_", p), paste0("Z_", p, "_dummy"))))
}

message("")
message("Exported:")
message("  data/cleaned/esg_model_ready_firmlevel.csv  (", nrow(df), " x ", ncol(df), ")")
message("  data/cleaned/esg_model_ready_panel.csv      (", nrow(esg_panel), " x ", ncol(esg_panel), ")")
