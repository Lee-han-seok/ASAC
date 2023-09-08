#1. 플라스크 모듈 가져오기
from flask import Flask

#2. 플라스크 객체 생성
app = Flask(__name__)

#3. 라우팅 및 응답 페이지
@app.route('/')
def home():
    # 홈페이지
    return 'hello flask web'

#4. 서버가동
if __name__ == '__main__':
    # 수정 => 저장 => 새로고침 => 반영 : 디버깅 모드 활성화
    app.run(debug = True)