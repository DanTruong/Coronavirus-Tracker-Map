# Load requisite libraries
library(leaflet)

ui <- navbarPage("US COVID-19 Cases",
  id = "nav",

  tabPanel("Map", div(
    class = "outer", tags$head(
      includeCSS("styles.css"),
      includeScript("gomap.js")
    ),

    leafletOutput("map",
      width = "100%",
      height = "100%"
    ),

    absolutePanel(
      id = "controls",
      class = "panel panel-default",
      fixed = TRUE,
      draggable = TRUE,
      top = 60,
      left = "auto",
      right = 20,
      bottom = "auto",
      width = 330,
      height = "auto",
      h2("Data Variables"),
      dateRangeInput("dateVal", "Date Range",
                     min = min(as.Date(covidCases$date, format = "%Y-%m-%d")),
                     max = max(as.Date(covidCases$date, format = "%Y-%m-%d")),
                     start  = min(as.Date(covidCases$date, format = "%Y-%m-%d")),
                     end = min(as.Date(covidCases$date, format = "%Y-%m-%d")) + 365,
                     format = "mm/dd/yy",
                     separator = " - "),
      selectInput("variableVal", "Select Filter", unique(covidCases$variable))
    ),
  )),

  tabPanel("Data", DT::dataTableOutput("incTable")),

  conditionalPanel("false", icon("crosshair"))
)
