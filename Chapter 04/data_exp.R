inj_df <- vroom::vroom("Chapter 04/neiss/injuries.tsv.gz")

prod <- vroom::vroom("Chapter 04/neiss/products.tsv")

pop <- vroom::vroom("Chapter 04/neiss/population.tsv")

dplyr::glimpse(inj_df)

skimr::skim(inj_df)

# Toilot injury exploration
toilot_inj_df <- inj_df |> 
  dplyr::filter(prod_code == 649)

toilot_inj_df |>
  dplyr::count(location, wt = weight, sort = TRUE)

inj_df |>
  dplyr::mutate(diag = forcats::fct_lump(diag, n = 5)) |>
  dplyr::count(diag, wt = weight)
library(magrittr)
count_top(df = inj_df, var = diag)
