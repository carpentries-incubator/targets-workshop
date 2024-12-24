glance_with_mod_name <- function(model_in_list) {
  model_name <- names(model_in_list)
  model <- model_in_list[[1]]
  glance(model) |>
    mutate(model_name = model_name)
}
