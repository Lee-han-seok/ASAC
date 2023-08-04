import random     
from config import AI_CREATE_NUM_MIN, AI_CREATE_NUM_MAX
from util import log

def create_random_number() :
    # TODO step4
    # 차후 최종 게임이 완성되면 위치가 조정될 수 있다. 게임이 시작되면 매번 수행되는 코드
    ai_number = random.randint(AI_CREATE_NUM_MIN, AI_CREATE_NUM_MAX)
    log(f'step4 완성, AI 생성값은={ai_number}')
    return ai_number