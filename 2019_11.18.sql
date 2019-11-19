--synonym에 public을 붙이려면 system계정에서만 가능

SELECT *
FROM user_views;

SELECT *
FROM all_views;

SELECT *
FROM all_views
WHERE owner='hyuk';



SELECT *
FROM hyuk.v_emp_dept;

--pc22계정에서 조회권한을 받은 v_emp_dept view를 hr계정에서 조회하기 위해서는
--계정명.view이름 형식으로 기술을 해야 한다
--매번 계정명을 기술하기 귀찮으므로 synonym을 통해 다른 별칭을 생성

CREATE SYNONYM v_emp_dept FOR hyuk.v_emp_dept;

--pc22.v_emp_dept --> v_emp_dept
SELECT *
FROM v_emp_dept;

--synonym 삭제
--DROP SYNONYM synonym명;
DROP SYNONYM v_emp_dept;

--hr계정 비밀번호 : java
--hr계정 비밀번호 변경 : hr
ALTER USER hr IDENTIFIED BY hr;
--ALTER USER pc22 IDENTIFIED BY jvav;--본인 계정이 아니라 생긴 에러

--GRANT구문에서
--WITH GRANT OPTION : 권한을 부여받은 사용자가 다른 사용자에게 부여함

--CONNECT와 RESOURCE도 ROLE의 일종이다



--DATA DICTIONARY
--접두어 : USER : 사용자 소유 객체
--      : ALL : 사용자가 사용가능한 객체
--      : DBA : 관리자 관점의 전체 객체(일반 사용자는 사용 불가)
--      : V$ : 시스템과 관련된 VIEW(일반 사용자는 사용 불가)

SELECT *
FROM user_tables;

SELECT *
FROM all_tables;

SELECT *
FROM dba_tables;--SYSTEM계정이 아니면 오류발생

SELECT *
FROM dba_tables
WHERE owner IN('PC22','HR');

--오라클에서 동일한 SQL이란?
--문자가 하나라도 틀리면 안됨
--다음 SQL들은 같은 결과를 만들어 낼지 몰라도 DBMS에서는 서로 다른 SQL로 인식된다
SELECT /* bind_test */ * FROM emp;
Select /* bind_test */ * FROM emp;
Select /* bind_test */ *  FROM emp;

SELECT /* bind_test */ * FROM emp WHERE empno=7369;
SELECT /* bind_test */ * FROM emp WHERE empno=7499;
SELECT /* bind_test */ * FROM emp WHERE empno=7521;

SELECT /* bind_test */ * FROM emp WHERE empno=:empno;

SELECT *
FROM V$SQL
WHERE SQL_TEXT LIKE '%bind_test%';


SELECT *
FROM fastfood
WHERE gb='버거킹'
ORDER BY addr;

SELECT *
FROM fastfood
WHERE gb='맥도날드'
ORDER BY addr;

SELECT *
FROM fastfood
WHERE gb='롯데리아'
ORDER BY addr;

SELECT *
FROM fastfood
WHERE gb='KFC'
ORDER BY addr;

SELECT 
    a.count(*)
FROM
    (SELECT *
    FROM fastfood
    WHERE gb IN ('맥도날드','버거킹','롯데리아','KFC')
    ORDER BY sido, sigungu, gb ) a;



SELECT 
    (SELECT a.*
    FROM a
    WHERE a.gb IN ('맥도날드','버거킹','롯데리아'))
FROM
    (SELECT *
    FROM fastfood
    WHERE gb IN ('맥도날드','버거킹','롯데리아','KFC')
    ORDER BY sido, sigungu, gb) a;


