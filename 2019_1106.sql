/*
- 그룹함수
- multi eow function : 여러개의 행을 입력으로 하나의 결과 행을 생성
- SUM, MAX, MIN, AVG, COUNT
- GROUP BY COL | express
- SELECT절에는 GROUP BY절에 기술된 COL, EXPRESS 표기가능
*/

--직원 중 가장 높은 급여 조회
-- 14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

--부서별로 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--실습 grp3
SELECT  deptno ,
            MAX(sal) max_sal,
            MIN(sal) min_sal,
           ROUND(AVG(sal),1) avg_sal,
            SUM(sal) sum_sal,
            COUNT(sal) sal_cnt,
            COUNT(mgr) mgr_cnt,
            COUNT(deptno) empno_cnt
FROM emp
GROUP BY deptno;

SELECT 
    case
        when deptno = '10' then 'ACCOUNTING'
        when deptno = '20' then 'RESEARCH'
        when deptno = '30' then 'SALES'
    end dname,
      MAX(sal) max_sal,
         MIN(sal) min_sal,
         ROUND(AVG(sal),1) avg_sal,
         SUM(sal) sum_sal,
         COUNT(sal) sal_cnt,
         COUNT(mgr) mgr_cnt,
         COUNT(deptno) empno_cnt
FROM emp
GROUP BY deptno
ORDER BY deptno DESC;

--decode 사용해서 다시 해볼것

--grp4
/*
emp 테이블을 이용하여 다음을 구하시오. 직원의 입사 년월별로 몇명의 직원이 
입사했는지 조회하는 쿼리를 작성
*/
DESC EMP;
SELECT 
   TO_CHAR(hiredate, 'YYYYMM') HIRE_YYYYMM,
   COUNT(TO_CHAR(hiredate, 'YYYYMM')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

--grp5
--emp 테이블을 이용하여 직원의 입사 년별로 몇명의 직원이 입사했는지 조회
SELECT 
   TO_CHAR(hiredate, 'YYYY') HIRE_YYYY,
   COUNT(TO_CHAR(hiredate, 'YYYY')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY  TO_CHAR(hiredate, 'YYYY'); --ORDER BY로 오름차순 정렬

--grp6
--회사에 존재하는 부서의 개수는 몇개인지 조회
SELECT COUNT(deptno)cnt, COUNT(*) cnt
FROM DEPT;

/*
- JOIN
- emp 테이블에는 dname 컬럼이 없다 => 부서번호(deptno)밖에 없음
*/
--emp 테이블에 부서이름을 저장할 수 있는 dname 컬럼 추가
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

UPDATE emp SET dname = 'ACCOUNTING' WHERE DEPTNO=10;
UPDATE emp SET dname = 'RESERCH' WHERE DEPTNO=20;
UPDATE emp SET dname = 'SALES' WHERE DEPTNO=30;
COMMIT;

SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

ALTER TABLE emp DROP COLUMN DNAME; --테이블이름 변경

SELECT *
FROM emp;

--anai natural join : 조인하는 테이블의 컬렴명이 같은 컬럼을 기준으로 JOIN)
SELECT DEPTNO, ENAME, DNAME
FROM emp NATURAL JOIN DEPT;

--ORACLE join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;


--ANSI JOING WITH USING
SELECT emp, empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno)

--fROM절에 JOIN 대상 테이블 나열
--WHERE 절에 JOIN 조건 기술
--기존에 사용하던 조건제약도 사농 가능
SELECT emp, empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.dname
from emp, dept
WHERE emp.deptno dept.deptno;
  AND emp.job = 'SALESMAN',  --job이 SALES인 사람만 대상으로 조회
         
--JOIN with ON (개발자가 JOIN 컬럼을 on절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--SELF join : 같은 테이블끼리 join
--emp테이블의 mgr 정보를 참고하기 위해서 emp 테이블과 조인을 해야한다.
--a : 직원정보, b : 관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno BETWEEN 7369 AND 7698;

SELECT *
FROM dept;

--self join(oracle)
SELECT s.ename, m.ename AS manger
FROM emp m, emp s
WHERE s.empno BETWEEN 7369 AND 7698
AND m.empno = s.mgr;

--non-equijoing(등식 조인이 아닌경우)
SELECT *
FROM salgrade;

--직원의 급여 등급은?
SELECT empno, ename, sal
FROM emp;

SELECT emp, empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;



