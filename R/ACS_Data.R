
get_pums_data <- function() {
 pums_data <- get_pums(
   variables = c("AGEP","SEX","SCHL","RAC1P","HISP"),
   state = "all",
   year = 2021,
   survey = "acs5",
   variables_filter = list(AGEP = (18:99)))
 pums_data
}


recode_pums <- function(x) {
  x |> 
    ## Education
    mutate(SCHL = case_when(
      SCHL %in% c("11", "12", "13", "14",
                  "15") ~ "1", ## some high schoool
      SCHL %in% c("16", "17", "18", "19") ~ "2", ## HS or GED
      SCHL == "20" ~ "3", ## Assoc Degree
      SCHL == "21" ~ "4", ## Bachelor Degree
      SCHL == "22" ~ "5", ## Masters
      SCHL == "24" ~ "6", ## phd
      SCHL %in% c("bb", "01", "02", "03", "04", "05", "06", "07",
                  "08", "09", "10", "23") ~ "7" ## other
    )) |> 
    ## Age
    mutate(AGEP = case_when(
      AGEP <=24 ~ "1",
      AGEP >= 25 & AGEP <= 34 ~ "2",
      AGEP >= 35 & AGEP <= 44 ~ "3",
      AGEP >= 45 & AGEP <= 54 ~ "4",
      AGEP >= 55 & AGEP <= 64 ~ "5",
      AGEP >= 65 ~ "6"
    )) |> 
    ## Race/Ethnicity
    mutate(RACE5 = case_when(
      RAC1P %in% c("3", "4", "5") & HISP == "01" ~ "1", ## American Indian or Alaskan Native
      RAC1P == "6" & HISP == "01" ~ "2", ## Asian Alone
      RAC1P == "2" & HISP == "01" ~ "4", ## Black Alone
      RAC1P == "7" & HISP == "01" ~ "5", ## Hawaiian and Other Pacific Islander
      RAC1P == "1" & HISP == "01" ~ "6", ## White, non hispanic
      RAC1P == "8" & HISP == "01" ~ "7", ## Other
      RAC1P == "9" & HISP == "01" ~ "9", ## two or more (need to add to dataset)
      HISP != "01" ~ "3", ## Hispanic
    )) |> 
    select(PWGTP, AGEP, SCHL, SEX, RACE5) |>
    ## converts character to vector with correct levels and labels
    mutate(SCHL = factor(SCHL,
                         levels = as.character(1:7),
                         labels = c("Some high school",
                                    "High school graduate or GED",
                                    "Associate degree",
                                    "Bachelor's degree",
                                    "Master's degree",
                                    "Doctorate or terminal degree",
                                    "Other")),
           AGEP = factor(AGEP,
                         levels = as.character(1:6),
                         labels = c("18:24", "25:34", "35:44", "45:54",
                                    "55:64", "65+")),
           RACE5 = factor(RACE5,
                          levels = c(1,2,3,4,5,6,7,9),
                          labels = c(
                            "American Indian/Native American or Alaska Native",
                            "Asian",
                            "Hispanic or Latino or Spanish Origin of any race",
                            "Black or African American",
                            "Native Hawaiian or Other Pacific Islander",
                            "White or Caucasian",
                            "Other",
                            "Two or More")))
}

## Creates proportion table using weighted ACS PUMS data
## We just need marginal weights for raking so this returns a named list
## of marginal weights usable by anesrake
prop_pums <- function(x) {
  x |> 
    as_survey_design(weights = PWGTP) |> 
    group_by(SEX) |> 
    summarise(prop = survey_prop()) -> SEX
  x |> 
    as_survey_design(weights = PWGTP) |> 
    group_by(RACE5) |> 
    summarise(prop = survey_prop()) -> RACE5
  x |> 
    as_survey_design(weights = PWGTP) |> 
    group_by(AGEP) |> 
    summarise(prop = survey_prop()) -> AGEP
  x |> 
    as_survey_design(weights = PWGTP) |> 
    group_by(SCHL) |> 
    summarise(prop = survey_prop()) -> SCHL
  
  list(SEX = SEX, 
       RACE5 = RACE5,
       AGEP = AGEP,
       SCHL = SCHL)
}



## convert proportion table to list that can be inputted to anesrake
prop_pums_to_list <- function(x) {
  
  rk_SEX <- x$SEX$prop
  names(rk_SEX) <- c("Male", "Not Male")
  
  rk_RACE5 <- x$RACE5$prop
  names(rk_RACE5) <- c("American Indian/Native American or Alaska Native",
                    "Asian",
                    "Hispanic or Latino or Spanish Origin of any race",
                    "Black or African American",
                    "Native Hawaiian or Other Pacific Islander",
                    "White or Caucasian",
                    "Other",
                    "Two or More")
  
  rk_AGEP <- x$AGEP$prop
  names(rk_AGEP) <- c("18:24", "25:34", "35:44", "45:54",
                   "55:64", "65+")
  
  rk_SCHL <- x$SCHL$prop
  names(rk_SCHL) <- c("Some high school",
                   "High school graduate or GED",
                   "Associate degree",
                   "Bachelor's degree",
                   "Master's degree",
                   "Doctorate or terminal degree",
                   "Other")
  
  list(rk_SEX_NM = rk_SEX,
       rk_RACE5 = rk_RACE5,
       rk_AGEP = rk_AGEP,
       rk_SCHL = rk_SCHL)
}