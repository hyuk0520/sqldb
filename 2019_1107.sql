/*
- emp ���̺��� �μ���ȣ(deptno)�� ����
- emp ���̺��� �μ����� ��ȸ�ϱ� ���ؼ��� dept ���̺�� join�� ���� �μ��� ��ȸ

- join ����
- ANSI : ���̺� JOIN ���̺�2 ON (���̺�.COL = ���̺�2.COL)
-        emp JOIN dept ON (emp.deptno = dept.deptno)
- ORACLE : FROM ���̺�, ���̺�2 WHERE ���̺�.col = ���̺�2.col
           FROM emp, dept WHERE emp.deptno = dept.deptno
*/

--�����ȣ, �����, �μ���ȣ, �μ���
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp , dept
WHERE emp.deptno = dept.deptno;

--�ǽ� join0_2
-- emp, dept ���̺��� �̿��Ͽ� ������ �ۼ�(�޿��� 2500�ʰ�)
SELECT emp.empno, emp.ename, sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND  emp.sal > 2500
ORDER BY deptno;

--ANSI ���


-- join0_3
-- emp, dept ���̺� �̿� (�޿� 2500�ʰ�, ��� 7600���� ū ����)
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.sal > 2500
AND emp.empno > 7600;

--join0_4
--�޿� 2500�ʰ�, ����� 7600���� ũ�� �μ����� RESERCH�� �μ��� ���� ����
SELECT emp.empno, emp.sal, dept.deptno, dept.dname
FROM dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = 20
AND emp.sal > 2500 
AND emp.empno > 7600;



--join1
--erd ���̾�׷��� �����Ͽ� prod ���̺�� lprod ���̺��� �����Ͽ� �����ۼ�
SELECT lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM lprod, prod
WHERE lprod.lprod_gu = prod.prod_lgu;
--------------------------------------------------------------------------
--join2
--erd ���̾�׷��� �����Ͽ� buyer, prod, ���̺��� �����Ͽ� byer�� ����ϴ� ��ǰ ������
-- ������ ���� ����� �������� ������ �ۼ�
SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM prod, buyer
WHERE prod.prod_buyer = buyer.buyer_id;
--------------------------------------------------------------------------
--join3
--erd ���̾�׷��� �����Ͽ� member, cart,prod ���̺��� �����Ͽ�
-- ȸ���� ��ٱ��Ͽ� ���� ��ǰ ������ ������ ���� ����� ������ ������
-- �ۼ��Ͻÿ�
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name,
        cart.cart_qty
FROM member, prod, cart
WHERE cart.cart_prod = prod.prod_id AND cart.cart_member = member.mem_id;
--------------------------------------------------------------------------
--�ǽ� join4
--erd ���̾�׷��� �����Ͽ� customer, cycle, product ���̺��� �����Ͽ� ���� ������ǰ,
-- ��������, ����, ��ǰ���� ������ ���� ����� �������� ���� �ۼ� (brown, sally�� ��ȸ)
SELECT customer.cid, customer.cnm, 
       cycle.pid,
       cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
AND customer.cnm in ('brown', 'sally');
--------------------------------------------------------------------------
--join5
--erd ���̾�׷��� �����Ͽ� customer,cycly,product ���̺��� �����Ͽ� ���� ������ǰ,
-- ��������, ����, ��ǰ���� ������ ���� ����� �������� �ۼ�
--(brown, sally�� ��ȸ)
SELECT customer.cid, customer.cnm,
       product.pid, product.pnm,
       cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND product.pid = cycle.pid
AND customer.cnm in ('brown', 'sally');
--------------------------------------------------------------------------
--join6
-- customer, cycle,product ���̺��� �����Ͽ� �������ϰ� �������, ���� ���� ��ǰ��,
-- ������ �հ�, ��ǰ���� ������ ���� ����� �������� ������ �ۼ��غ�����
SELECT cycle.cid, 
       customer.cnm,cycle.pid,
       product.pnm, SUM(cycle.cnt) CNT 
FROM   customer, cycle, product
WHERE  customer.cid = cycle.cid AND product.pid = cycle.pid
GROUP BY cycle.cid, 
         customer.cnm,cycle.pid,
         product.pnm, cycle.cnt;
 -------------------------------------------------------------------------- 



       






select *
from customer;

select *
from cycle;

select *
from product;





