-- SELECT : ��ȸ�� �÷� ���
--          - ��ü�÷� ��ȸ : *
--          - �Ϻ��÷� : �ش� �÷��� ����(, ����)
-- FROM : ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� ��� ����.
-- ��, keyword�� �ٿ��� �ۼ�
-- ��� �÷��� ��ȸ
SELECT * 
FROM prod;

--Ư�� �÷��� ��ȸ
SELECT prod_id, prod_name
FROM prod;

--1) lprod ���̺��� ��� �÷� ��ȸ
SELECT * 
FROM lprod;

--2) byer_id, byer_name �÷��� ��ȸ
SELECT buyer_id, buyer_name
FROM buyer;

--3) cart ���̺��� ��� �����͸� ��ȸ�ϴ� ����
SELECT *
FROM cart;

--4) member ���̺��� id pass name �÷��� ��ȸ�ϴ� ����
SELECT mem_id, mem_pass, mem_name
FROM member;

--������ / ��¥����
--date type + ���� : ���ڸ� ���Ѵ�.
--null�� ������ ������ ����� �׻� null �̴�.
SELECT userid, usernm, reg_dt, reg_dt + 5 reg_dt_after5, 
        reg_dt-5 as reg_dt_before5
FROM users;

SELECT *
FROM users;


-- prod ���̺��� prod_id prod_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--(�� prod_id -> id, prod_name -> name ���� �÷� ��Ī�� ����)
SELECT prod_id as id , prod_name as name
FROM prod;

--1prod ���̺��� lprod_gu lprod_nm �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�.
--(�� lprod_gu -> gu, lprod_nm -> nm���� ���� )
SELECT  lprod_gu as gu, lprod_nm as nm
from lprod;

--buyer ���̺��� buyer_id, buyer_name �� �÷��� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--(�� buyer_id -> ���̾���̵�, buyer_name -> �̸�)
SELECT buyer_id as ���̾���̵�, buyer_name as �̸�
FROM buyer;

--���ڿ� ����
--java + --> sql ||
--CONCAT(str, str) �Լ�
--users ���̺��� userid, usernm
SELECT userid, usernm, 
        userid || usernm, 
FROM users;

--���ڿ� ���(�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : ', userid,
        CONCAT('����� ���̵� : ', userid)
FROM users;

--�ǽ� sel_con1
SELECT 'select * from' || table_name || ';' as query
       
FROM user_tables;

--desc table
--���̺� ���ǵ� �÷��� �˰� ���� ��
--1.desc
--2.select * ....
desc emp;

SELECT *
FROM emp;


--WHERE�� ���ǿ�����
SELECT *
FROM users
WHERE userid = 'brown';

--usernm�� ������ �����͸� ��ȸ�ϴ� ������ �ۼ�
SELECT *
FROM users
WHERE userid = 'sally';

