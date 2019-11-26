SELECT ename, sal, deptno, 
        RANK() OVER(PARTITION BY deptno ORDER BY sal) rank,
        DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal) d_rank,
        ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal) rown
FROM emp;

--�ǽ� ana1
SELECT empno, ename, sal, deptno, 
       RANK() OVER(ORDER BY sal DESC, empno) sal_rank,
       DENSE_RANK() OVER(ORDER BY sal DESC, empno) sal_dense_rank,
       ROW_NUMBER() OVER(ORDER BY sal DESC, empno) sal_row_number
FROM emp ;
----------------------------------------------------------
--�ǽ� ana2(p.106)
SELECT deptno, COUNT(*)
FROM emp
GROUP BY deptno;

SELECT ename, empno, emp.deptno, b.cnt
FROM emp, (SELECT deptno, COUNT(*) cnt
           FROM emp
           GROUP BY deptno) b
WHERE emp.deptno = b.deptno
ORDER BY emp.deptno;
-------------------------
--�м��Լ��� ���� �μ��� ������
SELECT ename, empno, deptno,
        COUNT(*) OVER(PARTITION BY deptno) cnt
FROM emp;

--�μ��� ����� �޿� �հ�
--SUM �м��Լ�
SELECT ename, empno, deptno, sal,
        SUM(SAL) OVER(PARTITION BY deptno) sum_sal
FROM emp;
--------------
--�ǽ� ana2 (p.109)
SELECT empno, ename, sal, deptno,  
        ROUND(AVG(sal) OVER (PARTITION BY deptno), 2) avg_sal
FROM emp;
---------
--�ǽ� ana3 (p.110)
SELECT empno, ename, sal, deptno,
        MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;        
-----
--�ǽ� ana4   (p.111)
SELECT empno, ename, sal, deptno,
        MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;
-----

--�μ��� �����ȣ�� ���� �������
--�μ��� �����ȣ�� ���� �������

--window ��Ȯ��
SELECT empno, ename, deptno,
    FIRST_VALUE(empno) OVER(PARTITION BY deptno
                                 ORDER BY empno) f_emp,
    LAST_VALUE(empno) OVER(PARTITION BY deptno
                                 ORDER BY empno) l_emp                                 
FROM emp;
----------
--LAG (������)
--������
--LEAD(������)
--�޿��� ���������� ���� ������ �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�,
--�޿��� ���������� ���� ������ �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�
SELECT empno, ename, sal, LAG(sal) OVER (ORDER BY sal) lag_sal,
                        LEAD(sal) OVER (ORDER BY sal) lead_sal
FROM emp;
----------
--�ǽ� an5 (p.116)
SELECT empno, ename, hiredate, LEAD(sal) OVER(ORDER BY sal desc, hiredate) lead_sal
FROM emp;
------------
--�ǽ� ana6
SELECT empno, ename, hiredate, job, sal, LAG(sal) OVER(PARTITION BY job ORDER BY sal desc, hiredate) lead_sal 
FROM emp;
----------
--�ڡڡ�no_ana3(p.118)�ڡڡ�
SELECT a.empno, a.ename, a.sal, sum(b.sal) sal_sum
FROM
(SELECT a.*, ROWNUM rn
FROM    
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal, empno) a) b 
WHERE a.rn >= b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;

--���������̼� (sql���� 120p) �߿���
--WINDOWING
--UNBOUNDED PRECEDING : ���� ���� �������� �����ϴ� �����
-- CURRENT ROW : ������
--UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� �����
--N(����) PREFCEDING : ���� ���� �������� �����ϴ� N���� ��
--N(����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��

SELECT empno, ename, sal,
        SUM(sal) OVER(ORDER BY sal, empno 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)sum_sal,
        
        SUM(sal) OVER(ORDER BY sal, empno 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)sum_saL2,
        
        SUM(sal) OVER(ORDER BY sal, empno 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)sum_sal3
FROM emp;
----------
--�ǽ� ana7 p.126
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER(PARTITION BY deptno 
                        ORDER BY sal, empno
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

SELECT empno, ename, deptno, sal,
    SUM(sal) OVER(ORDER BY sal 
                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
    
    SUM(sal) OVER(ORDER BY sal 
                  ROWS UNBOUNDED PRECEDING) row_sum2,
                  
    SUM(sal) OVER(ORDER BY sal 
                  RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
    
    SUM(sal) OVER(ORDER BY sal 
                  RANGE UNBOUNDED PRECEDING) range_sum2              
FROM emp;


