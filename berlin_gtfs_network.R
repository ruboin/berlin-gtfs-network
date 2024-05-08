library(shiny)
library(bslib)
library(leaflet)
library(dplyr)
library(sf)

load("berlin_stops.RData") # load dataset with stops and (min-max scaled) network measures
load("berlin_lines.RData") # load dataset with shapes

# define route colors
route_colors <- colorFactor(palette = "plasma", domain = unique(as.factor(berlin_lines$route_type)))

# ui
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "darkly"),
  sidebarLayout(
    sidebarPanel(
      width = 2,
      selectInput("colorBy", "Station color by:",
                  choices = c("from_frequency", "to_frequency", "degree", "betweenness", "eigenvector", "closeness", "constraint"),
                  selected = "closeness"),
      selectInput("radiusBy", "Station radius by:",
                  choices = c("from_frequency", "to_frequency", "degree", "betweenness", "eigenvector", "closeness", "constraint"),
                  selected = "degree"),
      checkboxInput("incl_routes", "Include routes", FALSE)
    ),
    mainPanel(
      width = 10,
      leafletOutput("map", height = "100vh")
    )
  )
)

# server logic
server <- function(input, output, session) {
  output$map <- renderLeaflet({
    
    # initialize map
    map <- leaflet() %>% 
      addProviderTiles(providers$OpenStreetMap)
    
    # add berlin routes, if selected
    if (input$incl_routes) {
      map <- map %>% addPolylines(
        data = berlin_lines,
        color = ~route_colors(route_type),
        weight = 2,
        opacity = 1
      )
    }
    
    # set station colors according to user input
    station_colors <- colorFactor(palette = "viridis", domain = berlin_stops[[input$colorBy]])
    
    # add berlin stations, with radius according to user input
    map %>% addCircles(
      data = berlin_stops,
      lng = ~stop_lon, lat = ~stop_lat,
      radius = ~get(input$radiusBy) * 350,
      color = ~station_colors(get(input$colorBy)),
      popup = ~stop_name,
      fillOpacity = 0.8,
      opacity = 1
    )
  })
}

# run
shinyApp(ui = ui, server = server)