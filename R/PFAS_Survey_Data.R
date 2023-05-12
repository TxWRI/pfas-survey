
## read in survey results spreadsheet
read_pfas_survey <- function(x) {
  col_names <- read_csv(x, n_max = 0) |> 
    names()
  read_csv(x,
           col_names = col_names,
           skip = 3,
           show_col_types = FALSE) |> 
    clean_names()
  
}

## creates a clean analysis dataframe with responses
## as labeled factors and demographic variable names that
## match the ACS PUMS data so we can add response weights
munge_pfas_survey <- function(x) {
  PFAS_Results <- x
  
  PFAS_Results <- tibble(SEX = factor(as.character(PFAS_Results$q2), 
                                      levels = as.character(1:4),
                                      labels = c("Male", "Female", "Other", "No answer")),
                         AGEP = factor(as.character(PFAS_Results$q3),
                                       levels = as.character(1:7),
                                       labels = c("18:24", "25:34", "35:44", "45:54",
                                                  "55:64", "65+", "No answer")),
                         RACE5 = as.character(PFAS_Results$q4),
                         SCHL = factor(as.character(PFAS_Results$q25),
                                       levels = as.character(1:8),
                                       labels = c("Some high school",
                                                  "High school graduate or GED",
                                                  "Associate degree",
                                                  "Bachelor's degree",
                                                  "Master's degree",
                                                  "Doctorate or terminal degree",
                                                  "Other",
                                                  "No answer")
                         )) |> 
    mutate(RACE5 = case_when(
      ## create new lvl for two ro more races response
      !(RACE5 %in% c("1","2","3","4","5","6","7","8")) ~ "9",
      .default = as.character(RACE5)
    )) |> 
    mutate(RACE5 = factor(RACE5,
                          levels = as.character(1:9),
                          labels = c(
                            "American Indian/Native American or Alaska Native",
                            "Asian",
                            "Hispanic or Latino or Spanish Origin of any race",
                            "Black or African American",
                            "Native Hawaiian or Other Pacific Islander",
                            "White or Caucasian",
                            "Other",
                            "No answer",
                            "Two or More"))) |> 
    mutate(Q17 = factor(PFAS_Results$q17,
                        levels = as.character(1:4),
                        labels = c(
                          "I've never heard of it, and don't know what it is",
                          "I've heard of it or seen it somewhere, but don't know what it is",
                          "I think I know what it is",
                          "I'm confident I know what it is")))
  
  ## since ACS data only record binary sex
  ## following Gelman's suggestion this will recode sex as "not male"
  PFAS_Results <- PFAS_Results |> 
    mutate(SEX_NM = case_when(
      SEX == "Male" ~ "1",
      SEX == "Female" ~ "2",
      SEX == "Other" ~ "2",
      SEX == "No Answer" ~ NA
    )) |> 
    mutate(SEX_NM = factor(SEX_NM,
                           levels = c("1", "2"),
                           labels = c("Male", "Not Male")
    ))
  
  ## convert No answers to NAs
  PFAS_Results <- PFAS_Results |> 
    mutate(AGEP = fct_na_level_to_value(AGEP, "No answer"),
           RACE5 = fct_na_level_to_value(RACE5, "No answer"),
           SCHL = fct_na_level_to_value(SCHL, "No answer"))
  
}


impute_variables <- function(x) {
  ## select demo data used for imputing values
  survey_data <- x |> 
    select(SEX_NM, AGEP, RACE5, SCHL)
  ## impute missing values using random forest
  imputed_data <- mice(survey_data, maxit = 30, seed = 1234,
                       method = "rf", printFlag = FALSE)
  ## fill in missing values
  imputed_data <- complete(imputed_data)
  ## rename variables with rk_ prefix
  ## these will be used for raking, but the original data is
  ## retain with non prefixed variable names
  imputed_data <- imputed_data |> 
    rename(rk_SEX_NM = SEX_NM,
           rk_AGEP = AGEP,
           rk_RACE5 = RACE5,
           rk_SCHL = SCHL)
  x |> 
    bind_cols(imputed_data)
}