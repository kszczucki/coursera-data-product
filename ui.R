library(shiny)


shinyUI(fluidPage(
        
        
        titlePanel("GaltonFamilies dataset on Shiny"),
        
        
        sidebarLayout(
                sidebarPanel(
                        helpText("This app will use the GaltonFamilies data to predict the children height
                                 based on it's parents height"),
                        helpText("Please choose the values below:"),
                        
                        sliderInput(inputId = "FatherH",
                                    label = "Father's height (cm.):",
                                    min = 1,
                                    max = 200,
                                    value = 175),
                        
                        sliderInput(inputId = "MotherH",
                                    label = "Mothers's height (cm.):",
                                    min = 1,
                                    max = 200,
                                    value = 162),
                       
                        selectInput(inputId = "Gender",
                                     label = "Child's gender ",
                                     choices = c("Female"="female", "Male"="male")
                                     )
                        ),
                
               
                mainPanel(
                        
                        htmlOutput("MainText"),
                        htmlOutput("prediction"),
                        plotOutput("barsPlot")
                )
        )
        
        
))