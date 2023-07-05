augment_with_mod_name_slow <- function(model_in_list) {
  Sys.sleep(4)
  model_name <- names(model_in_list)
  model <- model_in_list[[1]]
  broom::augment(model) |>
    mutate(model_name = model_name)
}