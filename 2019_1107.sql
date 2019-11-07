/*
- emp 테이블에는 부서번호(deptno)만 존재
- emp 테이블에서 부서명을 조회하기 위해서는 dept 테이블과 join을 통해 부서명 조회

- join 문법
- ANSI : 테이블 JOIN 테이블2 ON (테이블.COL = 테이블2.COL)
-        emp JOIN dept ON (emp.deptno = dept.deptno)
- ORACLE : FROM 테이블, 테이블2 WHERE 테이블.col = 테이블2.col
           FROM emp, dept WHERE emp.deptno = dept.deptno
*/

--사원번호, 사원명, 부서번호, 부서명
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp , dept
WHERE emp.deptno = dept.deptno;

--실습 join0_2
-- emp, dept 테이블을 이용하여 쿼리를 작성(급여가 2500초과)
SELECT emp.empno, emp.ename, sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND  emp.sal > 2500
ORDER BY deptno;

--ANSI 방법


-- join0_3
-- emp, dept 테이블 이용 (급여 2500초과, 사번 7600보다 큰 직원)
SELECT emp.empno, emp.ename, emp.sal, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.sal > 2500
AND emp.empno > 7600;

--join0_4
--급여 2500초과, 사번이 7600보다 크고 부서명이 RESERCH인 부서에 속한 직원
SELECT emp.empno, emp.sal, dept.deptno, dept.dname
FROM dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = 20
AND emp.sal > 2500 
AND emp.empno > 7600;



--join1
--erd 다이어그램을 참고하여 prod 테이블과 lprod 테이블을 조인하여 쿼리작성
SELECT lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM lprod, prod
WHERE lprod.lprod_gu = prod.prod_lgu;
--------------------------------------------------------------------------
--join2
--erd 다이어그램을 참고하여 buyer, prod, 테이블을 조인하여 byer별 담당하는 제품 정보를
-- 다음과 같은 결과가 나오도록 쿼리를 작성
SELECT buyer.buyer_id, buyer.buyer_name, prod.prod_id, prod.prod_name
FROM prod, buyer
WHERE prod.prod_buyer = buyer.buyer_id;
--------------------------------------------------------------------------
--join3
--erd 다이어그램을 참고하여 member, cart,prod 테이블을 조인하여
-- 회원별 장바구니에 담은 제품 정보를 다음과 같은 결과가 나오는 쿼리를
-- 작성하시오
SELECT member.mem_id, member.mem_name, prod.prod_id, prod.prod_name,
        cart.cart_qty
FROM member, prod, cart
WHERE cart.cart_prod = prod.prod_id AND cart.cart_member = member.mem_id;
--------------------------------------------------------------------------
--실습 join4
--erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여 고객별 애음제품,
-- 애음요일, 개수, 제품명을 다음과 같은 결과가 나오도록 쿼리 작성 (brown, sally만 조회)
SELECT customer.cid, customer.cnm, 
       cycle.pid,
       cycle.day, cycle.cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
AND customer.cnm in ('brown', 'sally');
--------------------------------------------------------------------------
--join5
--erd 다이어그램을 참고하여 customer,cycly,product 테이블을 조인하여 고객별 애음제품,
-- 애음요일, 개수, 제품명을 다음과 같은 결과가 나오도록 작성
--(brown, sally만 조회)
SELECT customer.cid, customer.cnm,
       product.pid, product.pnm,
       cycle.day, cycle.cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND product.pid = cycle.pid
AND customer.cnm in ('brown', 'sally');
--------------------------------------------------------------------------
--join6
-- customer, cycle,product 테이블을 조인하여 애음요일과 관계없이, 고객별 애음 제품별,
-- 개수의 합과, 제품명을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
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





