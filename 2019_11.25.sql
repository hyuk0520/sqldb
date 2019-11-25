--member 테이블을 이용하여 member2 테이블을 생성
--member2 테이블에서
--김은대 회원(mem_id='a001')의 직업(mem_job)을 '군인'으로 변경후
--commit 하고 조회
SELECT *
FROM member;

CREATE TABLE member2 AS
SELECT *
FROM member;

UPDATE member2 SET mem_job = '군인'
WHERE mem_id = 'a001';

select mem_id, mem_name, mem_job
from member2
where mem_id = 'a001';

--제품별 제품 구매 수량(BUY_QTY) 합계, 제품 구입 금액(BUY_COST) 합계
SELECT *
FROM buyprod;

SELECT buy_prod, SUM(buy_qty) buy_qty, SUM(buy_cost) buy_cost
FROM buyprod
GROUP BY buy_prod;

--제품코드, 제품명, 수량합계, 금액합계
SELECT buy_prod, b.prod_name, sum_qty, sum_cost
FROM
(SELECT buy_prod, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost
FROM buyprod
GROUP BY buy_prod) a, prod b
WHERE a.buy_prod = b.prod_id;

--VW_PROD_BUY(view 생성)
CREATE VIEW vw_prod_buy AS
SELECT buy_prod, b.prod_name, sum_qty, sum_cost
FROM
(SELECT buy_prod, SUM(buy_qty) sum_qty, SUM(buy_cost) sum_cost
FROM buyprod
GROUP BY buy_prod) a, prod b
WHERE a.buy_prod = b.prod_id;

SELECT *
FROM USER_VIEWS;
----------------------------------------------------------------------
--사원의 부서별 급여(sal)별 순위 구하기

--부서별 랭킹
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, ROWNUM j_rn
     FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) a ) a, 
(SELECT b.rn, ROWNUM j_rn
FROM 
(SELECT a.deptno, b.rn 
 FROM
    (SELECT deptno, COUNT(*) cnt --3, 5, 6
     FROM emp
     GROUP BY deptno )a,
    (SELECT ROWNUM rn --1~14
     FROM emp) b
WHERE  a.cnt >= b.rn
ORDER BY a.deptno, b.rn ) b ) b
WHERE a.j_rn = b.j_rn;

----
SELECT ename, sal, deptno, 
        ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal desc) rank
FROM emp;
    
  





