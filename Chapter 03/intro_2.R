library(shiny)

freqpoly <- function(
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

ui <- fluidPage(
  fluidRow(
    column(3, 
           numericInput("lambda1", label = "lambda1", value = 3),
           numericInput("lambda2", label = "lambda2", value = 5),
           numericInput("n", label = "n", value = 1e4, min = 0),
           actionButton("simulate", "Simulate!")
    ),
    column(9, plotOutput("hist")),
    
    ## Observe Event
    shiny::textInput("name", "What's your name"),
    shiny::textOutput("greetings")
  )
)

server <- function(input, output, session) {
  # timer <- reactiveTimer(500)
  x1 <- eventReactive(input$simulate, {
    rpois(input$n, input$lambda1)
  })
  x2 <- eventReactive(input$simulate, {
    rpois(input$n, input$lambda2)
  })
  
  str_name <- shiny::reactive(paste0("Hello ", input$name, "!"))
  
  output$greetings <- renderText(str_name())
  
  observeEvent(input$name, {
    message("Greetings protected")
  })
  
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = 1, xlim = c(0, 40))
  }, res = 96)
}

shinyApp(ui, server)