library(shiny)
library(ggplot2)

datasets <- c("economics", "faithfuld", "seals")

ui <- fluidPage(
  shiny::selectInput("dataset", "Dataset", choices = datasets),
  shiny::verbatimTextOutput("summary"),
  shiny::plotOutput("plot")
)

server <- function(input, output, session) {
  dataset <- shiny::reactive({
    get(input$dataset, "package:ggplot2")
  })
  
  output$summary <- shiny::renderPrint(summary(dataset()))
  
  output$plot <- shiny::renderPlot({
    plot(dataset())
  }, res = 96)
}

shinyApp(ui, server)