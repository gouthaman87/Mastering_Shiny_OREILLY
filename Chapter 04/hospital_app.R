library(shiny)

prod_codes <- setNames(prod$prod_code, prod$title)

count_top <- function(df, var, n = 5){
  df |>
    dplyr::mutate(
      {{ var }} := forcats::fct_lump(forcats::fct_infreq({{ var }}), n = n)
    ) |>
    dplyr::count({{ var }}, wt = weight)
}

ui <- fluidPage(
  fluidRow(
    column(8, 
           selectInput("code", "Product", choices = prod_codes, width = "100%")),
    column(2,
           numericInput("rows", "Number of Rows", min = 1, max = 10, value = 5)),
    column(2,
           selectInput("y", "Y Axis", c("rate", "count")))
  ),
  
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  
  fluidRow(
    column(12, plotOutput("age_sex"))
  ),
  
  fluidRow(
    column(2, actionButton("prev_story", "Previous story")),
    column(2, actionButton("next_story", "Next story")),
    column(10, textOutput("narrative"))
  )
)

server <- function(input, output, session) {
  selected_df <- reactive(inj_df |> dplyr::filter(prod_code == input$code))
  
  # Find the maximum possible of rows.
  max_no_rows <- reactive(
    max(length(unique(selected_df()$diag)),
        length(unique(selected_df()$body_part)),
        length(unique(selected_df()$location)))
  )
  
  # Update the maximum value for the numericInput based on max_no_rows().
  observeEvent(input$code, {
    updateNumericInput(session, "rows", max = max_no_rows())
  })
  
  table_rows <- reactive(input$rows - 1)
  
  output$diag <- renderTable(count_top(selected_df(), diag, n = table_rows()), width = "100%")
  
  output$body_part <- renderTable(count_top(selected_df(), body_part, n = table_rows()), width = "100%")
  
  output$location <- renderTable(count_top(selected_df(), location, n = table_rows()), width = "100%")
  
  summary <- reactive(
    selected_df() |>
      dplyr::count(age, sex, wt = weight) |>
      dplyr::left_join(pop, by = c("age", "sex")) |>
      dplyr::mutate(rate = n/population * 1e4)
  )
  
  output$age_sex <- renderPlot({
    p <- if(input$y == "count"){
      summary() |>
        ggplot2::ggplot(ggplot2::aes(age, n, color = sex)) +
        ggplot2::geom_line() +
        ggplot2::labs(y = "Estimated number of injuries")
    }
    else{
      summary() |>
        ggplot2::ggplot(ggplot2::aes(age, rate, color = sex)) +
        ggplot2::geom_line(na.rm = TRUE) +
        ggplot2::labs(y = "Injuries per 10,000 people")
    }
     p +
      ggplot2::theme_minimal() +
      viridis::scale_color_viridis(discrete = TRUE)
  }, res = 96)
  
  # Store the maximum possible number of stories.
  max_no_stories <- reactive(length(selected_df()$narrative))
  
  # Reactive used to save the current position in the narrative list.
  story <- reactiveVal(1)
  
  # Reset the story counter if the user changes the product code. 
  observeEvent(input$code, story(1))
  
  # When the user clicks "Next story", increase the current position in the
  # narrative but never go beyond the interval [1, length of the narrative].
  # Note that the mod function (%%) is keeping `current`` within this interval.
  observeEvent(input$next_story, {
    story((story() %% max_no_stories()) + 1)
  })
  
  # When the user clicks "Previous story" decrease the current position in the
  # narrative. Note that we also take advantage of the mod function.
  observeEvent(input$prev_story, {
    story(((story() - 2) %% max_no_stories()) + 1)
  })
  
  narrative_sample <- eventReactive(
    list(input$story, selected_df()),
    selected_df() |> dplyr::pull(narrative) |> sample(1)
  )
  output$narrative <- renderText(
    selected_df()$narrative[story()]
  )
}

shinyApp(ui, server)