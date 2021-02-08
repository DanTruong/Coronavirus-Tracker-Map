# Load requisite libraries
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

server <- function(input, output, session) {
  # Define map as a Leaflet component
  output$map <- renderLeaflet({

    # Init Leaflet
    leaflet() %>%

      # Add map tiles from Mapbox
      addTiles() %>%
      
      # Set default map view over continental US
      setView(lng = -95.6650, lat = 37.6000, zoom = 4) %>%

      # Draw circles to represent cases
      addCircles(
        data = covidCasesCons[
          covidCasesCons$year == as.integer(input$yearVal) &
          covidCasesCons$month == as.integer(input$monthVal),
        ],
        lat = ~lat,
        lng = ~long,
        radius = ~ cases / 50,
        color = 'red',
        popup = ~ as.character(paste0(
          full,
          ": ",
          cases,
          " Active Cases"
        )),
        label = ~ as.character(paste0(
          full,
          ": ",
          cases, 
          " Active Cases"
        ))
      )
  })

  # Define table to include consolidated dataset
  output$incTable <- DT::renderDataTable(covidCasesCons)
}

