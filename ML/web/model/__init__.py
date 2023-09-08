import re
import joblib

def preprocessing_text(ori_text : str) -> list:
    '''
        원문 텍스트 데이터가 오면, 모델이 예측할 수 있는 2차원 리스트 형태로 전처리하여 반환
    '''
     # 1회만 지정
    p      = re.compile('[^a-z]*')
    STD_A_ASCII = ord('a')

    # 피처 추출
    text        = p.sub( '', ori_text.lower() )
    counts      = [0]*26
    for ch in text:
        counts[ ord(ch) - STD_A_ASCII ] += 1
    total_count = sum(counts)
    count_norms = list(map( lambda x:x/total_count, counts))
    return [count_norms]

def predict_lang_type(data : list) -> dict :
    '''
        모델, 정답 레이블 로드, 예측, 응답 데이터 구성    
    '''
    # 모델 로드
    clf = joblib.load('./web/model/lang_predict.ml')
    # 정답 로드
    labels = joblib.load('./web/model/lang_predict.lb')
    # 예측
    pred_y = clf.predict(data)
    print('예측결과', pred_y[0])
    return {
        'lang':pred_y[0], 
        'kor':labels[pred_y[0]], 
        'code': 1
    }

if __name__ == '__main__':
    print(predict_lang_type(preprocessing_text('''
                             ChatGPT —  pour Chat Generative Pre-trained Transformer (en) — est un prototype d'agent conversationnel utilisant l'intelligence artificielle, 
                            développé par OpenAI et spécialisé dans le dialogue.
                            L'agent conversationnel de ChatGPT repose sur les technologies du traitement automatique des langues (NLP), 
                            des grands modèles de langage (LLM) et des chatbots. Il est issu du modèle de langage GPT d'OpenAI, 
                            et est affiné en continu grâce à l'utilisation de techniques d'apprentissage supervisé et d'apprentissage par renforcement.
                             ''')))