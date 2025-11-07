

# Shiny 앱 코드
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(palmerpenguins)
library(ggridges)
library(viridis)
library(shinythemes)

# UI 정의
ui <- fluidPage(
  theme = shinytheme("flatly"),
  
  titlePanel("Data Visualization in R Using ggplot2 & Friends"),
  
  sidebarLayout(
    sidebarPanel(
      h4("그래프 선택"),
      selectInput("plot_type", 
                  "시각화 유형 선택:",
                  choices = c(
                    "1. Stacked Bar Chart" = "plot1",
                    "2. Box Plot with Points" = "plot2",
                    "3. Overlapping Histograms" = "plot3",
                    "4. Density Plot by Bathrooms" = "plot4",
                    "5. Violin Plot" = "plot5",
                    "6. Species Histogram" = "plot6",
                    "7. Heatmap" = "plot7",
                    "8. Box Plot by Gender" = "plot8",
                    "9. Density Ridge Plot" = "plot9",
                    "10. Scatter Plot with Labels" = "plot10",
                    "11. Violin Plot Multi" = "plot11",
                    "12. Donut Chart" = "plot12",
                    "13. All Plots Grid" = "all"
                  ),
                  selected = "plot1"),
      
      hr(),
      
      h4("정보"),
      p("이 대시보드는 ggplot2와 관련 패키지를 사용하여"),
      p("다양한 데이터 시각화 기법을 보여줍니다."),
      
      hr(),
      
      h5("데이터 소스:"),
      tags$ul(
        tags$li("Palmer Penguins 데이터셋"),
        tags$li("시뮬레이션 주택 가격 데이터"),
        tags$li("시뮬레이션 Netflix 장르 데이터")
      )
    ),
    
    mainPanel(
      plotOutput("selected_plot", height = "700px")
    )
  )
)

# Server 정의
server <- function(input, output) {
  
  # 데이터 준비
  data("penguins")
  
  # 주택 가격 데이터
  set.seed(123)
  house_data <- data.frame(
    city = rep(c("A", "B", "C"), each = 300),
    price = c(rnorm(300, 1500000, 400000),
              rnorm(300, 2000000, 500000),
              rnorm(300, 1800000, 450000)),
    bathrooms = sample(1:4, 900, replace = TRUE)
  )
  
  # Netflix 데이터
  netflix_data <- data.frame(
    genre = c("action", "crime", "drama", "comedy", "documentary", "reality"),
    count = c(1027, 1526, 3190, 235, 410, 695)
  ) %>%
    mutate(fraction = count / sum(count),
           ymax = cumsum(fraction),
           ymin = c(0, head(ymax, n = -1)),
           labelPosition = (ymax + ymin) / 2)
  
  # 히트맵 데이터
  set.seed(123)
  heatmap_data <- expand.grid(
    location = paste0("Loc", 1:50),
    price_range = paste0("$", seq(0, 5000, 100))
  ) %>%
    mutate(count = rpois(n(), lambda = 20))
  
  # Ridge plot 데이터
  ridge_data <- data.frame(
    group = rep(c("low", "mid", "high"), each = 500),
    weight = c(rnorm(500, 4, 0.5),
               rnorm(500, 5, 0.6),
               rnorm(500, 5.5, 0.4))
  )
  
  # Scatter 데이터
  set.seed(123)
  scatter_data <- data.frame(
    x = rnorm(30, 0, 1),
    y = rnorm(30, 0, 1),
    group = sample(c("Label A", "Label B", "Label C"), 30, replace = TRUE),
    label = paste0("p", 1:30)
  )
  
  # 그래프 생성 함수들
  make_plot1 <- function() {
    penguin_summary <- penguins %>%
      filter(!is.na(sex) & !is.na(species)) %>%
      count(species, sex)
    
    ggplot(penguin_summary, aes(x = species, y = n, fill = sex)) +
      geom_bar(stat = "identity", position = "stack") +
      geom_text(aes(label = n), position = position_stack(vjust = 0.5), 
                color = "white", size = 4, fontface = "bold") +
      scale_fill_manual(values = c("female" = "#E69F00", "male" = "#56B4E9")) +
      labs(title = "Penguin Count by Species and Sex",
           x = "Species", y = "Count") +
      theme_minimal(base_size = 14) +
      theme(legend.position = "right",
            plot.title = element_text(face = "bold", size = 16))
  }
  
  make_plot2 <- function() {
    ggplot(penguins %>% filter(!is.na(body_mass_g)), 
           aes(x = species, y = body_mass_g, fill = species)) +
      geom_boxplot(alpha = 0.7, outlier.shape = NA) +
      geom_jitter(width = 0.2, alpha = 0.3, size = 1.5) +
      scale_fill_manual(values = c("Adelie" = "#F8766D", 
                                   "Chinstrap" = "#00BA38", 
                                   "Gentoo" = "#619CFF")) +
      labs(title = "Distribution of Penguin Body Mass by Species",
           x = "Species", y = "Body Mass (g)") +
      theme_minimal(base_size = 14) +
      theme(legend.position = "none",
            plot.title = element_text(face = "bold", size = 16))
  }
  
  make_plot3 <- function() {
    ggplot(house_data, aes(x = price, fill = city)) +
      geom_histogram(alpha = 0.6, bins = 30, position = "identity") +
      scale_fill_manual(values = c("A" = "#FF6B6B", 
                                   "B" = "#4ECDC4", 
                                   "C" = "#95E1D3")) +
      scale_x_continuous(labels = scales::comma) +
      labs(title = "American House Prices in Big Cities",
           x = "Price (USD)", y = "Count") +
      theme_minimal(base_size = 14) +
      theme(legend.title = element_blank(),
            plot.title = element_text(face = "bold", size = 16))
  }
  
  make_plot4 <- function() {
    ggplot(house_data, aes(x = price, color = factor(bathrooms))) +
      geom_density(size = 1.2) +
      scale_color_viridis_d(name = "Bathrooms") +
      scale_x_continuous(labels = scales::comma) +
      labs(title = "House Prices - Density Plot by Number of Bathrooms",
           x = "Price (USD)", y = "Density") +
      theme_minimal(base_size = 14) +
      theme(plot.title = element_text(face = "bold", size = 16))
  }
  
  make_plot5 <- function() {
    ggplot(penguins %>% filter(!is.na(flipper_length_mm)), 
           aes(x = species, y = flipper_length_mm, fill = species)) +
      geom_violin(alpha = 0.8) +
      geom_boxplot(width = 0.1, fill = "white", alpha = 0.8) +
      scale_fill_manual(values = c("Adelie" = "#FF6B6B", 
                                   "Chinstrap" = "#4ECDC4", 
                                   "Gentoo" = "#95E1D3")) +
      labs(title = "Flipper Length Distribution by Species",
           x = "Species", y = "Flipper Length (mm)") +
      theme_minimal(base_size = 14) +
      theme(legend.position = "none",
            plot.title = element_text(face = "bold", size = 16))
  }
  
  make_plot6 <- function() {
    ggplot(penguins %>% filter(!is.na(body_mass_g)), 
           aes(x = body_mass_g, fill = species)) +
      geom_histogram(alpha = 0.6, bins = 20, position = "identity") +
      scale_fill_manual(values = c("Adelie" = "#FFB6C1", 
                                   "Chinstrap" = "#87CEEB", 
                                   "Gentoo" = "#98D8C8")) +
      labs(title = "Distribution of Penguin Body Mass by Species",
           x = "Body Mass (g)", y = "Frequency") +
      theme_minimal(base_size = 14) +
      theme(legend.position = "top",
            plot.title = element_text(face = "bold", size = 16))
  }
  
  make_plot7 <- function() {
    ggplot(heatmap_data, aes(x = price_range, y = location, fill = count)) +
      geom_tile() +
      scale_fill_gradientn(colors = c("green", "yellow", "orange", "red"),
                           name = "Count") +
      labs(title = "House Prices Heatmap",
           x = "Price Range", y = "Location") +
      theme_minimal(base_size = 12) +
      theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 6),
            axis.text.y = element_text(size = 6),
            plot.title = element_text(face = "bold", size = 16))
  }
  
  make_plot8 <- function() {
    ggplot(penguins %>% filter(!is.na(sex) & !is.na(flipper_length_mm)), 
           aes(x = species, y = flipper_length_mm, fill = sex)) +
      geom_boxplot(alpha = 0.7) +
      scale_fill_manual(values = c("female" = "#FF69B4", "male" = "#4682B4")) +
      labs(title = "Flipper Length by Species and Gender",
           x = "Species", y = "Flipper Length (mm)") +
      theme_minimal(base_size = 14) +
      theme(legend.title = element_text(face = "bold"),
            plot.title = element_text(face = "bold", size = 16))
  }
  
  make_plot9 <- function() {
    ggplot(ridge_data, aes(x = weight, y = group, fill = group)) +
      geom_density_ridges(alpha = 0.7) +
      scale_fill_manual(values = c("low" = "#8B7D6B", 
                                   "mid" = "#D2B48C", 
                                   "high" = "#F4A460")) +
      labs(title = "Density Ridge Plot by Group",
           x = "Weight", y = "Group") +
      theme_minimal(base_size = 14) +
      theme(legend.position = "none",
            plot.title = element_text(face = "bold", size = 16))
  }
  
  make_plot10 <- function() {
    ggplot(scatter_data, aes(x = x, y = y, color = group)) +
      geom_point(size = 4) +
      geom_text(aes(label = label), vjust = -0.8, size = 3, show.legend = FALSE) +
      scale_color_manual(values = c("Label A" = "#E74C3C", 
                                    "Label B" = "#3498DB", 
                                    "Label C" = "#2ECC71")) +
      labs(title = "Scatter Plot with Labels",
           x = "X Variable", y = "Y Variable") +
      theme_minimal(base_size = 14) +
      theme(plot.title = element_text(face = "bold", size = 16))
  }
  
  make_plot11 <- function() {
    violin_data <- penguins %>%
      filter(!is.na(bill_length_mm) & !is.na(species)) %>%
      mutate(season = sample(c("p=1991", "p=2007", "p=2008", "p=2009"), 
                             n(), replace = TRUE))
    
    ggplot(violin_data, 
           aes(x = season, y = bill_length_mm, fill = species)) +
      geom_violin(alpha = 0.7, position = position_dodge(0.8)) +
      geom_boxplot(width = 0.1, position = position_dodge(0.8), alpha = 0.5) +
      scale_fill_viridis_d() +
      labs(title = "Bill Length Distribution Across Seasons",
           x = "Season", y = "Bill Length (mm)") +
      theme_minimal(base_size = 14) +
      theme(plot.title = element_text(face = "bold", size = 16))
  }
  
  make_plot12 <- function() {
    ggplot(netflix_data, aes(ymax = ymax, ymin = ymin, 
                             xmax = 4, xmin = 3, fill = genre)) +
      geom_rect() +
      geom_text(x = 3.5, aes(y = labelPosition, label = count), 
                size = 4, fontface = "bold") +
      scale_fill_manual(values = c("action" = "#4ECDC4", "crime" = "#FF6B6B",
                                   "drama" = "#95E1D3", "comedy" = "#FFD93D",
                                   "documentary" = "#FFA07A", "reality" = "#DDA0DD")) +
      coord_polar(theta = "y") +
      xlim(c(2, 4)) +
      labs(title = "Genre Distribution - Netflix Movies & TV Shows") +
      theme_void(base_size = 14) +
      theme(legend.position = "right",
            plot.title = element_text(hjust = 0.5, face = "bold", size = 16))
  }
  
  # 출력 렌더링
  output$selected_plot <- renderPlot({
    switch(input$plot_type,
           "plot1" = make_plot1(),
           "plot2" = make_plot2(),
           "plot3" = make_plot3(),
           "plot4" = make_plot4(),
           "plot5" = make_plot5(),
           "plot6" = make_plot6(),
           "plot7" = make_plot7(),
           "plot8" = make_plot8(),
           "plot9" = make_plot9(),
           "plot10" = make_plot10(),
           "plot11" = make_plot11(),
           "plot12" = make_plot12(),
           "all" = {
             # patchwork을 사용한 그리드 레이아웃
             library(patchwork)
             (make_plot1() | make_plot2() | make_plot3()) /
               (make_plot4() | make_plot5() | make_plot6()) /
               (make_plot8() | make_plot9() | make_plot12())
           })
  })
}

# 앱 실행
shinyApp(ui = ui, server = server)
