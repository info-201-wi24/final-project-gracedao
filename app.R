library(shiny)
library(tidyverse)
library(plotly)
library(bslib)

source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)