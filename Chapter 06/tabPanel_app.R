library(shiny)

ui <- fluidPage(
  tabsetPanel(
    tabPanel(
      "Import Data",
      fileInput("file", "Data", buttonLabel = "Upload..."),
      textInput("delim", "Delimeter (leave blank to guess)", ""),
      numericInput("skip", "Rows to skip", 0, min = 0),
      numericInput("rows", "Rows to preview", 10, min = 1)
    ),
    
    tabPanel("Set parameters"),
    tabPanel("Visualize results")
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)