# -------------------------------
# Module UI: Plots
# -------------------------------
plotUI <- function(id) {
  ns <- NS(id)
  tagList(
    withSpinner(plotOutput(ns("plot1")), type = 6),
    withSpinner(plotOutput(ns("plot2")), type = 6)
  )
}

# -------------------------------
# Module Server: Plots
# -------------------------------
plotServer <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    output$plot1 <- renderPlot({
      data() %>%
        group_by(gender) %>%
        summarise(mean_income = mean(income, na.rm = TRUE)) %>%
        ggplot(aes(x = gender, y = mean_income, fill = gender)) +
        geom_bar(stat = "identity") +
        labs(title = "Average Income by Gender", y = "Mean Income") +
        theme_minimal()
    })
    
    output$plot2 <- renderPlot({
      ggplot(data(), aes(x = income, y = poverty_index, color = country)) +
        geom_point(size = 3, alpha = 0.7) +
        labs(title = "Income vs Poverty Index", x = "Income", y = "Poverty Index") +
        theme_minimal()
    })
  })
}


