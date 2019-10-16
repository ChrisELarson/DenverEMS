Something Maybe
================

I’ve been messing with all sorts of models…finally got one that actually
fits poisson. Got there by trimming the top and bottom 2.5%. Not sure
how right that feels but it works.

The low end doesn’t bother me at all, you could just suggest never have
less than X ambulances on for any hour.

I haven’t started going through the high end thats cut out in order to
look for some patterns there.

\#\#Reading the raw

``` r
raw<- read.csv("C:\\Users\\ADMIN\\Desktop\\SlackFiles\\all_vars.csv")
#Factoring Variables
cols<- c('broncos','rockies','nuggets','precip')
  raw[,cols]<- data.frame(apply(raw[cols],2, as.factor))
   raw$wday<-as.factor(raw$wday)
    levels(raw$wday)<- c('Sun','Mon','Tues','Wed','Thurs',
                         'Fri','Sat')
   raw$Hour<-as.factor(raw$Hour)
   raw$Month<-as.factor(raw$Month)
 
    levels(raw$Month)<-c('Jan','Feb','Mar','Apr','May','Jun',
                         'Jul','Aug','Sep','Oct','Nov','Dec')
levels(raw$precip)<-c('F','T')
levels(raw$nuggets)<-c('n','y')
levels(raw$broncos)<-c('n','y')
levels(raw$rockies)<-c('n','y')

sapply(raw, function(x) sum(is.na(x)))
```

    ##     Date        n     Year     Hour    Month     yday     wday     pick 
    ##        0        0        0        0        0        0        0        0 
    ## hr_index     Temp   precip  broncos  rockies  nuggets 
    ##        0      402      402        0        0        0

``` r
# This bit estimates for the missing values 
#'last observed carried forward' for precip
# linear interpolation for Temp
raw<- raw %>%  
    mutate(precip = na.locf(precip)) %>% 
  mutate(Temp = na.approx(Temp))
```

The Quantiles:

``` r
cbind(quantile(raw$n, 0.025), quantile(raw$n, 0.975))
```

    ##      [,1] [,2]
    ## 2.5%    3   22

``` r
quant<- raw %>% 
  #filter(n <= quantile(n, 0.975) & n > quantile(n, 0.025))
filter(n >=3) 
#filter(n <= 28)

max(quant$n)
```

    ## [1] 95

``` r
min(quant$n)
```

    ## [1] 3

\#\#Poisson

``` r
modelp<-glm(n ~ Year+Hour+Month+wday+pick+Temp+precip+
                     broncos+rockies+nuggets, data = quant, 
             family = 'poisson')
modelnb<- glm.nb(n ~ Year+Hour+Month+wday+pick+Temp+precip+
                     broncos+rockies+nuggets, data = quant)
summary(modelp)
```

    ## 
    ## Call:
    ## glm(formula = n ~ Year + Hour + Month + wday + pick + Temp + 
    ##     precip + broncos + rockies + nuggets, family = "poisson", 
    ##     data = quant)
    ## 
    ## Deviance Residuals: 
    ##     Min       1Q   Median       3Q      Max  
    ## -4.0585  -0.8048  -0.0941   0.6386  15.8192  
    ## 
    ## Coefficients: (2 not defined because of singularities)
    ##               Estimate Std. Error z value Pr(>|z|)    
    ## (Intercept) -8.909e+01  9.810e-01 -90.815  < 2e-16 ***
    ## Year         4.528e-02  4.868e-04  93.022  < 2e-16 ***
    ## Hour1       -4.287e-02  8.754e-03  -4.897 9.71e-07 ***
    ## Hour2       -9.341e-02  8.950e-03 -10.437  < 2e-16 ***
    ## Hour3       -3.515e-01  9.784e-03 -35.920  < 2e-16 ***
    ## Hour4       -4.871e-01  1.045e-02 -46.589  < 2e-16 ***
    ## Hour5       -4.759e-01  1.040e-02 -45.739  < 2e-16 ***
    ## Hour6       -3.274e-01  9.703e-03 -33.741  < 2e-16 ***
    ## Hour7       -6.691e-02  8.958e-03  -7.469 8.08e-14 ***
    ## Hour8        9.974e-02  8.596e-03  11.603  < 2e-16 ***
    ## Hour9        2.228e-01  8.360e-03  26.649  < 2e-16 ***
    ## Hour10       3.265e-01  8.208e-03  39.782  < 2e-16 ***
    ## Hour11       4.060e-01  8.098e-03  50.145  < 2e-16 ***
    ## Hour12       4.351e-01  8.031e-03  54.176  < 2e-16 ***
    ## Hour13       4.484e-01  8.040e-03  55.769  < 2e-16 ***
    ## Hour14       4.571e-01  7.965e-03  57.396  < 2e-16 ***
    ## Hour15       4.901e-01  7.831e-03  62.593  < 2e-16 ***
    ## Hour16       5.077e-01  7.747e-03  65.540  < 2e-16 ***
    ## Hour17       4.941e-01  7.716e-03  64.044  < 2e-16 ***
    ## Hour18       4.506e-01  7.807e-03  57.716  < 2e-16 ***
    ## Hour19       3.984e-01  7.937e-03  50.193  < 2e-16 ***
    ## Hour20       3.478e-01  8.025e-03  43.346  < 2e-16 ***
    ## Hour21       2.861e-01  8.115e-03  35.257  < 2e-16 ***
    ## Hour22       2.023e-01  8.171e-03  24.754  < 2e-16 ***
    ## Hour23       8.198e-02  8.404e-03   9.755  < 2e-16 ***
    ## MonthFeb     7.754e-03  5.577e-03   1.391  0.16437    
    ## MonthMar     1.628e-02  5.626e-03   2.894  0.00380 ** 
    ## MonthApr     7.240e-03  5.839e-03   1.240  0.21503    
    ## MonthMay     2.908e-02  6.113e-03   4.756 1.97e-06 ***
    ## MonthJun     5.128e-02  6.863e-03   7.472 7.92e-14 ***
    ## MonthJul     3.547e-02  7.132e-03   4.973 6.59e-07 ***
    ## MonthAug     4.233e-02  6.959e-03   6.082 1.18e-09 ***
    ## MonthSep     4.819e-02  6.577e-03   7.326 2.37e-13 ***
    ## MonthOct     2.508e-02  5.877e-03   4.268 1.97e-05 ***
    ## MonthNov    -2.687e-03  5.646e-03  -0.476  0.63413    
    ## MonthDec     3.816e-02  5.487e-03   6.954 3.55e-12 ***
    ## wdayMon      2.959e-03  4.245e-03   0.697  0.48581    
    ## wdayTues    -1.001e-02  4.269e-03  -2.345  0.01904 *  
    ## wdayWed     -1.241e-02  4.270e-03  -2.906  0.00366 ** 
    ## wdayThurs    8.328e-04  4.252e-03   0.196  0.84472    
    ## wdayFri      3.830e-02  4.209e-03   9.100  < 2e-16 ***
    ## wdaySat      4.007e-02  4.192e-03   9.558  < 2e-16 ***
    ## pickSpring          NA         NA      NA       NA    
    ## pickSummer          NA         NA      NA       NA    
    ## Temp         3.940e-03  1.982e-04  19.875  < 2e-16 ***
    ## precipT     -1.361e-02  5.306e-03  -2.565  0.01031 *  
    ## broncosy     3.316e-02  1.599e-02   2.073  0.03817 *  
    ## rockiesy     1.305e-03  5.722e-03   0.228  0.81954    
    ## nuggetsy    -1.423e-02  9.227e-03  -1.542  0.12302    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## (Dispersion parameter for poisson family taken to be 1)
    ## 
    ##     Null deviance: 153236  on 69350  degrees of freedom
    ## Residual deviance:  80418  on 69304  degrees of freedom
    ## AIC: 370109
    ## 
    ## Number of Fisher Scoring iterations: 4

Note that “pick” gives NA because its perfectly correlated with
month…wouldn’t include both

\#\#Dispersion

``` r
dispersiontest(modelp)
```

    ## 
    ##  Overdispersion test
    ## 
    ## data:  modelp
    ## z = 13.201, p-value < 2.2e-16
    ## alternative hypothesis: true dispersion is greater than 1
    ## sample estimates:
    ## dispersion 
    ##   1.190445

Good…pretty damn close to 1 (where it should be for poisson)

\#\#Goodness of fit

``` r
with(modelnb, cbind(res.deviance = deviance, df = df.residual, 
                     p = pchisq(deviance, df.residual, lower.tail = F)))
```

    ##      res.deviance    df         p
    ## [1,]     69200.17 69304 0.6091972

Doesn’t suggest poisson is no good
