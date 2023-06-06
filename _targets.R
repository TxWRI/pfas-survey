
## prior to tar_make(), make sure the census API key is set
## in the .renviron

library(targets)
library(tarchetypes)
targets::tar_option_set(
  packages = c("anesrake",
               "gtsummary",
               "janitor",
               "mice",
               "officedown",
               "officer",
               "tidyverse",
               "tidycensus",
               "srvyr",
               "survey",
               "svyEffects",
               "twriTemplates")
)



source("R/ACS_Data.R")
source("R/PFAS_Survey_Data.R")
source("R/Weights.R")
source("R/Tables.R")
source("R/Models.R")



list(
  
  ## Get population proportions
  ## from ACS PUMS data
  ## to weight our survey data with
  ## Functions in ACS_Data.R
  tar_target(pums, get_pums_data()),
  tar_target(formated_pums, recode_pums(pums)),
  tar_target(proportions_pums, prop_pums(formated_pums)),
  ## return a named list with target marginal proportions
  tar_target(target_prop_list, prop_pums_to_list(proportions_pums)),
  
  ## Functions in PFAS_SurveyData.R
  ## read in and clean up survey data for analysis prep
  tar_target(pfas_survey_csv,
             "data/PFAS_Survey_Data_Coded.csv",
             format = "file"),
  tar_target(pfas_survey_data,
             read_pfas_survey(pfas_survey_csv)),
  ## I want to impute no answer responses
  ## create new raking variables rk_AGEP, rk_SCHL, rk_SEX, rk_RACE5
  ## that have NA values replaced with imputed values
  ## pew uses the mice function in {mice} to impute values
  tar_target(pfas_analysis_data,
             munge_pfas_survey(pfas_survey_data)),
  ## impute missing data
  tar_target(pfas_raking_data,
             impute_variables(pfas_analysis_data)),

  ## Rake weights
  ## Functions in Weights.R
  tar_target(raked_weights,
             rake(target_prop_list,
                  pfas_raking_data)),

  
  ## run svyolr models next
  tar_target(m1,
             fit_m1(pfas_analysis_data,
                    raked_weights)),
  
  tar_target(m2,
             fit_m2(pfas_analysis_data,
                    raked_weights)),
  
  tar_target(m3,
             fit_m3(pfas_analysis_data,
                    raked_weights)),
  
  tar_target(m4,
             fit_m4(pfas_analysis_data,
                    raked_weights)),
  
  tar_target(m5,
             fit_m5(pfas_analysis_data,
                    raked_weights)),
  
  ## marginal estimates of m1 models
  tar_target(marginal_m1,
             m1_ame(m1)),
  
  ## marginal estimates of m2 models
  tar_target(marginal_m2,
             m2_ame(m2)),
  
  ## marginal estimates of m3 models
  tar_target(marginal_m3,
             m3_ame(m3)),
  
  ## marginal estimates of m5 models
  tar_target(marginal_m5,
             m5_ame(m5)),
  
  
  ## some reporting tables
  tar_target(q16_19_tables,
             table_q16_q19(pfas_analysis_data,
                           raked_weights)),
  
  tar_target(q_20_table,
             table_q20(pfas_analysis_data,
                       raked_weights)),
  
  ## Report
  tar_quarto(data_analysis_report, "quarto-docs/Data_Analysis.qmd",
            quiet = FALSE)
)