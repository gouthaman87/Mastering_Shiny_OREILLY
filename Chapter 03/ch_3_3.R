library(shiny)

ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  # Question 3.3.6.1 ----
  # output$greeting <- renderText(paste0("Hello ", input$name))
  
  string <- shiny::reactive(paste0("Hello ", input$name))
  output$greeting <- renderText(string())
}

shinyApp(ui, server)