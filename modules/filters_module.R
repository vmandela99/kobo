# -------------------------------
# Module UI: Filters
# -------------------------------
filterUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("gender"), "Select Gender:", choices = c("All", unique(filter_cohort$gender))),
    selectInput(ns("country"), "Select Country:", choices = c("All", unique(filter_cohort$country))),
    selectInput(ns("availability"), "Select Availability:", choices = c("All", unique(filter_cohort$availability)))
  )
}

# -------------------------------
# Module Server: Filters
# -------------------------------
filterServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    reactive({
      df <- data()
      if (input$gender != "All") df <- df %>% filter(gender == input$gender)
      if (input$country != "All") df <- df %>% filter(country == input$country)
      if (input$availability != "All") df <- df %>% filter(availability == input$availability)
      df
    })
  })
}
