# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

# Read the file, select the data
airlines <- read.csv("airlines.csv")
airports  <- read.csv("airports.csv")
flights <- read.csv("flights.csv")

# Look at data
dim(airlines)
dim(airports)
dims(flights)
names(airlines)
names(airports)
names(flights)

# Build the model
fit <- lm(Unique ~ Age + ISCED, data=Ruff1)

# Create data for the plotting grid
plot.ages = seq(40, 75, length=9)
plot.ISCEDs = seq(1,5,length=9)
scores <- outer(X=plot.ages, Y=plot.ISCEDs, function(X,Y) predict(fit, data.frame(Age=X, ISCED=Y)))
z.min = min(scores) # The have the z-value for the 'floor' of the plot

shinyServer(function(input, output) {

  predictedValue <- reactive({
      predict(fit, newdata=data.frame(Age = input$Age, ISCED=as.numeric(input$Education)), type="response")
  })      
    
  # PREDICTED VALUE     
  output$predictedValue <- renderText({
    paste(round(predictedValue()), "is the predicted number of unique designs from the model.")
  })
  
  # PREDICTED INTERQUARTILE RANGE
  output$interquartileRange <- renderText({
    pred_interval <- predict(fit, newdata=data.frame(Age = input$Age, ISCED=as.numeric(input$Education)),
                             interval="prediction", level=0.5)
    paste('The model predicts that 50% of people with this age and education level will produce between',
           round(pred_interval[2]), 'and', round(pred_interval[3]), 'figure designs in total on the test.')
  })
  
  # PLOT
  output$my.plot <- renderPlot({
      pmat <- persp(x=plot.ages, y=plot.ISCEDs,z=scores, d=1.5, theta=25, phi=15, col="lightgreen",
                    xlab="Age", ylab="Education level", zlab="Nr. of unique designs (predicted)",
                    r=4, ticktype="detailed",
                    main="Predicted value shown in a graphical representation of the Linear Model"
                    )
      fittedValue <- predictedValue()
      points(trans3d(x=input$Age, y=as.numeric(input$Education), z=fittedValue, pmat=pmat),
             col="darkgreen", pch=3, lwd=4, cex=1.6)
      
      lines.point1 <- as.data.frame(trans3d(x=input$Age, y=as.numeric(input$Education), z=fittedValue, pmat=pmat))
      lines.point2 <- as.data.frame(trans3d(x=input$Age, y=1, z=fittedValue, pmat=pmat))
      lines.point3 <- as.data.frame(trans3d(x=40, y=1, z=fittedValue, pmat=pmat))
      horizontal.lines <- rbind(lines.point1, lines.point2, lines.point3)
   
      lines.point4 <- as.data.frame(trans3d(x=input$Age, y=1, z=z.min, pmat=pmat))
      vertical.line <- rbind(lines.point2, lines.point4)
       
      lines(x=horizontal.lines, col="darkgreen", lwd=2)
      lines(x=vertical.line, col="darkgreen", lwd=2)

      
  })

})
