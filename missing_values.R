#Dealing with missing values

raw<- raw %>%  
  mutate(precip = na.locf(precip)) %>% 
  mutate(Temp = na.approx(Temp))