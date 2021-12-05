library(shiny)

df <- data.frame(x = rnorm(100), y = rnorm(100))

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),
  
  navbarPage(
    "Plot Graphics",
    # Mouse Click ----
    tabPanel(
      "Mouse Click",
      plotOutput("plt_1", click = "plot_click"),
      verbatimTextOutput("info")
    ),
    
    # Near Point ----
    tabPanel(
      "Near Point",
      plotOutput("plt_2", click = "plot_click"),
      tableOutput("dt_1")
    ),
    
    # Brush ----
    tabPanel(
      "Brush",
      plotOutput("plt_3", brush = "plot_brush"),
      tableOutput("dt_2")
    ),
    
    # Reactive Value ----
    tabPanel(
      "Reactive Value",
      plotOutput("plt_4", click = "plot_click")
    )
  )
)

server <- function(input, output, session) {
  thematic::thematic_shiny()
  
  # Mouse Click ----
  output$plt_1 <- renderPlot({
    ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
      ggplot2::geom_point() +
      ggplot2::theme_minimal()
  }, res = 96)
  
  output$info <- renderPrint({
    req(input$plot_click)
    x <- round(input$plot_click$x, 2)
    y <- round(input$plot_click$y, 2)
    cat("[", x, ", ", y, "]", sep = "")
  })
  
  # Near Point ----
  output$plt_2 <- renderPlot({
    ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
      ggplot2::geom_point() +
      ggplot2::theme_minimal()
  }, res = 96)
  
  output$dt_1 <- renderTable({
    req(input$plot_click)
    nearPoints(mtcars, input$plot_click)
  })
  
  # Brush ----
  output$plt_3 <- renderPlot({
    ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
      ggplot2::geom_point() +
      ggplot2::theme_minimal()
  }, res = 96)
  
  output$dt_2 <- renderTable({
    req(input$plot_brush)
    brushedPoints(mtcars, input$plot_brush)
  })
  
  # Reactive Value ----
  dist <- reactiveVal(rep(1, nrow(df)))
  
  observeEvent(
    input$plot_click,
    dist(nearPoints(df, input$plot_click, allRows = TRUE, addDist = TRUE)$dist_)
  )
  
  output$plt_4 <- renderPlot({
    df$dist <- dist()
    
    ggplot2::ggplot(df, ggplot2::aes(x, y, size = dist)) +
      ggplot2::geom_point() +
      ggplot2::scale_size_area(limits = c(0, 1000), max_size = 10, guide = NULL) +
      ggplot2::theme_minimal()
  }, res = 96)
}

shinyApp(ui, server)