--익명 블록
SET serveroutput on;

--return 있으면 함수, 없으면 프로시져
DECLARE
    --사원이름을 저장할 스칼라 변수(1개의 값)
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename  
    FROM emp;
    --조회결과는 여러건인데 스칼라 변수에 값을 저장하려고 한다.
    -- -> 에러
    
    --발생예외, 발생예외를 특정짓기 힘들 때 -> OTHERS(java: Exception)
    EXCEPTION
        WHEN others THEN
            dbms_output.put_line('Exception others');
        
END;
/


--사용자 정의 예외
DECLARE
    --emp 테이블 조회시 결과가 없을경우 발생시킬 사용자 정의 예외
    --예외명 EXCEPTION; --변수명 변수타입
    NO_EMP EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    BEGIN
    SELECT ename
    INTO v_ename
    FROM emp
    WHERE empno = 9999;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('데이터 미존재');
            --사용자가 생성한 사용자 정의 예외를 생성
            RAISE NO_EMP;
     END;
     
     EXCEPTION
        WHEN NO_EMP THEN
        dbms_output.put_line('no_emp exception');
END;
/


--사원번호를 인자하고, 해당 사원번호에 해당하는 사원이름을 리턴하는 함수(function)
CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE)
RETURN VARCHAR2 
IS
    --선언부
    ret_ename emp.ename%TYPE;
BEGIN
    --로직
SELECT ename
INTO ret_ename
FROM emp
WHERE empno = p_empno;

RETURN ret_ename;

END;
/

SELECT getEmpName(7369)
FROM dual;

SELECT empno, ename, getEmpName(empno)
FROM emp;
-------------------
--실습 function1
CREATE OR REPLACE FUNCTION getdeptname(p_deptno dept.deptno%TYPE)
RETURN VARCHAR2 
IS
    --선언부
    ret_dname dept.dname%TYPE;
BEGIN
    --로직
SELECT dname
INTO ret_dname
FROM dept
WHERE deptno = p_deptno;

RETURN ret_dname;

END;
/

SELECT getdeptname(10)
FROM dual;

SELECT deptno, dname, getdeptname(deptno)
FROM dept;
---------------------
--실습 function2

SELECT deptcd, indent(LEVEL, deptnm) as deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

CREATE OR REPLACE FUNCTION 
indent(p_level NUMBER, p_dname dept.dname%TYPE)
RETURN VARCHAR2
IS
    ret_text VARCHAR2(50);
BEGIN
    SELECT lpad(' ',(P_level-1)*4,' ') || p_dname
    INTO ret_text
    FROM dual;
    RETURN ret_text;
    
END;
/

SELECT indent(2, 'ACCOUNTING'), indent(3, 'SALES')
FROM dual;

CREATE TABLE user_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE
);

--users 테이블의 pass컬럼이 변경될 경우 
--users_history에 변경전 pass를 이력으로 남기는 트리거
CREATE OR REPLACE TRIGGER make_history
    BEFORE UPDATE ON users --users 테이블을 업데이트 전에
    FOR EACH ROW 
    
    BEGIN
        --:NEW.컬럼명 : UPDATE 쿼리시 작성한 값
        --,:OLD.컬럼명 : 현재 테이블 값
        IF :NEW.pass != :OLD.pass THEN
            INSERT INTO user_history
            VALUES(:OLD.userid, :OLD.pass, sysdate);
        END IF;
    END;
/

SELECT *
FROM users;

UPDATE users SET pass = 'brownpass'
WHERE userid = 'brown';

SELECT *
FROM user_history;

