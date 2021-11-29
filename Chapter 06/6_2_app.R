library(shiny)

ui <- fluidPage(
  fluidRow(
    column(6, plotOutput("distPlot")),
    column(6, plotOutput("histPlot"))
  ),
  
  fluidRow(
    shiny::sliderInput("obs", "Observations:", min = 0, max = 100, value = 50, width = '100%')
  )
)

server <- function(input, output, session) {
  means_df <- reactive(data.frame(means = replicate(1e4, mean(runif(input$obs)))))
  
  output$distPlot <- renderPlot({
    ggplot2::ggplot(data = means_df(), ggplot2::aes(x = means)) +
      ggplot2::geom_density(fill = "#fde725") +
      ggplot2::theme_minimal()
  }, res = 96)
  
  output$histPlot <- renderPlot({
    ggplot2::ggplot(data = means_df(), ggplot2::aes(x = means)) +
      ggplot2::geom_histogram(fill = "#fde725", color = "black", bins = 30) +
      ggplot2::theme_minimal()
  }, res = 96)
}

shinyApp(ui, server)