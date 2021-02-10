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
        data = aggregate(value ~ state + full + lat + long + variable,
                         covidCases[covidCases$date >= as.Date(input$dateVal[1], format = "%Y-%m-%d") 
                                    & covidCases$date <= as.Date(input$dateVal[2], format = "%Y-%m-%d")
                                    & covidCases$variable == input$variableVal, ], sum),
        lat = ~lat,
        lng = ~long,
        radius = ~ value,
        color = 'red',
        popup = ~ as.character(paste0(
          full,
          ": ",
          value,
          " ",
          variable
        )),
        label = ~ as.character(paste0(
          full,
          ": ",
          value,
          " ",
          variable
        ))
      )
  })

  # Define table to include consolidated dataset
  output$incTable <- DT::renderDataTable(covidCases)
}

