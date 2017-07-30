library(shiny)

data <- read.csv("hsb2.csv")
colnames(data)[7] <- "Read"
colnames(data)[9] <- "Math"
colnames(data)[10] <- "Science"

## Define a server for the Shiny app
shinyServer(function(input, output) {
  
  dataInput <- reactive({
    subset(data, select=c(input$subject), subset=(substring(data$gender,1,4) == input$gender))
  })
  
  ## Fill in the spot we created for a plot
  output$plot1 <- renderPlot({
    
    ## Render a barplot
    barplot(dataInput()[,input$subject],
            main=paste(input$subject, "in", input$gender),
            ylab="Subjecy", ylim=c(0,80),
            xlab="Gender")
  })
})
