library(tidyverse)
baci <- readRDS("C:/Users/ndams/Documents/EU_ACP/DATA/cache/baci_raw_cache.rds")

kenya_to_eac <- baci |>
  filter(iso3_exp == "KEN", iso3_imp %in% c("UGA","TZA","RWA","BDI"), year == 2019) |>
  summarise(v = sum(trade_value, na.rm = TRUE))

kenya_from_eac <- baci |>
  filter(iso3_imp == "KEN", iso3_exp %in% c("UGA","TZA","RWA","BDI"), year == 2019) |>
  summarise(v = sum(trade_value, na.rm = TRUE))

kenya_total <- baci |>
  filter(iso3_exp == "KEN" | iso3_imp == "KEN", year == 2019) |>
  summarise(v = sum(trade_value, na.rm = TRUE))

(kenya_to_eac$v + kenya_from_eac$v) / kenya_total$v
