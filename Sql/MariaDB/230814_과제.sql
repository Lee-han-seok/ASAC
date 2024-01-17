   -- 아래 쿼리를 기준으로 도시명도 가장 인구가 작은 도시명으로 출력되게 수정
   -- 출력값, 국가코드, 국가별 최소인구를가진 도시명, 국가별 최소인구수
   
	 SELECT A.countrycode, A.NAME, A.Population
	 FROM city2 AS A, (SELECT countrycode, MIN(Population) AS min_popu FROM city2 GROUP BY countrycode) AS B
	 WHERE A.population = B.min_popu AND A.countrycode = B.countrycode
	 ORDER BY B.min_popu;
	 
    -- 해당 국가코드의 데이터 나열이 끝나면 중간결과(중간합계) 넣어서 출력    
    -- Union 방식을 사용하였음.
    SELECT countrycode, NAME, population FROM city2 WHERE countrycode = 'KOR' and NAME IN (SELECT NAME FROM city2 WHERE countrycode = 'KOR' GROUP BY countrycode, NAME)
	 UNION
	 SELECT countrycode, NAME, sum(population) AS population FROM city2 GROUP BY countrycode, NAME WITH ROLLUP HAVING countrycode='KOR';