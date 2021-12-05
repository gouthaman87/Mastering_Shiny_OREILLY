library(shiny)

puppies <- tibble::tribble(
  ~breed, ~ id, ~author, 
  "corgi", "eoqnr8ikwFE","alvannee",
  "labrador", "KCdYn0xu2fU", "shaneguymon",
  "spaniel", "TzjMd7i5WQI", "_redo_"
)

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),
  
  navbarPage(
    "Image",
    
    tabPanel(
      "Puppies",
      selectInput(
        "id",
        label = "Pick a Breed",
        choices = setNames(puppies$id, puppies$breed)
      ),
      htmlOutput("source"),
      imageOutput("photo")
    )
  )
)

server <- function(input, output, session) {
  thematic::thematic_shiny()
  
  output$photo <- renderImage({
    list(
      src = file.path("puppy-photos", paste0(input$id, ".jpg")),
      contentType = "image/jpeg",
      width = 500,
      height = 650
    )
  }, deleteFile = FALSE)
}

shinyApp(ui, server)