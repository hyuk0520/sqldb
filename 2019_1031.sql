--���̺��� ������ ��ȸ
/*
    SELECT �÷� | express (���ڿ����)
    FROM �����͸� ��ȸ�� ���̺�(VIEW)
    WHERE ���� (collection)
*/

SELECT 'TEST'
FROM emp;

DESC user_tables;
SELECT table_name, 'SELECT * FROM' || table_name || ',' AS select_query
FROM user_tables
WHERE TABLE_NAME != 'EMP';

SELECT *
FROM user_objects;

--���ں� ����
-- �μ���ȣ�� 30������ ũ�ų� ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno >= 30;

--�μ���ȣ�� 30������ ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno < 30;

--�Ի����ڰ� 1982�� 1�� 1�� ������ ���� ��ȸ
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'YYYY/MM/DD');
--WHERE hiredate < TO_DATE('01011982', 'MMDDYYYY'); --�̱���¥����

--BETWEEN X AND Y ����
--�÷��� ���� x���� ũ�ų� ����, y���� �۰ų� ���� ������
--�޿��� (sal)�� 1000���� ũ�ų� ����, y���� �۰ų� ���� �����͸� ��ȸ
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--���� BETWEEN AND �����ڴ� �Ʒ��� <=, >= ���հ� ����
SELECT *
FROM emp
WHERE sal >= 1000 
AND sal <= 2000
AND deptno = 30;

--emp ���̺��� �Ի� ���ڰ� 1982��1��1�� ���ĺ��� 1983�� 1�� 1�� ������ �����
--ename, hiredate �����͸� ��ȸ�ϴ� ������ �ۼ��Ͻÿ� �����ڴ� between ����Ұ�

SELECT ename, hiredate
FROM emp
WHERE hiredate
BETWEEN TO_DATE('1982/01/01', 'YYYY/MM/DD')
AND TO_DATE('1983/01/01', 'YYYY/MM/DD');

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD')
AND hiredate <= TO_DATE('19830101', 'YYYYMMDD');

--IN ������
-- COL IN (VALUES...)
-- �μ���ȣ�� 10 Ȥ�� 20�� ���� ��ȸ

SELECT *
FROM emp
WHERE deptno in (10, 20);

--IN �����ڴ� OR �����ڷ� ǥ���� �� �ִ�.
SELECT *
FROM emp
WHERE depthno = 10
OR depthno = 20;

-- user ���̺��� userid�� brown, cony, sally�� �����͸� ��ȸ�Ͻÿ�
-- (IN ������ ���)

SELECT userid as ���̵� , usernm as �̸�, alias as ����
FROM userS
WHERE userid in ('brown', 'cony', 'sally');

-- COL LIKE 'S%'
-- COL�� ���� �빮�� S�� �����ϴ� ��� ��
-- COL LIKE 'S____'
-- COL�� ���� �빮�� S�� �����ϰ� �̾ 4���� ���ڿ��� �����ϴ� ��

-- emp ���̺��� �����̸��� s�� �����ϴ� ��� ���� ��ȸ
SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____';

--member ���̺��� ȸ���� ���� [��]���� ����� mem_id, mem_name�� ��ȸ
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

-- member ���̺��� ȸ���� �̸��� ���� [��]�� ���� ��� ����� 
-- mem_id, mem_name�� ��ȸ
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%'; --mem_name�� ���ڿ��ȿ� �̷� �����ϴ� ������
--WHERE mem_name LIKE '��%'; mem_name�� '��'�� �����ϴ� ������

--NULL ��
-- col IS NULL
-- EMP ���̺��� MGR ������ ���� ���(NULL) ��ȸ
SELECT *
FROM emp
WHERE mgr IS NULL;
--WHERE mgr != NULL;

--�ҼӺμ��� 10���� �ƴ� ������
SELECT *
FROM emp
WHERE deptno != '10';
-- =, !=
-- is null is not null

-- emp ���̺��� ��(comm)�� �ִ� ȸ���� ������ ��ȸ�Ͻÿ�

SELECT *
FROM emp
WHERE comm is not null;


-- AND / OR
-- ������(mgr) ����� 7698�̰� �޿��� 1000 �̻��� ���
SELECT *
FROM emp
WHERE mgr = 7698
AND sal >= 1000;

-- emp ���̺��� ������(mgr) ����� 7698 �̰ų� �޿�(sal)�� 1000 �̻��� ������ȸ
SELECT *
FROM emp
WHERE mgr = 7698
OR sal >= 1000;

-- emp ���̺��� ������(mgr) ����� 7698�̰�, 7839�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN (7698, 7839);

SELECT *
FROM emp
WHERE mgr != 7698
AND mgr != 7839;

-- IN, NOT IN �������� NULL ó��
-- emp ���̺��� ������(mgr) ����� 7698, 7839 �Ǵ� null�� �ƴ� ������ ��ȸ

SELECT *
FROM emp
--WHERE mgr NOT IN (7698, 7839, NULL);
-- IN �����ڿ��� NULL�� ���� ��� �ǵ����� ���� ������ �Ѵ�.
WHERE mgr NOT IN (7698, 7839)
AND mgr IS NOT NULL;

-- emp ���̺��� job�� SALESMAN �̰� �Ի����ڰ� 1981�� 6�� 1�� ������
-- ������ ������ ��ȸ�Ͻÿ�
SELECT *
FROM emp
WHERE job = 'SALESMAN'
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������
-- ������ ������ ������ ���� ��ȸ�Ͻÿ�(IN, NOT IN ������ ��� ����)
SELECT *
FROM emp
WHERE deptno != 10
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������
-- ������ ������ ������ ���� ��ȸ�Ͻÿ�(NOT IN ������ ���)
SELECT *
FROM emp
WHERE deptno NOT IN (10)
AND  hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- emp ���̺��� �μ���ȣ�� 10���� �ƴϰ� �Ի����ڰ� 1981�� 6�� 1�� ������
-- ������ ������ ������ ���� ��ȸ�Ͻÿ�
--(�μ��� 10,20,30�� �ִٰ� �����ϰ� IN �����ڸ� ���)
SELECT *
FROM emp
WHERE deptno IN (20, 30)
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

-- emp ���̺��� job�� SALESMAN �̰ų� �Ի����ڰ� 1981�� 6�� 1�� ������
-- ������ ������ ������ ���� ��ȸ�Ͻÿ�

SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate > TO_DATE('19810601', 'YYYYMMDD');

-- emp ���̺��� job�� SALESMAN �̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ȸ
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE '78%';

-- emp ���̺��� job��  SALESMAN �̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ȸ
--(like ������ ������� �� ��)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE ('78%');

SELECT *
FROM emp;








