# TODO step 0
is_dev_mode = True # 현재는 개발모드로 step 1~3은 건너뛰도록 설정.

# is_dev_mode 가 참이면 game_title값은 'N...'  이고, 거짓이면 None이다
game_title = 'Number Matching Game' if is_dev_mode else None
player_name = 'guest' if is_dev_mode else None

# TODO step 1
GAME_TITLE_MAX_LENGTH = 28
GAME_START_PROMPT = f"게임 제목을 입력해주세요. 최대 {GAME_TITLE_MAX_LENGTH}자이내, 영문/숫자 조합으로 입력하세요\n >"
ERROR_MSG_1 = "정확하게 입력하세요"

while not is_dev_mode: # 개발모드일때 제목 입력은 않받겠다 (설정) 
    game_title = input(GAME_START_PROMPT).strip()
    if not game_title:
        print(ERROR_MSG_1)
    elif len(game_title) > GAME_TITLE_MAX_LENGTH:
        # 초과됨 글자수를 포함시켜서 메시지 처리
        # 입력하신 제목은 5자가 초과되었습니다.
        print(f'입력하신 제목은 { len(game_title) - GAME_TITLE_MAX_LENGTH }자가 초과되었습니다.')
    else:
        break
print( f'step1 완료, 게임제목은={game_title}' )

# TODO step 2
PLAYER_NAME_MAX_LENGTH = GAME_TITLE_MAX_LENGTH
PLAYER_NAME_INPUT_PROMPT = f"플레이어 이름을 입력해주세요. 최대 {PLAYER_NAME_MAX_LENGTH}자이내, 영문/숫자 조합으로 입력하세요\n >"
ERROR_MSG_2 = "정확하게 입력하세요"

while not is_dev_mode: # 개발모드일때 이름 입력은 않받겠다 (설정)
    player_name = input(PLAYER_NAME_INPUT_PROMPT).strip()
    if not player_name:
        print(ERROR_MSG_2)
        continue
    if len(player_name) > PLAYER_NAME_MAX_LENGTH:
        print(f'입력하신 이름은 { len(player_name) - PLAYER_NAME_MAX_LENGTH }자가 초과되었습니다.')
        continue    
    break
print( f'step2 완료, 플레이어 이름은={player_name}' )

# TODO step 3
GAME_INTRO_MAX_LINE = GAME_TITLE_MAX_LENGTH + 4
INTRO_ICON = '-'
GAME_VERSION = 'ver 1.0.0'
# 인트로 연출
print( INTRO_ICON * GAME_INTRO_MAX_LINE )
print( f'{INTRO_ICON} {game_title:^28} {INTRO_ICON}' )
print( f'{INTRO_ICON} {player_name:^28} {INTRO_ICON}' )
print( f'{INTRO_ICON} {GAME_VERSION:^28} {INTRO_ICON}' )
print( INTRO_ICON * GAME_INTRO_MAX_LINE )

is_game_playing = True # 게임중임으로 의미하는 플래그 변수(상태 컨트롤용)
while is_game_playing :
    # TODO step4
    # 차후 최종 게임이 완성되면 위치가 조정될 수 있다. 게임이 시작되면 매번 수행되는 코드
    import random 
    AI_CREATE_NUM_MIN = 1
    AI_CREATE_NUM_MAX = 100
    ai_number = random.randint(AI_CREATE_NUM_MIN, AI_CREATE_NUM_MAX)
    print(f'step4 완성, AI 생성값은={ai_number}')

    # TODO step5

    # 0. 프럼프트 준비 및 출력 -> 문구의 내용은 변경되지 않는다. -> 1회만 초기화
    ERROR_MSG_3 = "정수형태로 다시 입력하세요 ex) 5, 22, 77"
    ERROR_MSG_4 = "1부터 100사이의 숫자로 다시 입력하세요"
    ERROR_MSG_5 = "AI의 숫자가 Player가 선택한 숫자보다 큽니다"
    ERROR_MSG_6 = "AI의 숫자가 Player가 선택한 숫자보다 작습니다"
    SUCCESS_MSG_1 = '정답입니다.'
    YOUR_INPUT_PROMPT = f'{AI_CREATE_NUM_MIN}~{AI_CREATE_NUM_MAX}사이 중 하나의 값을 넣으세요. \n >'

    # 시도횟수
    try_count = 0
    while True :
        while True :
            # 1. 사용자가 입력 -> 문자열 타입임 (input으로 받는 모든 값!)
            player_number = input(YOUR_INPUT_PROMPT).strip()
            # 2. 값 검사 -> 부정상황 체크
            if not player_number : # 빈 값이면 다시
                print(ERROR_MSG_4)
                continue
            elif not player_number.isnumeric(): # 정수가 아니면 False 출력
                print(ERROR_MSG_3)
                continue
            else : # 1보다 작거나 100보다 크면 다시
                # 정수로 보이는 문자열 -> 실제 정수 타입으로 변환
                # str -> int : 형변환(type casting)
                player_number = int(player_number)
                if (player_number < 1) or (player_number > 100) : 
                    print(ERROR_MSG_4)
                    continue # continue는 가장 가까운 반복문으로 jump
            # 3. 입력값이 정상이다 -> 반복문 종료
            break

        # AI값과 플레이어의 값을 비교
        try_count += 1
        if player_number > ai_number :
            print(ERROR_MSG_5) # 크다
        elif player_number < ai_number : # 작다
            print(ERROR_MSG_6)
        else : # 정답
            print(SUCCESS_MSG_1)
            # 점수 출력 (10-시도횟수) * 10
            print(f'이번 스테이지 점수는 {(10 - try_count) * 10}점 입니다.')
            break # 나를 감싸고 있는 가장 가까운 반복문으로 
    print(f'step5 완료, 사용자 입력값 = {player_number}')

    # TODO step6
    GAME_RETRY_PROMPT = '다시 게임을 하시겠습니까?'
    GAME_OVER_MSG = '게임 종료.'
    while True :
        answer = input(GAME_RETRY_PROMPT).lower().strip()
        if answer == 'yes' or answer == 'y' :
            # step4로 진입해야함.
            break
        elif answer == 'no' or answer == 'n' :
            print(GAME_OVER_MSG)
            # 프로그램 종료 -> 수행할 코드가 더이상 없게 조치 or exit()
            is_game_playing = False
            break
        else :
            print(ERROR_MSG_1)
            pass

