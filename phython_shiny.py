import shiny
from shiny import App, ui, render, reactive
import pandas as pd
import numpy as np
import plotnine as pn
import plotly.express as px
import plotly.graph_objects as go
import seaborn as sns
import matplotlib.pyplot as plt
import warnings

# 경고 메시지 억제
warnings.filterwarnings('ignore', category=UserWarning, message='.*pkg_resources.*')
warnings.filterwarnings('ignore', category=FutureWarning)

# Seaborn 스타일 설정
sns.set_style("whitegrid")
try:
    plt.style.use('seaborn-v0_8')
except OSError:
    try:
        plt.style.use('seaborn')
    except OSError:
        plt.style.use('default')

# 데이터 준비
# Palmer Penguins dataset: pip install palmerpenguins
from palmerpenguins import load_penguins

penguins = load_penguins()
penguins = penguins.dropna(subset=['body_mass_g', 'flipper_length_mm', 'species', 'sex'])

np.random.seed(123)
house_data = pd.DataFrame({
    'city': np.repeat(['A', 'B', 'C'], 300),
    'price': np.concatenate([
        np.random.normal(1500000, 400000, 300),
        np.random.normal(2000000, 500000, 300),
        np.random.normal(1800000, 450000, 300)
    ]),
    'bathrooms': np.random.choice([1, 2, 3, 4], 900, replace=True)
})

netflix_data = pd.DataFrame({
    'genre': ["action", "crime", "drama", "comedy", "documentary", "reality"],
    'count': [1027, 1526, 3190, 235, 410, 695]
})
netflix_data['fraction'] = netflix_data['count'] / netflix_data['count'].sum()
netflix_data['ymax'] = netflix_data['fraction'].cumsum()
netflix_data['ymin'] = netflix_data['ymax'].shift(fill_value=0)
netflix_data['labelPosition'] = (netflix_data['ymax'] + netflix_data['ymin']) / 2

# UI
app_ui = ui.page_navbar(
    ui.nav_panel(
        "Dashboard",
        ui.div(
            {"class": "info-box"},
            ui.h2("Welcome to Data Visualization Gallery"),
            ui.p("이 대시보드는 ggplot2 (plotnine), seaborn, plotly를 사용한 다양한 데이터 시각화 예제를 제공합니다."),
            ui.p(ui.strong("주요 기능:"), "세 가지 라이브러리의 차이점을 비교하고, 다양한 그래프 타입을 탐색할 수 있습니다."),
            ui.p(ui.strong("사용 방법:"), "상단 메뉴에서 원하는 차트 카테고리를 선택하여 다양한 시각화를 탐색하세요."),
        ),
        ui.hr(),
        ui.layout_columns(
            ui.card(ui.h4("Basic Charts"), ui.p("막대그래프, 박스플롯 등 기본적인 시각화"), ui.input_action_button("goto_basic", "보러가기")),
            ui.card(ui.h4("Distributions"), ui.p("분포도, 바이올린 플롯 등"), ui.input_action_button("goto_dist", "보러가기")),
            ui.card(ui.h4("Library Comparison"), ui.p("ggplot, seaborn, plotly 비교"), ui.input_action_button("goto_compare", "보러가기")),
            ui.card(ui.h4("Advanced"), ui.p("히트맵, 고급 시각화 기법"), ui.input_action_button("goto_adv", "보러가기")),
            ui.card(ui.h4("Interactive"), ui.p("커스터마이징 가능한 인터랙티브 차트"), ui.input_action_button("goto_inter", "보러가기")),
        ),
        ui.hr(),
        ui.layout_columns(
            ui.card(ui.h4("Quick Stats - Penguins Dataset"), ui.output_text_verbatim("quick_stats_penguins")),
            ui.card(ui.h4("Quick Stats - House Prices"), ui.output_text_verbatim("quick_stats_houses"))
        )
    ),
    ui.nav_panel(
        "Basic Charts",
        ui.layout_columns(
            ui.card(ui.h3("Stacked Bar Chart"), ui.output_plot("plot1"), ui.hr(), ui.p({"class": "text-muted"}, "펭귄 종과 성별에 따른 개체 수를 보여주는 적층 막대 그래프")),
            ui.card(ui.h3("Box Plot with Points"), ui.output_plot("plot2"), ui.hr(), ui.p({"class": "text-muted"}, "종별 체중 분포를 박스플롯과 개별 데이터 포인트로 표현")),
        ),
        ui.hr(),
        ui.layout_columns(
            ui.card(ui.h3("Overlapping Histograms"), ui.output_plot("plot3"), ui.hr(), ui.p({"class": "text-muted"}, "도시별 주택 가격 분포를 겹쳐서 비교")),
            ui.card(ui.h3("Density Plot"), ui.output_plot("plot4"), ui.hr(), ui.p({"class": "text-muted"}, "욕실 개수에 따른 주택 가격 밀도 분포"))
        )
    ),
    ui.nav_panel(
        "Distributions",
        ui.layout_columns(
            ui.card(ui.h3("Violin Plot"), ui.output_plot("plot5"), ui.hr(), ui.p({"class": "text-muted"}, "종별 체중 분포를 바이올린 플롯으로 표현")),
            ui.card(ui.h3("Ridge Plot"), ui.output_plot("plot6"), ui.hr(), ui.p({"class": "text-muted"}, "종별 날개 길이 분포를 리지 플롯으로 표현")),
        ),
        ui.hr(),
        ui.layout_columns(
            ui.card(ui.h3("Scatter Plot with Regression"), ui.output_plot("plot7"), ui.hr(), ui.p({"class": "text-muted"}, "체중과 날개 길이의 상관관계")),
            ui.card(ui.h3("Faceted Histogram"), ui.output_plot("plot8"), ui.hr(), ui.p({"class": "text-muted"}, "종별로 분할된 히스토그램")),
        )
    ),
    ui.nav_panel(
        "Library Comparison",
        ui.h2("같은 데이터, 다른 라이브러리 비교"),
        ui.p("동일한 데이터셋을 ggplot2 (plotnine), seaborn, plotly로 시각화하여 각 라이브러리의 특징을 비교합니다."),
        ui.hr(),
        ui.h3("1. 막대 그래프 비교"),
        ui.layout_columns(
            ui.card(ui.h4("ggplot2 (plotnine)"), ui.output_plot("compare_bar_ggplot"), ui.p({"class": "text-muted"}, "문법적 계층 구조, 레이어 기반")),
            ui.card(ui.h4("Seaborn"), ui.output_plot("compare_bar_seaborn"), ui.p({"class": "text-muted"}, "간결한 API, 통계적 시각화")),
            ui.card(ui.h4("Plotly"), ui.output_ui("compare_bar_plotly"), ui.p({"class": "text-muted"}, "인터랙티브, 웹 기반")),
        ),
        ui.hr(),
        ui.h3("2. 산점도 비교"),
        ui.layout_columns(
            ui.card(ui.h4("ggplot2 (plotnine)"), ui.output_plot("compare_scatter_ggplot"), ui.p({"class": "text-muted"}, "세밀한 커스터마이징 가능")),
            ui.card(ui.h4("Seaborn"), ui.output_plot("compare_scatter_seaborn"), ui.p({"class": "text-muted"}, "회귀선 자동 추가")),
            ui.card(ui.h4("Plotly"), ui.output_ui("compare_scatter_plotly"), ui.p({"class": "text-muted"}, "호버 정보, 줌/팬 기능")),
        ),
        ui.hr(),
        ui.h3("3. 박스플롯 비교"),
        ui.layout_columns(
            ui.card(ui.h4("ggplot2 (plotnine)"), ui.output_plot("compare_box_ggplot"), ui.p({"class": "text-muted"}, "레이어 추가로 확장 용이")),
            ui.card(ui.h4("Seaborn"), ui.output_plot("compare_box_seaborn"), ui.p({"class": "text-muted"}, "한 줄 코드로 빠른 시각화")),
            ui.card(ui.h4("Plotly"), ui.output_ui("compare_box_plotly"), ui.p({"class": "text-muted"}, "인터랙티브 박스플롯")),
        ),
        ui.hr(),
        ui.h3("4. 히트맵 비교"),
        ui.layout_columns(
            ui.card(ui.h4("ggplot2 (plotnine)"), ui.output_plot("compare_heatmap_ggplot"), ui.p({"class": "text-muted"}, "geom_tile 사용")),
            ui.card(ui.h4("Seaborn"), ui.output_plot("compare_heatmap_seaborn"), ui.p({"class": "text-muted"}, "heatmap() 함수로 간단히")),
            ui.card(ui.h4("Plotly"), ui.output_ui("compare_heatmap_plotly"), ui.p({"class": "text-muted"}, "인터랙티브 히트맵")),
        ),
    ),
    ui.nav_panel(
        "Advanced",
        ui.layout_columns(
            ui.card(ui.h3("Heatmap"), ui.output_plot("plot9"), ui.hr(), ui.p({"class": "text-muted"}, "펭귄 데이터 상관관계 히트맵")),
            ui.card(ui.h3("Pair Plot"), ui.output_plot("plot10"), ui.hr(), ui.p({"class": "text-muted"}, "변수 간 관계를 한눈에")),
        ),
        ui.hr(),
        ui.layout_columns(
            ui.card(ui.h3("Line Chart"), ui.output_plot("plot11"), ui.hr(), ui.p({"class": "text-muted"}, "시계열 데이터 시각화")),
            ui.card(ui.h3("Pie Chart"), ui.output_ui("plot12"), ui.hr(), ui.p({"class": "text-muted"}, "Netflix 장르별 분포")),
        )
    ),
    ui.nav_panel(
        "Interactive",
        ui.h2("Plotly 인터랙티브 차트"),
        ui.p("Plotly를 사용한 인터랙티브 시각화 - 줌, 팬, 호버 기능 지원"),
        ui.hr(),
        ui.layout_columns(
            ui.card(ui.h3("3D Scatter Plot"), ui.output_ui("interactive_3d"), ui.hr(), ui.p({"class": "text-muted"}, "3차원 산점도 - 회전 가능")),
            ui.card(ui.h3("Interactive Time Series"), ui.output_ui("interactive_ts"), ui.hr(), ui.p({"class": "text-muted"}, "인터랙티브 시계열 차트")),
        ),
        ui.hr(),
        ui.layout_columns(
            ui.card(ui.h3("Sunburst Chart"), ui.output_ui("interactive_sunburst"), ui.hr(), ui.p({"class": "text-muted"}, "계층적 데이터 시각화")),
            ui.card(ui.h3("Parallel Coordinates"), ui.output_ui("interactive_parallel"), ui.hr(), ui.p({"class": "text-muted"}, "다차원 데이터 시각화")),
        )
    ),
    title="Data Visualization Gallery"
)

# 서버 로직
def server(input, output, session):
    # 대시보드 quick stats
    @output
    @render.text
    def quick_stats_penguins():
        out = f"Total Penguins: {len(penguins)}\nSpecies:\n{penguins['species'].value_counts().to_string()}"
        return out

    @output
    @render.text
    def quick_stats_houses():
        out = f"Total Houses: {len(house_data)}\nPrice Range: ${int(house_data['price'].min()):,} - ${int(house_data['price'].max()):,}\nMean Price: ${int(house_data['price'].mean()):,}"
        return out

    # 정적 플롯
    @output
    @render.plot
    def plot1():
        df = penguins.groupby(['species', 'sex']).size().reset_index(name='n')
        p = (pn.ggplot(df, pn.aes(x='species', y='n', fill='sex'))
             + pn.geom_bar(stat='identity', position='stack')
             + pn.geom_text(pn.aes(label='n'), position=pn.position_stack(vjust=0.5), color="white", size=8, fontweight="bold")
             + pn.scale_fill_manual(values={"female": "#E69F00", "male": "#56B4E9"})
             + pn.labs(title="Penguin Count by Species and Sex", x="Species", y="Count", fill="Sex")
             + pn.theme_minimal(base_size=14))
        return p

    @output
    @render.plot
    def plot2():
        p = (pn.ggplot(penguins, pn.aes(x='species', y='body_mass_g', fill='species'))
             + pn.geom_boxplot(alpha=0.7)
             + pn.geom_jitter(width=0.2, alpha=0.3, size=1.5)
             + pn.scale_fill_manual(values={"Adelie": "#F8766D", "Chinstrap": "#00BA38", "Gentoo": "#619CFF"})
             + pn.labs(title="Distribution of Penguin Body Mass by Species", x="Species", y="Body Mass (g)")
             + pn.theme_minimal(base_size=14))
        return p

    @output
    @render.plot
    def plot3():
        p = (pn.ggplot(house_data, pn.aes(x='price', fill='city'))
             + pn.geom_histogram(alpha=0.6, bins=30, position='identity')
             + pn.scale_fill_manual(values={"A": "#FF6B6B", "B": "#4ECDC4", "C": "#95E1D3"})
             + pn.scale_x_continuous(labels=lambda l: [f"{int(x):,}" for x in l])
             + pn.labs(title="American House Prices in Big Cities", x="Price (USD)", y="Count", fill="City")
             + pn.theme_minimal(base_size=14))
        return p

    @output
    @render.plot
    def plot4():
        p = (pn.ggplot(house_data, pn.aes(x='price', color='bathrooms'))
             + pn.geom_density(size=1.2)
             + pn.scale_x_continuous(labels=lambda l: [f"{int(x):,}" for x in l])
             + pn.labs(title="House Prices - Density Plot by Number of Bathrooms", x="Price (USD)", y="Density")
             + pn.theme_minimal(base_size=14))
        return p

    # Distributions 탭 그래프
    @output
    @render.plot
    def plot5():
        p = (pn.ggplot(penguins, pn.aes(x='species', y='body_mass_g', fill='species'))
             + pn.geom_violin(alpha=0.7)
             + pn.scale_fill_manual(values={"Adelie": "#F8766D", "Chinstrap": "#00BA38", "Gentoo": "#619CFF"})
             + pn.labs(title="Violin Plot: Body Mass by Species", x="Species", y="Body Mass (g)")
             + pn.theme_minimal(base_size=14))
        return p

    @output
    @render.plot
    def plot6():
        fig, ax = plt.subplots(figsize=(10, 6))
        for species in penguins['species'].unique():
            data = penguins[penguins['species'] == species]['flipper_length_mm']
            sns.kdeplot(data=data, label=species, ax=ax, fill=True, alpha=0.6)
        ax.set_title("Ridge Plot: Flipper Length by Species")
        ax.set_xlabel("Flipper Length (mm)")
        ax.set_ylabel("Density")
        ax.legend()
        plt.tight_layout()
        return fig

    @output
    @render.plot
    def plot7():
        p = (pn.ggplot(penguins, pn.aes(x='flipper_length_mm', y='body_mass_g', color='species'))
             + pn.geom_point(alpha=0.6)
             + pn.geom_smooth(method='lm', se=True)
             + pn.scale_color_manual(values={"Adelie": "#F8766D", "Chinstrap": "#00BA38", "Gentoo": "#619CFF"})
             + pn.labs(title="Scatter Plot with Regression Line", x="Flipper Length (mm)", y="Body Mass (g)")
             + pn.theme_minimal(base_size=14))
        return p

    @output
    @render.plot
    def plot8():
        p = (pn.ggplot(penguins, pn.aes(x='body_mass_g', fill='species'))
             + pn.geom_histogram(bins=30, alpha=0.7)
             + pn.facet_wrap('~species', ncol=3)
             + pn.scale_fill_manual(values={"Adelie": "#F8766D", "Chinstrap": "#00BA38", "Gentoo": "#619CFF"})
             + pn.labs(title="Faceted Histogram: Body Mass by Species", x="Body Mass (g)", y="Count")
             + pn.theme_minimal(base_size=12))
        return p

    # Advanced 탭 그래프
    @output
    @render.plot
    def plot9():
        corr_data = penguins[['bill_length_mm', 'bill_depth_mm', 'flipper_length_mm', 'body_mass_g']].corr()
        p = (pn.ggplot(corr_data.reset_index().melt(id_vars='index'), 
                      pn.aes(x='index', y='variable', fill='value'))
             + pn.geom_tile()
             + pn.scale_fill_gradient2(low="#FF6B6B", mid="white", high="#4ECDC4", midpoint=0)
             + pn.labs(title="Correlation Heatmap", x="", y="", fill="Correlation")
             + pn.theme_minimal(base_size=12)
             + pn.theme(axis_text_x=pn.element_text(angle=45, hjust=1)))
        return p

    @output
    @render.plot
    def plot10():
        fig = sns.pairplot(penguins[['bill_length_mm', 'bill_depth_mm', 'flipper_length_mm', 'body_mass_g', 'species']], 
                          hue='species', diag_kind='kde')
        fig.fig.suptitle("Pair Plot: Variable Relationships", y=1.02)
        return fig.fig

    @output
    @render.plot
    def plot11():
        # 시계열 데이터 생성
        dates = pd.date_range('2020-01-01', periods=100, freq='D')
        ts_data = pd.DataFrame({
            'date': dates,
            'value': np.cumsum(np.random.randn(100)) + 100,
            'category': np.random.choice(['A', 'B', 'C'], 100)
        })
        p = (pn.ggplot(ts_data, pn.aes(x='date', y='value', color='category'))
             + pn.geom_line(size=1.2)
             + pn.labs(title="Time Series Line Chart", x="Date", y="Value")
             + pn.theme_minimal(base_size=14))
        return p

    @output
    @render.ui
    def plot12():
        fig = px.pie(netflix_data, values='count', names='genre', 
                     title="Netflix Genre Distribution",
                     color_discrete_sequence=px.colors.qualitative.Set3)
        fig.update_traces(textposition='inside', textinfo='percent+label')
        html_str = fig.to_html(include_plotlyjs='cdn', div_id="plot12")
        return ui.HTML(html_str)

    # Library Comparison - 막대 그래프
    @output
    @render.plot
    def compare_bar_ggplot():
        df = penguins.groupby('species').size().reset_index(name='count')
        p = (pn.ggplot(df, pn.aes(x='species', y='count', fill='species'))
             + pn.geom_bar(stat='identity')
             + pn.scale_fill_manual(values={"Adelie": "#F8766D", "Chinstrap": "#00BA38", "Gentoo": "#619CFF"})
             + pn.labs(title="ggplot2: Bar Chart", x="Species", y="Count")
             + pn.theme_minimal())
        return p

    @output
    @render.plot
    def compare_bar_seaborn():
        fig, ax = plt.subplots(figsize=(8, 5))
        sns.countplot(data=penguins, x='species', ax=ax, palette=["#F8766D", "#00BA38", "#619CFF"])
        ax.set_title("Seaborn: Bar Chart")
        ax.set_xlabel("Species")
        ax.set_ylabel("Count")
        plt.tight_layout()
        return fig

    @output
    @render.ui
    def compare_bar_plotly():
        df = penguins.groupby('species').size().reset_index(name='count')
        fig = px.bar(df, x='species', y='count', color='species',
                     title="Plotly: Interactive Bar Chart",
                     color_discrete_map={"Adelie": "#F8766D", "Chinstrap": "#00BA38", "Gentoo": "#619CFF"})
        html_str = fig.to_html(include_plotlyjs='cdn', div_id="compare_bar_plotly")
        return ui.HTML(html_str)

    # Library Comparison - 산점도
    @output
    @render.plot
    def compare_scatter_ggplot():
        p = (pn.ggplot(penguins, pn.aes(x='flipper_length_mm', y='body_mass_g', color='species'))
             + pn.geom_point(alpha=0.6)
             + pn.scale_color_manual(values={"Adelie": "#F8766D", "Chinstrap": "#00BA38", "Gentoo": "#619CFF"})
             + pn.labs(title="ggplot2: Scatter Plot", x="Flipper Length (mm)", y="Body Mass (g)")
             + pn.theme_minimal())
        return p

    @output
    @render.plot
    def compare_scatter_seaborn():
        fig, ax = plt.subplots(figsize=(8, 5))
        sns.scatterplot(data=penguins, x='flipper_length_mm', y='body_mass_g', 
                       hue='species', ax=ax, palette=["#F8766D", "#00BA38", "#619CFF"], alpha=0.6)
        sns.regplot(data=penguins, x='flipper_length_mm', y='body_mass_g', 
                   scatter=False, ax=ax, color='gray', line_kws={'linestyle': '--'})
        ax.set_title("Seaborn: Scatter Plot with Regression")
        ax.set_xlabel("Flipper Length (mm)")
        ax.set_ylabel("Body Mass (g)")
        plt.tight_layout()
        return fig

    @output
    @render.ui
    def compare_scatter_plotly():
        fig = px.scatter(penguins, x='flipper_length_mm', y='body_mass_g', color='species',
                        title="Plotly: Interactive Scatter Plot",
                        hover_data=['bill_length_mm', 'bill_depth_mm'],
                        color_discrete_map={"Adelie": "#F8766D", "Chinstrap": "#00BA38", "Gentoo": "#619CFF"})
        html_str = fig.to_html(include_plotlyjs='cdn', div_id="compare_scatter_plotly")
        return ui.HTML(html_str)

    # Library Comparison - 박스플롯
    @output
    @render.plot
    def compare_box_ggplot():
        p = (pn.ggplot(penguins, pn.aes(x='species', y='body_mass_g', fill='species'))
             + pn.geom_boxplot(alpha=0.7)
             + pn.geom_jitter(width=0.2, alpha=0.3)
             + pn.scale_fill_manual(values={"Adelie": "#F8766D", "Chinstrap": "#00BA38", "Gentoo": "#619CFF"})
             + pn.labs(title="ggplot2: Box Plot", x="Species", y="Body Mass (g)")
             + pn.theme_minimal())
        return p

    @output
    @render.plot
    def compare_box_seaborn():
        fig, ax = plt.subplots(figsize=(8, 5))
        sns.boxplot(data=penguins, x='species', y='body_mass_g', ax=ax, 
                   palette=["#F8766D", "#00BA38", "#619CFF"])
        sns.stripplot(data=penguins, x='species', y='body_mass_g', ax=ax, 
                     color='black', alpha=0.3, size=3)
        ax.set_title("Seaborn: Box Plot")
        ax.set_xlabel("Species")
        ax.set_ylabel("Body Mass (g)")
        plt.tight_layout()
        return fig

    @output
    @render.ui
    def compare_box_plotly():
        fig = px.box(penguins, x='species', y='body_mass_g', color='species',
                    title="Plotly: Interactive Box Plot",
                    color_discrete_map={"Adelie": "#F8766D", "Chinstrap": "#00BA38", "Gentoo": "#619CFF"})
        html_str = fig.to_html(include_plotlyjs='cdn', div_id="compare_box_plotly")
        return ui.HTML(html_str)

    # Library Comparison - 히트맵
    @output
    @render.plot
    def compare_heatmap_ggplot():
        corr_data = penguins[['bill_length_mm', 'bill_depth_mm', 'flipper_length_mm', 'body_mass_g']].corr()
        p = (pn.ggplot(corr_data.reset_index().melt(id_vars='index'), 
                      pn.aes(x='index', y='variable', fill='value'))
             + pn.geom_tile()
             + pn.scale_fill_gradient2(low="#FF6B6B", mid="white", high="#4ECDC4", midpoint=0)
             + pn.labs(title="ggplot2: Heatmap", x="", y="", fill="Correlation")
             + pn.theme_minimal()
             + pn.theme(axis_text_x=pn.element_text(angle=45, hjust=1)))
        return p

    @output
    @render.plot
    def compare_heatmap_seaborn():
        corr_data = penguins[['bill_length_mm', 'bill_depth_mm', 'flipper_length_mm', 'body_mass_g']].corr()
        fig, ax = plt.subplots(figsize=(8, 6))
        sns.heatmap(corr_data, annot=True, fmt='.2f', cmap='coolwarm', center=0, ax=ax, square=True)
        ax.set_title("Seaborn: Heatmap")
        plt.tight_layout()
        return fig

    @output
    @render.ui
    def compare_heatmap_plotly():
        corr_data = penguins[['bill_length_mm', 'bill_depth_mm', 'flipper_length_mm', 'body_mass_g']].corr()
        fig = px.imshow(corr_data, text_auto=True, aspect="auto",
                       title="Plotly: Interactive Heatmap",
                       color_continuous_scale='RdBu')
        html_str = fig.to_html(include_plotlyjs='cdn', div_id="compare_heatmap_plotly")
        return ui.HTML(html_str)

    # Interactive 탭 그래프
    @output
    @render.ui
    def interactive_3d():
        fig = px.scatter_3d(penguins, x='bill_length_mm', y='bill_depth_mm', z='flipper_length_mm',
                           color='species', size='body_mass_g',
                           title="3D Scatter Plot",
                           color_discrete_map={"Adelie": "#F8766D", "Chinstrap": "#00BA38", "Gentoo": "#619CFF"})
        html_str = fig.to_html(include_plotlyjs='cdn', div_id="interactive_3d")
        return ui.HTML(html_str)

    @output
    @render.ui
    def interactive_ts():
        dates = pd.date_range('2020-01-01', periods=100, freq='D')
        ts_data = pd.DataFrame({
            'date': dates,
            'value': np.cumsum(np.random.randn(100)) + 100,
            'category': np.random.choice(['A', 'B', 'C'], 100)
        })
        fig = px.line(ts_data, x='date', y='value', color='category',
                     title="Interactive Time Series",
                     markers=True)
        fig.update_xaxes(rangeslider_visible=True)
        html_str = fig.to_html(include_plotlyjs='cdn', div_id="interactive_ts")
        return ui.HTML(html_str)

    @output
    @render.ui
    def interactive_sunburst():
        # 계층적 데이터 생성
        hierarchical_data = pd.DataFrame({
            'ids': ['World', 'World-A', 'World-B', 'World-C', 'World-A-1', 'World-A-2', 'World-B-1', 'World-B-2'],
            'labels': ['World', 'A', 'B', 'C', 'A1', 'A2', 'B1', 'B2'],
            'parents': ['', 'World', 'World', 'World', 'World-A', 'World-A', 'World-B', 'World-B'],
            'values': [100, 40, 35, 25, 20, 20, 18, 17]
        })
        fig = px.sunburst(hierarchical_data, ids='ids', labels='labels', parents='parents', values='values',
                         title="Sunburst Chart")
        html_str = fig.to_html(include_plotlyjs='cdn', div_id="interactive_sunburst")
        return ui.HTML(html_str)

    @output
    @render.ui
    def interactive_parallel():
        # 샘플 데이터 선택
        sample_data = penguins.sample(min(100, len(penguins)))
        fig = px.parallel_coordinates(sample_data,
                                     dimensions=['bill_length_mm', 'bill_depth_mm', 'flipper_length_mm', 'body_mass_g'],
                                     color='body_mass_g',
                                     title="Parallel Coordinates Plot",
                                     color_continuous_scale=px.colors.sequential.Viridis)
        html_str = fig.to_html(include_plotlyjs='cdn', div_id="interactive_parallel")
        return ui.HTML(html_str)

# 앱 실행
app = App(app_ui, server)

if __name__ == "__main__":
    app.run()
