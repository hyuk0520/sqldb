--�������� ����
--����ŷ, �Ƶ�����, kfc ����

SELECT GB, SIDO, SIGUNGU
FROM   fastfood
WHERE  SIDO = '����������'
AND    gb IN('����ŷ', '�Ƶ�����', 'KFC')
ORDER BY SIDO, SIGUNGU, GB;

--�Ե�����
SELECT SIGUNGU, SIDO, COUNT(*) cnt
FROM   fastfood
WHERE  gb IN('KFC', '����ŷ', '�Ƶ�����')
GROUP BY SIDO, SIGUNGU;

--join �ϱ�
SELECT a.sido, a.sigungu, a.cnt kbm, b.cnt l,
       round(a.cnt/b.cnt,2) point
FROM
    --140�� (����)
    (SELECT SIGUNGU, SIDO, COUNT(*) cnt
    FROM   fastfood
    WHERE  gb IN('KFC', '����ŷ', '�Ƶ�����')
    GROUP BY SIDO, SIGUNGU) a,
    --188��(����)
    (SELECT SIGUNGU, SIDO, COUNT(*) cnt
    FROM   fastfood
    WHERE    gb IN('�Ե�����')
    GROUP BY SIDO, SIGUNGU) b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
    ORDER BY point desc;
    
-----------------------------------------------------------
SELECT sido, sigungu, sal, ROUND(sal/people, 2) point
FROM tax
ORDER BY sal desc;
--ORDER BY point desc;

--�������� �õ�, �ñ��� | �������� �õ� �ñ���
--�õ�, �ñ���, ��������, �õ�, �ñ���, �������� ���Ծ�
--����� �߱� 5.7 ��⵵ ������ 18623591

(SELECT c.*, ROWNUM rn
FROM 
    (SELECT a.sido, a.sigungu, a.cnt kbm, b.cnt l, round(a.cnt/b.cnt,2) point
    FROM
        --140�� (����)
        (SELECT SIGUNGU, SIDO, COUNT(*) cnt
        FROM   fastfood
        WHERE  gb IN('KFC', '����ŷ', '�Ƶ�����')
        GROUP BY SIDO, SIGUNGU) a,
        --188��(����)
        (SELECT SIGUNGU, SIDO, COUNT(*) cnt
        FROM   fastfood
        WHERE    gb IN('�Ե�����')
        GROUP BY SIDO, SIGUNGU) b
        WHERE a.sido = b.sido
        AND a.sigungu = b.sigungu
        ORDER BY point desc)c);
    

(SELECT d.*, ROWNUM rn2    
FROM
    (SELECT sido, sigungu, sal
    FROM tax
    ORDER BY sal desc) D);

SELECT q.rn, q.sido, q.sigungu, q.point, w.sido, w.sigungu, w.sal
FROM (SELECT c.*, ROWNUM rn
FROM 
    (SELECT a.sido, a.sigungu, a.cnt kbm, b.cnt l, round(a.cnt/b.cnt,2) point
    FROM
        --140�� (����)
        (SELECT SIGUNGU, SIDO, COUNT(*) cnt
        FROM   fastfood
        WHERE  gb IN('KFC', '����ŷ', '�Ƶ�����')
        GROUP BY SIDO, SIGUNGU) a,
        --188��(����)
        (SELECT SIGUNGU, SIDO, COUNT(*) cnt
        FROM   fastfood
        WHERE    gb IN('�Ե�����')
        GROUP BY SIDO, SIGUNGU) b
        WHERE a.sido = b.sido
        AND a.sigungu = b.sigungu
        ORDER BY point desc)c) Q,
        (SELECT d.*, ROWNUM rn2    
FROM
    (SELECT sido, sigungu, sal
    FROM tax
    ORDER BY sal desc) D) W 
WHERE Q.rn = W.rn2;


--emp_test ���̺� ����
DROP TABLE emp_test;

--multiple insert�� ���� �׽�Ʈ ���̺� ����
--empno, ename �ΰ��� �÷��� ���� emp_test, emp_test2 ���̺���
--emp ���̺�κ��� �����Ѵ�(CTAS)
--�����ʹ� �������� �ʴ´�

--CREATE TABLE emp_test AS
CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp
WHERE 1=2;

--INSERT ALL
--�ϳ��� INSERT SQL �������� ���� ���̺� �����͸� �Է�
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT 1, 'brown' FROM dual UNION ALL    
SELECT 2, 'sally' FROM dual;

--INSERT ������ Ȯ��
SELECT * FROM emp_test;
SELECT * FROM emp_test2;

--INSERT ALL �÷� ����
ROLLBACK;

INSERT ALL
    INTO emp_test(empno) VALUES(empno)
    INTO emp_test2 VALUES(empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual; 
--������ Ȯ��
SELECT * FROM emp_test;
SELECT * FROM emp_test2;

--multiple insert (conditional insert)
ROLLBACK;
INSERT ALL
    WHEN empno < 10 THEN
        INTO emp_test (empno) VALUES (empno)
    ELSE    --������ ������� ���� ���� ����
        INTO emp_test2 CALUES (empno, ename)
SELECT 20 AS empno, 'brown' AS ename FROM dual UNION ALL
SELECT 2 AS empno, 'sally' AS ename FROM dual; 


--INSERT FIRST
--���ǿ� �����ϴ� ù��° INSERT ������ ����
ROLLBACK;
INSERT FIRST
    WHEN empno > 10 THEN
        INTO emp_test (empno) VALUES (empno)
    WHEN empno > 5 THEN
        INTO emp_test2 CALUES (empno, ename)
SELECT 20 AS empno, 'brown' AS ename FROM dual;

select * from emp_test; 
select * from emp_test2;

ROLLBACK;
--MERGE : ���ǿ� �����ϴ� �����Ͱ� ������ UPDATE
--        ���ǿ� �����ϴ� �����Ͱ� ������ INSERT

--empno�� 7369�� �����͸� emp ���̺�κ��� emp_table���̺� ����(insert)
INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE EMPNO = 7369;

SELECT * FROM emp_test;

--emp���̺��� ������ �� emp_test ���̺��� empno�� ���� ���� ���� �����Ͱ� �������
--emp_test.ename = ename || 'merge'������ update
--�����Ͱ� ���� ��쿡�� emp_test���̺� insert
ALTER TABLE emp_test MODIFY (ename VARCHAR2(20));
MERGE INTO emp_test 
USING (SELECT empno, ename
        FROM emp
       WHERE emp.empno IN (7369, 7499) )  emp
ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);

SELECT * FROM EMP_TEST;

--�ٸ� ���̺��� ������ �ʰ� ���̺� ��ü�� ������ ���� ������ merge�ϴ� ���
ROLLBACK;

--empno = 1, ename = 'brown'
--empno�� ���� ���� ������ ename�� 'brown'���� update
--empno�� ���� ���� ������ �ű� insert 
--(�߿�� ���ֻ��)
MERGE INTO emp_test
USING dual
 ON (emp_test.empno = 1)
WHEN MATCHED THEN
    UPDATE SET ename = 'brown' || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES(1, 'brown');
    
SELECT 'X'
FROM emp_test
WHERE empno =1;

UPDATE emp_test SET ename = 'brown' || '_marge'
WHERE empno =1;

INSERT INTO emp_test VALUES (1, 'brown');

--�ǽ� GROUP_AD1
--�׷캰 �հ�, ��ü �հ踦 ������ ���� ���Ϸ���?? (table:emp)

SELECT deptno, sum(sal) AS sal
FROM emp
GROUP BY deptno UNION ALL
--��� ������ �޿� ��
SELECT null, sum(sal) sal
FROM emp;
--------------------------------------
SELECT deptno, sum(sal) sal
FROM emp GROUP BY deptno UNION ALL
SELECT null, sum(sal) sal
FROM emp
ORDER BY deptno;


--rollup
--group by�� ���� �׷��� ����
--GROUP BY ROLLUP( (col,))
--�÷��� �����ʿ������� �����ذ��鼭 ���� ����׷���
--GORUP BY �Ͽ� UNION �� �Ͱ� ����
--ex : GROUP BY ROLLUP (job, deptno)
--     GROUP BY job, deptno
--     UNION
--     GROUP BY job
--     UNION
--     GROUP BY => �Ѱ�(��� �࿡ ���� �׷��Լ� ����)
SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

-------------------------------------
SELECT deptno, sum(sal) sal
FROM emp GROUP BY deptno UNION ALL
SELECT null, sum(sal) sal
FROM emp
ORDER BY deptno;

--�� ������ ROLLUP ���·� ����
--GROUP BY deptno
--UNION ALL
--GROUP BY
SELECT deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);

--GROUPING SETS (col1, col2...)
--GROUPING SETS�� ������ �׸��� �ϳ��� ����׷����� GROUP BY ���� �̿�ȴ�.

--GROUP BY col1
--UNION ALL
--GROUP BY col2


--emp ���̺��� �̿��Ͽ� �μ��� �޿��հ�, ������(job)�� �޿����� ���Ͻÿ�

--�μ���ȣ, job, �޿��հ�
SELECT deptno, null AS job, SUM(sal)
FROM emp
GROUP BY deptno 

UNION ALL

SELECT null, job, SUM(sal)
FROM emp
GROUP BY job;

SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY GROUPING SETS(deptno, job, (deptno, job));










