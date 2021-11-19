library(shiny)

ui <- fluidPage(
  shiny::titlePanel("Central Limit Theorem"),
  
  shiny::sidebarLayout(
    shiny::sidebarPanel(
      shiny::sliderInput("obs", "Observations:", min = 0, max = 100, value = 50)
    ),
    
    shiny::mainPanel(
      shiny::plotOutput("distPlot")
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)