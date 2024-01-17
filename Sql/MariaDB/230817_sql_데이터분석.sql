SHOW DATABASES;

USE cars;

SHOW TABLES;

-- 데이터 모두 병합
SELECT G.order_no, G.mem_no, G.order_date, G.store_cd, G.prod_cd, G.quantity, G.store_addr, G.gender, G.age, G.addr, G.join_date, H.brand, H.`type`, H.model, H.price
FROM (SELECT E.order_no, E.mem_no, E.order_date, E.store_cd, E.prod_cd, E.quantity, E.store_addr, F.gender, F.age, F.addr, F.join_date
FROM (SELECT C.order_no, C.mem_no, C.order_date, C.store_cd, C.prod_cd, C.quantity, D.store_addr
FROM (SELECT A.order_no, A.mem_no, A.order_date, A.store_cd, B.prod_cd, B.quantity
FROM car_order AS A
LEFT JOIN car_orderdetail AS B ON A.order_no = B.order_no) AS C
LEFT JOIN car_store AS D ON C.store_cd = D.store_cd) AS E
LEFT JOIN car_member AS F ON E.mem_no = F.mem_no) AS G
LEFT JOIN car_product AS H ON G.prod_cd = H.prod_cd;

-- price가 varchar임!! 형변환이 필요함 : cast
CREATE VIEW car_mart2
AS SELECT I.order_no, I.mem_no, I.order_date, I.store_cd, I.prod_cd, I.quantity, I.price, I.brand, 
carsI.quantity * CAST(replace(I.price,',','') AS UNSIGNED) AS sales_amt, I.store_addr, I.gender, I.age, I.addr, I.join_date
FROM (SELECT G.order_no, G.mem_no, G.order_date, G.store_cd, G.prod_cd, G.quantity, G.store_addr, G.gender, G.age, G.addr, G.join_date, H.brand, H.`type`, H.model, H.price
FROM (SELECT E.order_no, E.mem_no, E.order_date, E.store_cd, E.prod_cd, E.quantity, E.store_addr, F.gender, F.age, F.addr, F.join_date
FROM (SELECT C.order_no, C.mem_no, C.order_date, C.store_cd, C.prod_cd, C.quantity, D.store_addr
FROM (SELECT A.order_no, A.mem_no, A.order_date, A.store_cd, B.prod_cd, B.quantity
FROM car_order AS A
LEFT JOIN car_orderdetail AS B ON A.order_no = B.order_no) AS C
LEFT JOIN car_store AS D ON C.store_cd = D.store_cd) AS E
LEFT JOIN car_member AS F ON E.mem_no = F.mem_no) AS G
LEFT JOIN car_product AS H ON G.prod_cd = H.prod_cd) AS I;

SELECT * FROM car_mart2 LIMIT 5;

SELECT age_band, gender ,COUNT(*) AS gender_count FROM user_profile_base GROUP BY age_band, gender;

SELECT age_band, gender, YEAR(order_date),COUNT(YEAR(order_date)) FROM user_profile_base GROUP BY age_band, gender, YEAR(order_date);

SELECT gender, age_band, 
COUNT(case when YEAR(order_date)=2020 then mem_no end) AS mem_count20, 
COUNT(case when YEAR(order_date)=2021 then mem_no end) AS mem_count21 
FROM user_profile_base GROUP BY gender, age_band;
####################
SELECT mem_no, SUM(sales_amt) AS pay_amt
FROM user_profile_base
GROUP BY mem_no
ORDER BY pay_amt DESC;
####################
SELECT mem_no, count(*) AS buy_amt
FROM user_profile_base
GROUP BY mem_no
ORDER BY buy_amt DESC;

-- RFM 분석
-- View 생성
CREATE VIEW rfm_base 
AS SELECT mem_no ,SUM(sales_amt) AS total_amt, count(*) AS total_fr
FROM car_mart
WHERE YEAR(order_date) BETWEEN 2020 AND 2021
GROUP BY mem_no;

SELECT A.mem_no, A.gender, A.age, A.addr, A.join_date, B.total_amt, B.total_fr, B.level
FROM car_member AS A
LEFT JOIN (SELECT *, 
case when total_amt >= 2000000000 AND total_fr >= 3 then 'VVIP'
	  when total_amt >= 1000000000 AND total_fr >= 2 then 'VIP'
	  when total_amt >= 500000000 then 'GOLD'
	  when total_amt >= 300000000 then 'SILVER'
	  ELSE 'BRONZE' END AS 'level'
FROM rfm_base) AS B ON A.mem_no = B.mem_no;

CREATE VIEW rfm_base_level 
as SELECT A.*, B.total_amt, B.total_fr, 
case when total_amt >= 2000000000 AND total_fr >= 3 then 'VVIP'
	  when total_amt >= 1000000000 AND total_fr >= 2 then 'VIP'
	  when total_amt >= 500000000 then 'GOLD'
	  when total_amt >= 300000000 then 'SILVER'
	  when total_fr >= 1 then 'BRONZE'
	  ELSE 'stone' END AS 'level'
FROM car_member AS A
LEFT JOIN rfm_base AS B ON A.mem_no = B.mem_no;

SELECT * FROM car

SELECT LEVEL, COUNT(*) AS population, SUM(total_amt) AS total_amt  
FROM rfm_base_level
GROUP BY LEVEL
ORDER BY total_amt;

CREATE VIEW rfm_recency 
AS

SELECT * FROM car_mart;

SELECT mem_no, order_no, order_date
case when YEAR(order_date) IN (2020,2021) then 'Y'
ELSE 'N' end AS 'yn'
FROM car_mart
group by mem_no, order_date;

SELECT mem_no, YEAR(order_date) AS order_year, COUNT(*)
FROM car_mart
GROUP BY mem_no, order_year;

# 2020년 구매자 회원번호 -> car_mart
SELECT A.mem_no AS ori_2020_mem_no, B.mem_no AS ori_2021_mem_no,
case when B.mem_no IS not NULL then 'Y' ELSE 'N' END AS yn
FROM 
(SELECT distinct(mem_no)
FROM car_mart
WHERE YEAR(order_date) = 2020) AS A
LEFT JOIN 
# 2021년 구매자 회원 번호
(SELECT distinct(mem_no)
FROM car_mart
WHERE YEAR(order_date) = 2021) AS B
on A.mem_no = B.mem_no;

SELECT
	COUNT(case when yn = 'y' then ori_2020_mem_no END)
	/COUNT(ori_2020_mem_no) * 100 AS rate
FROM buy_record_base;

CREATE VIEW buy_cycle_base as
SELECT store_cd, MIN(order_date) AS min_order_date, 
MAX(order_date) as max_order_date, count(DISTINCT(order_no)) AS total_cycle
FROM car_mart
GROUP BY store_cd
HAVING total_cycle > 2;

SELECT *, DATEDIFF(max_order_date, min_order_date) / total_cycle AS buy_cycle
FROM buy_cycle_base
ORDER BY buy_cycle ASC;

CREATE VIEW product_growth_base AS
SELECT brand, model, 
SUM(case when YEAR(order_date) = 2020 then sales_amt end) AS total_amt_2020, 
SUM(case when YEAR(order_date) = 2021 then sales_amt end) AS total_amt_2021
FROM car_mart
GROUP BY brand, model;

SELECT A.*, ROW_NUMBER() OVER(partition BY brand ORDER BY growth_per desc ) AS RANK 
FROM (select brand, model, sum(total_amt_2021)/sum(total_amt_2020) -1 as growth_per
from product_growth_base
group by brand, model 
ORDER BY brand, growth_per) AS A ;





