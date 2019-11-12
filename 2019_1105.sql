/*
��� �Ķ���Ͱ� �־����� �� �ش����� �ϼ��� ���ϴ� ����
201911 => 30 / 201912 => 31
*/
--�Ѵ� ���� �� �������� ���� = �ϼ�
--��������¥ ���� �� => DD�� ����
SELECT --TO_CHAR(LAST_DAY(TO_DATE('201911', 'YYYYMM')), 'DD') day_cnt
         :YYYYMM AS param,TO_CHAR(LAST_DAY(TO_DATE(:YYYYMMDD, 'YYYYMMDD')), 'DD') day_cnt
FROM DUAL;

explain plan for
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN. DISPLAY);

SELECT empno, ename, sal, TO_CHAR(sal, '999,999.99')sal_fmt
FROM emp;

SELECT empno, ename, sal, TO_CHAR(sal, 'L000999,999.99')sal_fmt
FROM emp;

SELECT empno, ename, sal, TO_CHAR(sal, 'L999,999.99')sal_fmt
FROM emp;

-- function null
-- nvl(coll, coll�� null�ϰ�� ��ü�� ��)
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm,
        sal + comm, 
        sal + nvl(comm, 0),
        nvl(sal + comm, 0)
FROM emp;

/*
NVL2(col1, col1�� null�� �ƴ� ��� ǥ���Ǵ� ��, col1 null�� ��� ǥ���Ǵ� ��)
*/
SELECT empno, ename, sal, comm, NVL2(comm, 0, comm) + sal
FROM emp;

/*
- NULLIF(expr1, expr2)
- expr1 == expr2 ������ null
- else : expr1
*/
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

/*
- COALESCE(expr1, expr2, empr3...)
- �Լ����� �� null�� �ƴ� ù��° ����
*/
SELECT empno, ename, sal, comm, coalesce(sal, comm)
FROM emp;

--fn4
--emp ���̺��� ������ ������ ���� ��ȸ�ǵ��� ������ �ۼ��Ͻÿ�
SELECT empno,ename,mgr, 
        NVL(mgr, 9999) AS mgr_n,
        NVL2(mgr, mgr, 9999) mgr_n,
        coalesce(mgr, 9999) mgr_n
FROM emp;

--fn5
SELECT userid, usernm, reg_dt,
        NVL(reg_dt, SYSDATE) n_reg_dt,
        NVL2(reg_dt, reg_dt, SYSDATE) n_reg_dt,
        COALESCE(reg_dt, SYSDATE) n_reg_dt
FROM users;

--case when
SELECT empno, ename, job, sal,
       case
            when job = 'SALESMAN' then sal*1.05
            when job = 'MANAGER' then sal*1.10
            when job = 'PRESIDENT' then sal*1.20
            else sal * 1
       end case_sal
FROM emp;

--decode(col, search1, retrun1, search2, return2... defult)
SELECT empno, ename, job, sal,
        DECODE(job, 'SALESMAN', sal*1.05, 
                    'MANAGER', sal*1.10, 
                    'PRESIDENT', sal*1.20, sal) decode_sal
FROM emp;

/*
cond1
- emp ���̺��� �̿��Ͽ�  deptno�� ���� �μ������� �����ؼ� ������ ���� ��ȸ�Ǵ�
   ������ �ۼ��Ͻÿ�
   10 => 'ACCOUNTING'
   20 => 'RESEARCH'
   30 => 'SALES'
   40 => 'OPERATIONS'
   ��Ÿ �ٸ��� => 'DDIT'
*/
SELECT  empno, ename,
        case
            when deptno = '10' then 'ACCOUNTING'
            when deptno = '20' then 'RESEARCH'
            when deptno = '30' then 'SALES'
            when deptno = '40' then 'OPERATIONS'
            else 'DDIT'
        end dname
FROM emp;

SELECT empno, ename,
    DECODE(deptno, 10, 'ACCOUNTING',
                   20, 'RESEARCH',
                   30, 'SALES',
                   40, 'OPERATIONS', 'DDIT') dname
FROM emp;

--����cond2
--emp ���̺��� �̿��Ͽ� hiredate�� ���� ���� �ǰ����� ���� ���������
--��ȸ�ϴ� ������ �ۼ��Ͻÿ� (������ �������� �ϳ� ���⼭�� �Ի�⵵�� �������� �Ѵ�.)
SELECT empno, ename, /*hiredate,TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(hiredate, 'YYYY') as a*/
        /*MOD(TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(hiredate, 'YYYY'),2) b*/
    case
        when  MOD(TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(hiredate, 'YYYY'),2) = 0 then '�ǰ����������'
        else '�ǰ����� ������'
    end �ǰ�����
FROM emp;

/*
-�׷��Լ�(AVG,MAX,MIN,SUM,COUNT)
-�׷��Լ��� NULL���� ����󿡼� �����Ѵ�.
-SUM(comm), COUNT(*), COUNT(mgr)
-���� �� ���� ���� �޿��� �޴»��
-���� �� ���� ���� �޿��� �޴»��
-������ �޿� ���(�Ҽ��� ��°�ڸ� ������ ������ => �Ҽ��� 3°�ڸ����� �ݿø�)
*/
SELECT deptno,
       MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(*) emp_cnt,
       COUNT(sal) sal_cnt,
       COUNT(mgr) mgr_cnt,
       SUM(comm) comm_sum
FROM emp
GROUP BY deptno;

--�μ��� ���� ���� �޿��� �޴»���� �޿�
--GROUP BY ���� ������� ���� �÷��� SELECT���� ����� ��� �����߻�
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

SELECT empno, ename, sal
FROM emp
order by sal;

--�μ��� �ִ� �޿�
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) > 3000;

--�ǽ� grp1
/*
emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�
- ������ ���� ���� �޿�
- ������ ���� ���� �޿�
- ������ �޿� ���
- ������ �޿� ��
- ������ �޿��� �ִ� ������ ��(null ����)
- ������ ����ڰ� �ִ� ������ ��(null ����)
- ��ü ������ ��
*/
SELECT      MAX(sal) max_sal,
            MIN(sal) min_sal,
           ROUND(AVG(sal),1) avg_sal,
            SUM(sal) sum_sal,
            COUNT(sal) sal_cnt,
            COUNT(mgr) mgr_cnt,
            COUNT(empno) empno_cnt
FROM emp;

--grp2
/*
emp ���̺��� �̿��Ͽ� ������ ���Ͻÿ�
- �μ� ���� ������ ���� ���� �޿�
- �μ� ���� ������ ���� ���� �޿�
- �μ� ���� ������ �޿� ���(�Ҽ��� 2�ڸ�����)
- �μ� ���������� �޿� ��
- �μ� ���� ������ �޿��� �ִ� ������ ��(null ����)
- �μ� ���� ������ ����ڰ� �ִ� ������ ��(null ����)
- �μ� ���� ��ü ������ ��
*/
SELECT  deptno,
            MAX(sal) max_sal,
            MIN(sal) min_sal,
           ROUND(AVG(sal),1) avg_sal,
            SUM(sal) sum_sal,
            COUNT(sal) sal_cnt,
            COUNT(mgr) mgr_cnt,
            COUNT(deptno) empno_cnt
            
FROM emp
GROUP BY deptno;

 
SELECT *
FROM emp;
