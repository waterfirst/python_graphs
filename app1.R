# app.R - 최종 완성 버전
# 필요한 패키지 자동 설치 및 로드
packages <- c("shiny", "ggplot2", "dplyr", "tidyr", "palmerpenguins", 
              "ggridges", "viridis", "shinythemes", "patchwork", 
              "scales", "DT")

install_if_missing <- function(packages) {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg, dependencies = TRUE)
      library(pkg, character.only = TRUE)
    }
  }
}

install_if_missing(packages)

# ============================================
# UI 정의
# ============================================
ui <- navbarPage(
  title = div(
    style = "display: inline-block;",
    icon("chart-bar"),
    "ggplot2 Visualization Gallery"
  ),
  theme = shinytheme("cosmo"),
  
  # CSS 스타일 추가
  tags$head(
    tags$style(HTML("
      .navbar-brand {
        font-size: 24px;
        font-weight: bold;
      }
      .well {
        background-color: #f8f9fa;
      }
      h3 {
        color: #2c3e50;
        font-weight: 600;
        margin-bottom: 20px;
      }
      .info-box {
        background-color: #e8f4f8;
        border-left: 4px solid #3498db;
        padding: 15px;
        margin: 10px 0;
        border-radius: 4px;
      }
    "))
  ),
  
  # ========== 탭 1: 홈 & 대시보드 ==========
  tabPanel(
    "Dashboard",
    icon = icon("home"),
    
    fluidRow(
      column(12,
             div(class = "info-box",
                 h2("Welcome to ggplot2 Visualization Gallery"),
                 p("이 대시보드는 R의 ggplot2 패키지와 관련 도구들을 사용한 다양한 데이터 시각화 예제를 제공합니다."),
                 p(strong("사용 방법:"), "상단 메뉴에서 원하는 차트 카테고리를 선택하여 다양한 시각화를 탐색하세요.")
             )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(3,
             div(class = "well",
                 h4(icon("chart-bar"), "Basic Charts"),
                 p("막대그래프, 박스플롯 등 기본적인 시각화"),
                 actionButton("goto_basic", "보러가기", 
                              class = "btn-primary btn-block")
             )
      ),
      column(3,
             div(class = "well",
                 h4(icon("chart-area"), "Distributions"),
                 p("분포도, 바이올린 플롯 등"),
                 actionButton("goto_dist", "보러가기", 
                              class = "btn-info btn-block")
             )
      ),
      column(3,
             div(class = "well",
                 h4(icon("fire"), "Advanced"),
                 p("히트맵, 고급 시각화 기법"),
                 actionButton("goto_adv", "보러가기", 
                              class = "btn-success btn-block")
             )
      ),
      column(3,
             div(class = "well",
                 h4(icon("sliders"), "Interactive"),
                 p("커스터마이징 가능한 인터랙티브 차트"),
                 actionButton("goto_inter", "보러가기", 
                              class = "btn-warning btn-block")
             )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(6,
             wellPanel(
               h4("Quick Stats - Penguins Dataset"),
               verbatimTextOutput("quick_stats_penguins")
             )
      ),
      column(6,
             wellPanel(
               h4("Quick Stats - House Prices"),
               verbatimTextOutput("quick_stats_houses")
             )
      )
    )
  ),
  
  # ========== 탭 2: 기본 차트 ==========
  tabPanel(
    "Basic Charts",
    icon = icon("chart-bar"),
    
    fluidRow(
      column(6,
             wellPanel(
               h3(icon("layer-group"), "Stacked Bar Chart"),
               plotOutput("plot1", height = "400px"),
               hr(),
               p(class = "text-muted", 
                 "펭귄 종과 성별에 따른 개체 수를 보여주는 적층 막대 그래프")
             )
      ),
      column(6,
             wellPanel(
               h3(icon("box"), "Box Plot with Points"),
               plotOutput("plot2", height = "400px"),
               hr(),
               p(class = "text-muted", 
                 "종별 체중 분포를 박스플롯과 개별 데이터 포인트로 표현")
             )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(6,
             wellPanel(
               h3(icon("chart-column"), "Overlapping Histograms"),
               plotOutput("plot3", height = "400px"),
               hr(),
               p(class = "text-muted", 
                 "도시별 주택 가격 분포를 겹쳐서 비교")
             )
      ),
      column(6,
             wellPanel(
               h3(icon("wave-square"), "Density Plot"),
               plotOutput("plot4", height = "400px"),
               hr(),
               p(class = "text-muted", 
                 "욕실 개수에 따른 주택 가격 밀도 분포")
             )
      )
    )
  ),
  
  # ========== 탭 3: 분포 시각화 ==========
  tabPanel(
    "Distribution Plots",
    icon = icon("chart-area"),
    
    fluidRow(
      column(6,
             wellPanel(
               h3(icon("music"), "Violin Plot"),
               plotOutput("plot5", height = "400px"),
               hr(),
               p(class = "text-muted", 
                 "종별 날개 길이 분포를 바이올린 형태로 표현")
             )
      ),
      column(6,
             wellPanel(
               h3(icon("chart-simple"), "Species Histogram"),
               plotOutput("plot6", height = "400px"),
               hr(),
               p(class = "text-muted", 
                 "펭귄 종별 체중 분포 히스토그램")
             )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(6,
             wellPanel(
               h3(icon("mountain"), "Density Ridge Plot"),
               plotOutput("plot9", height = "400px"),
               hr(),
               p(class = "text-muted", 
                 "그룹별 가중치 분포를 리지 형태로 시각화")
             )
      ),
      column(6,
             wellPanel(
               h3(icon("guitar"), "Multi Violin Plot"),
               plotOutput("plot11", height = "400px"),
               hr(),
               p(class = "text-muted", 
                 "시즌과 종에 따른 부리 길이 분포")
             )
      )
    )
  ),
  
  # ========== 탭 4: 고급 시각화 ==========
  tabPanel(
    "Advanced Charts",
    icon = icon("fire"),
    
    fluidRow(
      column(12,
             wellPanel(
               h3(icon("table-cells"), "Heatmap"),
               plotOutput("plot7", height = "550px"),
               hr(),
               p(class = "text-muted", 
                 "위치와 가격대별 주택 분포를 색상으로 표현한 히트맵")
             )
      )
    ),
    
    hr(),
    
    fluidRow(
      column(6,
             wellPanel(
               h3(icon("venus-mars"), "Box Plot by Gender"),
               plotOutput("plot8", height = "400px"),
               hr(),
               p(class = "text-muted", 
                 "종과 성별에 따른 날개 길이 비교")
             )
      ),
      column(6,
             wellPanel(
               h3(icon("circle-nodes"), "Scatter Plot with Labels"),
               plotOutput("plot10", height = "400px"),
               hr(),
               p(class = "text-muted", 
                 "라벨이 있는 산점도 - 그룹별 분포 시각화")
             )
      )
    )
  ),
  
  # ========== 탭 5: 특수 차트 ==========
  tabPanel(
    "Special Charts",
    icon = icon("pizza-slice"),
    
    fluidRow(
      column(12, align = "center",
             wellPanel(
               h3(icon("circle-notch"), "Donut Chart - Netflix Genre Distribution"),
               plotOutput("plot12", height = "600px", width = "100%"),
               hr(),
               p(class = "text-muted", 
                 "Netflix 콘텐츠의 장르별 분포를 도넛 차트로 표현")
             )
      )
    )
  ),
  
  # ========== 탭 6: 전체 보기 ==========
  tabPanel(
    "All Charts Grid",
    icon = icon("th"),
    
    fluidRow(
      column(12,
             wellPanel(
               h3(icon("grip"), "Complete Visualization Gallery"),
               p("모든 시각화를 한눈에 보기"),
               plotOutput("all_plots", height = "1400px")
             )
      )
    )
  ),
  
  # ========== 탭 7: 인터랙티브 ==========
  tabPanel(
    "Interactive",
    icon = icon("sliders"),
    
    sidebarLayout(
      sidebarPanel(
        width = 3,
        
        h4(icon("gears"), "커스터마이징 옵션"),
        
        hr(),
        
        # 펭귄 필터
        selectInput("species_filter", 
                    label = tags$b("펭귄 종 선택:"),
                    choices = c("All", "Adelie", "Chinstrap", "Gentoo"),
                    selected = "All"),
        
        # 가격 범위
        sliderInput("price_range",
                    label = tags$b("주택 가격 범위 (USD):"),
                    min = 500000,
                    max = 3500000,
                    value = c(500000, 3500000),
                    step = 100000,
                    pre = "$",
                    sep = ","),
        
        # 테마 선택
        selectInput("chart_theme",
                    label = tags$b("테마 선택:"),
                    choices = c("minimal" = "minimal", 
                                "classic" = "classic", 
                                "dark" = "dark", 
                                "light" = "light"),
                    selected = "minimal"),
        
        # 포인트 표시
        checkboxInput("show_points",
                      label = tags$b("데이터 포인트 표시"),
                      value = TRUE),
        
        hr(),
        
        # 새로고침 버튼
        actionButton("refresh", 
                     label = "새로고침", 
                     icon = icon("rotate"),
                     class = "btn-primary btn-block"),
        
        hr(),
        
        # 다운로드 버튼
        downloadButton("download_plot", "플롯 다운로드"),
        br(), br(),
        downloadButton("download_data", "데이터 다운로드")
      ),
      
      mainPanel(
        width = 9,
        
        tabsetPanel(
          tabPanel(
            "Penguin Analysis",
            icon = icon("dove"),
            br(),
            plotOutput("interactive_plot1", height = "500px")
          ),
          
          tabPanel(
            "House Prices",
            icon = icon("house"),
            br(),
            plotOutput("interactive_plot2", height = "500px")
          ),
          
          tabPanel(
            "Summary Stats",
            icon = icon("table"),
            br(),
            verbatimTextOutput("summary_stats")
          ),
          
          tabPanel(
            "Data Table",
            icon = icon("table-list"),
            br(),
            h4("Penguins Dataset (필터링됨)"),
            DT::dataTableOutput("penguin_table"),
            hr(),
            h4("House Prices Dataset (필터링됨)"),
            DT::dataTableOutput("house_table")
          )
        )
      )
    )
  ),
  
  # ========== 탭 8: 정보 ==========
  tabPanel(
    "About",
    icon = icon("circle-info"),
    
    fluidRow(
      column(12,
             wellPanel(
               h2(icon("book"), "Data Visualization Gallery"),
               hr(),
               
               h4("📦 사용된 패키지:"),
               tags$div(
                 style = "padding-left: 20px;",
                 tags$ul(
                   tags$li(tags$b("ggplot2:"), " 핵심 그래픽 시스템 - 모든 시각화의 기반"),
                   tags$li(tags$b("dplyr & tidyr:"), " 데이터 조작 및 정리"),
                   tags$li(tags$b("palmerpenguins:"), " 펭귄 데이터셋 제공"),
                   tags$li(tags$b("ggridges:"), " 리지 플롯 생성"),
                   tags$li(tags$b("viridis:"), " 색각 이상자 친화적 색상 팔레트"),
                   tags$li(tags$b("patchwork:"), " 여러 그래프 조합"),
                   tags$li(tags$b("shiny:"), " 인터랙티브 웹 애플리케이션"),
                   tags$li(tags$b("DT:"), " 인터랙티브 데이터 테이블")
                 )
               ),
               
               hr(),
               
               h4("📊 데이터 소스:"),
               tags$div(
                 style = "padding-left: 20px;",
                 tags$ol(
                   tags$li(tags$b("Palmer Penguins:"), 
                           " 남극 팔머 군도의 펭귄 관측 데이터 (실제 데이터)"),
                   tags$li(tags$b("주택 가격:"), 
                           " 시뮬레이션된 미국 주택 가격 데이터"),
                   tags$li(tags$b("Netflix 장르:"), 
                           " 시뮬레이션된 콘텐츠 장르 분포")
                 )
               ),
               
               hr(),
               
               h4("🎨 주요 시각화 기법:"),
               fluidRow(
                 column(6,
                        tags$ul(
                          tags$li("막대 그래프 (Bar Charts)"),
                          tags$li("박스 플롯 (Box Plots)"),
                          tags$li("히스토그램 (Histograms)"),
                          tags$li("밀도 플롯 (Density Plots)"),
                          tags$li("바이올린 플롯 (Violin Plots)")
                        )
                 ),
                 column(6,
                        tags$ul(
                          tags$li("히트맵 (Heatmaps)"),
                          tags$li("산점도 (Scatter Plots)"),
                          tags$li("도넛 차트 (Donut Charts)"),
                          tags$li("리지 플롯 (Ridge Plots)"),
                          tags$li("인터랙티브 필터링")
                        )
                 )
               ),
               
               hr(),
               
               h4("💡 학습 포인트:"),
               div(class = "info-box",
                   tags$ul(
                     tags$li("ggplot2의 레이어 기반 문법 이해"),
                     tags$li("다양한 geom 함수 활용법"),
                     tags$li("색상 팔레트와 테마 커스터마이징"),
                     tags$li("여러 그래프를 조합하는 방법"),
                     tags$li("Shiny를 통한 인터랙티브 대시보드 구축")
                   )
               ),
               
               hr(),
               
               div(style = "text-align: center; padding: 20px;",
                   h5(icon("r-project"), " Created with R + ggplot2 + Shiny"),
                   p(tags$em("Made for educational purposes")),
                   p(tags$b("Version:"), " 1.0.0 | ", 
                     tags$b("Last Updated:"), " 2025")
               )
             )
      )
    )
  )
)

# ============================================
# SERVER 정의
# ============================================
server <- function(input, output, session) {
  
  # 데이터 준비
  data("penguins")
  
  set.seed(123)
  house_data <- data.frame(
    city = rep(c("A", "B", "C"), each = 300),
    price = c(rnorm(300, 1500000, 400000),
              rnorm(300, 2000000, 500000),
              rnorm(300, 1800000, 450000)),
    bathrooms = sample(1:4, 900, replace = TRUE)
  )
  
  netflix_data <- data.frame(
    genre = c("action", "crime", "drama", "comedy", "documentary", "reality"),
    count = c(1027, 1526, 3190, 235, 410, 695)
  ) %>%
    mutate(fraction = count / sum(count),
           ymax = cumsum(fraction),
           ymin = c(0, head(ymax, n = -1)),
           labelPosition = (ymax + ymin) / 2)
  
  set.seed(123)
  heatmap_data <- expand.grid(
    location = paste0("Loc", 1:50),
    price_range = paste0("$", seq(0, 5000, 100))
  ) %>%
    mutate(count = rpois(n(), lambda = 20))
  
  ridge_data <- data.frame(
    group = rep(c("low", "mid", "high"), each = 500),
    weight = c(rnorm(500, 4, 0.5),
               rnorm(500, 5, 0.6),
               rnorm(500, 5.5, 0.4))
  )
  
  set.seed(123)
  scatter_data <- data.frame(
    x = rnorm(30, 0, 1),
    y = rnorm(30, 0, 1),
    group = sample(c("Label A", "Label B", "Label C"), 30, replace = TRUE),
    label = paste0("p", 1:30)
  )
  
  # 네비게이션 버튼 이벤트
  observeEvent(input$goto_basic, {
    updateNavbarPage(session, inputId = "nav", selected = "Basic Charts")
  })
  
  observeEvent(input$goto_dist, {
    updateNavbarPage(session, inputId = "nav", selected = "Distribution Plots")
  })
  
  observeEvent(input$goto_adv, {
    updateNavbarPage(session, inputId = "nav", selected = "Advanced Charts")
  })
  
  observeEvent(input$goto_inter, {
    updateNavbarPage(session, inputId = "nav", selected = "Interactive")
  })
  
  # Quick Stats
  output$quick_stats_penguins <- renderPrint({
    cat("Total Penguins:", nrow(penguins), "\n")
    cat("Species:\n")
    print(table(penguins$species))
  })
  
  output$quick_stats_houses <- renderPrint({
    cat("Total Houses:", nrow(house_data), "\n")
    cat("Price Range: $", scales::comma(min(house_data$price)), 
        " - $", scales::comma(max(house_data$price)), "\n")
    cat("Mean Price: $", scales::comma(round(mean(house_data$price))), "\n")
  })
  
  # ============================================
  # 그래프 생성 함수들
  # ============================================
  
  make_plot1 <- function() {
    penguin_summary <- penguins %>%
      filter(!is.na(sex) & !is.na(species)) %>%
      count(species, sex)
    
    ggplot(penguin_summary, aes(x = species, y = n, fill = sex)) +
      geom_bar(stat = "identity", position = "stack") +
      geom_text(aes(label = n), position = position_stack(vjust = 0.5), 
                color = "white", size = 5, fontface = "bold") +
      scale_fill_manual(values = c("female" = "#E69F00", "male" = "#56B4E9")) +
      labs(title = "Penguin Count by Species and Sex",
           x = "Species", y = "Count", fill = "Sex") +
      theme_minimal(base_size = 14) +
      theme(
        legend.position = "right",
        plot.title = element_text(face = "bold", hjust = 0.5, size = 16)
      )
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
      theme(
        legend.position = "none",
        plot.title = element_text(face = "bold", hjust = 0.5, size = 16)
      )
  }
  
  make_plot3 <- function() {
    ggplot(house_data, aes(x = price, fill = city)) +
      geom_histogram(alpha = 0.6, bins = 30, position = "identity") +
      scale_fill_manual(values = c("A" = "#FF6B6B", 
                                   "B" = "#4ECDC4", 
                                   "C" = "#95E1D3")) +
      scale_x_continuous(labels = scales::comma) +
      labs(title = "American House Prices in Big Cities",
           x = "Price (USD)", y = "Count", fill = "City") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", hjust = 0.5, size = 16)
      )
  }
  
  make_plot4 <- function() {
    ggplot(house_data, aes(x = price, color = factor(bathrooms))) +
      geom_density(size = 1.2) +
      scale_color_viridis_d(name = "Bathrooms") +
      scale_x_continuous(labels = scales::comma) +
      labs(title = "House Prices - Density Plot by Number of Bathrooms",
           x = "Price (USD)", y = "Density") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", hjust = 0.5, size = 16)
      )
  }
  
  make_plot5 <- function() {
    ggplot(penguins %>% filter(!is.na(flipper_length_mm)), 
           aes(x = species, y = flipper_length_mm, fill = species)) +
      geom_violin(alpha = 0.8, trim = FALSE) +
      geom_boxplot(width = 0.1, fill = "white", alpha = 0.8) +
      scale_fill_manual(values = c("Adelie" = "#FF6B6B", 
                                   "Chinstrap" = "#4ECDC4", 
                                   "Gentoo" = "#95E1D3")) +
      labs(title = "Flipper Length Distribution by Species",
           x = "Species", y = "Flipper Length (mm)") +
      theme_minimal(base_size = 14) +
      theme(
        legend.position = "none",
        plot.title = element_text(face = "bold", hjust = 0.5, size = 16)
      )
  }
  
  make_plot6 <- function() {
    ggplot(penguins %>% filter(!is.na(body_mass_g)), 
           aes(x = body_mass_g, fill = species)) +
      geom_histogram(alpha = 0.6, bins = 20, position = "identity") +
      scale_fill_manual(values = c("Adelie" = "#FFB6C1", 
                                   "Chinstrap" = "#87CEEB", 
                                   "Gentoo" = "#98D8C8"),
                        name = "Species") +
      labs(title = "Distribution of Penguin Body Mass by Species",
           x = "Body Mass (g)", y = "Frequency") +
      theme_minimal(base_size = 14) +
      theme(
        legend.position = "top",
        plot.title = element_text(face = "bold", hjust = 0.5, size = 16)
      )
  }
  
  make_plot7 <- function() {
    ggplot(heatmap_data, aes(x = price_range, y = location, fill = count)) +
      geom_tile(color = "white", size = 0.1) +
      scale_fill_gradientn(colors = c("green", "yellow", "orange", "red"),
                           name = "Count") +
      labs(title = "American House Prices Heatmap by Location",
           x = "Price Range (USD)", y = "Location") +
      theme_minimal(base_size = 12) +
      theme(
        axis.text.x = element_text(angle = 90, hjust = 1, size = 7),
        axis.text.y = element_text(size = 7),
        plot.title = element_text(face = "bold", hjust = 0.5, size = 16)
      )
  }
  
  make_plot8 <- function() {
    ggplot(penguins %>% filter(!is.na(sex) & !is.na(flipper_length_mm)), 
           aes(x = species, y = flipper_length_mm, fill = sex)) +
      geom_boxplot(alpha = 0.7) +
      scale_fill_manual(values = c("female" = "#FF69B4", "male" = "#4682B4"),
                        name = "Gender") +
      labs(title = "Flipper Length by Species and Gender",
           x = "Species", y = "Flipper Length (mm)") +
      theme_minimal(base_size = 14) +
      theme(
        legend.title = element_text(face = "bold"),
        plot.title = element_text(face = "bold", hjust = 0.5, size = 16)
      )
  }
  
  make_plot9 <- function() {
    ggplot(ridge_data, aes(x = weight, y = group, fill = group)) +
      geom_density_ridges(alpha = 0.7, scale = 3) +
      scale_fill_manual(values = c("low" = "#8B7D6B", 
                                   "mid" = "#D2B48C", 
                                   "high" = "#F4A460")) +
      labs(title = "Density Ridge Plot by Group",
           x = "Weight", y = "Group") +
      theme_minimal(base_size = 14) +
      theme(
        legend.position = "none",
        plot.title = element_text(face = "bold", hjust = 0.5, size = 16)
      )
  }
  
  make_plot10 <- function() {
    ggplot(scatter_data, aes(x = x, y = y, color = group)) +
      geom_point(size = 4, alpha = 0.7) +
      geom_text(aes(label = label), vjust = -0.8, size = 3, show.legend = FALSE) +
      scale_color_manual(values = c("Label A" = "#E74C3C", 
                                    "Label B" = "#3498DB", 
                                    "Label C" = "#2ECC71"),
                         name = "Group") +
      labs(title = "Scatter Plot with Labels",
           x = "X Variable", y = "Y Variable") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", hjust = 0.5, size = 16)
      )
  }
  
  make_plot11 <- function() {
    violin_data <- penguins %>%
      filter(!is.na(bill_length_mm) & !is.na(species)) %>%
      mutate(season = sample(c("p=1991", "p=2007", "p=2008", "p=2009"), 
                             n(), replace = TRUE))
    
    ggplot(violin_data, 
           aes(x = season, y = bill_length_mm, fill = species)) +
      geom_violin(alpha = 0.7, position = position_dodge(0.8), trim = FALSE) +
      geom_boxplot(width = 0.1, position = position_dodge(0.8), alpha = 0.5) +
      scale_fill_viridis_d(name = "Species") +
      labs(title = "Bill Length Distribution Across Seasons",
           x = "Season", y = "Bill Length (mm)") +
      theme_minimal(base_size = 14) +
      theme(
        plot.title = element_text(face = "bold", hjust = 0.5, size = 16)
      )
  }
  
  make_plot12 <- function() {
    ggplot(netflix_data, aes(ymax = ymax, ymin = ymin, 
                             xmax = 4, xmin = 3, fill = genre)) +
      geom_rect(color = "white", size = 0.5) +
      geom_text(x = 3.5, aes(y = labelPosition, label = count), 
                size = 6, fontface = "bold", color = "white") +
      scale_fill_manual(values = c("action" = "#4ECDC4", 
                                   "crime" = "#FF6B6B",
                                   "drama" = "#95E1D3", 
                                   "comedy" = "#FFD93D",
                                   "documentary" = "#FFA07A", 
                                   "reality" = "#DDA0DD"),
                        name = "Genre") +
      coord_polar(theta = "y") +
      xlim(c(2, 4)) +
      labs(title = "Genre Distribution - Netflix Movies & TV Shows") +
      theme_void(base_size = 14) +
      theme(
        legend.position = "right",
        plot.title = element_text(hjust = 0.5, face = "bold", size = 18)
      )
  }
  
  # ============================================
  # 정적 플롯 출력
  # ============================================
  
  output$plot1 <- renderPlot({ make_plot1() })
  output$plot2 <- renderPlot({ make_plot2() })
  output$plot3 <- renderPlot({ make_plot3() })
  output$plot4 <- renderPlot({ make_plot4() })
  output$plot5 <- renderPlot({ make_plot5() })
  output$plot6 <- renderPlot({ make_plot6() })
  output$plot7 <- renderPlot({ make_plot7() })
  output$plot8 <- renderPlot({ make_plot8() })
  output$plot9 <- renderPlot({ make_plot9() })
  output$plot10 <- renderPlot({ make_plot10() })
  output$plot11 <- renderPlot({ make_plot11() })
  output$plot12 <- renderPlot({ make_plot12() })
  
  # 전체 그리드
  output$all_plots <- renderPlot({
    library(patchwork)
    
    p1 <- make_plot1() + theme(plot.title = element_text(size = 12))
    p2 <- make_plot2() + theme(plot.title = element_text(size = 12))
    p3 <- make_plot3() + theme(plot.title = element_text(size = 12))
    p4 <- make_plot4() + theme(plot.title = element_text(size = 12))
    p5 <- make_plot5() + theme(plot.title = element_text(size = 12))
    p6 <- make_plot6() + theme(plot.title = element_text(size = 12))
    p8 <- make_plot8() + theme(plot.title = element_text(size = 12))
    p9 <- make_plot9() + theme(plot.title = element_text(size = 12))
    p12 <- make_plot12() + theme(plot.title = element_text(size = 12))
    
    (p1 | p2 | p3) /
      (p4 | p5 | p6) /
      (p8 | p9 | p12)
  })
  
  # ============================================
  # 인터랙티브 플롯
  # ============================================
  
  # 필터링된 펭귄 데이터 (반응형)
  filtered_penguins <- reactive({
    data <- penguins %>%
      filter(!is.na(body_mass_g) & !is.na(flipper_length_mm))
    
    if (input$species_filter != "All") {
      data <- data %>% filter(species == input$species_filter)
    }
    
    return(data)
  })
  
  # 필터링된 주택 데이터 (반응형)
  filtered_houses <- reactive({
    house_data %>%
      filter(price >= input$price_range[1] & price <= input$price_range[2])
  })
  
  # 테마 선택 함수
  get_theme <- reactive({
    switch(input$chart_theme,
           "minimal" = theme_minimal(base_size = 14),
           "classic" = theme_classic(base_size = 14),
           "dark" = theme_dark(base_size = 14),
           "light" = theme_light(base_size = 14))
  })
  
  # 인터랙티브 플롯 1: 펭귄
  output$interactive_plot1 <- renderPlot({
    p <- ggplot(filtered_penguins(), 
                aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
      scale_color_viridis_d(name = "Species") +
      labs(
        title = paste("Penguin Body Mass vs Flipper Length"),
        subtitle = ifelse(input$species_filter == "All", 
                          "All Species", 
                          paste("Species:", input$species_filter)),
        x = "Flipper Length (mm)",
        y = "Body Mass (g)"
      ) +
      get_theme() +
      theme(
        plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray40")
      )
    
    if (input$show_points) {
      p <- p + 
        geom_point(size = 3, alpha = 0.6) +
        geom_smooth(method = "lm", se = TRUE, alpha = 0.2, size = 1)
    } else {
      p <- p + 
        geom_smooth(method = "lm", se = TRUE, alpha = 0.3, size = 1.5)
    }
    
    p
  })
  
  # 인터랙티브 플롯 2: 주택
  output$interactive_plot2 <- renderPlot({
    ggplot(filtered_houses(), aes(x = price, fill = city)) +
      geom_histogram(alpha = 0.6, bins = 30, position = "identity") +
      scale_fill_manual(values = c("A" = "#FF6B6B", 
                                   "B" = "#4ECDC4", 
                                   "C" = "#95E1D3")) +
      scale_x_continuous(labels = scales::comma) +
      labs(
        title = "Filtered House Prices by City",
        subtitle = paste("Price Range: $", 
                         scales::comma(input$price_range[1]), 
                         " - $", 
                         scales::comma(input$price_range[2])),
        x = "Price (USD)",
        y = "Count",
        fill = "City"
      ) +
      get_theme() +
      theme(
        plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
        plot.subtitle = element_text(size = 12, hjust = 0.5, color = "gray40"),
        legend.position = "top"
      )
  })
  
  # 요약 통계
  output$summary_stats <- renderPrint({
    cat("=" , rep("=", 60), "\n", sep = "")
    cat("  PENGUIN DATASET SUMMARY\n")
    cat("=" , rep("=", 60), "\n\n", sep = "")
    
    cat("Selected Species:", input$species_filter, "\n")
    cat("Number of observations:", nrow(filtered_penguins()), "\n\n")
    
    cat("Body Mass Statistics (g):\n")
    cat("--------------------------\n")
    print(summary(filtered_penguins()$body_mass_g))
    
    cat("\nFlipper Length Statistics (mm):\n")
    cat("--------------------------------\n")
    print(summary(filtered_penguins()$flipper_length_mm))
    
    if (input$species_filter == "All") {
      cat("\n\nSpecies Distribution:\n")
      cat("---------------------\n")
      print(table(filtered_penguins()$species))
    }
    
    cat("\n\n", rep("=", 62), "\n", sep = "")
    cat("  HOUSE PRICE SUMMARY\n")
    cat(rep("=", 62), "\n\n", sep = "")
    
    cat("Price Range: $", scales::comma(input$price_range[1]), 
        " - $", scales::comma(input$price_range[2]), "\n")
    cat("Number of houses:", nrow(filtered_houses()), "\n\n")
    
    cat("Price Statistics by City:\n")
    cat("-------------------------\n")
    price_by_city <- filtered_houses() %>%
      group_by(city) %>%
      summarise(
        Count = n(),
        Mean = scales::comma(round(mean(price))),
        Median = scales::comma(round(median(price))),
        Min = scales::comma(round(min(price))),
        Max = scales::comma(round(max(price)))
      )
    print(as.data.frame(price_by_city), row.names = FALSE)
    
    cat("\n\nBathroom Distribution:\n")
    cat("----------------------\n")
    bathroom_dist <- filtered_houses() %>%
      count(bathrooms) %>%
      mutate(Percentage = paste0(round(n / sum(n) * 100, 1), "%"))
    print(as.data.frame(bathroom_dist), row.names = FALSE)
  })
  
  # 데이터 테이블
  output$penguin_table <- DT::renderDataTable({
    DT::datatable(
      filtered_penguins() %>% select(-year),
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        dom = 'Bfrtip'
      ),
      filter = 'top',
      rownames = FALSE
    )
  })
  
  output$house_table <- DT::renderDataTable({
    DT::datatable(
      filtered_houses() %>%
        mutate(price = scales::dollar(price)),
      options = list(
        pageLength = 10,
        scrollX = TRUE,
        dom = 'Bfrtip'
      ),
      filter = 'top',
      rownames = FALSE
    )
  })
  
  # ============================================
  # 다운로드 핸들러
  # ============================================
  
  # 플롯 다운로드
  output$download_plot <- downloadHandler(
    filename = function() {
      paste("penguin_plot_", Sys.Date(), ".png", sep = "")
    },
    content = function(file) {
      png(file, width = 1200, height = 800, res = 120)
      print(
        ggplot(filtered_penguins(), 
               aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
          geom_point(size = 3, alpha = 0.6) +
          geom_smooth(method = "lm", se = TRUE) +
          scale_color_viridis_d() +
          labs(title = "Penguin Body Mass vs Flipper Length",
               x = "Flipper Length (mm)", y = "Body Mass (g)") +
          theme_minimal(base_size = 14)
      )
      dev.off()
    }
  )
  
  # 데이터 다운로드
  output$download_data <- downloadHandler(
    filename = function() {
      paste("penguin_data_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filtered_penguins(), file, row.names = FALSE)
    }
  )
}

# ============================================
# 앱 실행
# ============================================
shinyApp(ui = ui, server = server)

