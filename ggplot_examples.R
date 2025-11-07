# 필요한 패키지 설치 (최초 1회)
install.packages(c("ggplot2", "dplyr", "tidyr", "palmerpenguins", 
                   "ggridges", "patchwork", "viridis", "shiny"))

# 패키지 로드
library(ggplot2)
library(dplyr)
library(tidyr)
library(palmerpenguins)
library(ggridges)
library(patchwork)
library(viridis)

# 펭귄 데이터 (palmerpenguins 패키지에서 제공)
data("penguins")

# 주택 가격 샘플 데이터 생성
set.seed(123)
house_data <- data.frame(
  city = rep(c("A", "B", "C"), each = 300),
  price = c(rnorm(300, 1500000, 400000),
            rnorm(300, 2000000, 500000),
            rnorm(300, 1800000, 450000)),
  bathrooms = sample(1:4, 900, replace = TRUE)
)

# 넷플릭스 장르 샘플 데이터
netflix_data <- data.frame(
  genre = c("action", "crime", "drama", "comedy", "documentary", "reality"),
  count = c(1027, 1526, 3190, 235, 410, 695)
)



# 종별 성별 데이터 준비
penguin_summary <- penguins %>%
  filter(!is.na(sex) & !is.na(species)) %>%
  count(species, sex)

plot1 <- ggplot(penguin_summary, aes(x = species, y = n, fill = sex)) +
  geom_bar(stat = "identity", position = "stack") +
  geom_text(aes(label = n), position = position_stack(vjust = 0.5), 
            color = "white", size = 3.5) +
  scale_fill_manual(values = c("female" = "#E69F00", "male" = "#56B4E9")) +
  labs(title = "Penguin Count by Species and Sex",
       x = "Species", y = "Count") +
  theme_minimal() +
  theme(legend.position = "right")

print(plot1)


plot2 <- ggplot(penguins %>% filter(!is.na(body_mass_g)), 
                aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(alpha = 0.7, outlier.shape = NA) +
  geom_jitter(width = 0.2, alpha = 0.3, size = 1) +
  scale_fill_manual(values = c("Adelie" = "#F8766D", 
                               "Chinstrap" = "#00BA38", 
                               "Gentoo" = "#619CFF")) +
  labs(title = "Distribution of Penguin Body Mass by Species",
       x = "Species", y = "Body Mass (g)") +
  theme_minimal() +
  theme(legend.position = "none")

print(plot2)


plot3 <- ggplot(house_data, aes(x = price, fill = city)) +
  geom_histogram(alpha = 0.6, bins = 30, position = "identity") +
  scale_fill_manual(values = c("A" = "#FF6B6B", 
                               "B" = "#4ECDC4", 
                               "C" = "#95E1D3")) +
  scale_x_continuous(labels = scales::comma) +
  labs(title = "American House Prices in Big Cities",
       x = "Price (USD)", y = "Count") +
  theme_minimal() +
  theme(legend.title = element_blank())

print(plot3)


plot4 <- ggplot(house_data, aes(x = price, color = factor(bathrooms))) +
  geom_density(size = 1.2) +
  scale_color_viridis_d(name = "Bathrooms") +
  scale_x_continuous(labels = scales::comma) +
  labs(title = "American House Prices - Density Plot by Number of Bathrooms",
       x = "Price (USD)", y = "Density") +
  theme_minimal()

print(plot4)



plot5 <- ggplot(penguins %>% filter(!is.na(flipper_length_mm)), 
                aes(x = species, y = flipper_length_mm, fill = species)) +
  geom_violin(alpha = 0.8) +
  geom_boxplot(width = 0.1, fill = "white", alpha = 0.8) +
  scale_fill_manual(values = c("Adelie" = "#FF6B6B", 
                               "Chinstrap" = "#4ECDC4", 
                               "Gentoo" = "#95E1D3")) +
  labs(title = "Flipper Length Distribution by Species",
       x = "Species", y = "Flipper Length (mm)") +
  theme_minimal() +
  theme(legend.position = "none")

print(plot5)



plot6 <- ggplot(penguins %>% filter(!is.na(body_mass_g)), 
                aes(x = body_mass_g, fill = species)) +
  geom_histogram(alpha = 0.6, bins = 20, position = "identity") +
  scale_fill_manual(values = c("Adelie" = "#FFB6C1", 
                               "Chinstrap" = "#87CEEB", 
                               "Gentoo" = "#98D8C8"),
                    labels = c("Adelie", "Chinstrap", "Gentoo")) +
  labs(title = "Distribution of Penguin Body Mass by Species",
       x = "Body Mass (g)", y = "Frequency") +
  theme_minimal() +
  theme(legend.position = "top")

print(plot6)



# 히트맵용 데이터 생성
set.seed(123)
heatmap_data <- expand.grid(
  location = paste0("Location", 1:50),
  price_range = paste0("$", seq(0, 5000, 100))
) %>%
  mutate(count = rpois(n(), lambda = 20))

plot7 <- ggplot(heatmap_data, aes(x = price_range, y = location, fill = count)) +
  geom_tile() +
  scale_fill_gradientn(colors = c("green", "yellow", "orange", "red"),
                       name = "Count") +
  labs(title = "American House Prices in Big Cities - Heatmap",
       x = "Price Range (USD)", y = "Location") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 6),
        axis.text.y = element_text(size = 6))

print(plot7)



plot8 <- ggplot(penguins %>% filter(!is.na(sex) & !is.na(flipper_length_mm)), 
                aes(x = species, y = flipper_length_mm, fill = sex)) +
  geom_boxplot(alpha = 0.7) +
  scale_fill_manual(values = c("female" = "#FF69B4", "male" = "#4682B4")) +
  labs(title = "Flipper Length by Species and Gender",
       x = "Species", y = "Flipper Length (mm)") +
  theme_minimal() +
  theme(legend.title = element_text(face = "bold"))

print(plot8)



# 밀도 리지 플롯용 데이터
ridge_data <- data.frame(
  group = rep(c("low", "mid", "high"), each = 500),
  weight = c(rnorm(500, 4, 0.5),
             rnorm(500, 5, 0.6),
             rnorm(500, 5.5, 0.4))
)

plot9 <- ggplot(ridge_data, aes(x = weight, y = group, fill = group)) +
  geom_density_ridges(alpha = 0.7) +
  scale_fill_manual(values = c("low" = "#8B7D6B", 
                               "mid" = "#D2B48C", 
                               "high" = "#F4A460")) +
  labs(title = "Density Ridge Plot by Group",
       x = "Weight", y = "Group") +
  theme_minimal() +
  theme(legend.position = "none")

print(plot9)


# 산점도용 데이터 생성
set.seed(123)
scatter_data <- data.frame(
  x = rnorm(30, 0, 1),
  y = rnorm(30, 0, 1),
  group = sample(c("Label A", "Label B", "Label C"), 30, replace = TRUE),
  label = paste0("point", 1:30)
)

plot10 <- ggplot(scatter_data, aes(x = x, y = y, color = group)) +
  geom_point(size = 3) +
  geom_text(aes(label = label), vjust = -0.5, size = 2.5, show.legend = FALSE) +
  scale_color_manual(values = c("Label A" = "#E74C3C", 
                                "Label B" = "#3498DB", 
                                "Label C" = "#2ECC71")) +
  labs(title = "Scatter Plot with Labels",
       x = "X Variable", y = "Y Variable") +
  theme_minimal() +
  theme(legend.position = "right")

print(plot10)



# 바이올린 플롯용 확장 데이터
violin_data <- penguins %>%
  filter(!is.na(bill_length_mm) & !is.na(species)) %>%
  mutate(season = sample(c("p = 1991", "p = 2007", "p = 2008", "p = 2009"), 
                         n(), replace = TRUE))

plot11 <- ggplot(violin_data, 
                 aes(x = season, y = bill_length_mm, fill = species)) +
  geom_violin(alpha = 0.7, position = position_dodge(0.8)) +
  geom_boxplot(width = 0.1, position = position_dodge(0.8), alpha = 0.5) +
  scale_fill_viridis_d() +
  labs(title = "Bill Length Distribution Across Seasons",
       x = "Season", y = "Bill Length (mm)") +
  theme_minimal()

print(plot11)



# 도넛 차트용 데이터 준비
netflix_data <- netflix_data %>%
  mutate(fraction = count / sum(count),
         ymax = cumsum(fraction),
         ymin = c(0, head(ymax, n = -1)),
         labelPosition = (ymax + ymin) / 2,
         label = paste0(genre, "\n", count))

plot12 <- ggplot(netflix_data, aes(ymax = ymax, ymin = ymin, 
                                   xmax = 4, xmin = 3, fill = genre)) +
  geom_rect() +
  geom_text(x = 3.5, aes(y = labelPosition, label = count), size = 3) +
  scale_fill_manual(values = c("action" = "#4ECDC4", "crime" = "#FF6B6B",
                               "drama" = "#95E1D3", "comedy" = "#FFD93D",
                               "documentary" = "#FFA07A", "reality" = "#DDA0DD")) +
  coord_polar(theta = "y") +
  xlim(c(2, 4)) +
  labs(title = "Genre Distribution - Netflix Movies & TV Shows") +
  theme_void() +
  theme(legend.position = "right",
        plot.title = element_text(hjust = 0.5, face = "bold"))

print(plot12)



