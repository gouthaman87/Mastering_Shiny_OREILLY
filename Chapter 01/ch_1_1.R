
# Define UI for application that draws a histogram
ui <- shiny::fluidPage(
    shiny::textInput(
        "name",
        label = "Please Enter the Name:"
    ),
    
    shiny::textOutput("person_name")
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    # Create reactive function
    name <- shiny::reactive({input$name})
    
    output$person_name <- shiny::renderText(
        glue::glue("Hi,", name(), " Welcome")
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
