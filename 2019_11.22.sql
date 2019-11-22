--�ǽ� h_2 �����ý��ۺ� ������ ���� �������� ��ȸ(dept0_02)
SELECT level lv, deptcd, 
           LPAD(' ', 4*(level-1), ' ') || deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

--����� ��������(�ǽ� h_3)
--Ư�� ���κ��� �ڽ��� �θ��带 Ž��(Ʈ�� ��ü Ž���� �ƴϴ�)
--���������� �������� ���� �μ��� ��ȸ
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;
------------------------------------------------------------------------
--�ǽ� h_4
SELECT LPAD(' ', 4*(level-1), ' ') || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;
---------------------------------------------------------------------------
--�ǽ� h_5
SELECT LPAD(' ', 4*(level-1), ' ') || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

select* from no_emp;
--------------------------------------------------------------

--PRUNING BRANCH(����ġ��)
--������������ [WHERE]���� START WITH, CONNECT BY ���� ���� ����� ���Ŀ� ����ȴ�.

--dept_h���̺��� �ֻ��� ������ ��������� ��ȸ
SELECT deptcd, deptnm, level
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--�������� ���� where���� ����ȴ�.
SELECT deptcd, LPAD(' ', 4*(level-1), ' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, LPAD(' ', 4*(level-1), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
            AND deptnm != '������ȹ��';
------------------------------------------------------------

--CONNECT_BY_ROOT
SELECT LPAD(' ', 4*(level-1), ' ') || org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        SYS_CONNECT_BY_PATH(org_cd, '-')path_org_cd
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;



SELECT LPAD(' ', 4*(level-1), ' ') || org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-')  path_org_cd
FROM   no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

--CONNECT_BY_ROOT(col): col�� �ֻ��� ��� �÷� ��
--SYS_CONNECT_BY_PATH(col, ������): col�� �������� ������ �����ڷ� ���� ���
--      LTRIM�� ���� �ֻ��� ��� ������ �����ڸ� �����ִ� ���°� �Ϲ���
--CONNECT_BY_ISLEAF: �ش� row�� leaf node���� �Ǻ�(������(O)=1, Ʋ����(X)=0)
SELECT  LPAD(' ', 4*(level-1), ' ') || org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-')  path_org_cd,
        CONNECT_BY_ISLEAF isleaf
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;
SELECT * FROM no_emp;
--------------------------------------------------------------------------
--�ǽ� h6
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title 
FROM BOARD_TEST
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;
---------------------------------------------------------

--�ǽ� h7 �ֽű��� ���� �ö������
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title 
FROM BOARD_TEST
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq desc;
----------------------------------------------------------
--�ǽ� h8 
SELECT level, seq, LPAD(' ', 4*(level-1), ' ') || title title 
FROM BOARD_TEST
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq desc; -- siblings => �ֻ��� ���������� ����
--------------------------------------------------------------
--�ǽ� h9
/*�Ϲ����� �Խ����� ���� �ֻ������� �ֽű��� ���� ����, ����� ��� �ۼ��� �������
  ������ �ȴ�. ��F�� �ϸ� �ֻ������� �ֽű� ��(desc)���� �����ϰ�, ����� ����(asc)
   ������ ������ �� ������? */
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title,
        CASE 
            WHEN parent_seq IS NULL THEN seq 
            ELSE 0
        END O1
FROM BOARD_TEST
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY CASE 
                    WHEN parent_seq IS NULL THEN seq 
                    ELSE 0 
                END DESC;
                
SELECT *
FROM board_test;
--�� �׷��ȣ �÷� �߰�
ALTER TABLE board_test ADD (gn NUMBER);
SELECT * FROM BOARD_TEST;

SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;
-----------------------------------------------------------------

SELECT ename, sal, ROWNUM l_sal
FROM 
    (SELECT ename, sal
    FROM emp
    ORDER BY sal DESC)
WHERE ROWNUM BETWEEN 2 AND 14;
AND ;

