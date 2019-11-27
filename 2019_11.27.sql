SELECT *
FROM no_emp;

--1.leaf node ã��
SELECT lpad(' ', (level-1)*4,' ') || org_cd, s_emp
FROM
    (SELECT org_cd, parent_org_cd,SUM(s_emp) s_emp
        FROM
        (SELECT org_cd, parent_org_cd,
                SUM(no_emp/org_cnt) OVER(PARTITION BY gr 
                                    ORDER BY rn 
                                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
        FROM
        (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr, COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
             FROM
            (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
                 FROM no_emp
                    START WITH parent_org_cd IS NULL
                    CONNECT BY PRIOR org_cd = parent_org_cd) a
                    START WITH leaf= 1
                    CONNECT BY PRIOR parent_org_cd = org_cd))
        GROUP BY org_cd, parent_org_cd)
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;
--------------------------------
--PL/SQL
--�Ҵ翬�� :=
--System.out.println(""); --> dbms_out.put_line("");
--Log4j
--set serveroutput on; --��±���� Ȱ��ȭ
--PL/SQL
--declare : ����, ��� ����
--begin : ��������
--exception : ����ó��

set serveroutput on;

DECLARE
    --���� ����
    deptno NUMBER(2);
    dname VARCHAR2(14);
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    
    --SELECT ���� ����� ������ �� �Ҵ��ߴ��� Ȯ��
    dbms_output.put_line('dname: ' || dname || '(' || deptno || ')');
END;
/
---------------------
DECLARE
    --�������� ����(���̺� �÷�Ÿ���� ����Ǿ PL/SQL ������ ������ �ʿ䰡 ����)
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    
    --SELECT ���� ����� ������ �� �Ҵ��ߴ��� Ȯ��
    dbms_output.put_line('dname: ' || dname || '(' || deptno || ')');
END;
/
------------
--10�� �μ��� �μ��̸��� LOC������ ȭ�鿡 ����ϴ� ���ν���
--���ν����� : printdept
--CREATE OR REPLACE VIEW
CREATE OR REPLACE PROCEDURE printdept 
IS
    --��������
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;    
BEGIN
    SELECT dname, loc 
    INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line('dname, loc = ' || dname || ',' || loc);
END;
/
exec printdept;
-------------------
CREATE OR REPLACE PROCEDURE printdept_P(p_deptno IN dept.deptno%TYPE)
IS
    --��������
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;    
BEGIN
    SELECT dname, loc 
    INTO dname, loc
    FROM dept
    WHERE deptno = P_deptno;
    
    dbms_output.put_line('dname, loc = ' || dname || ',' || loc);
END;
/
exec printdept_p(30); --����
--------
--�����ǽ� pro_1 p.16
CREATE OR REPLACE PROCEDURE printemp(p_empno IN emp.empno%TYPE)
IS
    ename emp.ename%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT a.ename, b.dname
    INTO ename, dname
    FROM emp a, dept b
    WHERE a.deptno = b.deptno
    AND p_empno = a.empno;
    
    dbms_output.put_line('ename, dname = ' || ename|| ',' || dname);
END;
/
exec printemp(7369);
--------------------
--�ǽ� pro_2
CREATE OR REPLACE PROCEDURE registdept_test
(p_deptno IN dept_test.deptno%TYPE, 
 p_dname IN dept_test.dname%TYPE,  
 p_loc IN dept_test.loc%TYPE)
IS
    
BEGIN
    INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc);
    
    dbms_output.put_line(p_deptno || ',' || p_dname || ',' || p_loc);
END;
/
exec registdept_test(99, 'ddit', 'daejeon');    
    select * from dept_test;

  