tar_target(growth_plot_id, {
  p <- ggplot(tidy_data) +
    aes(x = date, y = weight) +
    geom_path(
      data = ~ unique(.x[!(outlier), list(date, y, ymin, ymax)]),
      mapping = aes(x = date, y = y),
      colour = "#FFFFFF",
      linetype = 2, 
      size = 0.75,
      inherit.aes = FALSE
    ) +
    scale_x_date(
      date_breaks = "1 week",
      date_labels = "%d/%m<br>%Y",
      expand = expansion(add = c(0, 7 / 2))
    ) +
    scale_y_continuous(
      labels = number_format(big.mark = ",", scale = 1e-3),
      expand = expansion(c(0, 0.25))
    ) +
    scale_colour_viridis_d(begin = 0.50, end = 1) +
    scale_shape_manual(values = c(16, 4)) +
    coord_cartesian(ylim = range(c(0, tidy_data[!(outlier), weight]))) +
    labs(x = NULL, y = "Weight (kg)") +
    theme(  
      legend.position = "none", 
      panel.grid.major = element_line(size = ggplot2::rel(0.5)), 
      panel.grid.minor = element_line(size = ggplot2::rel(0.25))
    )

  lapply(
    X = unique(tidy_data[["id"]]),
    FUN = function(idog) {
      p +
      geom_path(data = ~.x[id %in% idog], mapping = aes(colour = id), size = 1) +
      geom_point(data = ~.x[id %in% idog], mapping = aes(colour = id, shape = outlier), size = 2) +
      labs(title = idog)
    }
  )
})
