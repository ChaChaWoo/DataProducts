# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  titlePanel("Flight Delays"),

  sidebarLayout(

    mainPanel(
      tabsetPanel(
        type = 'pills',
        id = 'activePanel',
        tabPanel(title="Documentation", value='Documentation',
          h4("Description of the model"),     
          p("This model predicts what spicies an iris is."),
          h4("Usage"),
          tags$ul(
            tags$li("Select an Age with the slider and one of five education levels with
                     the Radio buttons."),
            tags$li("The ", em("estimated"), "number of Unique figures that a person with the
                     selected Age and Education Level will produce on the test, will
                     be shown on the ", tags$b("Application"), " Tab. So please click on the
                     Application Tab when you are ready to start using the App."),
            tags$li("When you first open the Application Tab, please be patient for a few seconds ",
                    "for the application to initialize.")
          ),
          h4("Reactivity"),
          p("When viewing the Application Tab, you can slide the Age Slider and/or
             select a different Education Level. The result on the Application Page will
             be updated automatically ('reactively')."),
          h4("Plot"),
          p("The 3D plot shows the linear model (used the make the prediction) as a 2-dimensional plane
             in 3D space. This way, you can view graphically how the predication is made.
             The dimensions (axes) are Age (40-75) and Education Level (1-5). The place on the
             plane corresponding to the Age and Education Level is connected to the predicted value,
            which is shown on the vertical axis."
          )
        ),
        tabPanel(title="Application", value='Application',
          h4("Estimated Number of Unique Designs"),
            textOutput("predictedValue"),
          h4("Interquartile Range for this Age and Education Level"),
            p(textOutput("interquartileRange")),
            plotOutput("my.plot")
        ),
        tabPanel(title="Citations & small print", value='Citation',
          h4('Dataset source'),
          p("The dataset used for building the model can be found at the following
             location:", a(href="http://dx.doi.org/10.5061/dryad.rr138/1",
                           "http://dx.doi.org/10.5061/dryad.rr138/1")),
          p(em("Izaks GJ, Joosten H, Koerts J, Gansevoort RT, Slaets JP(2011)
            Data from: Reference data for the Ruff Figural Fluency Test stratified
            by age and educational level. Dryad Digital Repository.")),
          h4('Citation of Original Publication'),
          p('The original article is available from an Open Access journal:'),
          p(em('Izaks GJ, Joosten H, Koerts J, Gansevoort RT, Slaets JP (2011)
             Reference data for the Ruff Figural Fluency Test stratified by age and educational level.
            PLoS ONE 6(2): e17045.'),
            a(href="http://dx.doi.org/10.1371/journal.pone.0017045",
                   "http://dx.doi.org/10.1371/journal.pone.0017045"))
        )
      )
    ),
    sidebarPanel(
        conditionalPanel(
          condition = 'input.activePanel == "Documentation" | input.activePanel == "Application"',
          h4("Age and education level:"), 
          sliderInput("Age",
                      "Age:",
                      min = 40,
                      max = 75,
                      value = 45),
          radioButtons("Education",
                       label = "Education Level",
                       choices = list("1. Primary (/1st stage Basic)" = 1,
                                      "2. Lower Secondary (/2nd stage Basic)" = 2, 
                                      "3. Upper Secondary / High School" = 3, 
                                      "4. Post-secondary (vocational)" = 4, 
                                      "5. Higher (Tertiary) Education" = 5),
                       selected = 3)
        )
        ,
        conditionalPanel(
          condition = 'input.activePanel == "Citation"',
          h4("Shiny App"),
          p("This Shiny App was made as a student project for the Data Science Specialization,
             co-branded by Johns Hopkins University / Coursera."),
          p("Although serious effort was made to make
             a good Shiny App, the App has not been clinically validated and should not be used for any
             (clinical) purposes."),
          p(tags$small("The Shiny App is provided 'AS IS', without warranty of any kind,
                        express or implied, including but not limited to the warranties of merchantability,
                        fitness for a particular purpose and noninfringement. In no event shall
                        the author be liable for any claim, damages or other liability,
                        whether in an action of contract, tort or ortherise, arising from, out of
                        or in connection with the software or the use or other dealings in the software."))
        )
    )
  )    
))
