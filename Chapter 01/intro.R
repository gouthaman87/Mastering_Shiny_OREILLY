# Create App directory
ui <- shiny::fluidPage(
  # Create a list of data list
  shiny::selectInput(
    "dataset",
    label = "Dataset",
    choices = ls("package:datasets")
  ),
  
  shiny::verbatimTextOutput("summary"),
  
  shiny::tableOutput("table")
)

server <- function(input, output, session) {
  # Create reactive function
  dataset <- shiny::reactive({
    get(input$dataset, "package:datasets")
  })
  
  output$summary <- shiny::renderPrint({
    # dataset <- get(input$dataset, "package:datasets")
    skimr::skim(dataset())
  })
  
  output$table <- shiny::renderTable({
    # dataset <- get(input$dataset, "package:datasets")
    dataset()
  })
}

shiny::shinyApp(ui, server)
