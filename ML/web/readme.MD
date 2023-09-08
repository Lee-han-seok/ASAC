# 파이썬 기반 웹서비스
    - 머신러닝으로 학습한 모델을 이용하여 언어 감지 서비스를 제공

# 구조
L/
 L templates : html 파일들 위치하는 폴더, 고급 기능에서 수정가능
  L index.html
 L static : js, css,png/jpg 등 정적 리소스가 위치하는 폴더, 고급 기능에서 수정 가능
 L model : 모델 파일, 정답 레이블 파일, 모델을 사용하는 파이썬 파일
  L xx.lb : 모델 파일
  L xx.ml : 정답 레이블 파일
  L __init__.py : 모델을 사용하는 파이썬 파일

  L app2.py : 메인코드, 엔트리 포인트  
# 주요기능


# 설치과정
  - $는 프럼프트를 의미 실제 사용시에는 생략
  - pip install -r requirements.txt
  - 단, 구동시 가상환경 표식 확인하기
    - (web_svr) 프럼프트>
  - flask run => wsgi.py or app.py를 찾아서 자동으로 구동시킴
    - (web_svr) 프럼프트> flask run