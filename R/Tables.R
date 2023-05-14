## tables

## responses to q16-q19
table_q16_q19 <- function(df, weights) {
  
  ## convert sex No answer to NA
  df <- df |> 
    mutate(SEX = forcats::fct_na_level_to_value(SEX, "No answer")) |> 
    select(SEX, AGEP, RACE5, SCHL, Q16, Q17, Q18, Q19_1, Q19_2, Q19_3, Q19_4,
           Q19_5, Q19_6, Q19_7, Q19_8, Q19_9, Q19_10, Q19_11, Q19_12, Q19_13)
  df$weights <- weights$weightvec
  
  survey_design <- df |>
    as_survey_design(weights = weights)

  q_16_results <- survey_design |>
    select(Q16) |>
    group_by(Q16) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    mutate(Question = "To your knowledge, has your community been exposed to PFAS?") |>
    rename(Response = Q16)

  q_17_results <- survey_design |>
    select(Q17) |>
    group_by(Q17) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    mutate(Question = "How would you describe your knowledge about PFAS as an environmental contaminant?") |>
    rename(Response = Q17)

  q_18_results <- survey_design |>
    select(Q18) |>
    summarise(mean = survey_mean(Q18)) |>
    mutate(Question = "What percentage of the U.S. population do you think has been exposed to PFAS?")
  
  q_19_1_results <- survey_design |> 
    select(Q19_1) |> 
    group_by(Q19_1) |> 
    summarise(proportion = survey_mean(vartype = "se")) |> 
    rename(Response = Q19_1) |> 
    mutate(Question = "Drinking Water")

  q_19_2_results <- survey_design |>
    select(Q19_2) |>
    group_by(Q19_2) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    rename(Response = Q19_2) |> 
    mutate(Question = "Public waterways near waste disposal sites")

  q_19_3_results <- survey_design |>
    select(Q19_3) |>
    group_by(Q19_3) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    rename(Response = Q19_3) |> 
    mutate(Question = "Soils near waste disposal sites")

  q_19_4_results <- survey_design |>
    select(Q19_4) |>
    group_by(Q19_4) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    rename(Response = Q19_4) |> 
    mutate(Question = "Dairy products")

  q_19_5_results <- survey_design |>
    select(Q19_5) |>
    group_by(Q19_5) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    rename(Response = Q19_5) |> 
    mutate(Question = "Fresh produce")

  q_19_6_results <- survey_design |>
    select(Q19_6) |>
    group_by(Q19_6) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    rename(Response = Q19_6) |> 
    mutate(Question = "Freshwater fish")

  q_19_7_results <- survey_design |>
    select(Q19_7) |>
    group_by(Q19_7) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    rename(Response = Q19_7) |> 
    mutate(Question = "Seafood")

  q_19_8_results <- survey_design |>
    select(Q19_8) |>
    group_by(Q19_8) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    rename(Response = Q19_8) |> 
    mutate(Question = "Food packaging")

  q_19_9_results <- survey_design |>
    select(Q19_9) |>
    group_by(Q19_9) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    rename(Response = Q19_9) |>
    mutate(Question = "Non-stick cookware")

  q_19_10_results <- survey_design |>
    select(Q19_10) |>
    group_by(Q19_10) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    rename(Response = Q19_10) |> 
    mutate(Question = "Personal hygiene products")

  q_19_11_results <- survey_design |>
    select(Q19_11) |>
    group_by(Q19_11) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    rename(Response = Q19_11) |> 
    mutate(Question = "Household products (fabrics, cleaning products, paints and sealants)") 

  q_19_12_results <- survey_design |>
    select(Q19_12) |>
    group_by(Q19_12) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    rename(Response = Q19_12) |> 
    mutate(Question = "Fire extinguising foam")

  q_19_13_results <- survey_design |>
    select(Q19_13) |>
    group_by(Q19_13) |>
    summarise(proportion = survey_mean(vartype = "se")) |>
    rename(Response = Q19_13) |> 
    mutate(Question = "Fertilizers from wastewater plants")
  
  
  
  
  bind_rows(q_16_results, q_17_results, q_18_results, q_19_1_results,
            q_19_2_results, q_19_3_results, q_19_4_results,
            q_19_5_results, q_19_6_results, q_19_7_results,
            q_19_8_results, q_19_9_results, q_19_10_results,
            q_19_11_results, q_19_12_results, q_19_13_results
            )

}