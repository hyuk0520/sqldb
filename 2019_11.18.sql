--synonym�� public�� ���̷��� system���������� ����

SELECT *
FROM user_views;

SELECT *
FROM all_views;

SELECT *
FROM all_views
WHERE owner='hyuk';



SELECT *
FROM hyuk.v_emp_dept;

--pc22�������� ��ȸ������ ���� v_emp_dept view�� hr�������� ��ȸ�ϱ� ���ؼ���
--������.view�̸� �������� ����� �ؾ� �Ѵ�
--�Ź� �������� ����ϱ� �������Ƿ� synonym�� ���� �ٸ� ��Ī�� ����

CREATE SYNONYM v_emp_dept FOR hyuk.v_emp_dept;

--pc22.v_emp_dept --> v_emp_dept
SELECT *
FROM v_emp_dept;

--synonym ����
--DROP SYNONYM synonym��;
DROP SYNONYM v_emp_dept;

--hr���� ��й�ȣ : java
--hr���� ��й�ȣ ���� : hr
ALTER USER hr IDENTIFIED BY hr;
--ALTER USER pc22 IDENTIFIED BY jvav;--���� ������ �ƴ϶� ���� ����

--GRANT��������
--WITH GRANT OPTION : ������ �ο����� ����ڰ� �ٸ� ����ڿ��� �ο���

--CONNECT�� RESOURCE�� ROLE�� �����̴�



--DATA DICTIONARY
--���ξ� : USER : ����� ���� ��ü
--      : ALL : ����ڰ� ��밡���� ��ü
--      : DBA : ������ ������ ��ü ��ü(�Ϲ� ����ڴ� ��� �Ұ�)
--      : V$ : �ý��۰� ���õ� VIEW(�Ϲ� ����ڴ� ��� �Ұ�)

SELECT *
FROM user_tables;

SELECT *
FROM all_tables;

SELECT *
FROM dba_tables;--SYSTEM������ �ƴϸ� �����߻�

SELECT *
FROM dba_tables
WHERE owner IN('PC22','HR');

--����Ŭ���� ������ SQL�̶�?
--���ڰ� �ϳ��� Ʋ���� �ȵ�
--���� SQL���� ���� ����� ����� ���� ���� DBMS������ ���� �ٸ� SQL�� �νĵȴ�
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
WHERE gb='����ŷ'
ORDER BY addr;

SELECT *
FROM fastfood
WHERE gb='�Ƶ�����'
ORDER BY addr;

SELECT *
FROM fastfood
WHERE gb='�Ե�����'
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
    WHERE gb IN ('�Ƶ�����','����ŷ','�Ե�����','KFC')
    ORDER BY sido, sigungu, gb ) a;



SELECT 
    (SELECT a.*
    FROM a
    WHERE a.gb IN ('�Ƶ�����','����ŷ','�Ե�����'))
FROM
    (SELECT *
    FROM fastfood
    WHERE gb IN ('�Ƶ�����','����ŷ','�Ե�����','KFC')
    ORDER BY sido, sigungu, gb) a;


