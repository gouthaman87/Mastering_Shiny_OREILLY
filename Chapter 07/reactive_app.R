library(shiny)

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),
  
  navbarPage(
    "Reactive App",
    
    tabPanel(
      "Display",
      plotOutput("plt_1", brush = "plot_brush", dblclick = "plot_reset")
    )
  )
)

server <- function(input, output, session) {
  thematic::thematic_shiny()
  
  selected <- reactiveVal(rep(FALSE, nrow(mtcars)))
  
  observeEvent(
    input$plot_brush,
    {
      brushed <- brushedPoints(mtcars, input$plot_brush, allRows = TRUE)$selected_
      selected(brushed | selected())
    }
  )
  
  observeEvent(
    input$plot_reset,
    {
      selected(rep(FALSE, nrow(mtcars)))
    }
  )
  
  output$plt_1 <- renderPlot({
    mtcars$sel <- selected()
    
    ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
      ggplot2::geom_point(ggplot2::aes(col = sel)) +
      ggplot2::theme_minimal()
  }, res = 96)
}

shinyApp(ui, server)