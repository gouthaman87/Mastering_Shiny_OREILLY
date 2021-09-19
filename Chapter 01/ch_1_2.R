library(shiny)

ui <- fluidPage(
  shiny::sliderInput(
    "x",
    label = "Number Input",
    min = 1,
    max = 50,
    value = 10,
    step = 1
  ),
  
  shiny::sliderInput(
    "y",
    label = "Number Input",
    min = 1,
    max = 50,
    value = 10,
    step = 1
  ),
  "then, (x * y) is", textOutput("product"),
  "and, (x * y) + 5 is", textOutput("product_plus5"),
  "and (x * y) + 10 is", textOutput("product_plus10")
)

server <- function(input, output, session) {
  product <- shiny::reactive(input$x * input$y)

  output$product <- shiny::renderText(product())
  output$product_plus5 <- shiny::renderText(product() + 5)
  output$product_plus10 <- shiny::renderText(product() + 10)
}

shinyApp(ui, server)