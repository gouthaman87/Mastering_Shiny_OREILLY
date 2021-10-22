library(shiny)

freq_poly <- function(
  x1,
  x2,
  binwidth = 0.1,
  xlim = c(-3, 3)
){
  df <- dplyr::tibble(
    x = c(x1, x2),
    g = c(rep("x1", length(x1)), rep("x2", length(x2)))
  )
  
  ggplot2::ggplot(df, ggplot2::aes(x, color = g)) +
    ggplot2::geom_freqpoly(binwidth = binwidth, size = 1) +
    ggplot2::coord_cartesian(xlim = xlim)
}

t_test <- function(x1, x2){
  test <- t.test(x1, x2)
  
  broom::tidy(test)
}

ui <- fluidPage(
  shiny::fluidRow(
    shiny::column(
      4,
      "Distribution 1",
      shiny::numericInput("n1", label = "n", value = 1000, min = 1),
      shiny::numericInput("mu1", label = "mean", value = 0, step = 0.1),
      shiny::numericInput("sd1", label = "standard deviation", value = 0.5, min = 0.1, step = 0.1)
    ),
    
    shiny::column(
      4,
      "Distribution 2",
      shiny::numericInput("n2", label = "n", value = 1000, min = 1),
      shiny::numericInput("mu2", label = "mean", value = 0, step = 0.1),
      shiny::numericInput("sd2", label = "standard deviation", value = 0.5, min = 0.1, step = 0.1)
    ),
    
    shiny::column(
      4,
      "Frequency Polygun",
      shiny::numericInput("binwidth", label = "Bin Width", value = 0.1, step = 0.1),
      shiny::sliderInput("range", label = "range", min = -5, max = 5, value = c(-3,3))
    )
  ),
  
  shiny::fluidRow(
    shiny::column(9, shiny::plotOutput("hist")),
    shiny::column(3, shiny::tableOutput("ttest"))
  )
)

server <- function(input, output, session) {
  x1 <- shiny::reactive(rnorm(input$n1, input$mu1, input$sd1))
  x2 <- shiny::reactive(rnorm(input$n2, input$mu2, input$sd2))
  
  output$hist <- shiny::renderPlot(
    freq_poly(x1(), x2(), binwidth = input$binwidth, xlim = input$range),
    res = 96
  )
  
  output$ttest <- shiny::renderTable(
    t_test(x1(), x2())
  )
}

shinyApp(ui, server)