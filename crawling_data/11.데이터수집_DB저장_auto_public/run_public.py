# -*- coding: utf-8 -*-
"""# 4. 함수화
- 외부와 통신하는 부분을 함수화하여 재사용성을 높인다.

- 요구사항
    - 입력
        - 키워드(문자열), 포맷(json(기본값) or xml, 문자열), 검색결과갯수(10~100, 정수)
    - 연산
        - 네이버 뉴스 검색 수행
    - 출력
        - 응답 결과를 json 객체로 리턴
    - 함수명
        - get_search_news
"""
import pandas as pd
import pymysql 
import re
import html
import urllib
import urllib.request as req
import json
CLIENT_ID = '개인 ID 입력'
CLIENT_SECRET = '개인 SECRET 입력'
DEV_NAVER_URL = "https://openapi.naver.com/v1/search/news.{}?query={}&display={}&start=1&sort=sim"

def get_search_news(keyword : str = '삼성', format : str = 'json', display : int = 10) -> dict:
    enc_text = urllib.parse.quote(keyword)    # '삼성' -> '%A......'
    url = DEV_NAVER_URL.format( format, enc_text, display )    #  url 완성
    request = req.Request(url)
    request.add_header('X-Naver-Client-Id', CLIENT_ID)
    request.add_header('X-Naver-Client-Secret', CLIENT_SECRET)
    res_json = None
    try:
        response = req.urlopen( request )
        code = response.getcode()
        if  code == 200:
            res_json = json.load( response )
            res_json['status'] = 'success'
        else:
            # 오류 발생시 어떻게 처리할지 협의 필요
            res_json = { 'status':'fail', 'code': code }
    except Exception as e:
        res_json = { 'status':'fail', 'code': -1 }
    finally:
        return res_json

results = get_search_news('카눈', display=20)

# 응답 데이터에서 제목, 요약, 등록일 정보 추출
'''
결과를 파싱해서 뽑는 최종 형태
[
    {
        'title' : '내용'
        'description' : '요약'
        'pub_date' : '날짜정보'
    }

]
'''
pattern = re.compile('<[a-z0-9]+>|</[a-z0-9]+>', re.IGNORECASE)
clean_str = lambda x:pattern.sub('', html.unescape( x ) ).strip()
final_results = [
    {
        'title'         : clean_str( news['title'] ),
        'description'   : clean_str( news['description'] ),
        'pub_date'      : news['pubDate']
    }
    for news in results[ 'items' ]
]

"""# 5. 데이터베이스 저장을 위한 DataFrame 변환
- 현재 형태 [{},{},{}....] -> DataFrame으로 변환 처리
"""
import pandas as pd

df = pd.DataFrame.from_dict(final_results) # 사전 값을 DataFrame 형태로 변환

"""# 6. 데이터베이스에 저장

- 관계형 데이터베이스에 저장
    - 정형 데이터 형태로
    - 반정형 데이터 -> 가공 -> 정형 데이터로 저장하는 과정
- DB
    - mysql, maria,
"""

# 파이썬 <->  mysql or mariadb ... 상호연동을 위해서는 해당 DB를 지원하는 패키지 설치가 필요함!
#!pip install pymysql # 로컬에서 수행해야하는 작업 -> 추후 VS-Code 사용해야함

# 필요 모듈 가져오기
import pymysql
# 고급 기능
from sqlalchemy import create_engine # db <-> mysql <-> sqlalchemy <-> pandas
import pandas.io.sql as pSql

# 접속정보
IP = '127.0.0.1'
ID = 'root'
PW = '개인root PW'
PORT = 3306
DBNAME = 'news_test'
TABLENM = 'tbl_news_test'
PROTOCAL = 'mysql+pymysql'

# 1. 접속 URL 생성 -> I/O -> with문, try ~ 병행
# 프로토콜명://아이디:비밀번호@IP(혹은도메인):포트/데이터베이스명?파라미터(인코딩...)
db_url = f'{PROTOCAL}://{ID}:{PW}@{IP}:{PORT}/{DBNAME}'

# 2. 엔진 생성
from IPython.utils import encoding
engine = create_engine(db_url) # encoding = 'utf8'

# 3. 실제 연결 (클라우드에서는 안됨)
conn = engine.connect()

#4. 데이터를 데이터베이스에 입력(밀어 넣는다)
# 테이블이 없다면 자동 생성 (테이블 자체가 효율적이지는 않다 -> 추후 수정 가능)
# 데이터는 기존 내용 지우고 덮어쓰기도 가능
# 기존 데이터에 이어서 추가도 가능 <- if_exists = 'append' : 누적해서 추가
df.to_sql(name = TABLENM, con = conn, if_exists = 'append', index=False)

# 5. 연결 닫기
conn.close()

"""# 파이썬 덤프

- 단독 실행 코드로 *.py 파일 생성
- 코드 정리
    - 불필요한 내용 제거
"""