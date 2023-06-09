PFAS Public Survey
================

This is the data and code repository for the PFAS Public Survey study.

Berthold, A., McCrary A., deVilleneuve, S., Schramm, M. Pending.

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
