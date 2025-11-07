
# ggplot2 Visualization Gallery (Python Shiny 버전)

이 프로젝트는 R의 Shiny 및 ggplot2 기반 데이터 시각화 대시보드를 Python Shiny와 plotnine으로 변환한 예시입니다.  
팔머 펭귄/palmerpenguins, 시뮬레이션 주택 데이터, 넷플릭스 장르 등 다양한 데이터를 다루며 대시보드 형태로 시각화 기능을 제공합니다.

## 주요 기능

- 다양한 카테고리의 데이터 시각화 대시보드 제공
- 펭귄, 주택 가격, 넷플릭스 장르 등 여러 데이터셋 분석
- 정적/동적(필터/슬라이더) 시각화 탭 및 데이터 요약
- plotnine(ggplot2 스타일) 기반 다양한 차트, 데이터 테이블, 다운로드 기능
- Shiny for Python의 최신 UI 구조(page_navbar, nav_panel 등) 적용

## 설치 방법

아래 명령어로 필요한 Python 패키지를 설치하세요:

```
pip install shiny plotnine palmerpenguins pandas numpy
```

## 실행 방법

```
python phython_shiny.py
```
또는
```
shiny run phython_shiny.py
```
(환경에 따라 shiny CLI 사용 또는 직접 실행)

## 디렉터리 구조

```
├── phython_shiny.py      # 메인 shiny 앱 코드
├── README.md             # 깃허브 설명 파일 (본 문서)
```

## 코드 예시

앱 UI/서버 구조 요약:
```
from shiny import App, ui

app_ui = ui.page_navbar(
    ui.nav_panel("Dashboard", ...),
    ui.nav_panel("Basic Charts", ...),
    # 기타 탭 추가
    title="ggplot2 Visualization Gallery",
)
def server(input, output, session):
    # 서버 함수 정의
    pass
app = App(app_ui, server)
```

## 데이터 출처

- Palmer Penguins: 남극 팔머 군도의 실측 펭귄 데이터
- 주택 가격: 도시별 시뮬레이션 된 미국 주택 가격 데이터
- Netflix 장르: 시뮬레이터 분포 데이터

## 참고

- 원본 R Shiny/ggplot2 코드를 Python Shiny/plotnine으로 변환
- 참고 라이브러리: [shiny for python](https://shiny.posit.co/py/), [plotnine](https://plotnine.readthedocs.io/en/stable/), [palmerpenguins](https://github.com/allisonhorst/palmerpenguins)

## 라이선스

MIT License



