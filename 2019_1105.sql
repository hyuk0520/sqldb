/*
년월 파라미터가 주어졌을 때 해당년월의 일수를 구하는 문제
201911 => 30 / 201912 => 31
*/
--한달 더한 후 원래값을 빼면 = 일수
--마지막날짜 구한 후 => DD만 추출
SELECT --TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD') day_cnt
         :YYYYMM AS param,TO_CHAR(LAST_DAY(TO_DATE(:YYYYMMDD, 'YYYYMMDD')), 'DD') day_cnt
FROM DUAL;

explain plan for
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN. DISPLAY);

SELECT empno, ename, sal, TO_CHAR(sal, '999,999.99')sal_fmt
FROM emp;

SELECT empno, ename, sal, TO_CHAR(sal, 'L000999,999.99')sal_fmt
FROM emp;

SELECT empno, ename, sal, TO_CHAR(sal, 'L999,999.99')sal_fmt
FROM emp;

-- function null
-- nvl(coll, coll이 null일경우 대체할 값)
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm,
        sal + comm, 
        sal + nvl(comm, 0),
        nvl(sal + comm, 0)
FROM emp;

/*
NVL2(col1, col1이 null이 아닐 경우 표현되는 값, col1 null일 경우 표현되는 값)
*/
SELECT empno, ename, sal, comm, NVL2(comm, 0, comm) + sal
FROM emp;

/*
- NULLIF(expr1, expr2)
- expr1 == expr2 같으면 null
- else : expr1
*/
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

/*
- COALESCE(expr1, expr2, empr3...)
- 함수인자 중 null이 아닌 첫번째 인자
*/
SELECT empno, ename, sal, comm, coalesce(sal, comm)
FROM emp;

--fn4
--emp 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하시오
SELECT empno,ename,mgr, 
        NVL(mgr, 9999) AS mgr_n,
        NVL2(mgr, mgr, 9999) mgr_n,
        coalesce(mgr, 9999) mgr_n
FROM emp;

--fn5
SELECT userid, usernm, reg_dt,
        NVL(reg_dt, SYSDATE) n_reg_dt,
        NVL2(reg_dt, reg_dt, SYSDATE) n_reg_dt,
        COALESCE(reg_dt, SYSDATE) n_reg_dt
FROM users;

--case when
SELECT empno, ename, job, sal,
       case
            when job = 'SALESMAN' then sal*1.05
            when job = 'MANAGER' then sal*1.10
            when job = 'PRESIDENT' then sal*1.20
            else sal * 1
       end case_sal
FROM emp;

--decode(col, search1, retrun1, search2, return2... defult)
SELECT empno, ename, job, sal,
        DECODE(job, 'SALESMAN', sal*1.05, 
                    'MANAGER', sal*1.10, 
                    'PRESIDENT', sal*1.20, sal) decode_sal
FROM emp;

/*
cond1
- emp 테이블을 이용하여  deptno에 따라 부서명으로 변경해서 다음과 같이 조회되는
   쿼리를 작성하시오
   10 => 'ACCOUNTING'
   20 => 'RESEARCH'
   30 => 'SALES'
   40 => 'OPERATIONS'
   기타 다른값 => 'DDIT'
*/
SELECT  empno, ename,
        case
            when deptno = '10' then 'ACCOUNTING'
            when deptno = '20' then 'RESEARCH'
            when deptno = '30' then 'SALES'
            when deptno = '40' then 'OPERATIONS'
            else 'DDIT'
        end dname
FROM emp;

SELECT empno, ename,
    DECODE(deptno, 10, 'ACCOUNTING',
                   20, 'RESEARCH',
                   30, 'SALES',
                   40, 'OPERATIONS', 'DDIT') dname
FROM emp;

--문제cond2
--emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자인지
--조회하는 쿼리를 작성하시오 (생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다.)
SELECT empno, ename, /*hiredate,TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(hiredate, 'YYYY') as a*/
        /*MOD(TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(hiredate, 'YYYY'),2) b*/
    case
        when  MOD(TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(hiredate, 'YYYY'),2) = 0 then '건강검진대상자'
        else '건강검진 비대상자'
    end 건강검진
FROM emp;

/*
-그룹함수(AVG,MAX,MIN,SUM,COUNT)
-그룹함수는 NULL값을 계산대상에서 제외한다.
-SUM(comm), COUNT(*), COUNT(mgr)
-직원 중 가장 높은 급여를 받는사람
-직원 중 가장 낮은 급여를 받는사람
-직원의 급여 평균(소수점 둘째자리 까지만 나오게 => 소수점 3째자리에서 반올림)
*/
SELECT deptno,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;

--부서별 가장 높은 급여를 받는사람의 급여
--GROUP BY 절에 기술되지 않은 컬럼이 SELECT절에 기술될 경우 에러발생
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT empno, ename, sal
FROM emp
order by sal;

--부서별 최대 급여
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--실습 grp1
/*
emp 테이블을 이용하여 다음을 구하시오
- 직원중 가장 높은 급여
- 직원중 가장 낮은 급여
- 직원의 급여 평균
- 직원의 급여 합
- 직원중 급여가 있는 직원의 수(null 제외)
- 직원중 상급자가 있는 직원의 수(null 제외)
- 전체 직원의 수
*/
SELECT      MAX(sal) max_sal,
            MIN(sal) min_sal,
           ROUND(AVG(sal),1) avg_sal,
            SUM(sal) sum_sal,
            COUNT(sal) sal_cnt,
            COUNT(mgr) mgr_cnt,
            COUNT(empno) empno_cnt
FROM emp;

--grp2
/*
emp 테이블을 이용하여 다음을 구하시오
- 부서 기준 직원중 가장 높은 급여
- 부서 기준 직원중 가장 낮은 급여
- 부서 기준 직원의 급여 평균(소수점 2자리까지)
- 부서 기준직원의 급여 합
- 부서 기준 직원중 급여가 있는 직원의 수(null 제외)
- 부서 기준 직원중 상급자가 있는 직원의 수(null 제외)
- 부서 기준 전체 직원의 수
*/
SELECT  deptno,
            MAX(sal) max_sal,
            MIN(sal) min_sal,
           ROUND(AVG(sal),1) avg_sal,
            SUM(sal) sum_sal,
            COUNT(sal) sal_cnt,
            COUNT(mgr) mgr_cnt,
            COUNT(deptno) empno_cnt
            
FROM emp
GROUP BY deptno;

 
SELECT *
FROM emp;
