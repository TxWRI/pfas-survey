TWRI PFAS Survey Data and Analysis Code
================

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.8132988.svg)](https://doi.org/10.5281/zenodo.8132988)
[![License: CC BY
4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

This is the data and code repository for the PFAS Public Survey study.

Berthold, A., McCrary A., deVilleneuve, S., Schramm, M. In Submission.

This project uses the [renv](https://rstudio.github.io/renv/) and
[targets](https://docs.ropensci.org/targets/) R packages to facilitate
reproducibility. Once the project is downloaded and opened in RStudio
install the renv package:

``` r
install.packages("renv")
```

The packages and package versions used in the project can be installed
and restored using:

``` r
renv::restore()
```

To reproduce the analysis you will need a Census API key which can be
obtained from <https://api.census.gov/data/key_signup.html>. Then use
targets to rerun the analysis. This will take a little while to run:

``` r
tidycensus::census_api_key("API KEY GOES HERE")
targets::tar_make()
```

Survey responses used in our analysis are obtained with:

``` r
targets::tar_read(pfas_analysis_data)
```

    ## # A tibble: 1,100 × 38
    ##    SEX   AGEP  RACE5 SCHL  RACE2 Q6    Q9_6  Q11_6 Q16   Q17     Q18 Q19_1 Q19_2
    ##    <fct> <fct> <fct> <fct> <fct> <fct> <fct> <fct> <fct> <fct> <dbl> <fct> <fct>
    ##  1 Male  25:34 Asian Bach… Non-… Filt… No    Slig… No    I th…    88 Very… Mode…
    ##  2 Fema… 65+   Whit… High… White Filt… No    Slig… No    I've…    51 Not … Not …
    ##  3 Fema… 18:24 Whit… Mast… White Bott… No    Not … No    I th…    57 Very… Mode…
    ##  4 Fema… 45:54 Two … Other Non-… Bott… No    Extr… Not … I've…    92 Not … Slig…
    ##  5 Fema… 35:44 Whit… Mast… White Filt… No    Mode… Not … I've…    45 Mode… Mode…
    ##  6 Fema… 35:44 Whit… High… White Bott… No    Mode… Not … I th…    62 Slig… Slig…
    ##  7 Fema… 55:64 Whit… High… White Unfi… No    Slig… Not … I've…    33 Not … Slig…
    ##  8 Fema… 35:44 Blac… High… Non-… Bott… No    Very… No    I th…    85 Mode… Mode…
    ##  9 Male  45:54 Two … Doct… Non-… Unfi… No    Not … No    I've…    44 Very… Slig…
    ## 10 Fema… 35:44 Blac… High… Non-… Filt… No    Mode… No    I th…    70 Mode… Slig…
    ## # ℹ 1,090 more rows
    ## # ℹ 25 more variables: Q19_3 <fct>, Q19_4 <fct>, Q19_5 <fct>, Q19_6 <fct>,
    ## #   Q19_7 <fct>, Q19_8 <fct>, Q19_9 <fct>, Q19_10 <fct>, Q19_11 <fct>,
    ## #   Q19_12 <fct>, Q19_13 <fct>, Q20_1 <fct>, Q20_2 <fct>, Q20_3 <fct>,
    ## #   Q20_4 <fct>, Q20_5 <fct>, Q20_6 <fct>, Q20_7 <fct>, Q20_8 <fct>,
    ## #   Q20_9 <fct>, Q20_10 <fct>, Q20_11 <fct>, Q20_12 <fct>, Q20_13 <fct>,
    ## #   SEX_NM <fct>

Five models were fit in the analysis:

`m1`: Proportional odds model relating self-described knowledge about
PFAS to demographic indicators and community PFAS exposure.

`m2`: Summary of 13 proportional odds models relating familiarity of 13
items with potential for PFAS contamination with demographic indicators
and community PFAS exposure.

`m3`: Summary of 13 proportional odds models relating intention to
change 13 items with potential for PFAS contamination with demographic
indicators and community PFAS exposure.

`m4`: Logistic regression relating awareness of PFAS contamintion in
drinking water with demographics, community PFAS exposure, and drinking
water soruces.

`m5`: Proportional odds model relating levels of concern about PFAS in
drinking water with demographics, drinking water sources, and awareness
of drinking water contamination.

Model results can be obtained as follows:

``` r
targets::tar_read(m1) |> summary()
```

    ## Call:
    ## svyolr(Q17 ~ SEX + AGEP + RACE2 + SCHL + Q16, design = survey_design)
    ## 
    ## Coefficients:
    ##                                         Value Std. Error     t value
    ## SEXFemale                        -0.007018142  0.1333517 -0.05262881
    ## SEXOther                         -0.221628888  0.7350469 -0.30151668
    ## AGEP25:34                         0.319206386  0.2351060  1.35771253
    ## AGEP35:44                         0.488823011  0.2365146  2.06677726
    ## AGEP45:54                         0.032327673  0.2441379  0.13241561
    ## AGEP55:64                         0.087866123  0.2546267  0.34507819
    ## AGEP65+                          -0.057227295  0.2588213 -0.22110740
    ## RACE2Non-white                   -0.051615103  0.1487857 -0.34690915
    ## SCHLHigh school graduate or GED  -0.433721051  0.3268952 -1.32678926
    ## SCHLAssociate degree             -0.111914228  0.3444962 -0.32486346
    ## SCHLBachelor's degree            -0.017124060  0.3414690 -0.05014822
    ## SCHLMaster's degree               0.037258080  0.3634560  0.10251057
    ## SCHLDoctorate or terminal degree  0.322521674  0.4483818  0.71930145
    ## SCHLOther                         0.442288563  0.4739373  0.93322158
    ## Q16No                            -1.267234219  0.1892610 -6.69569515
    ## Q16Not sure                      -1.458431421  0.2034316 -7.16914882
    ## 
    ## Intercepts:
    ##                                                                                                                    Value  
    ## I've never heard of it, and don't know what it is|I've heard of it or seen it somewhere, but don't know what it is -1.5097
    ## I've heard of it or seen it somewhere, but don't know what it is|I think I know what it is                          0.0109
    ## I think I know what it is|I'm confident I know what it is                                                           1.6546
    ##                                                                                                                    Std. Error
    ## I've never heard of it, and don't know what it is|I've heard of it or seen it somewhere, but don't know what it is  0.4048   
    ## I've heard of it or seen it somewhere, but don't know what it is|I think I know what it is                          0.4074   
    ## I think I know what it is|I'm confident I know what it is                                                           0.4243   
    ##                                                                                                                    t value
    ## I've never heard of it, and don't know what it is|I've heard of it or seen it somewhere, but don't know what it is -3.7300
    ## I've heard of it or seen it somewhere, but don't know what it is|I think I know what it is                          0.0268
    ## I think I know what it is|I'm confident I know what it is                                                           3.8991
    ## (18 observations deleted due to missingness)

`m1` and `m2` require some tidying:

``` r
## each model is a row 1:13:
targets::tar_read(m2)$m[[1]] |> summary()
```

    ## Call:
    ## svyolr(as.formula(fmla), design = survey_design)
    ## 
    ## Coefficients:
    ##                                          Value Std. Error       t value
    ## SEXFemale                        -0.0002686932  0.1342515  -0.002001416
    ## SEXOther                         -0.1002121412  0.3006684  -0.333297874
    ## AGEP25:34                        -0.0405191544  0.2477934  -0.163519889
    ## AGEP35:44                         0.0596672008  0.2430864   0.245456775
    ## AGEP45:54                        -0.4067048355  0.2612073  -1.557019242
    ## AGEP55:64                        -0.8046801762  0.2623818  -3.066829411
    ## AGEP65+                          -1.2102407808  0.2785606  -4.344622670
    ## RACE2Non-white                   -0.0289145971  0.1518353  -0.190433898
    ## SCHLHigh school graduate or GED  -0.1365255724  0.3482390  -0.392045626
    ## SCHLAssociate degree             -0.2093106437  0.3646580  -0.573991686
    ## SCHLBachelor's degree             0.1871257068  0.3540321   0.528555725
    ## SCHLMaster's degree               0.8071510356  0.3814651   2.115923565
    ## SCHLDoctorate or terminal degree  0.5933868716  0.5193126   1.142639142
    ## SCHLOther                         0.0942200283  0.4541967   0.207443217
    ## Q16No                            -1.4256779239  0.1922047  -7.417496885
    ## Q16Not sure                      -2.0106256160  0.1991107 -10.098027107
    ## 
    ## Intercepts:
    ##                                       Value    Std. Error t value 
    ## Not at all familiar|Slightly familiar  -2.2146   0.4343    -5.0994
    ## Slightly familiar|Moderately familiar  -1.2421   0.4335    -2.8651
    ## Moderately familiar|Very familiar      -0.1139   0.4330    -0.2629
    ## Very familiar|Extremely familiar        0.9026   0.4374     2.0636
    ## (18 observations deleted due to missingness)

``` r
renv::diagnostics()
```

    ## Diagnostics Report [renv 1.0.0]
    ## ===============================
    ## 
    ## # Session Info ---------------------------------------------------------------
    ## R version 4.3.1 (2023-06-16 ucrt)
    ## Platform: x86_64-w64-mingw32/x64 (64-bit)
    ## Running under: Windows 11 x64 (build 22621)
    ## 
    ## Matrix products: default
    ## 
    ## 
    ## locale:
    ## [1] LC_COLLATE=English_United States.utf8 
    ## [2] LC_CTYPE=English_United States.utf8   
    ## [3] LC_MONETARY=English_United States.utf8
    ## [4] LC_NUMERIC=C                          
    ## [5] LC_TIME=English_United States.utf8    
    ## 
    ## time zone: America/Chicago
    ## tzcode source: internal
    ## 
    ## attached base packages:
    ## [1] grid      stats     graphics  grDevices datasets  utils     methods  
    ## [8] base     
    ## 
    ## other attached packages:
    ## [1] survey_4.2-1   survival_3.5-5 Matrix_1.4-1  
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] base64url_1.4     dplyr_1.1.1       compiler_4.3.1    renv_1.0.0       
    ##  [5] tidyselect_1.2.0  callr_3.7.3       splines_4.3.1     yaml_2.3.7       
    ##  [9] fastmap_1.1.1     lattice_0.20-45   R6_2.5.1          generics_0.1.3   
    ## [13] igraph_1.4.2      knitr_1.42        backports_1.4.1   targets_1.0.0    
    ## [17] tibble_3.2.1      DBI_1.1.3         pillar_1.9.0      rlang_1.1.0      
    ## [21] utf8_1.2.3        xfun_0.38         cli_3.6.1         withr_2.5.0      
    ## [25] magrittr_2.0.3    ps_1.7.4          digest_0.6.31     processx_3.8.0   
    ## [29] rstudioapi_0.14   lifecycle_1.0.3   vctrs_0.6.1       evaluate_0.20    
    ## [33] glue_1.6.2        data.table_1.14.8 codetools_0.2-18  mitools_2.4      
    ## [37] fansi_1.0.4       rmarkdown_2.21    tools_4.3.1       pkgconfig_2.0.3  
    ## [41] htmltools_0.5.5  
    ## 
    ## # Project --------------------------------------------------------------------
    ## Project path: "C:/Data-Analysis-Projects/pfas-survey"
    ## 
    ## # Status ---------------------------------------------------------------------
    ## No issues found -- the project is in a consistent state.
    ## 
    ## # Packages -------------------------------------------------------------------
    ##                      Library     Source   Lockfile     Source Path Dependency
    ## DBI                    1.1.3       CRAN      1.1.3       CRAN  [1]   indirect
    ## Formula                1.2-5       CRAN      1.2-5       CRAN  [1]   indirect
    ## Hmisc                  5.1-0       CRAN      5.1-0       CRAN  [1]   indirect
    ## KernSmooth           2.23-20       CRAN    2.23-20       CRAN  [1]   indirect
    ## MASS                  7.3-60       CRAN     7.3-60       CRAN  [1]   indirect
    ## Matrix                 1.4-1       CRAN      1.4-1       CRAN  [1]   indirect
    ## R6                     2.5.1       CRAN      2.5.1       CRAN  [1]   indirect
    ## RColorBrewer           1.1-3       CRAN      1.1-3       CRAN  [1]   indirect
    ## Rcpp                  1.0.10       CRAN     1.0.10       CRAN  [1]   indirect
    ## RcppEigen          0.3.3.9.3       CRAN  0.3.3.9.3       CRAN  [1]   indirect
    ## V8                     4.3.0       CRAN      4.3.0       CRAN  [1]   indirect
    ## anesrake                0.80       CRAN       0.80       CRAN  [1]     direct
    ## askpass                  1.1       CRAN        1.1       CRAN  [1]   indirect
    ## backports              1.4.1       CRAN      1.4.1       CRAN  [1]   indirect
    ## base64enc              0.1-3       CRAN      0.1-3       CRAN  [1]   indirect
    ## base64url                1.4       CRAN        1.4       CRAN  [1]   indirect
    ## bigD                   0.2.0       CRAN      0.2.0       CRAN  [1]   indirect
    ## bit                    4.0.5       CRAN      4.0.5       CRAN  [1]   indirect
    ## bit64                  4.0.5       CRAN      4.0.5       CRAN  [1]   indirect
    ## bitops                 1.0-7       CRAN      1.0-7       CRAN  [1]   indirect
    ## blob                   1.2.4       CRAN      1.2.4       CRAN  [1]   indirect
    ## bookdown                0.33       CRAN       0.33       CRAN  [1]   indirect
    ## boot                  1.3-28       CRAN     1.3-28       CRAN  [1]   indirect
    ## brio                   1.1.3       CRAN      1.1.3       CRAN  [1]   indirect
    ## broom                  1.0.4       CRAN      1.0.4       CRAN  [1]     direct
    ## broom.helpers         1.13.0       CRAN     1.13.0       CRAN  [1]   indirect
    ## bslib                  0.4.2       CRAN      0.4.2       CRAN  [1]   indirect
    ## cachem                 1.0.7       CRAN      1.0.7       CRAN  [1]   indirect
    ## callr                  3.7.3       CRAN      3.7.3       CRAN  [1]   indirect
    ## cellranger             1.1.0       CRAN      1.1.0       CRAN  [1]   indirect
    ## checkmate              2.2.0       CRAN      2.2.0       CRAN  [1]   indirect
    ## class                 7.3-22       CRAN     7.3-22       CRAN  [2]   indirect
    ## classInt               0.4-9       CRAN      0.4-9       CRAN  [1]   indirect
    ## cli                    3.6.1       CRAN      3.6.1       CRAN  [1]   indirect
    ## clipr                  0.8.0       CRAN      0.8.0       CRAN  [1]   indirect
    ## cluster                2.1.3       CRAN      2.1.3       CRAN  [1]   indirect
    ## codetools             0.2-18       CRAN     0.2-18       CRAN  [1]   indirect
    ## colorspace             2.1-0       CRAN      2.1-0       CRAN  [1]   indirect
    ## commonmark             1.9.0       CRAN      1.9.0       CRAN  [1]   indirect
    ## compiler                <NA>       <NA>       <NA>       <NA>  [2]   indirect
    ## conflicted             1.2.0       CRAN      1.2.0       CRAN  [1]   indirect
    ## cowplot                1.1.1       CRAN      1.1.1       CRAN  [1]     direct
    ## cpp11                  0.4.3       CRAN      0.4.3       CRAN  [1]   indirect
    ## crayon                 1.5.2       CRAN      1.5.2       CRAN  [1]   indirect
    ## credentials            1.3.2       CRAN       <NA>       <NA>  [1]       <NA>
    ## crul                     1.3       CRAN        1.3       CRAN  [1]   indirect
    ## curl                   5.0.0       CRAN      5.0.0       CRAN  [1]   indirect
    ## data.table            1.14.8       CRAN     1.14.8       CRAN  [1]   indirect
    ## dbplyr                 2.3.2       CRAN      2.3.2       CRAN  [1]   indirect
    ## desc                   1.4.2       CRAN      1.4.2       CRAN  [1]   indirect
    ## diffobj                0.3.5       CRAN      0.3.5       CRAN  [1]   indirect
    ## digest                0.6.31       CRAN     0.6.31       CRAN  [1]   indirect
    ## dplyr                  1.1.1       CRAN      1.1.1       CRAN  [1]     direct
    ## dtplyr                 1.3.1       CRAN      1.3.1       CRAN  [1]   indirect
    ## e1071                 1.7-13       CRAN     1.7-13       CRAN  [1]   indirect
    ## ellipsis               0.3.2       CRAN      0.3.2       CRAN  [1]   indirect
    ## evaluate                0.20       CRAN       0.20       CRAN  [1]   indirect
    ## fansi                  1.0.4       CRAN      1.0.4       CRAN  [1]   indirect
    ## farver                 2.1.1       CRAN      2.1.1       CRAN  [1]   indirect
    ## fastmap                1.1.1       CRAN      1.1.1       CRAN  [1]   indirect
    ## flextable              0.9.1       CRAN      0.9.1       CRAN  [1]     direct
    ## fontBitstreamVera      0.1.1       CRAN      0.1.1       CRAN  [1]   indirect
    ## fontLiberation         0.1.0       CRAN      0.1.0       CRAN  [1]   indirect
    ## fontawesome            0.5.0       CRAN      0.5.0       CRAN  [1]   indirect
    ## fontquiver             0.2.1       CRAN      0.2.1       CRAN  [1]   indirect
    ## forcats                1.0.0       CRAN      1.0.0       CRAN  [1]     direct
    ## foreign               0.8-82       CRAN     0.8-82       CRAN  [1]   indirect
    ## fs                     1.6.1       CRAN      1.6.1       CRAN  [1]   indirect
    ## furrr                  0.3.1       CRAN      0.3.1       CRAN  [1]   indirect
    ## future                1.32.0       CRAN     1.32.0       CRAN  [1]   indirect
    ## future.callr           0.8.1       CRAN      0.8.1       CRAN  [1]   indirect
    ## gargle                 1.3.0       CRAN      1.3.0       CRAN  [1]   indirect
    ## gdata                 2.19.0       CRAN     2.19.0       CRAN  [1]   indirect
    ## gdtools                0.3.3       CRAN      0.3.3       CRAN  [1]   indirect
    ## generics               0.1.3       CRAN      0.1.3       CRAN  [1]   indirect
    ## gert                   1.9.2       CRAN       <NA>       <NA>  [1]       <NA>
    ## gfonts                 0.2.0       CRAN      0.2.0       CRAN  [1]   indirect
    ## ggplot2                3.4.2       CRAN      3.4.2       CRAN  [1]   indirect
    ## gh                     1.4.0       CRAN       <NA>       <NA>  [1]       <NA>
    ## gitcreds               0.1.2       CRAN       <NA>       <NA>  [1]       <NA>
    ## globals               0.16.2       CRAN     0.16.2       CRAN  [1]   indirect
    ## glue                   1.6.2       CRAN      1.6.2       CRAN  [1]   indirect
    ## googledrive            2.1.0       CRAN      2.1.0       CRAN  [1]   indirect
    ## googlesheets4          1.1.0       CRAN      1.1.0       CRAN  [1]   indirect
    ## grDevices               <NA>       <NA>       <NA>       <NA>  [2]   indirect
    ## graphics                <NA>       <NA>       <NA>       <NA>  [2]   indirect
    ## grid                    <NA>       <NA>       <NA>       <NA>  [2]   indirect
    ## gridExtra                2.3       CRAN        2.3       CRAN  [1]   indirect
    ## gt                     0.9.0       CRAN      0.9.0       CRAN  [1]   indirect
    ## gtable                 0.3.3       CRAN      0.3.3       CRAN  [1]     direct
    ## gtools                 3.9.4       CRAN      3.9.4       CRAN  [1]   indirect
    ## gtsummary              1.7.1       CRAN      1.7.1       CRAN  [1]     direct
    ## haven                  2.5.2       CRAN      2.5.2       CRAN  [1]   indirect
    ## highr                   0.10       CRAN       0.10       CRAN  [1]   indirect
    ## hms                    1.1.3       CRAN      1.1.3       CRAN  [1]   indirect
    ## htmlTable              2.4.1       CRAN      2.4.1       CRAN  [1]   indirect
    ## htmltools              0.5.5       CRAN      0.5.5       CRAN  [1]   indirect
    ## htmlwidgets            1.6.2       CRAN      1.6.2       CRAN  [1]   indirect
    ## httpcode               0.3.0       CRAN      0.3.0       CRAN  [1]   indirect
    ## httpuv                 1.6.9       CRAN      1.6.9       CRAN  [1]   indirect
    ## httr                   1.4.5       CRAN      1.4.5       CRAN  [1]   indirect
    ## httr2                  0.2.3       CRAN       <NA>       <NA>  [1]       <NA>
    ## ids                    1.0.1       CRAN      1.0.1       CRAN  [1]   indirect
    ## igraph                 1.4.2       CRAN      1.4.2       CRAN  [1]   indirect
    ## ini                    0.3.1       CRAN       <NA>       <NA>  [1]       <NA>
    ## isoband                0.2.7       CRAN      0.2.7       CRAN  [1]   indirect
    ## janitor                2.2.0       CRAN      2.2.0       CRAN  [1]     direct
    ## jquerylib              0.1.4       CRAN      0.1.4       CRAN  [1]   indirect
    ## jsonlite               1.8.4       CRAN      1.8.4       CRAN  [1]   indirect
    ## juicyjuice             0.1.0       CRAN      0.1.0       CRAN  [1]   indirect
    ## kableExtra             1.3.4       CRAN      1.3.4       CRAN  [1]     direct
    ## knitr                   1.42       CRAN       1.42       CRAN  [1]     direct
    ## labeling               0.4.2       CRAN      0.4.2       CRAN  [1]   indirect
    ## labelled              2.11.0       CRAN     2.11.0       CRAN  [1]   indirect
    ## later                  1.3.0       CRAN      1.3.0       CRAN  [1]   indirect
    ## lattice              0.20-45       CRAN    0.20-45       CRAN  [1]   indirect
    ## lifecycle              1.0.3       CRAN      1.0.3       CRAN  [1]   indirect
    ## listenv                0.9.0       CRAN      0.9.0       CRAN  [1]   indirect
    ## lme4                  1.1-33       CRAN     1.1-33       CRAN  [1]   indirect
    ## lubridate              1.9.2       CRAN      1.9.2       CRAN  [1]   indirect
    ## magrittr               2.0.3       CRAN      2.0.3       CRAN  [1]   indirect
    ## markdown                 1.6       CRAN        1.6       CRAN  [1]   indirect
    ## memoise                2.0.1       CRAN      2.0.1       CRAN  [1]   indirect
    ## methods                 <NA>       <NA>       <NA>       <NA>  [2]   indirect
    ## mgcv                  1.8-40       CRAN     1.8-40       CRAN  [1]   indirect
    ## mice                  3.15.0       CRAN     3.15.0       CRAN  [1]     direct
    ## mime                    0.12       CRAN       0.12       CRAN  [1]   indirect
    ## minqa                  1.2.5       CRAN      1.2.5       CRAN  [1]   indirect
    ## mitools                  2.4       CRAN        2.4       CRAN  [1]   indirect
    ## modelr                0.1.11       CRAN     0.1.11       CRAN  [1]   indirect
    ## munsell                0.5.0       CRAN      0.5.0       CRAN  [1]   indirect
    ## nlme                 3.1-157       CRAN    3.1-157       CRAN  [1]   indirect
    ## nloptr                 2.0.3       CRAN      2.0.3       CRAN  [1]   indirect
    ## nnet                  7.3-19       CRAN     7.3-19       CRAN  [2]   indirect
    ## numDeriv          2016.8-1.1       CRAN 2016.8-1.1       CRAN  [1]   indirect
    ## officedown             0.3.0       CRAN      0.3.0       CRAN  [1]     direct
    ## officer                0.6.2       CRAN      0.6.2       CRAN  [1]     direct
    ## openssl                2.0.6       CRAN      2.0.6       CRAN  [1]   indirect
    ## packrat                0.9.1       CRAN      0.9.1       CRAN  [1]   indirect
    ## parallel                <NA>       <NA>       <NA>       <NA>  [2]   indirect
    ## parallelly            1.35.0       CRAN     1.35.0       CRAN  [1]   indirect
    ## patchwork              1.1.2       CRAN      1.1.2       CRAN  [1]     direct
    ## pillar                 1.9.0       CRAN      1.9.0       CRAN  [1]   indirect
    ## pkgconfig              2.0.3       CRAN      2.0.3       CRAN  [1]   indirect
    ## pkgload                1.3.2       CRAN      1.3.2       CRAN  [1]   indirect
    ## praise                 1.0.0       CRAN      1.0.0       CRAN  [1]   indirect
    ## prettyunits            1.1.1       CRAN      1.1.1       CRAN  [1]   indirect
    ## processx               3.8.0       CRAN      3.8.0       CRAN  [1]   indirect
    ## progress               1.2.2       CRAN      1.2.2       CRAN  [1]   indirect
    ## promises             1.2.0.1       CRAN    1.2.0.1       CRAN  [1]   indirect
    ## proxy                 0.4-27       CRAN     0.4-27       CRAN  [1]   indirect
    ## ps                     1.7.4       CRAN      1.7.4       CRAN  [1]   indirect
    ## purrr                  1.0.1       CRAN      1.0.1       CRAN  [1]   indirect
    ## quarto                   1.2       CRAN        1.2       CRAN  [1]     direct
    ## ragg                   1.2.5       CRAN      1.2.5       CRAN  [1]     direct
    ## ranger                0.15.1       CRAN     0.15.1       CRAN  [1]     direct
    ## rappdirs               0.3.3       CRAN      0.3.3       CRAN  [1]   indirect
    ## reactR                 0.4.4       CRAN      0.4.4       CRAN  [1]   indirect
    ## reactable              0.4.4       CRAN      0.4.4       CRAN  [1]   indirect
    ## readr                  2.1.4       CRAN      2.1.4       CRAN  [1]   indirect
    ## readxl                 1.4.2       CRAN      1.4.2       CRAN  [1]   indirect
    ## rematch                1.0.1       CRAN      1.0.1       CRAN  [1]   indirect
    ## rematch2               2.1.2       CRAN      2.1.2       CRAN  [1]   indirect
    ## renv                   1.0.0       CRAN      1.0.0       CRAN  [1]     direct
    ## reprex                 2.0.2       CRAN      2.0.2       CRAN  [1]   indirect
    ## rlang                  1.1.0       CRAN      1.1.0       CRAN  [1]   indirect
    ## rmarkdown               2.21       CRAN       2.21       CRAN  [1]     direct
    ## rpart                 4.1.16       CRAN     4.1.16       CRAN  [1]   indirect
    ## rprojroot              2.0.3       CRAN      2.0.3       CRAN  [1]   indirect
    ## rsconnect             0.8.29       CRAN     0.8.29       CRAN  [1]   indirect
    ## rstudioapi              0.14       CRAN       0.14       CRAN  [1]   indirect
    ## rvest                  1.0.3       CRAN      1.0.3       CRAN  [1]   indirect
    ## rvg                    0.3.2       CRAN      0.3.2       CRAN  [1]   indirect
    ## s2                     1.1.3       CRAN      1.1.3       CRAN  [1]   indirect
    ## sass                   0.4.5       CRAN      0.4.5       CRAN  [1]   indirect
    ## scales                 1.2.1       CRAN      1.2.1       CRAN  [1]   indirect
    ## selectr                0.4-2       CRAN      0.4-2       CRAN  [1]   indirect
    ## sessioninfo            1.2.2       CRAN       <NA>       <NA>  [1]       <NA>
    ## sf                    1.0-13       CRAN     1.0-13       CRAN  [1]   indirect
    ## shiny                  1.7.4       CRAN      1.7.4       CRAN  [1]   indirect
    ## snakecase             0.11.0       CRAN     0.11.0       CRAN  [1]   indirect
    ## sourcetools          0.1.7-1       CRAN    0.1.7-1       CRAN  [1]   indirect
    ## spatial               7.3-16       CRAN       <NA>       <NA>  [2]       <NA>
    ## splines                 <NA>       <NA>       <NA>       <NA>  [2]   indirect
    ## srvyr                  1.2.0       CRAN      1.2.0       CRAN  [1]     direct
    ## stats                   <NA>       <NA>       <NA>       <NA>  [2]   indirect
    ## stringi               1.7.12       CRAN     1.7.12       CRAN  [1]   indirect
    ## stringr                1.5.0       CRAN      1.5.0       CRAN  [1]   indirect
    ## survey                 4.2-1       CRAN      4.2-1       CRAN  [1]     direct
    ## survival               3.5-5       CRAN      3.5-5       CRAN  [2]   indirect
    ## svglite                2.1.1       CRAN      2.1.1       CRAN  [1]   indirect
    ## svyEffects        0.0.0.9000     GitHub 0.0.0.9000     GitHub  [1]     direct
    ## sys                    3.4.1       CRAN      3.4.1       CRAN  [1]   indirect
    ## systemfonts            1.0.4       CRAN      1.0.4       CRAN  [1]   indirect
    ## tarchetypes            0.7.6       CRAN      0.7.6       CRAN  [1]     direct
    ## targets                1.0.0       CRAN      1.0.0       CRAN  [1]     direct
    ## testthat               3.1.8       CRAN      3.1.8       CRAN  [1]   indirect
    ## textshaping            0.3.6       CRAN      0.3.6       CRAN  [1]   indirect
    ## tibble                 3.2.1       CRAN      3.2.1       CRAN  [1]   indirect
    ## tidycensus             1.3.2       CRAN      1.3.2       CRAN  [1]     direct
    ## tidyr                  1.3.0       CRAN      1.3.0       CRAN  [1]   indirect
    ## tidyselect             1.2.0       CRAN      1.2.0       CRAN  [1]   indirect
    ## tidyverse              2.0.0       CRAN      2.0.0       CRAN  [1]     direct
    ## tigris                 2.0.1       CRAN      2.0.1       CRAN  [1]   indirect
    ## timechange             0.2.0       CRAN      0.2.0       CRAN  [1]   indirect
    ## tinytex                 0.44       CRAN       0.44       CRAN  [1]   indirect
    ## tools                   <NA>       <NA>       <NA>       <NA>  [2]   indirect
    ## triebeard              0.4.1       CRAN      0.4.1       CRAN  [1]   indirect
    ## twriTemplates          0.2.3 Repository      0.2.3 Repository  [1]     direct
    ## tzdb                   0.3.0       CRAN      0.3.0       CRAN  [1]   indirect
    ## units                  0.8-2       CRAN      0.8-2       CRAN  [1]   indirect
    ## urltools               1.7.3       CRAN      1.7.3       CRAN  [1]   indirect
    ## usethis                2.2.2       CRAN       <NA>       <NA>  [1]       <NA>
    ## utf8                   1.2.3       CRAN      1.2.3       CRAN  [1]   indirect
    ## utils                   <NA>       <NA>       <NA>       <NA>  [2]   indirect
    ## uuid                   1.1-0       CRAN      1.1-0       CRAN  [1]   indirect
    ## vctrs                  0.6.1       CRAN      0.6.1       CRAN  [1]   indirect
    ## viridis                0.6.3       CRAN      0.6.3       CRAN  [1]   indirect
    ## viridisLite            0.4.1       CRAN      0.4.1       CRAN  [1]   indirect
    ## visNetwork             2.1.2       CRAN      2.1.2       CRAN  [1]     direct
    ## vroom                  1.6.1       CRAN      1.6.1       CRAN  [1]   indirect
    ## waldo                  0.5.1       CRAN      0.5.1       CRAN  [1]   indirect
    ## webshot                0.5.5       CRAN      0.5.5       CRAN  [1]   indirect
    ## weights                1.0.4       CRAN      1.0.4       CRAN  [1]   indirect
    ## whisker                0.4.1       CRAN       <NA>       <NA>  [1]       <NA>
    ## withr                  2.5.0       CRAN      2.5.0       CRAN  [1]   indirect
    ## wk                     0.7.3       CRAN      0.7.3       CRAN  [1]   indirect
    ## xfun                    0.38       CRAN       0.38       CRAN  [1]   indirect
    ## xml2                   1.3.3       CRAN      1.3.3       CRAN  [1]   indirect
    ## xtable                 1.8-4       CRAN      1.8-4       CRAN  [1]   indirect
    ## yaml                   2.3.7       CRAN      2.3.7       CRAN  [1]   indirect
    ## zip                    2.2.2       CRAN      2.2.2       CRAN  [1]   indirect
    ## 
    ## [1]: C:/Data-Analysis-Projects/pfas-survey/renv/library/R-4.3/x86_64-w64-mingw32                    
    ## [2]: C:/Users/michael.schramm/AppData/Local/R/cache/R/renv/sandbox/R-4.3/x86_64-w64-mingw32/f8897b8d
    ## 
    ## # ABI ------------------------------------------------------------------------
    ## - ABI conflict checks are not yet implemented on Windows.
    ## 
    ## # User Profile ---------------------------------------------------------------
    ## [no user profile detected]
    ## 
    ## # Settings -------------------------------------------------------------------
    ## List of 13
    ##  $ bioconductor.version     : NULL
    ##  $ external.libraries       : chr(0) 
    ##  $ ignored.packages         : chr(0) 
    ##  $ package.dependency.fields: chr [1:3] "Imports" "Depends" "LinkingTo"
    ##  $ ppm.enabled              : NULL
    ##  $ ppm.ignored.urls         : NULL
    ##  $ r.version                : NULL
    ##  $ snapshot.type            : chr "implicit"
    ##  $ use.cache                : logi TRUE
    ##  $ vcs.ignore.cellar        : logi TRUE
    ##  $ vcs.ignore.library       : logi TRUE
    ##  $ vcs.ignore.local         : logi TRUE
    ##  $ vcs.manage.ignores       : logi TRUE
    ## 
    ## # Options --------------------------------------------------------------------
    ## List of 8
    ##  $ defaultPackages                     : chr [1:6] "datasets" "utils" "grDevices" "graphics" ...
    ##  $ download.file.method                : NULL
    ##  $ download.file.extra                 : NULL
    ##  $ install.packages.compile.from.source: chr "interactive"
    ##  $ pkgType                             : chr "both"
    ##  $ repos                               : Named chr "https://cran.rstudio.com"
    ##   ..- attr(*, "names")= chr "CRAN"
    ##  $ renv.consent                        : logi TRUE
    ##  $ renv.verbose                        : logi TRUE
    ## 
    ## # Environment Variables ------------------------------------------------------
    ## HOME                        = C:/Users/michael.schramm/Documents
    ## LANG                        = <NA>
    ## MAKE                        = <NA>
    ## R_LIBS                      = C:/Data-Analysis-Projects/pfas-survey/renv/library/R-4.3/x86_64-w64-mingw32;C:/Users/michael.schramm/AppData/Local/R/cache/R/renv/sandbox/R-4.3/x86_64-w64-mingw32/f8897b8d
    ## R_LIBS_SITE                 = C:/Users/michael.schramm/AppData/Local/Programs/R/R-4.3.1/site-library
    ## R_LIBS_USER                 = C:/Data-Analysis-Projects/pfas-survey/renv/library/R-4.3/x86_64-w64-mingw32;C:/Users/michael.schramm/AppData/Local/R/cache/R/renv/sandbox/R-4.3/x86_64-w64-mingw32/f8897b8d
    ## RENV_DEFAULT_R_ENVIRON      = <NA>
    ## RENV_DEFAULT_R_ENVIRON_USER = <NA>
    ## RENV_DEFAULT_R_LIBS         = <NA>
    ## RENV_DEFAULT_R_LIBS_SITE    = C:/Users/michael.schramm/AppData/Local/Programs/R/R-4.3.1/site-library
    ## RENV_DEFAULT_R_LIBS_USER    = C:\Users\michael.schramm\AppData\Local/R/win-library/4.3
    ## RENV_DEFAULT_R_PROFILE      = <NA>
    ## RENV_DEFAULT_R_PROFILE_USER = <NA>
    ## RENV_PROJECT                = C:/Data-Analysis-Projects/pfas-survey
    ## 
    ## # PATH -----------------------------------------------------------------------
    ## - C:\rtools43/x86_64-w64-mingw32.static.posix/bin
    ## - C:\rtools43/usr/bin
    ## - C:\rtools43\x86_64-w64-mingw32.static.posix\bin
    ## - C:\rtools43\usr\bin
    ## - C:\Users\michael.schramm\AppData\Local\Programs\R\R-4.3.1\bin\x64
    ## - C:\Windows\system32
    ## - C:\Windows
    ## - C:\Windows\System32\Wbem
    ## - C:\Windows\System32\WindowsPowerShell\v1.0\
    ## - C:\Windows\System32\OpenSSH\
    ## - C:\Program Files\dotnet\
    ## - C:\Users\michael.schramm\AppData\Local\Microsoft\WindowsApps
    ## - C:\Users\michael.schramm\AppData\Local\Programs\Git\cmd
    ## - C:\Program Files\RStudio\resources\app\bin\quarto\bin
    ## - C:\Program Files\RStudio\resources\app\bin\postback
    ## 
    ## # Cache ----------------------------------------------------------------------
    ## There are a total of 253 packages installed in the renv cache.
    ## Cache path: "C:/Users/michael.schramm/AppData/Local/R/cache/R/renv/cache/v5/R-4.3/x86_64-w64-mingw32"
