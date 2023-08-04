'''
    유틸리티 함수 모음
'''
IS_DEV = True

def log(msg):
    if IS_DEV:
        print(msg)

def game_print(msg) :
    '''
        게임 진행상 콘솔에 출력하는 함수
        기존 print 함수를 wrapping 해서 처리
    '''
    #print('-'*30)
    print(msg)
    #print('-'*30)