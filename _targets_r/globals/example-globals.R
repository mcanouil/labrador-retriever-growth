tar_option_set(
  packages = c(
    "here",
    "svglite", "ggplot2", "ggtext", "patchwork", "scales",
    "ggrepel", "ggfx", "data.table", "readxl", "showtext"
  )
)

should_glow <- FALSE

font <- "Alegreya Sans"
sysfonts::font_add_google(font, font, regular.wt = 300)
showtext::showtext_auto()
source("https://raw.githubusercontent.com/mcanouil/xaringan-template/main/assets/setup-ggplot2-mc.R")
