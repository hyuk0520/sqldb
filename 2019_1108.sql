/*
-조인복습
-조인 왜?
-REDMS의 특성상 데이터 중복을 최대 배제한 설계를 한다.
-EMP 테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서정보는 부서번호만 갖고있고,
  부서번호를 통해 DEPT 테이블과 조인을 통해 해당 부서의 정보를 가져올 수 있다.
  
-직원 번호, 직원이름, 직원의 소속 부서번호, 부서이름
-emp, dept
*/
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--부서번호, 부서명, 해당부서의 인원수

SELECT emp.deptno, dept.dname, COUNT(emp.empno) AS CNT
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY   emp.deptno, dept.dname; 

/*
- OUTER JOIN : 조인에 실패해도 기준이 되는 테이블의 데이터는 조회결과가 나오도록 하는 조인형태
- LEFT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이 되도록 하는 조인형태
- RIGHT OUTER JOIN : JOIN KEYWORD 오른쪽에 위치한 테이블이 조회 기준이 되도록 하는 조인형태
-FULL OUTER JOIN : LEFT OUTER JOON + RIGHT OUTER JOIN - 중복제거
*/
--직원정보와 해당 직원의 관리자 정보 outer join
--직원정보, 직원이름, 관리자번호, 관리자 이름


SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno);

--oracle outer join (left, right만 존재 fullouter는 지원하지 않음)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a,  emp b
WHERE a.mgr = b.empno(+);

-- ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
  FROM emp a LEFT OUTER JOIN emp b 
    ON (a.mgr = b.empno)
 WHERE b.deptno = 10;

--oracle outer 문법에서는 outer 테이블이 되는 모든 컬럼에 (+)를 붙여줘야 
--outer join이 정상적으로 동작한다.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
AND b.deptno(+) = 10;

--ANSI RIGHT OUTER
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON (a.mgr = b.empno);

--실습 outerjoin1
--buyprod 테이블에 구매일자가 2005년 1월 25일인 데이터는 3품목밖에 없다.
--모든 품목이 나올 수 있도록 쿼리를 작성하시오
SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_name, buyprod.buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id
                                  AND buyprod.buy_date = TO_DATE('050125', 'YYMMDD'));

SELECT a.buy_date, a.buy_prod, b.prod_name, a.buy_qty
FROM buyprod a, prod b
WHERE a.buy_prod(+) = b.prod_id 
AND a.buy_date(+) = TO_DATE('050125', 'YYMMDD');

--실습 outerjoin2
SELECT TO_DATE('050125', 'YYMMDD'), buyprod.buy_prod, prod.prod_name, buyprod.buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id 
                                   AND buyprod.buy_date = TO_DATE('050125', 'YYMMDD'));
                                   
--실습 outerjoin3
SELECT TO_DATE('050125', 'YYMMDD'), buyprod.buy_prod, prod.prod_name, 
                                    nvl(buyprod.buy_qty, 0)
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id 
                                   AND buyprod.buy_date = TO_DATE('050125', 'YYMMDD'));

--실습 outerjoin4
SELECT b.pid, b.pnm, nvl(a.cid,1) cid, nvl(a.day,0) day, nvl(a.cnt,0) cnt
FROM cycle a RIGHT OUTER JOIN product b ON (a.pid = b.pid AND a.cid = 1);

SELECT b.pid, b.pnm, nvl(a.cid,1) cid, nvl(a.day,0) day, nvl(a.cnt,0) cnt
FROM cycle a , product b
WHERE a.pid(+) = b.pid AND a.cid(+) = 1;

--실습 outerjoin5 다시 풀어야 함
SELECT b.pid, b.pnm, nvl(a.cid,1) cid, c.cnm, nvl(a.day,0) day, nvl(a.cnt,0) cnt
FROM cycle a , product b, customer c
WHERE a.pid(+) = b.pid 
AND a.cid(+) = 1 AND a.cid = c.cid ;

--실습 crossjoin1
SELECT c.cid, c.cnm, p.pid, p.pnm
FROM customer c, product p;

SELECT c.cid, c.cnm, p.pid, p.pnm
FROM customer c CROSS JOIN product p;

/*
 SUBQUERT : main쿼리에 속하는 부분 쿼리
 사용되는 위치 : 
 -SELECT -scalar subquery(하나의 행과, 하나의 컬럼만 조회되는 쿼리이어야 한다)
 -FROM - inline view
 -WHERE - subquery
*/
--SCALAR subquery
SELECT empno, ename, (SELECT SYSDATE FROM dual)now 
FROM emp;
------------------------------------------------------------
SELECT deptno --20
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20;

-- 위 두개 결합

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

--서브쿼리 실습 sub1
SELECT AVG(sal)
FROM emp;

SELECT COUNT(sal) 
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
 
--실습 SUB2
SELECT AVG(sal)
FROM emp;

SELECT * 
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
--sub3
SELECT *
FROM emp
WHERE deptno IN ((SELECT deptno
                FROM emp
                WHERE ename = 'SMITH'),(SELECT deptno
                FROM emp
                WHERE ename = 'WARD'));

SELECT *
FROM emp
WHERE DEPTNO = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH')
                    
   OR DEPTNO = (SELECT deptno
                FROM emp
                WHERE ename = 'WARD')
                ;
            
SELECT *
FROM emp
WHERE DEPTNO = 30;





select * from emp; 
                             
