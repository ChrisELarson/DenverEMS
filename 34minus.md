High End Filtered 34+
================

High Filtered: There are only 9 data points with n greater than or equal
to 34

``` r
train_control<- trainControl(method = 'cv', number = 10)

nb1<-train(n ~ Year + Hour + Temp + precip +
            broncos + rockies + nuggets +
            Spring + Summer + M_Th + Fri,
           data = filtered,
           trControl = train_control,
           method = 'glm.nb')
print(nb1)
```

    ## Negative Binomial Generalized Linear Model 
    ## 
    ## 69343 samples
    ##    11 predictor
    ## 
    ## No pre-processing
    ## Resampling: Cross-Validated (10 fold) 
    ## Summary of sample sizes: 62409, 62409, 62408, 62408, 62407, 62409, ... 
    ## Resampling results across tuning parameters:
    ## 
    ##   link      RMSE      Rsquared   MAE     
    ##   identity  3.663082  0.4538691  2.863764
    ##   log       3.633316  0.4623355  2.838815
    ##   sqrt      3.642098  0.4597873  2.845773
    ## 
    ## RMSE was used to select the optimal model using the smallest value.
    ## The final value used for the model was link = log.
