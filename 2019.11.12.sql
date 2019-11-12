--sub7 실습

--1번고객에 먹는 애음제품
--2번 고객도 먹는 애음제품을오 제한
--고객명 추가
SELECT cycle.cid, customer.cnm, product.pid, day, cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.pid IN (SELECT pid 
                    FROM cycle
                   WHERE cid = 2); 

--sub9 실습
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
                     FROM cycle
                    WHERE cid = 1
                      AND  pid = product.pid);
--------------------------------과제확인---------------------------------------

--DELETE , INSERT 
DELETE dept where deptno = 99;
COMMIT;

INSERT INTO emp (empno,ename,job)
VALUES(9999,'brown', 'null');

select * from emp;

rollback;

desc emp;

select *
from user_tab_columns
where table_name = 'EMP';

INSERT INTO emp
VALUES(9999,'brown', 'ranger', null, sysdate, 2500, null, 40);

--SELECT 결과(여러건)를 INSERT
INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROM dept;
commit;

--UPDATE
--UPDATE 테이블 SET 컬럼=값, 컬럼=값...
--WHERE condition

INSERT INTO dept values(99,'ddit','daejeon');
commit;

SELECT * FROM dept;

UPDATE dept SET dname='대덕IT', loc='ym'
WHERE deptno = 99;
ROLLBACK;

--DELETE 테이블명
--WHERE condition

--사원번호가 9999인 직원을 emp 테이블에서 삭제
DELETE emp
WHERE empno = 9999;

--부서테이블을 이용해서 emp 테이블에 입력한 5건(4건)의 데이터를 삭제
--10, 20, 30, 40, 99 --> empno < 100, empno BETWEEN 10 AND 99
DELETE emp
 WHERE empno <100;
 rollback;
 
DELETE emp
WHERE empno BETWEEN 10 AND 99;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);
commit;
/*삭제하기 전 select를 이용하여 미리 확인해보자.*/
select * from emp where empno<100; 

--Oracle에서는 datablock을 이력에 따라 멀티버전으로 관리

--LV1 --> LV3
SET TRANSACTION
isolation LEVEL SERIALIZABLE;

SELECT *
FROM dept;

--DDL: AUTO COMMIT, rollback이 안된다.
--CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER, --숫자타입
    ranger_name VARCHAR2(50), --문자 : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate -- DEFAULT: SYSDATE
);

--ddl은 rollback이 적용되지 않는다.
INSERT INTO ranger_new(ranger_no, ranger_name)
VALUES(1000, 'brown');

--날짜 타입에서 특정 필드 가져오기
--ex: sysdate에서 년도만가져오기
SELECT TO_CHAR(sysdate, 'yyyy')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt, 'MM'),
       EXTRACT(MONTH FROM reg_dt) mm,
       EXTRACT(YEAR FROM reg_dt) year,
       EXTRACT(day FROM reg_dt) day
FROM ranger_new;

--제약조건
--DEPT 모방해서 DEPT_TEST 생성
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY, --deptno 컬럼을 식별자로 지정
    dname varchar2(14),           --식별자로 지정이 되면 갑의 중복이 될 수 없으며
    loc varchar2(13)              --null일 수도 없다.
);

/*
primary key 제약조건 확인
1.null이 들어갈 수 없다.
2.deptno컬럼에 중복된 값이 들어갈 수 없다.
*/
INSERT INTO dept_test(deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(1, 'ddit2', 'daejeon');
rollback;


--사용자지정 제약조건명을 부여한 PRIMARY KEY
DROP TABLE dept_test;
CREATE TABLE dept_test (
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

--TABLE CONSTRAINT
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY(deptno, dname)
);

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(1, 'ddit2', 'daejeon');
select * from dept_test;
rollback;

--NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, null, 'daejeon');

--UNIQUE
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(2, 'ddit2', 'daejeon');
rollback;