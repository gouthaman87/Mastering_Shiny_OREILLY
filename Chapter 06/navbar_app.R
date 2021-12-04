library(shiny)
library(plotly)

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),
  
  # navlistPanel(
  #   id = "tabset",
  #   "Heading 1",
  #   tabPanel("panel 1", "Panel 1 Contestants"),
  #   "Heading 2",
  #   tabPanel("panel 2", "Panel 2 Contestants")
  # )
  
  navbarPage(
    "Test Theme/Navbar",
    tabPanel(
      "Plot", 
      titlePanel("A themed plot"),
      plotly::plotlyOutput("plt")
    )
  )
)

server <- function(input, output, session) {
  thematic::thematic_shiny()
  
  output$plt <- plotly::renderPlotly({
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    ggplot2::geom_smooth() +
    ggplot2::theme_minimal()
  
  plotly::ggplotly(p)
  })
}

shinyApp(ui, server)