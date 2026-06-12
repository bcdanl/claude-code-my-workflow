# =============================================================================
# 01_load.R — Load raw data. No transformations, no derivations.
#
# Reads the project's raw inputs into named objects that 02_clean.R consumes.
# Boring and idempotent by design: read files, assign names, print row counts.
#
# Sources (all under data/raw/, PROPRIETARY — gitignored):
#   - Sustainalytics ESG pillar scores, March 2024 & March 2025 snapshots
#   - Sustainalytics 2024 rating-enhancement overview (instrument provenance)
#   - Yahoo Finance annual financials (income / balance sheet / cash flow)
# =============================================================================

suppressPackageStartupMessages({
  library(here)
  library(readr)
})

raw_dir <- here("data", "raw")

# Financial value columns arrive as comma-formatted, quoted strings
# (e.g., "11,895,000"). Read everything as character here; 02_clean.R parses
# the specific numeric columns it needs with readr::parse_number(). This keeps
# loading dumb and defers all coercion to the cleaning step.
read_raw <- function(file, all_chr = FALSE) {
  path <- file.path(raw_dir, file)
  if (!file.exists(path)) stop("01_load.R: missing raw file: ", path)
  readr::read_csv(
    path,
    show_col_types = FALSE,
    guess_max = 100000,
    name_repair = "unique_quiet",   # financial files have blank header cells
    col_types = if (all_chr) readr::cols(.default = readr::col_character()) else NULL
  )
}

# ---- ESG pillar snapshots ---------------------------------------------------
esg2024_raw <- read_raw("esg_proj_2024.csv")
esg2025_raw <- read_raw("esg_proj_2025.csv")

# ---- Rating-enhancement overview (instrument provenance) --------------------
enh_raw <- read_raw("ds_standard_esg-risk-ratings-enhancement-overview_csv.csv")

# ---- Yahoo Finance ANNUAL financials (read as character; parse in 02) -------
fin_income_raw  <- read_raw("yf_income_annual_raw_2025_09.csv",      all_chr = TRUE)
fin_balance_raw <- read_raw("yf_balancesheet_annual_raw_2025_09.csv", all_chr = TRUE)
fin_cashflow_raw <- read_raw("yf_cashflow_annual_raw_2025_09.csv",    all_chr = TRUE)

# Quarterly files exist but are not used in this pass (annual alignment only).
# Wire them up in a later task if quarterly outcomes are needed:
#   yf_income_quarterly_raw_2025_09.csv, yf_balancesheet_quarterly_raw_2025_09.csv,
#   yf_cashflow_quarterly_raw_2025_09.csv

message(sprintf(
  "Loaded raw: esg2024=%d, esg2025=%d, enh=%d, income=%d, balance=%d, cashflow=%d rows.",
  nrow(esg2024_raw), nrow(esg2025_raw), nrow(enh_raw),
  nrow(fin_income_raw), nrow(fin_balance_raw), nrow(fin_cashflow_raw)
))
