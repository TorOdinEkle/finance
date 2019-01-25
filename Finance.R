## Learning R for Finance purposes
## Start with a model for oil prices in NOK

install.packages("tidyverse")
library(tidyverse)
install.packages("plotly")
library(plotly)
install.packages("Quandl")
library(Quandl)
install.packages("lubridate")
library(lubridate)
library(readxl)

## Use EU Brent oil price from Quandl and currency from Norges Bank
## Choose to use inner_join for simplicity.

oilprice <- Quandl("FRED/DCOILBRENTEU")
View(oilprice)


valutakurser_d <- read_excel("~/R/Finance/valutakurser_d.xlsx")
View(valutakurser_d)

ggplot(data = oilprice) +
  geom_line(mapping = aes(x = Date, y = Value))

valutakurser_d$Date <- as.Date(valutakurser_d$Date)

Oilprice <- inner_join(oilprice, valutakurser_d)
View(Oilprice)
Oilprice$NOK <- (Oilprice$Value * Oilprice$USD)

## Indekserer så dataen etter 4 Januar 2000
Oilprice$NOKINDEX <- (Oilprice$NOK / Oilprice$NOK[Oilprice$Date == "2000-01-04"])
Oilprice$USDINDEX <- (Oilprice$Value / Oilprice$Value[Oilprice$Date == "2000-01-04"])


ggplot(data = Oilprice) +
  geom_line(mapping = aes(x = Date, y = NOKINDEX, color = "red"))+
  geom_line(mapping = aes(x = Date, y = USDINDEX)) +
  labs( x = "Date", y = "index", title = "Oljeprisutvikling i NOK og USD", subtitle = "Indeksert etter 4. jan 2000 ") +
  geom_hline(yintercept = max(Oilprice$NOKINDEX, na.rm = TRUE), na.rm = TRUE, colour = "blue") +
  geom_hline(yintercept = first(Oilprice$NOKINDEX), na.rm = TRUE, colour = "blue")

var(Oilprice$NOKINDEX, na.rm = TRUE)
var(Oilprice$USDINDEX, na.rm = TRUE)

## Interaktivt

plot_ly()