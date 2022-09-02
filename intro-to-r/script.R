#' ---
#' title: "An intro to R for data journalism"
#' output: github_document
#' ---
#'
#' ## Learning objectives
#' - gain familiarity with the RStudio IDE      
#' - know how to load data      
#' - understand some dplyr functions     
#' - create simple data visualisations with ggplot2      
#'
#' ## Data
#' We'll be exploring the [Baby names in England and Wales: from 1996](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/livebirths/datasets/babynamesinenglandandwalesfrom1996) dataset published by the Office for National Statistics.
#'
#' ## Setup
#' If you haven't set up RStudio on your ONS computer check out these [instructions](https://officenationalstatistics.sharepoint.com/:w:/r/sites/MTHIT/_layouts/15/Doc.aspx?sourcedoc=%7B63CEC66C-C810-451D-B2C5-37560E16A42C%7D&file=R_Setup_Instructions_2019.docx&action=default&mobileredirect=true&DefaultItemOpen=1&cid=f002a8e4-3998-4bc2-b2e6-b7bdee409585). 
#'
#' **set the working directory**   
#'        
#' - `getwd()`  

#' 
#' - `setwd()`   

#'
#' **install packages**  
#'     
#' - `install.packages()`    

#'
#' **load packages**   
#'   
#' - `library()`    

library(tidyverse) ; library(readxl)

#'
#' ## Read data 
#' **from a folder**      
#'
#' - `read_excel()` 

#df <- read_excel("data/babynames1996to2020.xls", sheet = "Boys")

#' 
#' - `read_csv()`  

#df <- read_csv("data/babynames1996to2020.csv")

#'
#' **from a URL**      

df <- read_csv("https://raw.githubusercontent.com/rcatlord/ddj/main/data/babynames1996to2020.csv")

#'
#' **by hand**   
#'   
#' - `tribble()`  

#df <- tribble(
#  ~year, ~sex, ~name, ~n, ~rank,
#  2020, "M", "Oliver", 4225, 1,
#  2020, "F", "Olivia", 3640, 1
#)

#'
#' ## Inspect data 
#' - `glimpse()`  

glimpse(df)

#' 
#' - `slice()`    

slice(df, 1:10)

#' 
#' - `slice_max()`

slice_max(df, n, n = 5)

#'
#' ## Explore data 
#' **manipulating columns**   
#'   
#' - `select()` 

select(df, year, sex, rank)
select(df, Year = year, Sex = sex, Rank = rank)
select(df, rank, sex, n)

#' 
#' - `mutate()`   

mutate(df, name_length = str_length(name))   

#' 
#' **manipulating rows**    
#'   
#' - `arrange()`  

arrange(df, n)
arrange(df, desc(n))

#' 
#' - `filter()`  

filter(df, name == "Thor")

filter(df, name == "Thor" & year == 2020)

filter(df, name %in% c("Thor", "Odin"))

#' 
#' **summarising data**    
#'   
#' - `group_by()`  

df %>% 
  group_by(year) %>% 
  top_n(1, n)

df %>% 
  group_by(year, sex) %>% 
  top_n(1, n)

#'
#' ## Visualise data
#' - `geom_line()`  

df_sub <- filter(df, name == "Thor")

ggplot(df_sub, aes(x = year, y = n)) +
  geom_line()

df_sub <- filter(df, name %in% c("Thor", "Odin"))

ggplot(df_sub, aes(x = year, y = n, colour = name)) +
  geom_line(size = 1.5) +
  facet_wrap(~name)

#'
#' ## Share data
#' - `ggsave()`  

#ggsave("outputs/plot.png", scale = 1, dpi = 300)

#' 
#' - `write_csv()`  

#write_csv(df_sub, "outputs/names.csv")

#'
#' ## Further resources
#' **Beginners**     
#' - [RStudio primers](https://rstudio.cloud/learn/primers)   
#' - [R for Data Science](https://r4ds.had.co.nz/) by Hadley Wickham and Garrett Grolemund   
#' 
#' **Data visualisation**    
#' - [Fundamentals of Data Visualization](https://clauswilke.com/dataviz) by Claus Wilke      
#' - [Data Visualization: A practical introduction](http://socviz.co/) by Kieran Healy    
#' - [BBC Visual and Data Journalism cookbook for R graphics](https://bbc.github.io/rcookbook)   
#'
#' **Statistics**   
#' - [Discovering Statistics Using R](https://us.sagepub.com/en-us/nam/discovering-statistics-using-r-and-rstudio/book261351) by Andy Field  
#' - [Statistics: An Introduction Using R](https://www.wiley.com/en-gb/Statistics%3A+An+Introduction+Using+R%2C+2nd+Edition-p-9781118941096) by Michael J. Crawley   
#'
#' **Help**   
#' - [StackOverflow](https://stackoverflow.com/questions/tagged/r)   
#' - [RStudio Community](https://community.rstudio.com)   
#' - [Twitter #rstats hashtag](https://twitter.com/search?q=%23rstats)