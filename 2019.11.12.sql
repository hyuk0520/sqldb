--sub7 �ǽ�

--1������ �Դ� ������ǰ
--2�� ���� �Դ� ������ǰ���� ����
--���� �߰�
SELECT cycle.cid, customer.cnm, product.pid, day, cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.pid IN (SELECT pid 
                    FROM cycle
                   WHERE cid = 2); 

--sub9 �ǽ�
SELECT *
FROM product
WHERE NOT EXISTS (SELECT 'X'
                     FROM cycle
                    WHERE cid = 1
                      AND  pid = product.pid);
--------------------------------����Ȯ��---------------------------------------

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

--SELECT ���(������)�� INSERT
INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROM dept;
commit;

--UPDATE
--UPDATE ���̺� SET �÷�=��, �÷�=��...
--WHERE condition

INSERT INTO dept values(99,'ddit','daejeon');
commit;

SELECT * FROM dept;

UPDATE dept SET dname='���IT', loc='ym'
WHERE deptno = 99;
ROLLBACK;

--DELETE ���̺��
--WHERE condition

--�����ȣ�� 9999�� ������ emp ���̺��� ����
DELETE emp
WHERE empno = 9999;

--�μ����̺��� �̿��ؼ� emp ���̺� �Է��� 5��(4��)�� �����͸� ����
--10, 20, 30, 40, 99 --> empno < 100, empno BETWEEN 10 AND 99
DELETE emp
 WHERE empno <100;
 rollback;
 
DELETE emp
WHERE empno BETWEEN 10 AND 99;

DELETE emp
WHERE empno IN (SELECT deptno FROM dept);
commit;
/*�����ϱ� �� select�� �̿��Ͽ� �̸� Ȯ���غ���.*/
select * from emp where empno<100; 

--Oracle������ datablock�� �̷¿� ���� ��Ƽ�������� ����

--LV1 --> LV3
SET TRANSACTION
isolation LEVEL SERIALIZABLE;

SELECT *
FROM dept;

--DDL: AUTO COMMIT, rollback�� �ȵȴ�.
--CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER, --����Ÿ��
    ranger_name VARCHAR2(50), --���� : [VARCHAR2], CHAR
    reg_dt DATE DEFAULT sysdate -- DEFAULT: SYSDATE
);

--ddl�� rollback�� ������� �ʴ´�.
INSERT INTO ranger_new(ranger_no, ranger_name)
VALUES(1000, 'brown');

--��¥ Ÿ�Կ��� Ư�� �ʵ� ��������
--ex: sysdate���� �⵵����������
SELECT TO_CHAR(sysdate, 'yyyy')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt, 'MM'),
       EXTRACT(MONTH FROM reg_dt) mm,
       EXTRACT(YEAR FROM reg_dt) year,
       EXTRACT(day FROM reg_dt) day
FROM ranger_new;

--��������
--DEPT ����ؼ� DEPT_TEST ����
CREATE TABLE dept_test(
    deptno number(2) PRIMARY KEY, --deptno �÷��� �ĺ��ڷ� ����
    dname varchar2(14),           --�ĺ��ڷ� ������ �Ǹ� ���� �ߺ��� �� �� ������
    loc varchar2(13)              --null�� ���� ����.
);

/*
primary key �������� Ȯ��
1.null�� �� �� ����.
2.deptno�÷��� �ߺ��� ���� �� �� ����.
*/
INSERT INTO dept_test(deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon');

INSERT INTO dept_test VALUES(1, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES(1, 'ddit2', 'daejeon');
rollback;


--��������� �������Ǹ��� �ο��� PRIMARY KEY
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