--���� where11
--job�� SALESMAN �̰ų� �Ի����ڰ� 1981��6��1�� ������ �������� ��ȸ
-- �̰ų� --> OR
-- 1981�� 6�� 1�� ���� --> 1981��6��1�� �����ؼ�
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--ROWNUM
SELECT ROENUM, e.*
FROM emp e;

/*
- ROWNUM�� ���� ����
- ORDER BY���� SELECT �� ���Ŀ� ����
- ROWNUM �����÷��� ����ǰ� ���� ���ĵǱ� ������ �츮�� ���ϴ´�� ù��° �����ͺ��� 
�������� ��ȣ �ο��� ���� �ʴ´�.
*/
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

--ORDER BY ���� ������ �ζ��� �並 ����
SELSECT e.*
FROM emp e
ORDER BY ename;

--ORDER BY ���� ������ �ζ��� �並 ����
SELECT ROWNUM, *
FROM
    (SELECT e.*
    FROM Eempe
    ORDER BY ename) a;
    
/*
- ROWNUM : 1������ �о�� �Ѵ�.
- WHERE���� ROWNUM���� �߰��� �д°� �Ұ���
- �Ұ����� ���̽�
- WHERE RUWNUM = 2
- WHERE ROWNUM >= 2

- ������ ���̽�
- WHERE ROWNUM = 1
- WHERE ROWNUM <= 10
*/

(SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a)
WHERE rn BETTWEEN 10 AND 14;

/*
������ SQL ĥ������
1. �º��� �������� ���ƶ�
   �º�(TABLE�� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
   Function based Index -> FBI
   
 - CONCAT : ���ڿ� ���� - �ΰ��� ���ڿ��� �����ϴ� �Լ� 
 - SUBSTR : ���ڿ��� �κ� ���ڿ� (java : String.substring)
*/
   
SELECT CONCAT('HELLO', 'WORLD') CONCAT,
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
    LPAD ('HELLO, WORLD', 15, '*') lapad,
    --REPLACE(�������ڿ�,���� ���ڿ����� �����ϰ��� �ϴ� ��� ���ڿ�, ���湮�ڿ�)
    REPLACE(REPLACE('HELLO, WORLD', 'HELLO', 'hello'), 'WORLD', 'WORLD')replace,
    TRIM(' HELLO,WORLD ') trim,
    TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;


--ROUND(������, �ݿø� ��� �ڸ���)
SELECT ROUND(105.54, 1) r1, --�Ҽ��� ��° �ڸ����� �ݿø�
       ROUND(105.55, 1) r2, --�Ҽ��� ��° �ڸ����� �ݿø� 
       ROUND(105.55, 0) r3, -- �Ҽ��� ù° �ڸ����� �ݿø�
        ROUND(105.55, -1) r4 -- ���� ù° �ڸ����� �ݿø�
FROM dual; 

desc emp;
SELECT empno, ename, sal, sal/1000, 
         /*ROUND(sal/1000, 0) qutient,*/ MOD(sal,1000) reminder
FROM emp;

SELECT ROUND(105.54, 1) T1, --�Ҽ��� ��° �ڸ����� ����
TRUNC(105.55, 1) T2, --�Ҽ��� ��° �ڸ����� ���� 
TRUNC(105.55, 0) T3, --�Ҽ��� ù° �ڸ����� ����
TRUNC(105.55, -1) T4 -- ���� ù° �ڸ����� ����
FROM dual;


--SYSDATE : ����Ŭ�� ��ġ�� ���� ��¥ + �ð������� ����
-- ������ ���ڰ� ���� �Լ�

--TO_CHAR : DATE Ÿ���� ���ڿ��� ��ȯ
--��¥�� ���ڿ��� ��ȯ�ÿ� ������ ����
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS'),
       TO_CHAR(SYSDATE +(1/24/60)*30, 'YYYY/MM/DD HH24:MI:SS')

FROM dual;

--�ǽ� fn1
--2019�� 12�� 31���� date������ ǥ��
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') as lastday,
       TO_DATE('2019/12/31')-5 lastday_before5, --2019�� 12�� 31�� date������ ǥ���ϰ� 5�� ���� ��¥
       TO_CHAR(SYSDATE, 'YYYY/MM/DD') AS now, -- ���糯¥
       SYSDATE-3 now_before3
FROM dual;


--�ٸ����
SELECT LASTDAY, LASTDAY-5 LASTDAY_BEFORE5, NOW, NOW-3 NOT_BEFORE3
FROM
    (SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') LASTDAY, SYSDATE NOW
    FROM DUAL);
    
--date formet
--�⵵ : YYYY, YY, RR : 2���� ���� 4���� ���� �ٸ�
--RR : 50���� Ŭ ��� ���ڸ��� 19, 50���� ���� ��� ���ڸ��� 20
-- YYYY,RRRR�� ����
--YYYY, RRRR �������̸� ��������� ǥ��
--D : ������ ���ڷ� ǥ��(�Ͽ���-1, ������-2, ȭ����-3, ..., �����-7)
SELECT TO_CHAR(TO_DATE('35/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r1,
       TO_CHAR(TO_DATE('55/03/01', 'RR/MM/DD'), 'YYYY/MM/DD') r2,
        TO_CHAR(TO_DATE('35/03/01', 'YY/MM/DD'), 'YYYY/MM/DD') y1,
        TO_CHAR(SYSDATE, 'D') d, --������ ������-2,
        TO_CHAR(SYSDATE, 'IW') iw, --���� ǥ��
        TO_CHAR(TO_DATE('20191231', 'YYYY/MM/DD'), 'IW')this_year
FROM dual;

/*
�ǽ� fn2
���� ��¥�� ������ ���� �������� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
1.��-��-��
2.��-��-�� �ð�(24)-��-��
3.��-��-��
*/
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') AS DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
        TO_CHAR(SYSDATE, 'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;


--��¥�� �ݿø�(ROUND), ����(TRUNC)
--ROUND(DATE, '����') YYYY, MM, DD
desc emp;
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD HH24:MI:SS') as hiredate,
        TO_CHAR(TRUNC(hiredate, 'YYYY'), 'YYYY/MM/DD HH24:MI:SS')AS trunc_yyyy,
        TO_CHAR(TRUNC(hiredate, 'MM'), 'YYYY/MM/DD HH24:MI:SS') AS trunc_MM,
        TO_CHAR(TRUNC(hiredate, 'DD'), 'YYYY/MM/DD HH24:MI:SS') AS trunc_DD,
        TO_CHAR(TRUNC(hiredate-1, 'MM'), 'YYYY/MM/DD HH24:MI:SS') AS trunc_MM,
        TO_CHAR(TRUNC(hiredate-2, 'MM'), 'YYYY/MM/DD HH24:MI:SS') AS trunc_MM
FROM emp
WHERE ename = 'SMITH';

SELECT SYSDATE + 30 --28, 29, 31
FROM DUAL;

/*
��¥ ���� �Լ�
- MINTHS_BETWEEN(DATE, DATE) : �� ��¥ ������ ���� ��
- 19801217 ~ 20191104 => 20191117
*/
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
        MONTHS_BETWEEN(SYSDATE, hiredate) months_between,
        MONTHS_BETWEEN(TO_DATE('20191117', 'YYYYMMDD'), hiredate) months_between
FROM emp
WHERE ename ='SMITH';

--ADD_MONTHS(DATE, ������): DATE�� �������� ���� ��¥
--�������� ����� ��� �̷�, ������ ��� ����
SELECT ename, TO_CHAR(hiredate, 'YYYY-MM-DD HH24:MI:SS') hiredate,
        ADD_MONTHS(hiredate, 467) add_months,
        ADD_MONTHS(hiredate, -467) add_months
FROM emp
WHERE ename ='SMITH';

--NEXR_DAY(DATE, ����) : DATE ���� ù��° ������ ��¥
SELECT SYSDATE, NEXT_DAY(SYSDATE, 7) first_sat, -- ���ó�¥ ���� ù ����� ����
                NEXT_DAY(SYSDATE, '�����') first_sat -- ���ó�¥ ���� ù ����� ����
FROM dual;

--LAST_DAY(DATE) �ش� ��¥�� ���� ���� ������ ����
SELECT SYSDATE, LAST_DAY(SYSDATE) LAST_DAY,
                LAST_DAY(ADD_MONTHS(SYSDATE, 1)) LAST_DAY12
FROM DUAL;

--DATE + ���� = DATE (DATE���� ������ŭ ������ DATE)
--D1 + ���� = D2
--�纯���� D2 ����
--D1 + ���� -D2 = D2-D2
-- P1 + ���� -D1 = D2 - D1
���� = D2 - D1
--��¥���� ��¥�� ���� ���ڰ� ���´�

SELECT 
    TO_DATE('20191104','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') subtraction,
    TO_DATE('20191201','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') subtraction,
    --201908 : 2019��� 8���� �ϼ� : 31���� ���
    TO_DATE('201908','YYYYMM'),
    ADD_MONTHS(TO_DATE('201908','YYYYMM'), 1) - TO_DATE('201908','YYYYMM'),
    ADD_MONTHS(TO_DATE('201602','YYYYMM'), 1) - TO_DATE('201602','YYYYMM') --����
FROM dual;
       





