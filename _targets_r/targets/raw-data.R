tar_target(raw_data, {
  setnames(
    x = setDT(
      read_excel(
        path = here("data/nash-nora-2021.xls"),
        col_names = FALSE,
        range = "C11:M68"
      )
    ),
    old = sub(" ", "", toupper(apply(setDT(
      read_excel(here("data/nash-nora-2021.xls"), col_names = FALSE, n_max = 10)
    )[j = -c(1, 2)], 2, function(x) paste(c(sprintf("%02d", as.numeric(x[7])), x[9:10]), collapse = "_"))))
  )[
    j = lapply(.SD, function(x) as.numeric(sub("GR$", "", x)))
  ]
})
