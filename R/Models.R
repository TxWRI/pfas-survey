fit_m1 <- function(df, weights) {
  ## convert sex No answer to NA
  df <- df |> 
    mutate(SEX = forcats::fct_na_level_to_value(SEX, "No answer")) |> 
    select(SEX, AGEP, RACE2, SCHL, Q16, Q17, Q18, Q19_1, Q19_2, Q19_3, Q19_4,
           Q19_5, Q19_6, Q19_7, Q19_8, Q19_9, Q19_10, Q19_11, Q19_12, Q19_13)
  df$weights <- weights$weightvec
  
  survey_design <- df |>
    as_survey_design(weights = weights)
  
  m1 <- svyolr(Q17 ~ SEX + AGEP + RACE2 + SCHL + Q16,
               design = survey_design)
  m1
  
}

## gets the predicted average marginal effects from the models
## fit above
## and tidys them
m1_ame <- function(x) {
  svyAME(x, varname = "Q16")
}


fit_m2 <- function(df, weights) {
  ## convert sex No answer to NA
  df <- df |> 
    mutate(SEX = forcats::fct_na_level_to_value(SEX, "No answer")) |> 
    select(SEX, AGEP, RACE2, SCHL, Q16, Q17, Q18, Q19_1, Q19_2, Q19_3, Q19_4,
           Q19_5, Q19_6, Q19_7, Q19_8, Q19_9, Q19_10, Q19_11, Q19_12, Q19_13)
  df$weights <- weights$weightvec
  
  survey_design <- df |>
    as_survey_design(weights = weights)
  
  
  m_df <- tibble(model = c(
    "Drinking water", "Public waterways near waste disposal sites",
    "Soils near waste disposal sites", "Dairy products",
    "Fresh produce", "Freshwater fish", "Seafood", "Food packaging",
    "Non-stick cookware", "Personal hygiene products", 
    "Household products (fabrics, cleaning products, etc.)",
    "Fire extinguishing foams", "Fertilizers from WWTPs"),
    iv = c("Q19_1","Q19_2","Q19_3","Q19_4","Q19_5",
           "Q19_6","Q19_7","Q19_8","Q19_9","Q19_10",
           "Q19_11","Q19_12","Q19_13")) |> 
    mutate(m = map(iv,
                   ~{
                     fmla <- paste0(.x, "~ SEX + AGEP + RACE2 + SCHL + Q16")
                     svyolr(as.formula(fmla),
                            design = survey_design)
                   }))
  m_df
}

## gets the predicted average mariginal effects from the models
## fit above
## and tidys them
m2_ame <- function(x) {
  x |> 
    mutate(preds = map(m,
                       ~svyAME(.x,
                               varname = "Q16"))) |> 
    mutate(preds = map(preds, 
                       ~{.x$preds})) |> 
    unnest(preds)
}



fit_m3 <- function(df, weights) {
  ## convert sex No answer to NA
  df <- df |> 
    mutate(SEX = forcats::fct_na_level_to_value(SEX, "No answer")) |> 
    select(SEX, AGEP, RACE2, SCHL, Q16, Q17, Q18, Q20_1, Q20_2, Q20_3, Q20_4,
           Q20_5, Q20_6, Q20_7, Q20_8, Q20_9, Q20_10, Q20_11, Q20_12, Q20_13)
  df$weights <- weights$weightvec
  
  survey_design <- df |>
    as_survey_design(weights = weights)
  
  
  m_df <- tibble(model = c(
    "Drinking water", "Public waterways near waste disposal sites",
    "Soils near waste disposal sites", "Dairy products",
    "Fresh produce", "Freshwater fish", "Seafood", "Food packaging",
    "Non-stick cookware", "Personal hygiene products", 
    "Household products (fabrics, cleaning products, etc.)",
    "Fire extinguishing foams", "Fertilizers from WWTPs"),
    iv = c("Q20_1","Q20_2","Q20_3","Q20_4","Q20_5",
           "Q20_6","Q20_7","Q20_8","Q20_9","Q20_10",
           "Q20_11","Q20_12","Q20_13")) |> 
    mutate(m = map(iv,
                   ~{
                     fmla <- paste0(.x, "~ SEX + AGEP + RACE2 + SCHL + Q16")
                     svyolr(as.formula(fmla),
                            design = survey_design)
                   }))
  m_df
}

## gets the predicted average mariginal effects from the models
## fit above
## and tidys them
m3_ame <- function(x) {
  x |> 
    mutate(preds = map(m,
                       ~svyAME(.x,
                               varname = "Q16"))) |> 
    mutate(preds = map(preds, 
                       ~{.x$preds})) |> 
    unnest(preds)
}
