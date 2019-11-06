/*
- �׷��Լ�
- multi eow function : �������� ���� �Է����� �ϳ��� ��� ���� ����
- SUM, MAX, MIN, AVG, COUNT
- GROUP BY COL | express
- SELECT������ GROUP BY���� ����� COL, EXPRESS ǥ�Ⱑ��
*/

--���� �� ���� ���� �޿� ��ȸ
-- 14���� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

--�μ����� ���� ���� �޿� ��ȸ
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--�ǽ� grp3
SELECT  deptno ,
            MAX(sal) max_sal,
            MIN(sal) min_sal,
           ROUND(AVG(sal),1) avg_sal,
            SUM(sal) sum_sal,
            COUNT(sal) sal_cnt,
            COUNT(mgr) mgr_cnt,
            COUNT(deptno) empno_cnt
FROM emp
GROUP BY deptno;

SELECT 
    case
        when deptno = '10' then 'ACCOUNTING'
        when deptno = '20' then 'RESEARCH'
        when deptno = '30' then 'SALES'
    end dname,
      MAX(sal) max_sal,
         MIN(sal) min_sal,
         ROUND(AVG(sal),1) avg_sal,
         SUM(sal) sum_sal,
         COUNT(sal) sal_cnt,
         COUNT(mgr) mgr_cnt,
         COUNT(deptno) empno_cnt
FROM emp
GROUP BY deptno
ORDER BY deptno DESC;

--decode ����ؼ� �ٽ� �غ���

--grp4
/*
emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�. ������ �Ի� ������� ����� ������ 
�Ի��ߴ��� ��ȸ�ϴ� ������ �ۼ�
*/
DESC EMP;
SELECT 
   TO_CHAR(hiredate, 'YYYYMM') HIRE_YYYYMM,
   COUNT(TO_CHAR(hiredate, 'YYYYMM')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYYMM');

--grp5
--emp ���̺��� �̿��Ͽ� ������ �Ի� �⺰�� ����� ������ �Ի��ߴ��� ��ȸ
SELECT 
   TO_CHAR(hiredate, 'YYYY') HIRE_YYYY,
   COUNT(TO_CHAR(hiredate, 'YYYY')) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY')
ORDER BY  TO_CHAR(hiredate, 'YYYY'); --ORDER BY�� �������� ����

--grp6
--ȸ�翡 �����ϴ� �μ��� ������ ����� ��ȸ
SELECT COUNT(deptno)cnt, COUNT(*) cnt
FROM DEPT;

/*
- JOIN
- emp ���̺��� dname �÷��� ���� => �μ���ȣ(deptno)�ۿ� ����
*/
--emp ���̺� �μ��̸��� ������ �� �ִ� dname �÷� �߰�
ALTER TABLE emp ADD (dname VARCHAR2(14));

SELECT *
FROM emp;

UPDATE emp SET dname = 'ACCOUNTING' WHERE DEPTNO=10;
UPDATE emp SET dname = 'RESERCH' WHERE DEPTNO=20;
UPDATE emp SET dname = 'SALES' WHERE DEPTNO=30;
COMMIT;

SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

ALTER TABLE emp DROP COLUMN DNAME; --���̺��̸� ����

SELECT *
FROM emp;

--anai natural join : �����ϴ� ���̺��� �÷Ÿ��� ���� �÷��� �������� JOIN)
SELECT DEPTNO, ENAME, DNAME
FROM emp NATURAL JOIN DEPT;

--ORACLE join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno;


--ANSI JOING WITH USING
SELECT emp, empno, emp.ename, dept.dname
FROM emp JOIN dept USING (deptno)

--fROM���� JOIN ��� ���̺� ����
--WHERE ���� JOIN ���� ���
--������ ����ϴ� �������൵ ��� ����
SELECT emp, empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.dname
from emp, dept
WHERE emp.deptno dept.deptno;
  AND emp.job = 'SALESMAN',  --job�� SALES�� ����� ������� ��ȸ
         
--JOIN with ON (�����ڰ� JOIN �÷��� on���� ���� ���)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--SELF join : ���� ���̺��� join
--emp���̺��� mgr ������ �����ϱ� ���ؼ� emp ���̺�� ������ �ؾ��Ѵ�.
--a : ��������, b : ������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno)
WHERE a.empno BETWEEN 7369 AND 7698;

SELECT *
FROM dept;

--self join(oracle)
SELECT s.ename, m.ename AS manger
FROM emp m, emp s
WHERE s.empno BETWEEN 7369 AND 7698
AND m.empno = s.mgr;

--non-equijoing(��� ������ �ƴѰ��)
SELECT *
FROM salgrade;

--������ �޿� �����?
SELECT empno, ename, sal
FROM emp;

SELECT emp, empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;



