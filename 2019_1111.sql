--SMITH, WARD�� ���ϴ� �μ��� ������ ��ȸ
SELECT *
  FROM emp
 WHERE deptno IN (20,30);

SELECT *
  FROM emp
 WHERE deptno = 20
   OR deptno = 30;
   
SELECT *
  FROM emp
 WHERE deptno in(SELECT deptno
                   FROM emp
                  WHERE ename IN('SMITH','WARD') );
                
SELECT *
  FROM emp
 WHERE deptno in(SELECT deptno
                   FROM emp
                  WHERE ename IN(:name1, :name2) );
                  
--ANY : SET�߿� �����ϴ°� �ϳ��� ������ ������(ũ���)
--SMITH,WARD �� ����� �޿����� ���� �޿��� �޴� �������� ��ȸ
SELECT *
  FROM emp
 WHERE sal < ANY(SELECT sal --800,1250 --> 1250���� ���� �޿��� �޴»��
                  FROM emp
                 WHERE ename IN ('SMITH','WARD') );
                 
--SMITH �� WARD���� �޿��� ���� ���� ��ȸ
--SMITH���ٵ� �޿��� ���� WARD���ٵ� �޿��� ���� ���(AND)
SELECT *
  FROM emp
 WHERE sal > ANY(SELECT sal --800,1250 --> 1250���� ���� �޿��� �޴»��
                  FROM emp
                 WHERE ename IN ('SMITH','WARD') );

--NOT IN
--�������� ��������
--1.�������� ����� ��ȸ
-- . mgr �÷��� ���� ������ ����
SELECT DISTINCT mgr
FROM emp
ORDER BY mgr;

--� ������ ������ ������ �ϴ� �������� ��ȸ
SELECT *
FROM emp
WHERE empno IN(7839,7782,7698,7902,7566,7788);

SELECT *
  FROM emp
WHERE empno IN (SELECT mgr
                   FROM emp );
                   
SELECT *
  FROM emp
WHERE empno IN (SELECT mgr
                   FROM emp );


--������ ������ ���� �ʴ� ���� ���� ��ȸ
--�� NOT IN������ ���� SET�� NULL���� ���Ե� ��� ���������� �������� �ʴ´�.
--NULLó�� �Լ��� WHERE���� ���� NULL���� ó���� ���� ���
SELECT *
  FROM emp --7839,7782,7698,7902,7566,7788 �������� ����� ���Ե��� �ʴ� ���� 
 WHERE empno NOT IN (SELECT mgr
                   FROM emp );


--pair wise
--��� 7499,7782�� ������ ������,�μ���ȣ ��ȸ
--7698 30
--7839 10
--mgr, deptno �÷��� [����]�� ���� ��Ű�� �������� ��ȸ
SELECT mgr, deptno
FROM   emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                          FROM emp                       
                         WHERE empno IN(7499,7782) );
                         

SELECT mgr, deptno
FROM   emp
WHERE mgr IN (SELECT mgr
                FROM emp                       
               WHERE empno IN(7499,7782) )
AND deptno IN (SELECT deptno
                 FROM emp
                WHERE empno IN (7499,7782) );
                
--SCLAR SUBQUERY : SELECT���� �����ϴ� ��������(�� ���� �ϳ��� ��, �ϳ��� �÷�)
--������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT empno, ename, deptno,(SELECT dname
                               FROM dept
                              WHERE deptno = emp.deptno) dname
FROM emp;

--sub4 ������ ����
INSERT INTO dept VALUES (99,'ddit','daejeon');
COMMIT;

--�ǽ� sub4 
SELECT * 
  FROM dept
 WHERE deptno NOT IN (SELECT deptno
                        FROM emp);
                        
--�ǽ� sub5
SELECT pid
  FROM cycle
 WHERE cid = 1;
   
SELECT *
FROM product 
WHERE pid NOT IN (SELECT pid
                    FROM cycle
                    WHERE cid = 1);

--�ǽ� sub6
SELECT *
FROM   cycle
WHERE  cid = 1
AND    pid IN (SELECT PID 
               FROM cycle 
               WHERE CID = 2);

--�ǽ� sub7 (����)
SELECT a.cid, 'borwn' cnm, b.pid, b.pnm, a.day, a.cnt
  FROM cycle a, product b
 WHERE a.cid = 1
   AND a.day IN (2,4,6)
   AND b.pid IN (SELECT b.pid
                   FROM product
                  WHERE b.pid = 100);


--EXISTS MAIN������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
--�����ϴ� ���� �ϳ��� �����Ѵٸ� ���̻� �������� �ʰ� ���߱� ������ ���ɸ鿡�� ����

--MGR�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X'
                FROM emp
               WHERE empno = a.mgr);
               
--MGR�� �������� �ʴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X'
                    FROM emp
                   WHERE empno = a.mgr);

--�ǽ� sub8
SELECT *
FROM emp 
WHERE mgr IS NOT NULL;

--�μ��� �Ҽӵ� ������ �ִ� �μ����� ��ȸ(EXISTS)
SELECT * 
FROM dept
WHERE EXISTS (SELECT 'X'
                FROM emp
                WHERE emp.deptno = dept.deptno);



--�ǽ� SUB9 ���� 
SELECT *
  FROM product
 WHERE EXISTS (SELECT 'X'
                 FROM cycle
                WHERE cycle.cid NOT IN (1));
                  

select * from product;

--���տ���
--UNION : ������, �ߺ��� ����
--        DBMS������ �ߺ��� �����ϱ� ���� �����͸� ����
--        (�뷮�� �����Ϳ� ���� ���Ľ� ����)
--UNION ALL : UNION�� ��������
--            �ߺ��� �������� �ʰ�, �� �Ʒ� ������ ���� => �ߺ�����
--            ���Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ� 
--            UNION �����ں��� ���ɸ鿡�� ����
--����� 7566 �Ǵ� 7698�� ��� ��ȸ(���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION
--����� 7369,7499�� �����ȸ(���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno = 7369 OR empno = 7499;


--UNION ALL(�ߺ����, �� �Ʒ� ������ ��ġ�⸸ �Ѵ�.)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698

UNION ALL
--����� 7369,7499�� �����ȸ(���, �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 OR empno = 7698;
--WHERE empno = 7369 OR empno = 7499;

--INTERSECT(������ : �� �Ʒ� ���հ� ���� ������)
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698,7499);

--MINUS(������ : �� ���տ��� �Ʒ� ������ ����)
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7369)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698,7499);
---

SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499)

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698,7369);

SELECT 1 n, 'x' m
 FROM dual
 
 UNION
 
 SELECT 2, 'y'
 FROM dual
 ORDER BY m DESC;
 
 SELECT *
 FROM USER_CONSTRAINTS
 WHERE OWNER = 'HYUK'
 AND TABLE_NAME IN ('PROD', 'LPROD')
 AND CONSTRAINT_TYPE IN ('P','R');
 
 