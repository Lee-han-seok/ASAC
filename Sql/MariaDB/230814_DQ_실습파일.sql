SHOW DATABASES;
-- 데이터베이스 사용(지정)
USE t1;
-- 모든 테이블 목록을 출력
SHOW TABLES;
-- 특정 테이블의 구조(칼럼, 타입, null 여부, 기본값...)
DESC city2;
DESCRIBE country2;
-- 쿼리 실행
-- city2의 모든 데이터를 가져오시오
-- 데이터 shape (4079, 5)
SELECT * 
FROM city2;
-- name, population 칼럼만 추출
-- 칼럼의 순서는 분석에 용이하게 배치하여 수행한다.
SELECT `NAME`, population FROM city2;

-- 칼럼의 이름을 짧게 줄이거나, 의미가 명확하게 변경
-- 별칭 --> as 별칭
SELECT `NAME` AS nm , population AS popu FROM city2;

-- 인구수 5000000 이상(>=) 되는 도시를 추출하시오
SELECT name
FROM city2
WHERE population >= 5000000;

-- COUNT(칼럼명|*|...) 데이터수가 출력
SELECT COUNT(*) AS cnt
FROM city2
WHERE population >= 5000000;

-- 인구수가 500만 이상, 600만 이하인 도시의 수는?
SELECT COUNT(*) AS cnt 
FROM city2
WHERE population >= 5000000 AND population <= 6000000;

SELECT * 
FROM city2
WHERE population >= 5000000 AND population <= 6000000;

-- 특정 숫자와 일치하는 인구수를 가진 도시 정보 추출
-- 5598953
SELECT * 
FROM city2
WHERE population = 5598953;

-- 국가를 구분하는 code의 개별값들을 확인한다.
SELECT DISTINCT countrycode FROM city2; 

-- 한국과 미국에 있는 모든 도시 정보를 출력하시오
SELECT * 
FROM city2
WHERE countrycode = 'KOR' OR countrycode = 'USA' ;

-- 한국의 도시들 중에서 인구수가 백만 이상인 도시만 추출하시오

SELECT * 
FROM city2
WHERE countrycode = 'KOR' AND population >= 1000000;

-- 조건의 배치에 따라서 수행시간도 달라진다
-- 데이터 상황에 따라서는 조건 순서도 달라질 수 있다!

SELECT * 
FROM city2
WHERE population >= 1000000 AND countrycode = 'KOR';

-- Between 사용
-- 인구수가 500만 이상 600만 이하인 도시 추출
SELECT * 
FROM city2
WHERE population BETWEEN 5000000 AND 6000000;

-- 도시 이름이 서울, 부산, 인천인 경우 전체 정보를 출력
SELECT *
FROM city2
WHERE NAME IN ('seoul', 'pusan', 'inchon');

-- 한국, 미국, 일본, 프랑스 도시들을 다 모아서 총수를 리턴하시오
SELECT COUNT(*) FROM city2
WHERE countrycode IN ('KOR', 'USA', 'JPN', 'FRA');

-- 한국, 미국, 일본, 프랑스 도시들 중
-- 인구수 600만 이상인 도시의 이름을 출력
SELECT name FROM city2
WHERE countrycode IN ('KOR', 'USA', 'JPN', 'FRA') 
AND population >= 6000000;

-- 프랑스를 뽑을때 FR까지는 알겠는데 FR()마지막 문자를 모르는 경우
-- 파리가 프랑스 도시인것을 아니까, 파리를 통해서 국가코드를 획득 => 국가코드를 이용해 도시정보를 출력
-- 서브쿼리는 쿼리속에 쿼리!
-- 파리(paris) 도시 정보 출력
SELECT countrycode FROM city2 WHERE NAME = 'paris';

-- 추출한 정보를 이용하여 매인 쿼리 작성
SELECT *
FROM city2
WHERE countrycode = (SELECT countrycode FROM city2 
WHERE NAME = 'paris');

-- 서브쿼리의 결과가 2개 이상인 경우 오류발생 -> 핸들링 방법은?
SELECT * FROM city2
WHERE district = 'New York';

-- 국가 코드가 6개가 나오는데 어떻게 해결하면 될까? => Distinct 사용
SELECT Distinct CountryCode FROM city2
WHERE district = 'New York';

-- 국가 코드가 6개가 나오는데 어떻게 해결하면 될까? => Any 사용
SELECT Distinct CountryCode FROM city2
WHERE district = 'New York';

-- 서로 다른 결과값이 6개 출력되지만
SELECT population FROM city2
WHERE District = 'New York'

-- 서브쿼리로 활용하면 오류 발생 -> 해결해보자
/*
SELECT * FROM city2
WHERE population > (SELECT population FROM city2
WHERE District = 'New York');
*/
-- 해석 : 뉴욕주에 있는 모든 도시들의 인구수보다 많기만 하면 다 포함(하나만 일치해도 OK)
SELECT * FROM city2
WHERE population > ANY(SELECT population FROM city2
							WHERE District = 'New York');

-- =any
SELECT * FROM city2
WHERE population = any(SELECT population FROM city2
							WHERE District = 'New York');
							
-- all
SELECT * FROM city2
WHERE population > all(SELECT population FROM city2
							WHERE District = 'New York');

-- ORDER BY
-- 도시의 모든 정보를 인구수의 오름차순으로 정렬하여 출력하시오
SELECT * FROM city2
ORDER BY population;

SELECT * FROM city2
ORDER BY population DESC;

-- 조합
-- 인구순은 내림차순, 국가코드는 오름차순
SELECT * FROM city2
ORDER BY countrycode ASC, population DESC ;

-- 인구수 내림차순, 한국만 처리
SELECT * FROM city2
WHERE countrycode = 'KOR'
ORDER BY population DESC ;

-- 국가 면적(SurfaceArea)순 내림차순, country2 정보 출력, 
-- 국가명 SurfaceArea 출력 
DESC country2;

SELECT NAME, surfacearea FROM country2
ORDER BY surfacearea DESC;

-- 모든 국가코드를 1개씩만 출력하시오
SELECT distinct countrycode FROM city2;

- 국가 면적순으로 내림차순 정렬, 상위 10개만 출력
SELECT NAME, surfacearea FROM country2
ORDER BY surfacearea DESC 
LIMIT 10;

- LIMIT 활용하여 게시판에서 출력되는 데이터를 가져오기
-- 1페이지당 데이터는 10개씩 출력
-- 1페이지는 limit(1-1) * 10, 10

SELECT NAME, surfacearea FROM country2
ORDER BY surfacearea DESC 
LIMIT 0, 10;

-- GROUP BY
-- 같은 국가코드를 가진 데이터끼리 집계
-- GROUP BY CountryCode
-- 최소 인구수 탑 10 오름차순으로 정렬하여 출력
-- 출력 내용, 국가코드, 도시명, 인구수
-- 국가별로 가장 인구수가 작은 도시들 중 하위 10개 출력
DESC city2;

-- 국가별 가장 작은 도시의 인구수가 나오지만 도시명은 국가별 최초값이 나오는듯함
SELECT countrycode, NAME, MIN(population) AS min_popu FROM city2
WHERE population
GROUP BY countrycode
ORDER BY min_popu ASC 
LIMIT 10;

-- 국가별 도시 인구 평균을 구해서 내림차순 정렬
-- 상위 탑 5위 ~ 10위까지 출력하시오 => 비교 상위 15개도 출력
-- 출력값 국가코드, 평균인구수 (avg_popu)

SELECT countrycode, AVG(population) AS avg_popu
FROM city2
GROUP BY countrycode
ORDER BY avg_popu
LIMIT 4, 10;

-- 국가별로 인구가 가장 많은 도시(그룹 대표)들을 모아서 내림차순 정렬
SELECT countrycode, max(population) AS max_popu
FROM city2
GROUP BY countrycode
ORDER BY max_popu DESC;

-- 위의 결과에서 인구 9백만 이상만 출력하시오
SELECT countrycode, max(population) AS max_popu
FROM city2
GROUP BY countrycode
HAVING max_popu >= 9000000
ORDER BY max_popu DESC;


-- 같은 국가코드를 가진 데이터들의 인구수를 합산(sum())하여
-- 해당 국가코드의 데이터 나열이 끝나면 중간 결과(중간합계_ 넣어서 출력
SELECT countrycode, NAME, SUM(population) AS sum_popu
FROM city2
GROUP BY countrycode, name WITH ROLLUP
HAVING countrycode = 'KOR';

-- Join
-- 대상 테이블
SELECT COUNT(*) FROM city2; # (4079,)
SELECT COUNT(*) FROM country2; # (239,)
-- 2개 테이블 조인(city2, country2) -> 공통된 값을 가진 칼럼 필요
-- key value는 countrycode와 code 
-- 도시 정보 우측으로 국가 정보 추가
-- 조건이 되는 칼럼은 중복으로 노출(단, 칼럼을 지정하면 처리 가능하다)
SELECT *
FROM city2 
JOIN country2
ON city2.countrycode = country2.code

-- 개선, 필요한 데이터만 추출, 별칭 사용
SELECT A.name, B.code, A.district, A.population, B.surfacearea
FROM city2 AS A
JOIN country2 AS B
ON A.countrycode = B.code


-- 3개 테이블 조인
-- city2, countrycode, countrylanguage
-- 국가별 언어가 1개가 아니다! -> 데이터 수가 많은 이유
SELECT *
FROM city2 AS A
JOIN country2 AS B ON A.countrycode = B.code
JOIN countrylanguage AS C ON A.countrycode = C.countrycode;


-- inner, left, right join 사용
-- full -> union과 결합해서 처리 가능 (mysql)
-- (4079, 5)
SELECT A.name, B.code, A.district, A.population, B.surfacearea
FROM city2 AS A
inner JOIN country2 AS B
ON A.countrycode = B.code

SELECT A.name, B.code, A.district, A.population, B.surfacearea
FROM city2 AS A
left JOIN country2 AS B
ON A.countrycode = B.code

-- right join은 결과가 약간 다름.
SELECT A.name, B.code, A.district, A.population, B.surfacearea
FROM city2 AS A
right JOIN country2 AS B
ON A.countrycode = B.code

SELECT A.name, B.code, A.district, A.population, B.surfacearea
FROM city2 AS A
right JOIN country2 AS B
ON A.countrycode = B.code


-- 이름, 인구수 출력, city2, 한국만 대상, 인구수 900만 이상
-- 이름, 인구수 출력, city2, 한국만 대상, 인구수 80만 이상
-- 2개와의 결과를 합치시오
SELECT NAME, population FROM city2 WHERE countrycode = 'KOR' AND population >= 9000000
UNION
SELECT NAME, population FROM city2 WHERE countrycode = 'KOR' AND population >= 800000;

SELECT NAME, population FROM city2 WHERE countrycode = 'KOR' AND population >= 9000000
UNION all
SELECT NAME, population FROM city2 WHERE countrycode = 'KOR' AND population >= 800000;
