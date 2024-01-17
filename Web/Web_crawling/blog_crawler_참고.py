import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException

driver = webdriver.Chrome()

try:
    driver.get("https://blog.naver.com/")

    # Wait for the search input to be present
    search_input = WebDriverWait(driver, 20).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, "[name='query']"))
    )
    search_input.send_keys("신한은행")

    search_button = driver.find_element_by_css_selector(".btn_submit")
    search_button.click()

    # Wait for articles to be present
    articles = WebDriverWait(driver, 20).until(
        EC.presence_of_all_elements_located((By.CSS_SELECTOR, ".post_list li"))
    )

    for article in articles:
        title = article.find_element_by_css_selector(".post_title").text
        content = article.find_element_by_css_selector(".post_content").text
        print(f"제목: {title}")
        print(f"내용: {content}")

except TimeoutException:
    print("TimeoutException: Element not found within the specified time.")
    print("Current URL:", driver.current_url)
    print("Page Source:", driver.page_source)

finally:
    driver.quit()
