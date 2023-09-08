# html을 읽어서 서버에서 동적 구성 해서 응답하기 : 서버에서 화면을 다 만들어서 전송
# ssr (SERVER SIDE RENDERING)

from flask import Flask, render_template, jsonify, request
from model import preprocessing_text, predict_lang_type

app = Flask(__name__)

# http://127.0.0.1:5000(플라스크서버)
# 라우팅 : 사용자가 요청하면 누가 처리할지 정의해주는 요소
@app.route('/')
def home():
    # render_template()
    # index.html을 읽어서 이 페이지를 요청하는 클라이언트에게 랜더링 후 전송한다.
    return render_template('index.html')

# 아무런 표기가 없으면 GET, 기타 메소드는 표기해야 한다.
# 아래 표현은 POST 전용
@app.route('/predict', methods = ['POST'])
def predict():
    #4. 서버측에서 클라이언트가 전송한 데이터 획득, 데이터는 요청(request)을 타고 들어온다
    # 데이터 추출식 변수[키] => 틀리면 오류 발생
    ori_text =  request.form.get('ori')
    print(ori_text)
    if not ori_text: # 잘못된 키로 전달되었다, 해당키가 없다
        return jsonify({'code':-1})
    
    #5. 전처리
    data = preprocessing_text(ori_text)

    #6. 모델 예측(모델을 미리 로드?, 필요시 로드? (여기서는 필요시 로드))
    res = predict_lang_type( data )

    #7. 응답
    # dict -> json 형태의 문자열로 처리해주는 함수, 응답 데이터 필요
    # 더미 데이터 => client와 server는 각각 개발 시작 가능
    #res = { 'lang':'en', 'kor':'영어','code': 1}
    return jsonify( res )

if __name__ == '__main__':
    # 서버에서는 host값을 0.0.0.0으로 세팅, 포트는 다른 포트로 변경해서 사용(알려지지 않은)
    app.run(debug = True, host='0.0.0.0', port = 3636)