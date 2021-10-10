tar_target(growth_plot, {
  ggplot(tidy_data) +
    aes(x = date, y = weight) +
    with_outer_glow(
      geom_path(data = ~ .x[!(outlier)], mapping = aes(colour = id)),
      colour = "#FFFFFF",
      sigma = 1
    ) +
    # geom_point(aes(colour = id, shape = outlier), size = 1) +
    geom_text_repel(
      data = ~ .x[!(outlier)][date == max(date)],
      mapping = aes(colour = id, label = id),
      nudge_x = 2,
      direction = "y",
      min.segment.length = 0,
      size = 5,
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
    coord_cartesian(ylim = range(c(0, tidy_data[!(outlier), weight]))) +
    labs(x = NULL, y = "Weight (g)") +
    theme(legend.position = "none") +
    facet_grid(rows = vars(colour), cols = vars(sex))
})
