library(tidyverse)

raw_app <- read_csv("raw/apportionment.csv")
apportionments <- raw_app %>%
  pivot_longer(-state, names_to = "census_name",
               values_to = "seats", values_drop_na = TRUE )

raw_census <- read_csv("raw/censuses.csv")

censuses <- raw_census %>%
  select(-1) %>%
  t() %>%
  as.data.frame() %>%
  rownames_to_column()
colnames(censuses) <- c("census_name", "year_census", "year_apportionment", "house_size")
fourteenth <- tribble(
  ~census_name, ~year_census, ~year_apportionment, ~house_size,
  "14th", 1920L, NA_integer_, NA_integer_
)
censuses <- censuses %>%
  bind_rows(fourteenth) %>%
  mutate(census = census_name %>% str_extract("\\d+") %>% as.integer()) %>%
  mutate(census = if_else(is.na(census), 0L, census)) %>%
  select(census, census_name, everything()) %>%
  arrange(census)

dir.create("data", showWarnings = FALSE)
write_csv(apportionments, "data/apportionments.csv")
write_csv(censuses, "data/censuses.csv")
