library(shiny)
library(ggplot2)
library(palmerpenguins)

# Define UI
ui <- fluidPage(
  titlePanel("Penguin Data Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("xvar", "X-axis:", choices = names(penguins)[3:6], selected = "bill_length_mm"),
      selectInput("yvar", "Y-axis:", choices = names(penguins)[3:6], selected = "bill_depth_mm"),
      checkboxGroupInput("species", "Select Species:", 
                         choices = unique(na.omit(penguins$species)), 
                         selected = unique(na.omit(penguins$species)))
    ),
    
    mainPanel(
      plotOutput("scatterPlot")
    )
  )
)

# Define Server
server <- function(input, output) {
  output$scatterPlot <- renderPlot({
    # Filter data based on selected species
    filtered_data <- subset(penguins, species %in% input$species)
    
    # Create scatter plot
    ggplot(filtered_data, aes_string(x = input$xvar, y = input$yvar, color = "species")) +
      geom_point(size = 3, alpha = 0.7) +
      labs(x = input$xvar, y = input$yvar, color = "Species") +
      theme_minimal()
  })
}

# Run the App
shinyApp(ui = ui, server = server)
