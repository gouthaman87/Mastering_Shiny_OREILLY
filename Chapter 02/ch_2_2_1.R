library(shiny)

ui <- fluidPage(
  # Question 2.2.1
  shiny::textInput(
    "name", 
    label = "Whats your name?", 
    placeholder = "Your name"
  ),
  
  # Question 2.2.2
  shiny::sliderInput(
    "date",
    label = "When should we deliver?",
    min = as.Date("2020-09-16"),
    value = as.Date("2020-09-17"),
    max = as.Date("2020-09-23"),
    step = 1
  ),
  
  # Question 2.2.3
  shiny::sliderInput(
    "number",
    label = "",
    min = 0,
    max = 100,
    value = 0,
    step = 5,
    animate = TRUE
  ),
  
  # Question 2.2.4
  shiny::selectInput(
    "breed",
    "Select your favourite animal",
    choices = list(dogs = list('German Shepherd', 'Bulldog', 'Labrador Retriever'),
                   cats = list('Persian cat', 'Bengal cat', 'Siamese Cat'))
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)