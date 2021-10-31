library(shiny)

sales <- readr::read_csv("https://raw.githubusercontent.com/hadley/mastering-shiny/master/sales-dashboard/sales_data_sample.csv")

sales <- sales[c(
  "TERRITORY", "ORDERDATE", "ORDERNUMBER", "PRODUCTCODE",
  "QUANTITYORDERED", "PRICEEACH"
)]

ui <- fluidPage(
  shiny::sliderInput("x", "x", value = 1, min = 0, max = 10),
  shiny::sliderInput("y", "y", value = 2, min = 0, max = 10),
  shiny::sliderInput("z", "z", value = 3, min = 0, max = 10),
  shiny::textOutput("total"),
  shiny::selectInput("territory", "territory", choices = unique(sales$TERRITORY)),
  shiny::tableOutput("selected")
)

server <- function(input, output, session) {
  selected <- shiny::reactive({
    if(input$territory == "NA")
      subset(sales, is.na(TERRITORY))
    else
      subset(sales, TERRITORY %in% input$territory)
  })
  output$selected <- shiny::renderTable(head(selected(), 10))
  
  shiny::observeEvent(input$x, {
    message(glue::glue("Updating y from {input$y} to {input$x *2}"))
    updateSliderInput(session, "y", value = input$x * 2)
  })
  
  total <- reactive({
    total <- input$x + input$y + input$z
    message(glue::glue("New total is {total}"))
    total
  })
  
  output$total <- renderText({
    total()
  })
}

shinyApp(ui, server)