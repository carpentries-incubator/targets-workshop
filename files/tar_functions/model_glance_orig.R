model_glance_orig <- function(penguins_data) {
  model <- lm(
    bill_depth_mm ~ bill_length_mm,
    data = penguins_data)
  broom::glance(model)
}
