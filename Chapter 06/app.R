library(shiny)

ui <- fluidPage(
  shiny::titlePanel("Central Limit Theorem"),
  
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::sliderInput("obs", "Observations:", min = 0, max = 100, value = 50),
    ),
    
    shiny::mainPanel(
      shiny::plotOutput("distPlot")
    ),
    
    position = "right"
  )
)

server <- function(input, output, session) {
  output$distPlot <- renderPlot({
    means_df <- data.frame(means = replicate(1e4, mean(runif(input$obs))))
    
    ggplot2::ggplot(data = means_df, ggplot2::aes(x = means)) +
      ggplot2::geom_density(fill = "#fde725") +
      ggplot2::theme_minimal()
  }, res = 96)
}

shinyApp(ui, server)