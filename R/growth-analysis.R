message(timestamp(quiet = TRUE))
### Project Setup ==================================================================================
library(here)
output_directory <- here("outputs")
dir.create(output_directory, recursive = TRUE, showWarnings = FALSE, mode = "0775")


### Load Packages ==================================================================================
suppressPackageStartupMessages({
  library(svglite)
  library(ggplot2)
  library(ggtext)
  library(patchwork)
  library(scales)
  library(ggrepel)
  library(data.table)
  library(readxl)
  library(showtext)
})


### Tables and Figures Theme =======================================================================
font <- "Alegreya Sans"
font_add_google(font, font, regular.wt = 300)
showtext_auto()
source("https://raw.githubusercontent.com/mcanouil/xaringan-template/main/assets/setup-ggplot2-mc.R")


### Functions ======================================================================================


### Analysis =======================================================================================
dt <- setnames(
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

dt <- melt(
  data = dt[
    rowSums(is.na(dt)) == 0
  ][
    j = date := as.Date("2021-09-06") + seq_len(.N) - 1
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

growth_ggplot <- ggplot(dt) +
  aes(x = date, y = weight) +
  geom_path(data = ~ .x[!(outlier)], mapping = aes(colour = id)) +
  geom_point(aes(colour = id, shape = outlier), size = 1) +
  geom_text_repel(
    data = ~ .x[!(outlier)][date == max(date)],
    mapping = aes(colour = id, label = id),
    nudge_x = 2,
    direction = "y",
    min.segment.length = 0,
    size = 4,
    hjust = 0
  ) +
  # geom_ribbon(
  #   data = ~ unique(.x[!(outlier), list(date, y, ymin, ymax)]),
  #   mapping = aes(x = date, y = y, ymin = ymin, ymax = ymax),
  #   fill = "#FFFFFF80",
  #   inherit.aes = FALSE
  # ) +
  geom_path(
    data = ~ unique(.x[!(outlier), list(date, y, ymin, ymax)]),
    mapping = aes(x = date, y = y),
    colour = "#FFFFFF",
    linetype = 2,
    inherit.aes = FALSE
  ) +
  scale_x_date(
    date_breaks = "1 week",
    date_labels = "%d/%m<br>%Y",
    expand = expansion(add = c(0, 4))
  ) +
  scale_y_continuous(
    labels = number_format(big.mark = ","),
    expand = expansion(c(0, 0.25))
  ) +
  scale_colour_viridis_d(begin = 0.50, end = 1) +
  scale_shape_manual(values = c(16, 4)) +
  coord_cartesian(ylim = range(c(0, dt[!(outlier), weight]))) +
  labs(x = NULL, y = "Weight (g)") +
  theme(legend.position = "none") + 
  facet_grid(rows = vars(colour), cols = vars(sex))

htmlSVG(
  code = print(growth_ggplot),
  width = 8,
  height = 8
)

svglite(filename = here("outputs/growth.svg"), width = 8, height = 6)
print(growth_ggplot)
invisible(dev.off())


### Complete =======================================================================================
message("Success!", appendLF = TRUE)
message(timestamp(quiet = TRUE))
