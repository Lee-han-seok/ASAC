# 모듈의 경로는 엔트리포인트에서부터 체크해서 내려온다, 나의 위치는 상관없다.
from util import log, game_print
from config import *
import engine.ai as ai

def step1():
    log('step1 호출')
    game_title = None
    while True: # 개발모드일때 제목 입력은 않받겠다 (설정) 
        game_title = input(GAME_START_PROMPT).strip()
        if not game_title:
            game_print(ERROR_MSG_1)
        elif len(game_title) > GAME_TITLE_MAX_LENGTH:
            # 초과됨 글자수를 포함시켜서 메시지 처리
            # 입력하신 제목은 5자가 초과되었습니다.
            game_print(f'입력하신 제목은 { len(game_title) - GAME_TITLE_MAX_LENGTH }자가 초과되었습니다.')
        else:
            break
    log( f'step1 완료, 게임제목은={game_title}' )
    # 게임 제목 리턴 => step3에서 사용되니까
    return game_title

def step2():
    log('step2 호출')
    player_name = None
    while True: # 개발모드일때 이름 입력은 않받겠다 (설정)
        player_name = input(PLAYER_NAME_INPUT_PROMPT).strip()
        if not player_name:
            game_print(ERROR_MSG_2)
            continue
        if len(player_name) > PLAYER_NAME_MAX_LENGTH:
            game_print(f'입력하신 이름은 { len(player_name) - PLAYER_NAME_MAX_LENGTH }자가 초과되었습니다.')
            continue    
        break
    log( f'step2 완료, 플레이어 이름은={player_name}' )
    return player_name


def step3(game_title, player_name):
    log('step3 호출')
    print( INTRO_ICON * GAME_INTRO_MAX_LINE )
    print( f'{INTRO_ICON} {game_title:^28} {INTRO_ICON}' )
    print( f'{INTRO_ICON} {player_name:^28} {INTRO_ICON}' )
    print( f'{INTRO_ICON} {GAME_VERSION:^28} {INTRO_ICON}' )
    print( INTRO_ICON * GAME_INTRO_MAX_LINE )
        
def step4() -> int:
    log('step4 호출')
    return ai.create_random_number()
    # TODO step4
    # 차후 최종 게임이 완성되면 위치가 조정될 수 있다. 게임이 시작되면 매번 수행되는 코드


    pass

def step5(ai_number : int) -> None:
    log('step5 호출')
    # TODO step5
    # 시도횟수
    try_count = 0
    while True :
        while True :
            # 1. 사용자가 입력 -> 문자열 타입임 (input으로 받는 모든 값!)
            player_number = input(YOUR_INPUT_PROMPT).strip()
            # 2. 값 검사 -> 부정상황 체크
            if not player_number : # 빈 값이면 다시
                game_print(ERROR_MSG_4)
                continue
            elif not player_number.isnumeric(): # 정수가 아니면 False 출력
                game_print(ERROR_MSG_3)
                continue
            else : # 1보다 작거나 100보다 크면 다시
                # 정수로 보이는 문자열 -> 실제 정수 타입으로 변환
                # str -> int : 형변환(type casting)
                player_number = int(player_number)
                if (player_number < AI_CREATE_NUM_MIN) or (AI_CREATE_NUM_MAX > 100) : 
                    game_print(ERROR_MSG_4)
                    continue # continue는 가장 가까운 반복문으로 jump
            # 3. 입력값이 정상이다 -> 반복문 종료
            break

        # AI값과 플레이어의 값을 비교
        try_count += 1
        if player_number > ai_number :
            game_print(ERROR_MSG_5) # 크다
        elif player_number < ai_number : # 작다
            game_print(ERROR_MSG_6)
        else : # 정답
            game_print(SUCCESS_MSG_1)
            # 점수 출력 (10-시도횟수) * 10
            game_print(f'이번 스테이지 점수는 {(10 - try_count) * 10}점 입니다.')
            break # 나를 감싸고 있는 가장 가까운 반복문으로 
    print(f'step5 완료, 사용자 입력값 = {player_number}')
    pass

def step6() -> bool:
    log('step6 호출')
    is_game_playing = True
    while True :
        answer = input(GAME_RETRY_PROMPT).lower().strip()
        if answer == 'yes' or answer == 'y' :
            # step4로 진입해야함.
            break
        elif answer == 'no' or answer == 'n' :
            game_print(GAME_OVER_MSG)
            # 프로그램 종료 -> 수행할 코드가 더이상 없게 조치 or exit()
            is_game_playing = False
            break
        else :
            print(ERROR_MSG_1)
            pass
    return is_game_playing