
## Create Sample weights using ACS PUMS data

library(targets)
library(tidyverse)
library(srvyr)
library(anesrake)
library(survey)
library(twriTemplates)
library(gtsummary)

## convert sex No answer to NA
survey_data <- tar_read(pfas_analysis_data) |> 
  mutate(SEX = forcats::fct_na_level_to_value(SEX, "No answer")) |> 
  select(SEX, AGEP, RACE5, SCHL, Q16, Q17, Q18, Q19_1, Q19_2, Q19_3, Q19_4,
         Q19_5, Q19_6, Q19_7, Q19_8, Q19_9, Q19_10, Q19_11, Q19_12, Q19_13)


weights <- tar_read(raked_weights)$weightvec


survey_data$weights <- weights


survey_design <- survey_data |> 
  as_survey_design(weights = weights)

survey_data |>  summary()

survey_design |>  summary()


## q16-q19 should probably be tables
q_17_results <- survey_design |> 
  select(Q17) |> 
  group_by(Q17) |> 
  summarise(proportion = survey_mean(vartype = "se"))
q_17_results

q_18_results <- survey_design |> 
  select(Q18) |> 
  summarise(mean = survey_mean(Q18))
q_18_results

q_19_12_results <- survey_design |>
  select(Q19_12) |>
  group_by(Q19_12) |>
  mutate(Question = "Fire extinguising foam") |>
  summarise(proportion = survey_mean(vartype = "se")) |>
  rename(Response = Q19_12)

q_19_12_results



# ggplot(q_17_results) +
#   geom_pointrange(aes(x = Q17, y = proportion,
#                       ymin = proportion_low,
#                       ymax = proportion_upp)) +
#   scale_y_continuous(labels = scales::percent) +
#   coord_flip() +
#   labs(x = "", y = "Response Rate",
#        subtitle = "Q: How would you describe your knowledge about PFAS as an environmental contaminant?") +
#   theme_TWRI_print(base_family = "Arial") +
#   theme(axis.text.y = element_text(hjust = 1),
#         panel.grid.major.x = element_line(linetype = "dashed",
#                                           size = 0.2,
#                                           color = alpha("black", 0.5)),
#         panel.grid.major.y = element_blank(),
#         plot.subtitle = element_text(face = "bold"))

m1 <- svyolr(Q17 ~ SEX + AGEP + RACE5 + SCHL,
             design = survey_design)
m1
summary(m1)
plot(m1)

str(m1)


## looks like {marginaleffects} supports svyolr now



## okay, svyEffects looks promising!
## https://github.com/jb-santos/svyEffects

library(svyEffects)
preds_sex <- svyAME(m1,varname = c("SEX"))
preds_age <- svyAME(m1,varname = c("AGEP"))
preds_race <- svyAME(m1,varname = c("RACE5"))
preds_edu <- svyAME(m1,varname = c("SCHL"))

preds <- preds_sex$preds |>
  rename(Value = SEX) |> 
  mutate(var = "Sex/Gender") |> 
  bind_rows(preds_age$preds |>
              rename(Value = AGEP) |> 
              mutate(var = "Age")) |> 
  bind_rows(preds_race$preds |> 
              rename(Value = RACE5) |> 
              mutate(var = "Race/Ethnicity")) |> 
  bind_rows(preds_edu$preds |> 
              rename(Value = SCHL) |> 
              mutate(var = "Education"))

ggplot(preds,
       aes(Value, y = predicted, ymin = conf.low, ymax = conf.high, color = y)) +
  geom_pointrange(position = position_dodge(0.25)) +
  facet_wrap(~var, scales = "free_y") +
  coord_flip() +
  labs(y = "Predicted Probability",
       x = "Sex/Gender")



## couple things we need:
## 1 population proportion of responses to Q17 and changes in use of pfas
## 2 response by demographics
## 3 response by community exposure, community impact, and other desired variables.



m1 <- targets::tar_read(m1)
grants_tidy <- function(x, ...) {
  broom::tidy(x, ...) %>%
    dplyr::mutate(
      p.value =
        pnorm(abs(statistic), lower.tail = FALSE) * 2
    )
}

tbl <- tbl_regression(
  m1,
  exponentiate = TRUE,
  tidy_fun = grants_tidy
  ) |> 
  add_significance_stars(hide_ci = FALSE, hide_p = FALSE)
tbl



## relevel race
levels(tar_read(pfas_analysis_data)$RACE5)
tar_read(pfas_analysis_data) |> 
  mutate(RACE5 = forcats::fct_infreq(RACE5)) |> 
  pull(RACE5) |> 
  str()

##############################
library(srvyr)

df <- tar_read(pfas_analysis_data) |> 
  mutate(SEX = forcats::fct_na_level_to_value(SEX, "No answer")) |> 
  select(SEX, AGEP, RACE2, SCHL, Q16, Q17, Q18, Q19_1, Q19_2, Q19_3, Q19_4,
         Q19_5, Q19_6, Q19_7, Q19_8, Q19_9, Q19_10, Q19_11, Q19_12, Q19_13)
df$weights <- tar_read(raked_weights)$weightvec

survey_design <- df |>
  as_survey_design(weights = weights)

m_df <- tibble(model = c(
  "Drinking water", "Public waterways near waste disposal sites",
  "Soils near waste disposal sites", "Dairy products",
  "Fresh produce", "Freshwater fish", "Seafood", "Food packaging",
  "Non-stick cookware", "Personal hygiene products", 
  "Household products (fabrics, cleaning products, paints & sealants",
  "Fire extinguishing foams", "Fertilizers from wastewater treatment plants"),
  iv = c("Q19_1","Q19_2","Q19_3","Q19_4","Q19_5",
         "Q19_6","Q19_7","Q19_8","Q19_9","Q19_10","Q19_11",
         "Q19_12","Q19_13")) |> 
  mutate(m = map(iv,
                 ~{
                   fmla <- paste0(.x, "~ SEX + AGEP + RACE2 + SCHL + Q16")
                   svyolr(fmla,
                          design = survey_design)
                 }))
