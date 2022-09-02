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
#' We'll be exploring the [Baby names in England and Wales: from 1996](https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/livebirths/datasets/babynamesinenglandandwalesfrom1996) dataset.
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


#'
#' ## Read data 
#' **from a folder**      
#'
#' - `read_excel()` 
#' 
#' - `read_csv()`  

#'
#' **from a URL**      

#'
#' **by hand**   
#'   
#' - `tribble()`  

#'
#' ## Inspect data 
#' - `glimpse()`      
#' 
#' - `slice()`      
#' 
#' - `slice_max()`      



#'
#' ## Explore data 
#' **manipulating columns**   
#'   
#' - `select()`      
#' 
#' - `mutate()`      

#' 
#' **manipulating rows**    
#'   
#' - `arrange()`      
#' 
#' - `filter()`  

#' 
#' **summarising data**    
#'   
#' - `group_by()`      

#'
#' ## Visualise data
#' - `geom_line()`  


#'
#' ## Share data
#' - `ggsave()`      
#' 
#' - `write_csv()`  


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
