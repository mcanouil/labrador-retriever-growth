tar_target(tidy_data, {
  melt(
    data = raw_data[
      j = .SD[rowSums(is.na(.SD)) == 0]
    ][
      j = date := as.Date("2021-09-06") + day
    ][
      j = day := NULL
    ],
    id.vars = "date",
    value.name = "weight",
    variable.name = "dog_id"
  )[
    j = outlier := !between(weight, median(weight) - 4 * IQR(weight), median(weight) + 4 * IQR(weight)),
    by = "date"
  ][
    j = c("id", "sex", "colour") := tstrsplit(dog_id, "_")
  ][
    j = `:=`(
      sex = factor(sex, levels = c("F", "M"), labels = c("Female", "Male")),
      colour = factor(colour, levels = c("SABLE", "NOIR"), labels = c("Yellow", "Black"))
    )
  ][
    i = !(outlier),
    j = c("y", "ymin", "ymax") := mean_se(weight),
    by = "date"
  ]
})
