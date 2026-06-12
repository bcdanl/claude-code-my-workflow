# Cleaning Sustainanalytics Rating Change ---------------------------------

# 2025-09-27
# ds_standard_esg-risk-ratings-enhancement-overview.xlsx
# https://www.sustainalytics.com/docs/default-source/default-document-library/client-portal/ds_standard_esg-risk-ratings-enhancement-overview.xlsx%3Fsfvrsn%3D7f6cedac_3&ved=2ahUKEwikk77zhfmPAxWgnokEHXbrOyUQFnoECBsQAQ&usg=AOvVaw2-oKrUv7Np3JA9GyRe01dG


library(tidyverse)
library(janitor)
library(stringr)
library(readr)
library(skimr)
library(AER)       # ivreg()
library(lmtest)    # waldtest()
library(sandwich)  # robust vcov
library(car)       # linearHypothesis()

csv_path <- "data/ds_standard_esg-risk-ratings-enhancement-overview.csv"

# 1) Read & clean
raw <- readr::read_csv(csv_path, guess_max = 100000, show_col_types = FALSE) %>% clean_names()
cat("Cols:\n"); print(names(raw))

# Quick diagnostics
diag_cols <- c("fieldclustername","grouping","fieldname_current","fieldname_new","enhancement_detail","description")
for (c in diag_cols[diag_cols %in% names(raw)]) {
  cat("\nTop values in", c, ":\n")
  print(raw %>% count(.data[[c]], sort = TRUE) %>% slice_head(n = 15))
}

# 2) Pick columns safely
pick <- function(df, pattern) {
  nm <- names(df)
  hit <- nm[str_detect(nm, regex(pattern, ignore_case = TRUE))]
  if (length(hit) == 0) return(NULL)
  hit[1]
}

col_current  <- pick(raw, "^fieldname_current$")
col_new      <- pick(raw, "^fieldname_new$")
col_cluster  <- pick(raw, "^fieldclustername$")
col_grouping <- pick(raw, "^grouping$")
col_detail   <- pick(raw, "^enhancement_detail$")
col_desc     <- pick(raw, "^description$")
col_product  <- pick(raw, "^product_name$")
col_pkg      <- pick(raw, "^datapackagename$")

df <- tibble(
  field_current = if (!is.null(col_current)) raw[[col_current]] else NA_character_,
  field_new     = if (!is.null(col_new))     raw[[col_new]]     else NA_character_,
  cluster       = if (!is.null(col_cluster)) raw[[col_cluster]] else NA_character_,
  grouping      = if (!is.null(col_grouping)) raw[[col_grouping]] else NA_character_,
  detail        = if (!is.null(col_detail))  raw[[col_detail]]  else NA_character_,
  description   = if (!is.null(col_desc))    raw[[col_desc]]    else NA_character_,
  product_name  = if (!is.null(col_product)) raw[[col_product]] else NA_character_,
  data_package  = if (!is.null(col_pkg))     raw[[col_pkg]]     else NA_character_
) %>% mutate(across(everything(), ~as.character(replace_na(., ""))))

# 3) Change-type
df <- df %>%
  mutate(change_type = case_when(
    field_current == "" & field_new != "" ~ "NEW_FIELD",
    field_current != "" & field_new == "" ~ "RETIRED_FIELD",
    field_current != "" & field_new != "" & field_current != field_new ~ "RENAMED_FIELD",
    field_current != "" & field_new != "" & field_current == field_new ~ "UNCHANGED_OR_MOVED",
    TRUE ~ "UNKNOWN"
  ))

# 4) Robust MEI keyword search across multiple text columns
mei_keywords <- c(
  "water", "biodivers", "emission", "ghg", "pollution", "waste", "resource", "energy",
  "corporate governance", "stakeholder governance", "ethics", "corruption",
  "cyber", "data privacy", "information security", "privacy"
)

text_all <- df %>%
  mutate(text_blob = paste(field_current, field_new, cluster, grouping, detail, description, sep = " | "))

mei_rows <- text_all %>%
  filter(str_detect(tolower(text_blob), str_c(mei_keywords, collapse = "|"))) %>%
  select(-text_blob)

# 5) Summary & save
cat("\nMEI-like rows found:", nrow(mei_rows), "\n")
print(mei_rows %>% count(change_type, sort = TRUE))

write_csv(mei_rows, "data/sustainalytics_mei_like_change_catalog.csv")




# IV creation-prep -------------------------------------------------------------

library(tidyverse)
library(stringr)
library(readr)

# 0) You already created `mei_rows` (56 x 9). Start from there.
#    If it's in a CSV from the prior step, read it:
# mei_rows <- read_csv("sustainalytics_mei_like_change_catalog.csv")

# 1) Quick look
mei_rows %>% count(change_type, sort = TRUE)

# 2) Normalize text fields and build an "issue" label
mei_clean <- mei_rows %>%
  mutate(across(c(field_current, field_new, cluster, grouping, detail, description),
                ~str_squish(tolower(coalesce(., ""))))) %>%
  mutate(issue_from = field_current,
         issue_to   = if_else(field_new != "", field_new, field_current),
         issue_all  = paste(issue_from, issue_to, detail, description, sep = " | "))

# 3) Tag MEIs into E/S/G pillars (edit keywords if you prefer Cyber under G)
to_pillar <- function(x) {
  case_when(
    str_detect(x, "water|biodivers|emission|ghg|pollution|waste|resource|energy") ~ "E",
    str_detect(x, "labor|human capital|product.*safety|community|privacy|data|cyber") ~ "S", # <<< set to "G" if you want cyber->G
    str_detect(x, "corporate governance|stakeholder governance|ethics|corruption") ~ "G",
    TRUE ~ "Unknown"
  )
}

mei_tagged <- mei_clean %>%
  mutate(pillar_from = to_pillar(issue_from),
         pillar_to   = to_pillar(issue_to))

# 4) Pull specific 2024–25 enhancements (keywords)
mei_focus <- mei_tagged %>%
  mutate(
    is_water     = str_detect(issue_all, "\\bwater\\b"),
    is_stake_gov = str_detect(issue_all, "stakeholder governance"),
    is_cyber     = str_detect(issue_all, "cyber|data privacy|information security")
  )

# 5) Create an industry-level exposure template you can JOIN to your firm data
#    (You’ll map industries yourself; below is a simple table you can edit/expand.)
#    Example: industries most exposed to each enhancement.
exposure_map <- tribble(                                        # <<< edit to your NAICS/GICS names
  ~industry_pattern,           ~water_exposed, ~cyber_exposed, ~stake_gov_exposed,
  "agri|farm|food|bev",                 1,             0,               0,
  "mining|metals|oil|gas|chem|steel",   1,             0,               0,
  "utilities|power|water",              1,             0,               0,
  "tech|software|semiconductor|it",     0,             1,               0,
  "bank|financ|insur|broker|exchange",  0,             1,               1,
  "health|pharma|biotech|medical",      0,             1,               0,
  "retail|wholesale|apparel",           0,             1,               0,
  "telecom|media",                      0,             1,               0
)

# Helper to apply regex-based industry exposure (1 if matches any row with 1)
add_exposure_flags <- function(df_firms, industry_col = "industry") {
  out <- df_firms %>% mutate(water_exposed = 0, cyber_exposed = 0, stake_gov_exposed = 0)
  for (i in seq_len(nrow(exposure_map))) {
    pat <- exposure_map$industry_pattern[i]
    if (exposure_map$water_exposed[i] == 1)
      out$water_exposed <- if_else(str_detect(tolower(out[[industry_col]]), pat) | out$water_exposed == 1, 1, out$water_exposed)
    if (exposure_map$cyber_exposed[i] == 1)
      out$cyber_exposed <- if_else(str_detect(tolower(out[[industry_col]]), pat) | out$cyber_exposed == 1, 1, out$cyber_exposed)
    if (exposure_map$stake_gov_exposed[i] == 1)
      out$stake_gov_exposed <- if_else(str_detect(tolower(out[[industry_col]]), pat) | out$stake_gov_exposed == 1, 1, out$stake_gov_exposed)
  }
  out
}



# ESG data cleaning -------------------------------------------------------

esg2024 <- read_csv('data/esg_proj_2024.csv')
esg2025 <- read_csv('data/esg_proj_2025.csv')

esg2025 <- esg2025 |> 
  mutate(Year = 2025)

company_info <- esg2024 |> 
  select(Symbol:IPO_Year)

colnames(company_info) <- str_to_lower(colnames(company_info))
company_info <- company_info |> 
  select(-market_cap)

esg2024 <- esg2024 |> 
  select(Year, Symbol, Total_ESG:Controversy)

esg2024 <- esg2024 |> 
  relocate(Symbol, Year)
esg2025 <- esg2025 |> 
  relocate(Symbol, Year)

colnames(esg2024) <- str_to_lower(colnames(esg2024))
colnames(esg2025) <- str_to_lower(colnames(esg2025))

esg2025 <- esg2025 |> 
  mutate(controversy = as.numeric(controversy))

esg_pillars <- esg2024 |> 
  bind_rows(esg2025) |> 
  group_by(symbol) |> 
  filter(n() != 1) |> 
  distinct() |> 
  ungroup() |> 
  arrange(symbol, year) |> 
  group_by(symbol) |> 
  filter(n() != 1) |> 
  ungroup() |> 
  select(-total_esg) |> 
  left_join(company_info) |> 
  rename(firm_id = symbol,
         firm_name = name,
         E_score = environmental,
         S_score = social,
         G_score = governance) |> 
  relocate(firm_id, firm_name, sector, industry, year, 
           E_score, S_score, G_score, controversy)

esg_all_tmp <- esg_pillars |> 
  group_by(firm_id) |> 
  count() |> 
  filter(n != 2)

rm(esg_all_tmp)



# IV creation -------------------------------------------------------------


# 6) Turn exposures × Post into IVs with your 2024/2025 firm-year pillars
#    Expect your firm data like:
#    esg_pillars: firm_id, year (2024/2025), E_score, S_score, G_score, industry, controls...

# EXAMPLE scaffold (replace with your real data frame)
# esg_pillars <- read_csv("your_firm_pillar_file.csv")

# Add exposure flags
esg_pillars2 <- add_exposure_flags(esg_pillars, industry_col = "industry")

skim(esg_pillars2)


# Make deltas and IVs
# post dummy: 1 if 2025, 0 if 2024
esg_pillars2 <- esg_pillars2 %>%
  mutate(post2025 = as.integer(year == 2025))

# Collapse to firm-level changes (2025–2024)
dtab <- esg_pillars2 %>%
  arrange(firm_id, year) %>%
  group_by(firm_id) %>%
  summarise(
    d_E = E_score[year==2025] - E_score[year==2024],
    d_S = S_score[year==2025] - S_score[year==2024],
    d_G = G_score[year==2025] - G_score[year==2024],
    water_exposed       = first(water_exposed),
    cyber_exposed       = first(cyber_exposed),
    stake_gov_exposed   = first(stake_gov_exposed),
    industry            = first(industry),
    .groups = "drop"
  )

# IVs: exposure × post (with only two years, this is equivalent to exposure itself in Δ form)
# Build separate IVs by pillar focus if you’re instrumenting ΔE, ΔS, or ΔG:
dtab <- dtab %>%
  mutate(
    Z_E = water_exposed,                     # Water enhancement → E pillar shock
    Z_S = cyber_exposed,                     # Cyber/Data privacy enhancement → S pillar shock (or G if you prefer)
    Z_G = stake_gov_exposed                  # Governance split → G pillar shock
  )

dtab <- esg_pillars2 %>%
  arrange(firm_id, year) %>%
  group_by(firm_id) %>%
  summarise(
    d_E = E_score[year==2025] - E_score[year==2024],
    d_S = S_score[year==2025] - S_score[year==2024],
    d_G = G_score[year==2025] - G_score[year==2024],
    
    d_controversy = controversy[year==2025] - controversy[year==2024],   # ✅ ADD THIS
    
    water_exposed       = first(water_exposed),
    cyber_exposed       = first(cyber_exposed),
    stake_gov_exposed   = first(stake_gov_exposed),
    industry            = first(industry),
    .groups = "drop"
  ) %>%
  mutate(
    Z_E = water_exposed,
    Z_S = cyber_exposed,
    Z_G = stake_gov_exposed
  )

skim(dtab)

# Save change catalog for your appendix/report
write_csv(mei_tagged, "data/sustainalytics_mei_change_catalog_clean.csv")

# Optional: a tiny dashboard-ish summary
cat("\n— Detected enhancements —\n")
cat(sprintf("Water: %s\n", any(mei_focus$is_water)))
cat(sprintf("Stakeholder Governance: %s\n", any(mei_focus$is_stake_gov)))
cat(sprintf("Cyber/Data Privacy: %s\n", any(mei_focus$is_cyber)))


# Weak instrument tests ---------------------------------------------------

# -----------------------------
# 0) Helper: robust first-stage F test for excluded instruments
# -----------------------------
first_stage_F <- function(df, endog, instruments, controls = NULL) {
  
  rhs <- c(instruments, controls)
  fml <- as.formula(paste(endog, "~", paste(rhs, collapse = " + ")))
  
  fs <- lm(fml, data = df)
  V  <- sandwich::vcovHC(fs, type = "HC1")
  
  # Joint F-test: instruments = 0
  hyp <- paste0(instruments, " = 0")
  test <- car::linearHypothesis(fs, hyp, vcov. = V, test = "F")
  
  list(
    first_stage_model = fs,
    robust_F_test = test
  )
}

# -----------------------------
# 1) CHOOSE your outcome variable and controls
# -----------------------------
# You must define your outcome (dependent variable) in dtab.
# Example placeholders:
#   - outcome:   d_controversy  (if you build it)
#   - controls:  sector/industry FE, size, leverage, etc.
#
# Replace "d_y" with YOUR outcome variable name.
outcome  <- "d_y"

# Example controls (edit as needed)
controls <- c()  
# controls <- c("ipo_year") 
# controls <- c("log_mktcap", "leverage", "profitability")

# -----------------------------
# 2) Single-endogenous IV models (one endogenous regressor, one instrument)
#    Example: instrument d_E with Z_E
# -----------------------------
# Build formulas
f_iv_E <- as.formula(paste0(
  outcome, " ~ d_E", 
  if (length(controls) > 0) paste0(" + ", paste(controls, collapse = " + ")) else "",
  " | Z_E",
  if (length(controls) > 0) paste0(" + ", paste(controls, collapse = " + ")) else ""
))

iv_E <- AER::ivreg(f_iv_E, data = dtab)

# Robust SE + diagnostics (includes Weak instruments test)
sum_iv_E <- summary(
  iv_E,
  vcov = function(x) sandwich::vcovHC(x, type = "HC1"),
  diagnostics = TRUE
)

cat("\n============================\n")
cat("IV model: d_E instrumented by Z_E\n")
cat("============================\n")
print(sum_iv_E)
cat("\n--- Diagnostics (Weak IV / Wu-Hausman / Sargan) ---\n")
print(sum_iv_E$diagnostics)

# First-stage robust F-test on excluded instrument(s)
fs_E <- first_stage_F(
  df = dtab,
  endog = "d_E",
  instruments = c("Z_E"),
  controls = controls
)

cat("\n--- First-stage robust excluded-IV F-test (E) ---\n")
print(fs_E$robust_F_test)

# -----------------------------
# 3) Single-endogenous models for d_S and d_G as well
# -----------------------------
f_iv_S <- as.formula(paste0(
  outcome, " ~ d_S",
  if (length(controls) > 0) paste0(" + ", paste(controls, collapse = " + ")) else "",
  " | Z_S",
  if (length(controls) > 0) paste0(" + ", paste(controls, collapse = " + ")) else ""
))

f_iv_G <- as.formula(paste0(
  outcome, " ~ d_G",
  if (length(controls) > 0) paste0(" + ", paste(controls, collapse = " + ")) else "",
  " | Z_G",
  if (length(controls) > 0) paste0(" + ", paste(controls, collapse = " + ")) else ""
))

iv_S <- AER::ivreg(f_iv_S, data = dtab)
iv_G <- AER::ivreg(f_iv_G, data = dtab)

sum_iv_S <- summary(iv_S, vcov = function(x) sandwich::vcovHC(x, type="HC1"), diagnostics=TRUE)
sum_iv_G <- summary(iv_G, vcov = function(x) sandwich::vcovHC(x, type="HC1"), diagnostics=TRUE)

cat("\n============================\n")
cat("IV model: d_S instrumented by Z_S\n")
cat("============================\n")
print(sum_iv_S$diagnostics)

cat("\n============================\n")
cat("IV model: d_G instrumented by Z_G\n")
cat("============================\n")
print(sum_iv_G$diagnostics)

fs_S <- first_stage_F(dtab, "d_S", instruments = c("Z_S"), controls = controls)
fs_G <- first_stage_F(dtab, "d_G", instruments = c("Z_G"), controls = controls)

cat("\n--- First-stage robust excluded-IV F-test (S) ---\n")
print(fs_S$robust_F_test)

cat("\n--- First-stage robust excluded-IV F-test (G) ---\n")
print(fs_G$robust_F_test)

# -----------------------------
# 4) Multiple-endogenous IV model (d_E, d_S, d_G all endogenous)
#    Instruments: Z_E, Z_S, Z_G
# -----------------------------
f_iv_all <- as.formula(paste0(
  outcome, " ~ d_E + d_S + d_G",
  if (length(controls) > 0) paste0(" + ", paste(controls, collapse = " + ")) else "",
  " | Z_E + Z_S + Z_G",
  if (length(controls) > 0) paste0(" + ", paste(controls, collapse = " + ")) else ""
))

iv_all <- AER::ivreg(f_iv_all, data = dtab)
sum_iv_all <- summary(
  iv_all,
  vcov = function(x) sandwich::vcovHC(x, type="HC1"),
  diagnostics = TRUE
)

cat("\n============================\n")
cat("IV model: (d_E,d_S,d_G) instrumented by (Z_E,Z_S,Z_G)\n")
cat("============================\n")
print(sum_iv_all)
cat("\n--- Diagnostics ---\n")
print(sum_iv_all$diagnostics)

# First-stage joint excluded-IV F-tests for each endogenous variable
# (Here: each first stage uses ALL instruments Z_E Z_S Z_G)
fs_E_all <- first_stage_F(dtab, "d_E", instruments = c("Z_E","Z_S","Z_G"), controls = controls)
fs_S_all <- first_stage_F(dtab, "d_S", instruments = c("Z_E","Z_S","Z_G"), controls = controls)
fs_G_all <- first_stage_F(dtab, "d_G", instruments = c("Z_E","Z_S","Z_G"), controls = controls)

cat("\n--- First-stage robust excluded-IV F-test for d_E (using all Z's) ---\n")
print(fs_E_all$robust_F_test)

cat("\n--- First-stage robust excluded-IV F-test for d_S (using all Z's) ---\n")
print(fs_S_all$robust_F_test)

cat("\n--- First-stage robust excluded-IV F-test for d_G (using all Z's) ---\n")
print(fs_G_all$robust_F_test)

# -----------------------------
# 5) Rule of thumb reminder
# -----------------------------
cat("\n\nRule of thumb: first-stage excluded-IV F > 10 is often used as a weak-IV threshold.\n")
# controls ----------------------------------------------------------------

income_annual <- read_csv('data/yf_income_annual_raw_2025_09.csv')
income_annual <- income_annual |> 
  filter(!is.na(`Total Revenue`))
income_annual_firms <- income_annual |> 
  distinct(firm_id)

income_quarterly <- read_csv('data/yf_income_quarterly_raw_2025_09.csv')
income_quarterly <- income_quarterly |> 
  filter(!is.na(`Total Revenue`))
income_quarterly_firms <- income_quarterly |> 
  distinct(firm_id)
income_quarterly <- income_quarterly |> 
  rename(period = quarter)

colnames(income_quarterly) == colnames(income_annual)

balancesheet_annual <- read_csv('data/yf_balancesheet_annual_raw_2025_09.csv')
balancesheet_annual <- balancesheet_annual |> 
  filter(!is.na(`Total Assets`))
balancesheet_annual_firms <- balancesheet_annual |> 
  distinct(firm_id)

balancesheet_quarterly <- read_csv('data/yf_balancesheet_quarterly_raw_2025_09.csv')
balancesheet_quarterly <- balancesheet_quarterly |> 
  filter(!is.na(`Total Assets`))
balancesheet_quarterly_firms <- balancesheet_quarterly |> 
  distinct(firm_id)
balancesheet_quarterly <- balancesheet_quarterly |> 
  rename(period = quarter)

colnames(balancesheet_quarterly) == colnames(balancesheet_annual)


cashflow_annual <- read_csv('data/yf_cashflow_annual_raw_2025_09.csv')
cashflow_annual <- cashflow_annual |> 
  filter(!is.na(`Operating Cash Flow`))
cashflow_annual_firms <- cashflow_annual |> 
  distinct(firm_id)

cashflow_quarterly <- read_csv('data/yf_cashflow_quarterly_raw_2025_09.csv')
cashflow_quarterly <- cashflow_quarterly |> 
  filter(!is.na(`Operating Cash Flow`))
cashflow_quarterly_firms <- cashflow_quarterly |> 
  distinct(firm_id)
cashflow_quarterly <- cashflow_quarterly |> 
  rename(period = quarter)

colnames(cashflow_quarterly) == colnames(cashflow_annual)

