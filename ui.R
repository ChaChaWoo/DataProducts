library(shiny)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(
    
    # Give the page a title
    titlePanel("Grades and Gender"),
    
    # Generate a row with a sidebar
    sidebarLayout(
      
      # Define the sidebar with one input
      sidebarPanel(
        selectInput("Subject", "Subject Material is:",
                    choices=c("Math", "Read", "Science")),
        selectInput("Gender", "Gender:",
                    choices=c("Male", "Female")),
        hr(),
        helpText("Data from my renovated house (since 2012).", br(),
                 "Select the subject and gender to get the appropriate bar plot.")),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("plot1")))))
