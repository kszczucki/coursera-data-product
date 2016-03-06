library(shiny)
library(HistData)
library(dplyr)
library(ggplot2)

# convert from inches to cm
dataset <- GaltonFamilies
dataset <- dataset %>% mutate(father=father*2.54,
                    mother=mother*2.54,
                    childHeight=childHeight*2.54)

# use a reasonably simple linear model
modFit <- lm(childHeight ~ father + mother + gender, data=dataset)

shinyServer(function(input, output) {
        
        output$MainText <- renderText({
                paste("You have entered: Father's height:",strong(round(input$FatherH, 1)),
                      "cm, Mother's height",strong(round(input$MotherH, 1)),
                      "cm and child's gender:",strong(input$Gender))
        })
        
        output$prediction <- renderText({
                dataf <- data.frame(father=input$FatherH,
                                 mother=input$MotherH,
                                 gender=factor(input$Gender, levels=levels(dataset$gender)))
                model <- predict(modFit, newdata=dataf)
                
                if(input$Gender=="female")({
                        paste0("Girl's predicted height would be around:",
                              strong(round(model, 1)))
                })
                
                else if(input$Gender=="male")({
                        paste("Boy's predicted height would be around:",
                              strong(round(model, 1)))
                })
                
        })
        output$barsPlot <- renderPlot({
                chGender <- ifelse(
                        input$Gender=="female","Girl","Boy"
                )
                dataf <- data.frame(father=input$FatherH,
                                 mother=input$MotherH,
                                 gender=factor(input$Gender, levels=levels(dataset$gender)))
                model <- predict(modFit, newdata=dataf)
                types <- c("Father", "Mother", chGender)
                dataf <- data.frame(
                        x = factor(types, levels = types, ordered = TRUE),
                        y = c(input$FatherH, input$MotherH,model)
                        
                )
                 ggplot(dataf, aes(x=x, y=y)) +
                        geom_bar(stat="identity", alpha = .8, 
                                 fill = c("navyblue","plum2","darkgreen"), colour = "black") +
                        xlab("") +
                        ylab("Height (cm)") + 
                        scale_y_continuous(breaks = seq(from = 1, to = 200, by = 20)) +
                        theme(
                                axis.text = element_text(size = 14),
                                plot.title = element_text(size = rel(1.8)), 
                                panel.grid.major = element_line(colour = "grey40"),
                                panel.grid.minor = element_blank(),
                                panel.background = element_rect(fill = "white"),
                                legend.position="none",
                                legend.title=element_blank()
                        )
        })
})