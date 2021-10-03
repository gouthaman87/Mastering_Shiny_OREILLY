library(shiny)

ui <- fluidPage(
  shiny::plotOutput("plot", width = "700px", height = "300px"),
  
  shiny::dataTableOutput("table")
)

server <- function(input, output, session) {
  output$plot <- shiny::renderPlot({
    ggplot2::ggplot(data = ggplot2::mpg, ggplot2::aes(cyl, displ)) +
      ggplot2::geom_point()
  },
  res = 96,
  alt = "impaired")
  
  output$table <- renderDataTable(
    datasets::mtcars,
    options = list(pageLength = 5, ordering = FALSE, searching = FALSE)
  )
}

shinyApp(ui, server)