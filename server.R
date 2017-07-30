# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2) # Data visualization
library(ggvis)
library(gmodels)
library(class)
library(caret)
library(lattice)
library(e1071)

# Read the file, select the data
hsb2 <- read.csv("https://stats.idre.ucla.edu/stat/data/hsb2.csv")

# Build Model to predict math score based on other grades for sceince and reading
fit <- lm(math ~ read + science, data = hsb2)

# Create data for the plotting grid
plot.read = seq(0, 100, length=9)
plot.science = seq(0, 100,length=9)
scores <- outer(X=plot.read, Y=plot.science, function(X,Y) predict(fit, data.frame(read=X, science=Y)))
z.min = min(scores) # The have the z-value for the 'floor' of the plot

shinyServer(function(input, output) {

  predictedValue <- reactive({
      predict(fit, newdata=data.frame(read = input$read, science = input$science, type="response")
  })      
    
  # PREDICTED VALUE     
  output$predictedValue <- renderText({
    paste(round(predictedValue()), "is the predicted math score from the model.")
  })
  
   
  # PLOT
  output$my.plot <- renderPlot({
      pmat <- persp(x=plot.read, y=plot.science ,z=scores, d=1.5, theta=25, phi=15, col="lightgreen",
                    xlab="Reading Score", ylab="Science Score", zlab="Math Score",
                    r=4, ticktype="detailed",
                    main="Predicted value shown in a graphical representation of the Linear Model"
                    )
      fittedValue <- predictedValue()
      points(trans3d(x=input$read, y=input$science, z=fittedValue, pmat=pmat),
             col="darkgreen", pch=3, lwd=4, cex=1.6)
      
      lines.point1 <- as.data.frame(trans3d(x=input$read, y=input$science, z=fittedValue, pmat=pmat))
      lines.point2 <- as.data.frame(trans3d(x=input$read, y=1, z=fittedValue, pmat=pmat))
      lines.point3 <- as.data.frame(trans3d(x=40, y=1, z=fittedValue, pmat=pmat))
      horizontal.lines <- rbind(lines.point1, lines.point2, lines.point3)
   
      lines.point4 <- as.data.frame(trans3d(x=input$Age, y=1, z=z.min, pmat=pmat))
      vertical.line <- rbind(lines.point2, lines.point4)
       
      lines(x=horizontal.lines, col="darkgreen", lwd=2)
      lines(x=vertical.line, col="darkgreen", lwd=2)

      
  })

})
