---
pagetitle: "Plot"
output:
  html_document:
    keep_md: yes
---




```r
library(tidyverse)
```


```r
df <- read_csv("https://raw.githubusercontent.com/rcatlord/ddj/main/data/babynames1996to2020.csv")
```


```r
glimpse(df)
```

```
## Rows: 294,798
## Columns: 5
## $ year <dbl> 1996, 1996, 1996, 1996, 1996, 1996, 1996, 1996, 1996, 1996, 1996,~
## $ sex  <chr> "M", "M", "M", "M", "M", "M", "M", "M", "M", "M", "M", "M", "M", ~
## $ name <chr> "Jack", "Daniel", "Thomas", "James", "Joshua", "Matthew", "Ryan",~
## $ n    <dbl> 10779, 10338, 9603, 9385, 7887, 7426, 6496, 6193, 6161, 5802, 575~
## $ rank <dbl> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19~
```


```r
selected_name <- "Alex"
```


```r
df %>% 
  filter(name == selected_name) %>% 
  ggplot(aes(x = year, y = n)) +
  geom_line(aes(colour = sex), size = 1.5) +
  scale_x_continuous(breaks = seq(1996, 2020, 4)) +
  scale_y_continuous(position = "right", labels = scales::comma_format(accuracy = 1)) +
  scale_color_manual(values = c("F" = "#8700F9", "M" = "#00C4AA"),
                     labels = c("F" = "Girls", "M" = "Boys")) +
  labs(x = NULL, y = NULL,
       title = paste("Number of babies named", selected_name),
       subtitle = "England & Wales, 1996-2020",
       caption = "Source: Office for National Statistics",
       colour = NULL)  +
  theme_minimal(base_size = 14) +
  theme(plot.margin = unit(rep(1, 4), "cm"),
        panel.border = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line.x = element_line(),
        plot.title.position = "plot",
        plot.title = element_text(size = rel(1.2), face = "bold", hjust = 0, margin = margin(b = 7)),
        plot.subtitle = element_text(size = rel(0.85), hjust = 0),
        plot.caption = element_text(size = rel(0.8), color = "#777777", hjust = 0, margin = margin(t = 15)),
        legend.position = "top") +
  coord_cartesian(expand = FALSE, clip = "off")
```

![](plot_files/figure-html/unnamed-chunk-5-1.png)<!-- -->


```r
ggsave(paste0(str_to_lower(selected_name), "_plot.png"), scale = 1, dpi = 300)
```

