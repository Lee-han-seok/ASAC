-- 문자열 길이 체크
SELECT LENGTH('hi');
SELECT LENGTH('HI');
SELECT LENGTH('가나');
SELECT LENGTH('12');
SELECT LENGTH('!@');

-- city2 테이블에서 도시 이름, 도시 이름 길이 출력
-- 이름 길이의 칼럼명 size
-- 이름 길이순으로 내림차순 정렬
-- 상위 5개만 출력
SELECT NAME, LENGTH(NAME) AS size
FROM city2
ORDER BY size desc
LIMIT 5;

-- 수치값을 가진 칼럼의 길이를 계산?
-- 길이를 추출하는 대상이 반드시 문자열일 필요는 없다
SELECT NAME, population, LENGTH(population) AS size
FROM city2

-- 기본 결합
SELECT CONCAT('hello','-','world');

-- null이 있다면?
SELECT CONCAT('hello',null,'world');

-- 칼럼 결합
SELECT CONCAT(NAME, '-', population) AS spec
FROM city2;

-- LOCATE
SELECT LOCATE('W', 'WORLD');

# 없는 문자열 0 반환
SELECT LOCATE('Z', 'WORLD');

# 칼럼에 적용도 가능하다
SELECT NAME, LOCATE('se', NAME) AS loc
FROM city2;

-- city2 테이블에서 도시 이름중 se로 시작하는 도시들을 찾아서
-- 그 위치값이 1이상이고 4보다 작은 데이터들을 위치값 기준 오름차순 정렬
-- 출력값은 도시명, 위치값(loc), where절이 아닌 having을 사용해야한다
-- 동적으로 생성된 칼럼을 조건에 사용 => having
-- 조건 부여시 이미 칼럼이 존재했다면 => where
select *
FROM (SELECT NAME, LOCATE('se', NAME) AS loc
FROM city2) AS A
WHERE A.loc > 0 AND A.loc <3
ORDER BY A.loc;

SELECT NAME, LOCATE('se', NAME) AS loc
FROM city2
HAVING loc BETWEEN 1 AND 2
ORDER BY loc ;

-- left, right
SELECT LEFT('hello world', 3);

SELECT RIGHT('hellow world', 3);

SELECT LEFT(NAME,3), NAME, RIGHT(NAME,3)
FROM city2;

-- LOWER(), UPPER()
SELECT LOWER('abAB가나12!@');
SELECT UPPER('abAB가나12!@');

-- 칼럼 적용
SELECT LOWER(NAME), NAME, UPPER(NAME)
FROM city2;

-- REPLACE
SELECT REPLACE('abcD가나123!@#', 'ef', '-비씨-');

-- 수치데이터 대체
SELECT population, REPLACE(population, '0', '*')
FROM city2;

-- TRIM() : 특정 문자, 공백 제거 (지정자 BOTH, LEADING, TRAILING)
-- 앞뒤 공백 제거, 앞 공백 제거, 뒤 공백 제거
SELECT TRIM('  @@@ A @@@  '),
TRIM(LEADING '@' FROM '@@@ A @@@'),
TRIM(TRAILING '@' FROM '  @@@ A @@@  '),
TRIM(BOTH '@' FROM '  @@@ A @@@  ')
;

-- 한국 도시명에서 첫글자 S 제거(존재하면) 이름, S가 제거된 이름
SELECT NAME, TRIM(LEADING 'S' FROM NAME)
FROM city2
where countrycode = 'kor';

-- formatt
SELECT FORMAT(123123123123123123.456456456, 3),
		 FORMAT(123123123123123123.456456456, 4);
		 
SELECT population, FORMAT(population, 0)
FROM city2;

-- floor, ceil, round
SELECT FLOOR(3.95), CEIL(3.95), CEIL(3.91), ROUND(3.5), ROUND(3.4);

-- SQRT, POW, EXP, LOG
SELECT SQRT(4), POW(2, 3), EXP(3), LOG(20) ;

-- PI, SIN, COS, TAN
SELECT PI(), SIN(PI()/2), COS(PI()), TAN(PI()/4) 

-- ABS, RAND
SELECT ABS(-1), RAND(), ROUND(RAND()*10, 0) ; 

-- 1 <= x <= 100
SELECT 1+ROUND(RAND()*99, 0);

-- STD( ), VARIANCE( )
SELECT STD(population), VARIANCE(population)
FROM city2

-- 국가별 도시의 개수를 구해서 
-- 그 개수가 50개 이상인 국가만 모아서
-- 그 국가의 인구수 표준편차를 구해서
-- 오름차순 정렬하시오 (출력 : 국가코드, 표준편차)
SELECT A.countrycode, A.st AS 표준편차
FROM (SELECT countrycode, STD(population) AS st
	   FROM city2
		GROUP BY countrycode
		HAVING COUNT(*) >= 50) AS A
ORDER BY 표준편차 ;

-- 다른 풀이
SELECT countrycode, round(STD(Population), 1) AS st
FROM city2
GROUP BY countrycode
HAVING COUNT(countrycode) >= 50
ORDER BY st ASC;

-- 시간 함수들
SELECT NOW(), CURDATE(), CURTIME();

SELECT RIGHT(CURDATE(),5), LEFT(CURTIME(),5);

SELECT NOW(), DATE(NOW()), MONTH(NOW()), DAY(NOW()), 
		HOUR(NOW()), MINUTE(NOW()), SECOND(NOW()) ;
		
SELECT NOW(), MONTHNAME(NOW()), DAYNAME(NOW());

SELECT NOW(), DAYOFWEEK(NOW()), DAYOFMONTH(NOW()), DAYOFYEAR(NOW());

SELECT DATE_FORMAT(NOW(), '%D %y %s %d %m %j')

SELECT abs(DATEDIFF(NOW(), '2023-07-26'));

-- DDL
-- CREATE
CREATE TABLE city2_copy2 AS SELECT * FROM city2;

-- city2_sub 테이블 생성
-- city2 테이블을 기반, 국가코드가 한국, 미국, 일본만 대상으로 생성
-- 국가코드, 이름, 인구수만 추가하시오
CREATE TABLE city2_sub AS SELECT countrycode, NAME, population 
FROM city2
WHERE countrycode in('usa', 'kor', 'jpn');

-- 테이블을 만들어보자! (회원 테이블)
CREATE TABLE users(
	id INT NOT NULL PRIMARY KEY , 
	age int NULL, 
	uid VARCHAR(32) NOT NULL, 
	pwd VARCHAR(128) NOT NULL,  
	email VARCHAR(64) NULL,    
	regdate TIMESTAMP NOT NULL);

-- 칼럼 추가해보자
ALTER TABLE users
ADD col INT NULL;

DESC users;

ALTER TABLE users
modify col VARCHAR(128);

DESC users;

-- 칼럼 삭제
ALTER TABLE users
DROP col;

DESC users;

-- 해당 테이블의 모든 인덱스 출력
SHOW INDEX FROM users;

-- 인덱스 생성
CREATE INDEX name_idx
ON users (uid);

SHOW INDEX FROM users;

# Unique Index
CREATE unique INDEX email_idx
ON users (email);

SHOW INDEX FROM users;

# 멀티 Column의 인덱스 생성 (uid, email)
CREATE UNIQUE INDEX uid_email_idx
ON users (uid, email);

SHOW INDEX FROM users;

-- index 삭제
ALTER TABLE users
DROP INDEX email_idx;

SHOW INDEX FROM users;

-- FULLTEXT INDEX
ALTER TABLE users
ADD FULLTEXT uid_check(uid);

SHOW INDEX FROM users;

-- VIEW
-- VIEW 생성

CREATE VIEW city_view 
AS SELECT NAME, population FROM city2;

SELECT * FROM city_view;

-- VIEW 수정 (ALTER VIEW)
ALTER VIEW city_view 
AS SELECT countrycode ,population FROM city2;

SELECT * FROM city_view;

DROP VIEW city_View;

SELECT * FROM city_view;

-- city2, country2, countrylanguage 조인
-- 한국에 대한 정보만 뷰로 생성한다.
-- total_kor_view, 칼럼 : 도시명, 면적, 인구수, language
# city2
SELECT countrycode, NAME, population 
FROM city2
WHERE countrycode = 'kor';

# country2
SELECT code, NAME, surfacearea
FROM country2
WHERE CODE = 'kor';

# countrylanguagecountrylanguage
SELECT countrycode, LANGUAGE
FROM countrylanguage
WHERE countrycode = 'kor';

# Join & create View
CREATE VIEW total_kor_view as
SELECT A.name, B.surfacearea, A.population, c.language
FROM (SELECT countrycode, NAME, population FROM city2 WHERE countrycode = 'kor') AS A
JOIN (SELECT code, NAME, surfacearea FROM country2 WHERE CODE = 'kor') AS B ON A.countrycode = B.code
JOIN (SELECT countrycode, LANGUAGE FROM countrylanguage WHERE countrycode = 'kor') AS C ON A.countrycode = C.countrycode;
	
## DML (users2 테이블 생성)
CREATE TABLE users2(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
	`age` int NULL, 
	uid VARCHAR(32) NOT NULL, 
	pwd VARCHAR(128) NOT NULL,  
	email VARCHAR(64) NULL,    
	regdate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);
	
SHOW TABLES;

-- 입력 1, 칼럼을 나열해서 입력 (필수 칼럼은 반드시 포함해야함)
-- 자동 입력 칼럼(id, regdate)는 생략 가능하다는 뜻!
INSERT INTO users2 
(`age`, uid, email, pwd)
VALUE (10, 'a', 'a@a.com', '1234');

-- values
INSERT INTO users2 
VALUES (3, 12, 'a2', '1234','a1@a.com', NOW());

-- 멀티 데이터 입력
INSERT INTO users2 
(`age`, uid, email, pwd)
VALUES (14, 'a4', 'a4@a.com', '1234'),
		 (15, 'a5', 'a5@a.com', '1234'),
		 (16, 'a6', 'a6@a.com', '1234');
		 

-- insert into ~ select
INSERT INTO users2 SELECT * from users;


SELECT * FROM users2;
-- 수정
-- 2번 유저의 uid 수정
UPDATE users2
SET uid='new_uid', age = age + 100
WHERE id = 2;

-- DELETE 데이터 삭제
-- 회원가입시 고객 정보 유지 시간 1년 동의 X
-- 탈퇴후 바로 전체 데이터를 삭제하는것 처리
-- 조건은 데이터를 특정할 수 있는 값(기본키, unique값)

DELETE FROM users2
WHERE id = 200; 

-- 제약조건
-- 2개 테이블 생성, 1:N연결, 데이터 입력 후 삭제
CREATE TABLE country(
	country_id INT, 
	NAME VARCHAR(50),
	population INT, 
	PRIMARY KEY (country_id)
);

CREATE TABLE city5(
	city_id INT, 
	NAME VARCHAR(50), 
	country_id INT,
	PRIMARY KEY (city_id),
	FOREIGN KEY (country_id) REFERENCES country(country_id) 
	ON DELETE CASCADE	
);country

-- 삭제, country에서 특정 국가를 삭제하면 이를 참조하는 city5에 데이터로 같이 삭제된다.
DELETE FROM country 
WHERE country_id = 2;

SELECT * FROM city5;

-- Truncate
TRUNCATE TABLE city5;

-- DROP
DROP TABLE country;

-- 현재 사용할 데이터베이스 변경1
USE mysql;

SHOW TABLES;

-- user 테이블 조회 -> 현재 mariadb 사용자를 관리 테이블
SELECT * FROM USER;

SELECT HOST, USER, PASSWORD FROM USER;

-- 권한 부여할 계정 생성 
CREATE USER guest1;

CREATE USER guest2@localhost IDENTIFIED BY '1234';

CREATE USER gusest3@'%' IDENTIFIED BY '1234';

SELECT HOST, USER, PASSWORD FROM USER;

-- 권한 부여

GRANT ALL PRIVILEGES ON t1.`*` TO guest3@'%' IDENTIFIED BY  '1234';

-- 권한 삭제
REVOKE ALL PRIVILEGES ON t1.* FROM guest3@'%';

DROP USER guest1;
DROP USER guest2@localhost;
DROP USER guest3@'%';
