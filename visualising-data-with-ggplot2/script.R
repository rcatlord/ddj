#' ---
#' title: "Visualising data with ggplot2"
#' output: github_document
#' always_allow_html: true
#' ---
#'
#' ## Learning objectives
#' - basic understanding of 'grammar of graphics'  
#' - able to create simple charts
#' - adapt charts to [ONS chart style guide](https://ons-design.notion.site/ONS-chart-style-guide-abc7605a97624dc2bc7f2a3e16379d82)
#' 

#' ## Data
#' We’ll be comparing the percentage of children living in poverty by local authority with levels of air pollution. 
#' Child poverty after housing costs (2020/21) derive from [End Child Poverty](http://endchildpoverty.org.uk/child-poverty) and population-weighted annual mean PM2.5 concentrations (2020) are published by [DEFRA](https://uk-air.defra.gov.uk/data/pcm-data).
#'
#' ## Setup


#' 
#' ## Read data



#' ## 'grammar of graphics'
#' The [ggplot2](https://ggplot2.tidyverse.org) package is underpinned by the '**g**rammar of **g**raphics' ([Wilkinson, 2005](https://link.springer.com/book/10.1007/0-387-28695-0)). 
#' Essentially, every data visualisation has a formal structure with three principle layers: data, aesthetics, and geometry. 
#' Variables in your **data** are mapped to the **aes**thetic properties (e.g. position, size and colour) of **geom**etric objects like scatter plots or line charts.
#' You can see this in the arguments used by ggplot2:
#' 
#' ``` r
#' ggplot(data = df,                                        # data
#'   mapping = aes(x = var1, y = var2, colour = var3)) +    # aesthetics
#'   geom_point()                                           # geometry
#' ```

#' 
#' ## Chart types
#' 
#' **Bar chart**
#' 


#'
#' **Choropleth map**

  
#' 
#' **Scatter plot**


#' 
#' **Small multiples**


#' 
#' **Trend lines**


#'
#' ## Create a chart template


#'
#' ## Typography


#'
#' ## Scales

#'
#' ## Colour


#'
#' ## Chart furniture
#' 
#' **Gridlines**


#' 
#' **Legend**


#' 
#' **Annotations**


#'
#' ## Highlighting


#'
#' ## Interactivity
#' 

#'
#' ## Further resources
#' - [ggplot2: Elegant Graphics for Data Analysis, 3rd edition ](https://ggplot2-book.org/index.html) by Hadley Wickham et al.
#' - [ggplot2 reference](https://ggplot2.tidyverse.org/reference/)
#' - *R for Data Science* (Wickham & Grolemund) pages on [data visualization](https://r4ds.had.co.nz/data-visualisation.html)
#' - [A ggplot2 Tutorial for Beautiful Plotting in R](https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/) by Cédric Scherer 
#' - [BBC Visual and Data Journalism cookbook for R graphics](https://bbc.github.io/rcookbook/)