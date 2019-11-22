--실습 h_2 정보시스템부 하위의 조직 계층구조 조회(dept0_02)
SELECT level lv, deptcd, 
           LPAD(' ', 4*(level-1), ' ') || deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

--상향식 계층쿼리(실습 h_3)
--특정 노드로부터 자신의 부모노드를 탐색(트리 전체 탐색이 아니다)
--디자인팀을 시작으로 상위 부서를 조회
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;
------------------------------------------------------------------------
--실습 h_4
SELECT LPAD(' ', 4*(level-1), ' ') || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;
---------------------------------------------------------------------------
--실습 h_5
SELECT LPAD(' ', 4*(level-1), ' ') || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

select* from no_emp;
--------------------------------------------------------------

--PRUNING BRANCH(가지치기)
--계층쿼리에서 [WHERE]절은 START WITH, CONNECT BY 절이 전부 적용된 이후에 실행된다.

--dept_h테이블을 최상위 노드부터 하향식으로 조회
SELECT deptcd, deptnm, level
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--계층쿼리 이후 where절이 적용된다.
SELECT deptcd, LPAD(' ', 4*(level-1), ' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, LPAD(' ', 4*(level-1), ' ') || deptnm deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd
            AND deptnm != '정보기획부';
------------------------------------------------------------

--CONNECT_BY_ROOT
SELECT LPAD(' ', 4*(level-1), ' ') || org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        SYS_CONNECT_BY_PATH(org_cd, '-')path_org_cd
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;



SELECT LPAD(' ', 4*(level-1), ' ') || org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-')  path_org_cd
FROM   no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

--CONNECT_BY_ROOT(col): col의 최상의 노드 컬럼 값
--SYS_CONNECT_BY_PATH(col, 구분자): col의 계층구조 순서를 구분자로 이은 경로
--      LTRIM을 통해 최상위 노드 왼쪽의 구분자를 없애주는 형태가 일반적
--CONNECT_BY_ISLEAF: 해당 row가 leaf node인지 판별(맞으면(O)=1, 틀리면(X)=0)
SELECT  LPAD(' ', 4*(level-1), ' ') || org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd, '-'), '-')  path_org_cd,
        CONNECT_BY_ISLEAF isleaf
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;
SELECT * FROM no_emp;
--------------------------------------------------------------------------
--실습 h6
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title 
FROM BOARD_TEST
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;
---------------------------------------------------------

--실습 h7 최신글이 위로 올라오도록
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title 
FROM BOARD_TEST
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq desc;
----------------------------------------------------------
--실습 h8 
SELECT level, seq, LPAD(' ', 4*(level-1), ' ') || title title 
FROM BOARD_TEST
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq desc; -- siblings => 최상위 묶음단위로 정렬
--------------------------------------------------------------
--실습 h9
/*일반적인 게시판을 보면 최상위글은 최신글이 먼저 오고, 답글의 경우 작성한 순서대로
  정렬이 된다. 어덯게 하면 최상위글은 최신글 순(desc)으로 정렬하고, 답글은 순차(asc)
   적으로 정렬할 수 있을까? */
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
--글 그룹번호 컬럼 추가
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

