/*
--����
- WHERE
- ������
- ��: =, !=, <>, >=, >, <=, <
- BETWEEN start AND end
- IN (set)
- LIKE 'S%' (% : �ټ��� ���ڿ��� ��Ī, _ : ��Ȯ�� �ѱ��� ��Ī)
- IS NULL(!= NULL)
- AND, OR, NOT
*/

/*emp ���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�� ���̿� �ִ�
����������ȸ
*/
SELECT *
FROM emp
WHERE hiredate > TO_DATE ('1981/06/01', 'YYYY/MM/DD')
AND hiredate < TO_DATE ('1986/12/31', 'YYYY/MM/DD');

--emp ���̺��� ������(mgr)�� �ִ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

-- emp ���̺��� job��  SALESMAN �̰ų� �����ȣ�� 78�� �����ϴ� ������ ������ȸ
--(like ������ ������� �� ��)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR (empno > 7800 AND empno < 7900);

/*
WHERE14
emp ���̺��� job�� SALESMAN�̰ų� �����ȣ�� 78�� �����ϸ鼭 �Ի����ڰ�
1981/06/01 ������ ������ ������ ��ȸ�ϼ���
*/

SELECT *
FROM emp
WHERE JOB = 'SALESMAN'
OR (empno LIKE ('78%') AND hiredate > TO_DATE ('1981/06/01', 'YYYY/MM/DD'));

/*
order by �÷��� | ��Ī | �÷��ε��� | [ASD | DESC]
order by ������ WHERE�� ������ ���
WHERE ���� ���� ��� FROM�� ������ ���
emp ���̺��� ename �������� �������� ����
*/
SELECT *
FROM emp
ORDER BY ename ASC;
/*
- ASC : default
- ASC�� �Ⱥٿ��� �� ������ ������
*/
SELECT *
FROM emp
ORDER BY ename;

--�̸�(ename) �������� ��������
SELECT *
FROM emp
ORDER BY ename DESC;

--job�� �������� ������������ ����, ���� job�� �������, ���(empno)���� �ø����� ����
--SALESMAN - PRESIDENT - MANAGER - CLERK - ANALYST
SELECT *
FROM emp
ORDER BY job DESC, empno ASC;

/*
��Ī���� �����ϱ�
�����ȣ(empno), �����(ename), ����(sal * 12) as year_sal
year_sal ��Ī���� �������� ����
*/
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY year_sal;

--SELECT�� �÷����� �ε����� ����
SELECT empno, ename, sal, sal*12 as year_sal
FROM emp
ORDER BY 3;

/*
������ ���� orderby1
- dept ���̺��� ��� ������ �μ��̸����� �������� ���ķ� ��ȸ�ǵ��� �����ۼ�
*/
SELECT *
FROM dept
ORDER BY dname ASC;

-- dept ���̺��� ��� ������ �μ���ġ�� �����������ķ� ��ȸ�ǵ��� �����ۼ�
SELECT *
FROM dept
ORDER BY loc DESC;

/*
orderby2
emp ���̺��� ��(comm)������ �ִ� ����鸸 ��ȸ�ϰ�, �󿩸� ���� �޴� ����� ����
��ȸ�ǵ��� �ϰ� �󿩰� ������� ������� �������� �����Ͻÿ�.
*/
SELECT *
FROM emp
WHERE comm IS NOT NULL
ORDER BY comm DESC, empno ASC;

/*
orderby3
emp���̺��� �����ڰ� �ִ� ����鸸 ��ȸ�ϰ� ����(job) ������ �������� �����ϰ�
������ ���� ��� ����� ū ����� ���� ��ȸ�ǵ��� ������ �ۼ��Ͻÿ�
*/
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job ASC, empno DESC;

/*
orderby4
emp ���̺��� 10���μ�(deptno) Ȥ�� 30�� �μ��� ���ϴ� ��� �� �޿�(sal)�� 1500�� �Ѵ�
����鸸 ��ȸ�ϰ� �̸����� �������� ���ĵǵ��� ������ �ۼ��Ͻÿ�
*/
SELECT *
FROM emp
WHERE deptno IN (10, 30)
AND sal > 1500
ORDER BY ename DESC;

DESC emp;
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 2; 

/*
emp ���̺��� ���(empno), �̸�(ename)�� �޿� �������� �������� �����ϰ� 
���ĵ� ��������� ROWNUM
*/
SELECT ROWNUM, empno, ename, sal
FROM emp
ORDER BY sal;

SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a;

/*
row_1
emp ���̺��� ROWNUM ���� 1~10�� ���� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
(���ľ��� �����Ͻÿ�.)
*/
SELECT ROWNUM, a.*
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal) a
WHERE ROWNUM <= 10;
-- => WHERE ROWNUM  BETWEEN1 AND 10;

/*
row_2
ROWNUM ���� 11~20�� ���� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
*/
SELECT *
FROM
    (SELECT ROWNUM rn, b.* 
    FROM
        (SELECT empno, ename, sal
        FROM emp 
        ORDER BY sal) b )
    WHERE RN BETWEEN 11 AND 14;
    
    /*
    - FUNCTION
    - DUAL ���̺� ��ȸ
    */
    SELECT 'HELLO WORLD' AS msg
    FROM DUAL;
    
    SELECT 'HELLO WORLD'
    FROM emp;
    
    /*
    - ���ڿ� ��ҹ��� ���� �Լ�
    - LOWER, UPPER, INITCAP
    */
    SELECT LOWER('Hello World'), UPPER('Hello World')
        , INITCAP('Hello World')
    FROM dual;
    
     SELECT LOWER('Hello World'), UPPER('Hello World')
        , INITCAP('Hello World')
    FROM emp
    WHERE JOB = 'SALESMAN';
    
--FUNCTION�� WHERE�������� ��� ����
SELECT *
FROM emp
WHERE LOWER(ename) = ('smith');



/*
������ SQL ĥ������
1. �º��� �������� ���ƶ�
   �º�(TABLE�� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
   Function based Index -> FBI
   
 - CONCAT : ���ڿ� ���� - �ΰ��� ���ڿ��� �����ϴ� �Լ� 
 - SUBSTR : ���ڿ��� �κ� ���ڿ� (java : String.substring)
*/
   
    SELECT CONCAT('HELLO', 'WORLD'),
--    SELECT CONCAT (CONCAT('HELLO', '. '), 'WORLD'),
    SUBSTR('HELLO, WORLD', 0, 5) substr,
    SUBSTR ('HELLO, WORLD', 1, 5) substr1,
    LENGTH ('HELLO WORLD') length,
    INSTR ('HELLO WORLD', 'O') instr,
--  INSTR (���ڿ�, ã�� ���ڿ�, ���ڿ��� Ư�� ��ġ ���� ǥ��)
    INSTR ('HELLO WORLD', 'O', 6) instr1,
    --LPAD(���ڿ�, ��ü���ڿ�����, ���ڿ��� ��ü���ڿ����̿� ��ġ�� ���Ұ�� �߰��� ����);
    LPAD ('HELLO, WORLD', 15, '*') lpad,
    LPAD ('HELLO, WORLD', 15) lapad,
    LPAD ('HELLO, WORLD', 15, '') lapad,
    LPAD ('HELLO, WORLD', 15, '*') lapad
    
FROM dual;


    
    
    
    
 










