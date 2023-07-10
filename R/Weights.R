rake <- function(target_list,
                 survey_df) {
  survey_df$caseid <- 1:1100
  weights <- anesrake(inputter = target_list,
                      dataframe = as.data.frame(survey_df),
                      caseid = survey_df$caseid,
                      verbose = FALSE,
                      type = "nolim")
}