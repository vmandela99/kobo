library(shiny)
library(dplyr)
library(ggplot2)
library(shinycssloaders)
library(KoboconnectR)
source("modules/filters_module.R")
source("modules/plot_module.R")


# -------------------------------
# UI
# -------------------------------
ui <- fluidPage(
  titlePanel("Cohort Dashboard"),
  sidebarLayout(
    sidebarPanel(
      filterUI("filters")
    ),
    mainPanel(
      plotUI("plots")
    )
  )
)


textOutput("loading_status")

# Define the reactivePoll within the server function
server <- function(input, output, session) {
  
  # Reactive polling every 20 minutes
  poll_data <- reactivePoll(
    intervalMillis = 1200000,  # 20 minutes
    session = session,
    checkFunc = function() {
      # Use the current time rounded to the nearest 20 minutes as a proxy
      format(Sys.time(), "%Y-%m-%d %H:%M")
    },
    valueFunc = function() {
      # Fetch data from KoboToolbox
      ai_cohort1 <- kobo_df_download(
        url = "kf.kobotoolbox.org",
        uname = "vickman",
        pwd = "vickman",
        assetid = "akWjF8fLC662zYmYYh6YwR"
      )
      
      # Process the data
      ai_cohort1 %>%
        select(8, 9, 17) %>%
        rename(
          gender = "Your.gender.",
          country = "In.which.country.are.you.currently.located.",
          availability = "What.time.would.you.be.comfortable.having.a.2.hour.session...regardless.of.your.country.of.residence."
        ) %>%
        mutate(
          income = runif(n(), min = 100, max = 1000),
          poverty_index = runif(n(), min = 1, max = 100)
        )
    }
  )
  
  output$loading_status <- renderText({
    "Fetching latest data from KoboToolbox..."
  })
  
  # Use the polled data in your modules
  filtered_data <- filterServer("filters", poll_data)
  plotServer("plots", filtered_data)
}

# Run the app
shinyApp(ui, server)
