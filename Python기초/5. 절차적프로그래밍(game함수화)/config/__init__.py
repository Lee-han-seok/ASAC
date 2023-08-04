'''
    환경변수, 리소스 정의
'''
GAME_TITLE_MAX_LENGTH = 28
GAME_START_PROMPT = f"게임 제목을 입력해주세요. 최대 {GAME_TITLE_MAX_LENGTH}자이내, 영문/숫자 조합으로 입력하세요\n >"
ERROR_MSG_1 = "정확하게 입력하세요"

PLAYER_NAME_MAX_LENGTH = GAME_TITLE_MAX_LENGTH
PLAYER_NAME_INPUT_PROMPT = f"플레이어 이름을 입력해주세요. 최대 {PLAYER_NAME_MAX_LENGTH}자이내, 영문/숫자 조합으로 입력하세요\n >"
ERROR_MSG_2 = "정확하게 입력하세요"

GAME_INTRO_MAX_LINE = GAME_TITLE_MAX_LENGTH + 4
INTRO_ICON = '-'
GAME_VERSION = 'ver 1.0.0'

AI_CREATE_NUM_MIN = 1
AI_CREATE_NUM_MAX = 100

ERROR_MSG_3 = "정수형태로 다시 입력하세요 ex) 5, 22, 77"
ERROR_MSG_4 = "1부터 100사이의 숫자로 다시 입력하세요"
ERROR_MSG_5 = "AI의 숫자가 Player가 선택한 숫자보다 큽니다"
ERROR_MSG_6 = "AI의 숫자가 Player가 선택한 숫자보다 작습니다"
SUCCESS_MSG_1 = '정답입니다.'
YOUR_INPUT_PROMPT = f'{AI_CREATE_NUM_MIN}~{AI_CREATE_NUM_MAX}사이 중 하나의 값을 넣으세요. \n >'

GAME_RETRY_PROMPT = '다시 게임을 하시겠습니까?'
GAME_OVER_MSG = '게임 종료.'