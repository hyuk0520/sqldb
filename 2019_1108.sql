/*
-���κ���
-���� ��?
-REDMS�� Ư���� ������ �ߺ��� �ִ� ������ ���踦 �Ѵ�.
-EMP ���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ������� �μ���ȣ�� �����ְ�,
  �μ���ȣ�� ���� DEPT ���̺�� ������ ���� �ش� �μ��� ������ ������ �� �ִ�.
  
-���� ��ȣ, �����̸�, ������ �Ҽ� �μ���ȣ, �μ��̸�
-emp, dept
*/
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--�μ���ȣ, �μ���, �ش�μ��� �ο���

SELECT emp.deptno, dept.dname, COUNT(emp.empno) AS CNT
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY   emp.deptno, dept.dname; 

/*
- OUTER JOIN : ���ο� �����ص� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ����� �������� �ϴ� ��������
- LEFT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ��� �ϴ� ��������
- RIGHT OUTER JOIN : JOIN KEYWORD �����ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ��� �ϴ� ��������
-FULL OUTER JOIN : LEFT OUTER JOON + RIGHT OUTER JOIN - �ߺ�����
*/
--���������� �ش� ������ ������ ���� outer join
--��������, �����̸�, �����ڹ�ȣ, ������ �̸�


SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno);

--oracle outer join (left, right�� ���� fullouter�� �������� ����)
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a,  emp b
WHERE a.mgr = b.empno(+);

-- ANSI LEFT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
  FROM emp a LEFT OUTER JOIN emp b 
    ON (a.mgr = b.empno)
 WHERE b.deptno = 10;

--oracle outer ���������� outer ���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ���� 
--outer join�� ���������� �����Ѵ�.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+)
AND b.deptno(+) = 10;

--ANSI RIGHT OUTER
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON (a.mgr = b.empno);

--�ǽ� outerjoin1
--buyprod ���̺� �������ڰ� 2005�� 1�� 25���� �����ʹ� 3ǰ��ۿ� ����.
--��� ǰ���� ���� �� �ֵ��� ������ �ۼ��Ͻÿ�
SELECT buyprod.buy_date, buyprod.buy_prod, prod.prod_name, buyprod.buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id
                                  AND buyprod.buy_date = TO_DATE('050125', 'YYMMDD'));

SELECT a.buy_date, a.buy_prod, b.prod_name, a.buy_qty
FROM buyprod a, prod b
WHERE a.buy_prod(+) = b.prod_id 
AND a.buy_date(+) = TO_DATE('050125', 'YYMMDD');

--�ǽ� outerjoin2
SELECT TO_DATE('050125', 'YYMMDD'), buyprod.buy_prod, prod.prod_name, buyprod.buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id 
                                   AND buyprod.buy_date = TO_DATE('050125', 'YYMMDD'));
                                   
--�ǽ� outerjoin3
SELECT TO_DATE('050125', 'YYMMDD'), buyprod.buy_prod, prod.prod_name, 
                                    nvl(buyprod.buy_qty, 0)
FROM buyprod RIGHT OUTER JOIN prod ON (buyprod.buy_prod = prod.prod_id 
                                   AND buyprod.buy_date = TO_DATE('050125', 'YYMMDD'));

--�ǽ� outerjoin4
SELECT b.pid, b.pnm, nvl(a.cid,1) cid, nvl(a.day,0) day, nvl(a.cnt,0) cnt
FROM cycle a RIGHT OUTER JOIN product b ON (a.pid = b.pid AND a.cid = 1);

SELECT b.pid, b.pnm, nvl(a.cid,1) cid, nvl(a.day,0) day, nvl(a.cnt,0) cnt
FROM cycle a , product b
WHERE a.pid(+) = b.pid AND a.cid(+) = 1;

--�ǽ� outerjoin5 �ٽ� Ǯ��� ��
SELECT b.pid, b.pnm, nvl(a.cid,1) cid, c.cnm, nvl(a.day,0) day, nvl(a.cnt,0) cnt
FROM cycle a , product b, customer c
WHERE a.pid(+) = b.pid 
AND a.cid(+) = 1 AND a.cid = c.cid ;

--�ǽ� crossjoin1
SELECT c.cid, c.cnm, p.pid, p.pnm
FROM customer c, product p;

SELECT c.cid, c.cnm, p.pid, p.pnm
FROM customer c CROSS JOIN product p;

/*
 SUBQUERT : main������ ���ϴ� �κ� ����
 ���Ǵ� ��ġ : 
 -SELECT -scalar subquery(�ϳ��� ���, �ϳ��� �÷��� ��ȸ�Ǵ� �����̾�� �Ѵ�)
 -FROM - inline view
 -WHERE - subquery
*/
--SCALAR subquery
SELECT empno, ename, (SELECT SYSDATE FROM dual)now 
FROM emp;
------------------------------------------------------------
SELECT deptno --20
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = 20;

-- �� �ΰ� ����

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

--�������� �ǽ� sub1
SELECT AVG(sal)
FROM emp;

SELECT COUNT(sal) 
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
 
--�ǽ� SUB2
SELECT AVG(sal)
FROM emp;

SELECT * 
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
--sub3
SELECT *
FROM emp
WHERE deptno IN ((SELECT deptno
                FROM emp
                WHERE ename = 'SMITH'),(SELECT deptno
                FROM emp
                WHERE ename = 'WARD'));

SELECT *
FROM emp
WHERE DEPTNO = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH')
                    
   OR DEPTNO = (SELECT deptno
                FROM emp
                WHERE ename = 'WARD')
                ;
            
SELECT *
FROM emp
WHERE DEPTNO = 30;





select * from emp; 
                             
