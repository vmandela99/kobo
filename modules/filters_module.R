# -------------------------------
# Module UI: Filters
# -------------------------------
filterUI <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("gender_ui")),
    uiOutput(ns("country_ui")),
    uiOutput(ns("availability_ui"))
  )
}

# -------------------------------
# Module Server: Filters
# -------------------------------
filterServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    output$gender_ui <- renderUI({
      selectInput(session$ns("gender"), "Select Gender:", choices = c("All", unique(data()$gender)))
    })
    output$country_ui <- renderUI({
      selectInput(session$ns("country"), "Select Country:", choices = c("All", unique(data()$country)))
    })
    output$availability_ui <- renderUI({
      selectInput(session$ns("availability"), "Select Availability:", choices = c("All", unique(data()$availability)))
    })
    
    reactive({
      df <- data()
      if (input$gender != "All") df <- df %>% filter(gender == input$gender)
      if (input$country != "All") df <- df %>% filter(country == input$country)
      if (input$availability != "All") df <- df %>% filter(availability == input$availability)
      df
    })
  })
}
