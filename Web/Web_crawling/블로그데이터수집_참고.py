import pandas as pd
import os
import sys
from selenium import webdriver as wd
import time
import selenium
from selenium.webdriver.common.by import By
from sqlalchemy import create_engine
import re
from datetime import datetime
import re
import random
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

site = "https://section.blog.naver.com/Search/Post.naver?pageNo=1&rangeType=ALL&orderBy=sim&keyword=%EB%B8%94%EB%A1%9C%EA%B7%B8%20%EB%B0%B1%EB%AC%B8%EB%B0%B1%EB%8B%B5"

# 백문백답 창

driver = wd.Chrome()
driver.get(site)

# 개인 블로그 창
driver_blog = wd.Chrome()

# css
title_css = "#content > section > div.area_list_search > div:nth-child({}) > div > div.info_post > div.desc > a.desc_inner > strong"
page_css = "#content > section > div.pagination > span:nth-child({}) > a"
next_page_css = "#content > section > div.pagination > a"
b_site_css = "#content > section > div.area_list_search > div:nth-child({}) > div > div.info_post > div.desc > a.desc_inner"
text_css = ".se-main-container"
all_title_css = "#category0"
next_title_css = "#listTopForm > table > tbody > tr:nth-child({}) > td.title > div > span "
#listTopForm > table > tbody > tr:nth-child(2) > td.title > div > span > a
#listTopForm > table > tbody > tr:nth-child(2) > td.title > div 
#listTopForm > table > tbody > tr:nth-child(2) > td.title > div > span
list_css = "#toplistSpanBlind"
# mbti list
mbti_list = [
    'ESFP','ESFJ','ESTP','ESTJ',
    'ENFP','ENFJ','ENTP','ENTJ',
    'ISFP','ISFJ','ISTP','ISTJ',
    'INFP','INFJ','INTP','INTJ']

# 정규식 표현
p = re.compile("[ESFP|ESFJ|ESTP|ESTJ|ENFP|ENFJ|ENTP|ENTJ|ISFP|ISFJ|ISTP|ISTJ|INFP|INFJ|INTP|INTJ]{4}")

# 딕셔너리
mbti_dict ={
    'mbti' : [],
    "str" : []
}


#로그 제목 순서 css  : 한페이지에 1~7

# 블로그 한 페이지 

def page_text_cr():
    for i in range(1, 8):
        b_site = driver.find_element(By.CSS_SELECTOR, b_site_css.format(i))
        driver_blog.get(b_site.get_attribute('href'))
        iframe = driver_blog.find_element(By.CSS_SELECTOR, '#mainFrame')
        driver_blog.switch_to.frame(iframe)

        try:
            # .se-main-container 엘리먼트가 나타날 때까지 최대 20초까지 대기
            WebDriverWait(driver_blog, 20).until(
                EC.presence_of_element_located((By.CSS_SELECTOR, '.se-main-container'))
            )

            text_all = driver_blog.find_element(By.CSS_SELECTOR, text_css)

            # 읽어온 텍스트에서 mbti 뽑아내기
            mbti = ""
            mbti_ = p.search(text_all.text.upper())

            text_list = []
            if not mbti_:
                # mbti 없으면 다음 블로그로 넘어가기
                continue
            else:
                mbti = mbti_.group()

            # 전체글보기
            all_title = driver_blog.find_element(By.CSS_SELECTOR, all_title_css)
            all_title.click()

            for j in range(1, 6):
                # 글이 없을 때까지 시도
                try:
                    next_title = driver_blog.find_element(By.CSS_SELECTOR, next_title_css.format(j))
                    next_title.click()
                    text_all = driver_blog.find_element(By.CSS_SELECTOR, text_css)
                    text_list.append(text_all.text)
                    time.sleep(random.randrange(3, 7))
                except NoSuchElementException:
                    break

            mbti_dict['mbti'].append(mbti)
            mbti_dict['str'].append(text_list)

            data = pd.DataFrame(mbti_dict)
            data.to_csv('MBTI_blog.csv', index=False, mode='a')
            
        except Exception as e:
            print(f"Error: {e}")
            continue

# 초기 페이지 크롤링
page_text_cr()

# 다음 페이지 크롤링
for j in range(2, 12):
    page_text_cr()

print(mbti_dict)