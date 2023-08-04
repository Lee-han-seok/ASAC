'''
    절차적 방식으로 작성된 게임 코드를 함수 지향적으로 마이그레이션 수행
    - 모듈화 가능
        - 메인 : game_ex.py (간단한 큰틀 설정, 함수 호출, 배치등만 구현)
        - 모듈 : engine > ai.py(난수 생성), play.py(게임 진행)
'''
from engine.play import step1, step2, step3, step4, step5, step6
from util import log, game_print

def main():
    step3(step1(), step2())
    
    is_game_playing = True # 게임중임으로 의미하는 플래그 변수(상태 컨트롤용)
    while is_game_playing :
        ai_number = step5(step4())
        is_game_playing = step6()
    pass

if __name__ == '__main__':
    main()