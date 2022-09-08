library(dplyr) ; library(ggplot2)

df <- read_csv("https://github.com/rcatlord/ewbabynames/raw/main/ewbabynames.csv")

glimpse(df)

name <- "Cameron"

names <- df %>%
  filter(name %in% c("Tim", "Ahmad", "Theo", "Sam"), sex == "M")

ggplot(names, aes(x = year, y = n, color = name)) +
  geom_line()





df %>%
  filter(name == name) %>%
  ggplot(aes(x = year, y = n)) +
  geom_line(aes(group = sex, colour = sex), size = 1.5) +
  scale_x_continuous(limits = c(1996, NA)) +
  scale_color_manual(values = c("#8C5FF8", "#63E6D2"),
                     labels = c("Female", "Male")) +
  labs(x = "Year", 
       y = "Number of babies",
       title = paste("Babies named", name),
       subtitle = "England and Wales, 1996 and 2020",
       caption = "Source: ONS",
       color = "") +
  theme_minimal(base_size = 14) +
  theme(plot.margin = unit(rep(1, 4), "cm"),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = rel(1.2), face = "bold"),
        plot.subtitle = element_text(size = rel(0.9)),
        axis.title.x = element_text(size = rel(0.8), hjust = 1, margin = margin(t = 10)),
        axis.title.y = element_text(size = rel(0.8), angle = 90, hjust = 1, margin = margin(r = 10)),
        plot.caption = element_text(colour = "grey60", hjust = 0, margin = margin(t = 20)),
        legend.position = "top", 
        legend.justification = "left",
        legend.text = element_text(size = rel(0.8)))

ggsave("baby_plot.png", scale=1, dpi=300)
