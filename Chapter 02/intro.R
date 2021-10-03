library(shiny)

animals <- c("dog", "cat", "mouse", "bird", "other", "I hate animals")

ui <- fluidPage(
  # Input ----
  # Free Text
  shiny::textInput("name", "What's your name?"),
  shiny::passwordInput("password", "What's your password?"),
  shiny::textAreaInput("story", "Tell me about yourself", rows = 3),
  
  # Numeric Input
  shiny::numericInput("num", "Number One", value = 0, min = 0, max = 100),
  shiny::sliderInput("num2", "Number Two", value = 50, min = 0, max = 100),
  shiny::sliderInput("rng", "Range", value = c(10, 20), min = 0, max = 100),
  
  # Input: Custom currency format for with basic animation
  shiny::sliderInput(
    "format",
    "Custom format:",
    min = 0,
    max = 10000,
    value = 0,
    sep = ",",
    pre = "$",
    animate = TRUE
  ),
  
  # Input: Animation with custom interval (in ms)
  # to control speed, plus looping
  shiny::sliderInput(
    "animation",
    "Looping animation:",
    min = 1,
    max = 1000,
    value = 1,
    step = 10,
    animate = shiny::animationOptions(interval = 300, loop = TRUE)
  ),
  
  # Date
  shiny::dateInput("dob", "When were you born?"),
  shiny::dateRangeInput("holiday", "When do you want to go on a vacation?"),
  
  # Limited Choices
  shiny::radioButtons("animals", "Select Animal", choices = animals),
  shiny::selectInput("state", "What's your favourite region?", state.region),
  
  # File uploads
  shiny::fileInput("upload", NULL),
  
  # Action Buttons
  shiny::actionButton("click", "Click me!", class = "btn-danger"),
  shiny::actionButton("drink", "Drink me!", icon = icon("cocktail")),
  
  # Output ----
  shiny::textOutput("text"),
  shiny::verbatimTextOutput("code"),
  
  shiny::tableOutput("static"),
  shiny::dataTableOutput("dynamic"),
  reactable::reactableOutput("react"),
  
  shiny::plotOutput("plot", width = "400px")
)

server <- function(input, output, session) {
  output$text <- shiny::renderText("Hello Friend!")
  output$code <- shiny::renderPrint(skimr::skim(ggplot2::mpg))
  
  output$static <- shiny::renderTable(ggplot2::midwest[1:10,])
  output$dynamic <- shiny::renderDataTable(ggplot2::midwest, options = list(pageLength = 5))
  output$react <- reactable::renderReactable(reactable::reactable(ggplot2::midwest))
  
  output$plot <- shiny::renderPlot({
    ggplot2::ggplot(data = ggplot2::mpg, ggplot2::aes(cyl, displ)) +
      ggplot2::geom_point()
  },
  res = 96)
}

shinyApp(ui, server)