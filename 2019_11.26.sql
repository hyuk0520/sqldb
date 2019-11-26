SELECT ename, sal, deptno, 
        RANK() OVER(PARTITION BY deptno ORDER BY sal) rank,
        DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal) d_rank,
        ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal) rown
FROM emp;

--실습 ana1
SELECT empno, ename, sal, deptno, 
       RANK() OVER(ORDER BY sal DESC, empno) sal_rank,
       DENSE_RANK() OVER(ORDER BY sal DESC, empno) sal_dense_rank,
       ROW_NUMBER() OVER(ORDER BY sal DESC, empno) sal_row_number
FROM emp ;
----------------------------------------------------------
--실습 ana2(p.106)
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT ename, empno, emp.deptno, b.cnt
FROM emp, (SELECT deptno, COUNT(*) cnt
           FROM emp
           GROUP BY deptno) b
WHERE emp.deptno = b.deptno
ORDER BY emp.deptno;
-------------------------
--분석함수를 통한 부서별 직원수
SELECT ename, empno, deptno,
        COUNT(*) OVER(PARTITION BY deptno) cnt
FROM emp;

--부서별 사원의 급여 합계
--SUM 분석함수
SELECT ename, empno, deptno, sal,
        SUM(SAL) OVER(PARTITION BY deptno) sum_sal
FROM emp;
--------------
--실습 ana2 (p.109)
SELECT empno, ename, sal, deptno,  
        ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;
---------
--실습 ana3 (p.110)
SELECT empno, ename, sal, deptno,
        MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;        
-----
--실습 ana4   (p.111)
SELECT empno, ename, sal, deptno,
        MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;
-----

--부서별 사원번호가 가장 빠른사람
--부서별 사원번호가 가장 느린사람

--window 재확인
SELECT empno, ename, deptno,
    FIRST_VALUE(empno) OVER(PARTITION BY deptno
                                 ORDER BY empno) f_emp,
    LAST_VALUE(empno) OVER(PARTITION BY deptno
                                 ORDER BY empno) l_emp                                 
FROM emp;
----------
--LAG (이전행)
--현재행
--LEAD(다음행)
--급여가 높은순으로 정렬 했을때 자기보다 한단계 급여가 낮은 사람의 급여,
--급여가 높은순으로 정렬 했을때 자기보다 한단계 급여가 높은 사람의 급여
SELECT empno, ename, sal, LAG(sal) OVER (ORDER BY sal) lag_sal,
                        LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;
----------
--실습 an5 (p.116)
SELECT empno, ename, hiredate, LEAD(sal) OVER(ORDER BY sal desc, hiredate) lead_sal
FROM emp;
------------
--실습 ana6
SELECT empno, ename, hiredate, job, sal, LAG(sal) OVER(PARTITION BY job ORDER BY sal desc, hiredate) lead_sal 
FROM emp;
----------
--★★★no_ana3(p.118)★★★
SELECT a.empno, a.ename, a.sal, sum(b.sal) sal_sum
FROM
(SELECT a.*, ROWNUM rn
FROM    
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal, empno) a) b 
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;

--프레젠테이션 (sql응용 120p) 중요함
--WINDOWING
--UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든행
-- CURRENT ROW : 현재행
--UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든행
--N(정수) PREFCEDING : 현재 행을 기준으로 선행하는 N개의 행
--N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행

SELECT empno, ename, sal,
        SUM(sal) OVER(ORDER BY sal, empno 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)sum_sal,
        
        SUM(sal) OVER(ORDER BY sal, empno 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)sum_saL2,
        
        SUM(sal) OVER(ORDER BY sal, empno 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)sum_sal3
FROM emp;
----------
--실습 ana7 p.126
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER(PARTITION BY deptno 
                        ORDER BY sal, empno
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

SELECT empno, ename, deptno, sal,
    SUM(sal) OVER(ORDER BY sal 
                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
    
    SUM(sal) OVER(ORDER BY sal 
                  ROWS UNBOUNDED PRECEDING) row_sum2,
                  
    SUM(sal) OVER(ORDER BY sal 
                  RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
    
    SUM(sal) OVER(ORDER BY sal 
                  RANGE UNBOUNDED PRECEDING) range_sum2              
FROM emp;


