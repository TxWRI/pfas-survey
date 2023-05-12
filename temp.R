
## Create Sample weights using ACS PUMS data

library(targets)
library(tidyverse)
library(srvyr)
library(anesrake)
library(survey)

## convert sex No answer to NA
survey_data <- tar_read(pfas_analysis_data) |> 
  mutate(SEX = forcats::fct_na_level_to_value(SEX, "No answer")) |> 
  select(SEX, AGEP, RACE5, SCHL, Q17)


weights <- tar_read(raked_weights)$weightvec


survey_data$weights <- weights


survey_design <- survey_data |> 
  as_survey_design(weights = weights)

survey_data |>  summary()

survey_design |>  summary()


q_17_results <- survey_design |> 
  select(Q17) |> 
  group_by(Q17) |> 
  summarise(proportion = survey_mean(vartype = "ci"),
            total = survey_total(vartype = "ci"))

ggplot(q_17_results) +
  geom_pointrange(aes(x = Q17, y = proportion,
                      ymin = proportion_low,
                      ymax = proportion_upp)) +
  scale_y_continuous(labels = scales::percent) +
  coord_flip() +
  labs(x = "", y = "% of Responses",
       subtitle = "How would you describe your knowledge about PFAS as an environmental contaminant?")

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