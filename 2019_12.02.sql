--�͸� ���
SET serveroutput on;

--return ������ �Լ�, ������ ���ν���
DECLARE
    --����̸��� ������ ��Į�� ����(1���� ��)
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename  
    FROM emp;
    --��ȸ����� �������ε� ��Į�� ������ ���� �����Ϸ��� �Ѵ�.
    -- -> ����
    
    --�߻�����, �߻����ܸ� Ư������ ���� �� -> OTHERS(java: Exception)
    EXCEPTION
        WHEN others THEN
            dbms_output.put_line('Exception others');
        
END;
/


--����� ���� ����
DECLARE
    --emp ���̺� ��ȸ�� ����� ������� �߻���ų ����� ���� ����
    --���ܸ� EXCEPTION; --������ ����Ÿ��
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
            dbms_output.put_line('������ ������');
            --����ڰ� ������ ����� ���� ���ܸ� ����
            RAISE NO_EMP;
     END;
     
     EXCEPTION
        WHEN NO_EMP THEN
        dbms_output.put_line('no_emp exception');
END;
/


--�����ȣ�� �����ϰ�, �ش� �����ȣ�� �ش��ϴ� ����̸��� �����ϴ� �Լ�(function)
CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE)
RETURN VARCHAR2 
IS
    --�����
    ret_ename emp.ename%TYPE;
BEGIN
    --����
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
--�ǽ� function1
CREATE OR REPLACE FUNCTION getdeptname(p_deptno dept.deptno%TYPE)
RETURN VARCHAR2 
IS
    --�����
    ret_dname dept.dname%TYPE;
BEGIN
    --����
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
--�ǽ� function2

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

--users ���̺��� pass�÷��� ����� ��� 
--users_history�� ������ pass�� �̷����� ����� Ʈ����
CREATE OR REPLACE TRIGGER make_history
    BEFORE UPDATE ON users --users ���̺��� ������Ʈ ����
    FOR EACH ROW 
    
    BEGIN
        --:NEW.�÷��� : UPDATE ������ �ۼ��� ��
        --,:OLD.�÷��� : ���� ���̺� ��
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

