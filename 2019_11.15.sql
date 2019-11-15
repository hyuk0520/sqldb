--emp테이블에 empno컬럼을 기준으로 PRIMARY KEY를 생성
--PRIMARY KEY = UNIQUE + NOT NULL
--UNIQUE => 해당컬럼으로 UNIQUE INDEX를 자동으로 생성

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno =7782;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    87 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    87 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
   
--empno 컬럼으로 인덱스가 존재하는 상황에서 다른컬럼 값으로 데이터를 조회하는 경우
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |   261 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   261 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB"='MANAGER')
 
--인덱스 구성 컬럼만 SELECT 절에 기술한 경우 테이블 접근이 필요없다.
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHRE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);

/*컬럼에 중복이 가능한 non-unique 인덱스 생성후
unique index와의 실행계획 비교
PRIMARY KEY 제약조건 삭제(unique 인덱스 삭제)*/
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp(empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 4208888661
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
 
/*emp 테이블에 job 컬럼으로 두번째 인덱스 생성(non-unique index)
job 컬럼은 다른 로우의 job 컬럼과 중복이 가능한 컬럼이다.*/
CREATE INDEX idx_emp_02 ON emp (job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job= 'MANAGER';

SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   261 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   261 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job= 'MANAGER'
AND ename LIKE 'C%';


SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')

/* emp 테이블에 job, ename 컬럼을 기준으로 non-unique 인덱스 생성 (다시.) */
CREATE INDEX IDX_emp_03 ON emp (job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER' AND ename LIKE '%C';

SELECT *
FROM TABLE (dbms_xplan.display);

Plan hash value: 4079571388
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" IS NOT NULL AND "ENAME" LIKE '%C')
   2 - access("JOB"='MANAGER')


/*emp 테이블에 ename, job 컬럼으로 non-unique 인덱스 생성 */
CREATE INDEX IDX_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_04) */ *
FROM emp
WHERE ename LIKE '%C'
AND job = 'MANAGER' ;

SELECT *
FROM TABLE (dbms_xplan.display);

/* HINT를 사용한 실행계획 제어 */
EXPLAIN PLAN FOR
SELECT /*+ INDEX (emp idx_emp_03) */ *
FROM emp
WHERE job = 'MANAGER' AND ename LIKE '%C';

SELECT *
FROM TABLE (dbms_xplan.display);

--실습 idx1
CREATE TABLE dept_test AS SELECT * FROM dept WHERE 1=1;

--deptno컬럼을 기준으로 unique 인덱스 생성
CREATE UNIQUE INDEX idx_dept_test_01 ON dept_test (deptno);
CREATE INDEX idx_dept_test_02 ON dept_test (dname);
CREATE INDEX idx_dept_test_03 ON dept_test (deptno, dname);

--실습 idx2 위에서 생성한 인덱스 삭제
DROP INDEX idx_dept_test_01;
DROP INDEX idx_dept_test_02;
DROP INDEX idx_dept_test_03;



