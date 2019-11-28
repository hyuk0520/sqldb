--실습PRO_3 p.18
CREATE OR REPLACE PROCEDURE UPDATEdept_test
(p_deptno IN dept_test.deptno%TYPE,
 p_dname IN dept_test.dname%TYPE,
 p_loc IN dept_test.loc%TYPE
 )
 IS
 
 BEGIN
    UPDATE dept_test SET dname = p_dname, deptno = p_deptno,  loc = p_loc
    WHERE deptno = 99;
    
    COMMIT;  
 END;
 /
 exec updatedept_test(99, 'ddit_m', 'daejeon');
 
 select * from dept_test;
 commit;
 
 CREATE TABLE dept_test AS
 select *
 from dept;
 -----
 --ROWTYPE : 테이블의 한 행의 데이터를 담을 수 있는 참조타입
set serveroutput on;
 DECLARE
    dept_row dept%ROWTYPE;
 BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(dept_row.deptno || ',' || 
                          dept_row.dname || ',' || 
                           dept_row.loc);
 END;
 /
 
 --복합변수 : record (개발자가 직접 만들 수 있음)
 --다른 테이블의 컬럼들을 내가 만든 컬럼에 담을 수 있다.!
 DECLARE
    --UserVO userVo; 
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname dept.dname%TYPE
    ); --한행의 두개의 컬럼
    v_dname dept.dname%TYPE;
    v_row dept_row;
    
 BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line(v_row.deptno || ',' || v_row.dname);
 END;
 /
 
--tabletype 여러개의 행을 저장할 수 있음
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER; --인덱스의 타입을 선언
    
    --java : 타입 변수명;
    --pl/sql : 변수명 타입;
    v_dept dept_tab;
    
BEGIN
    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    FOR i IN 1..v_dept.count LOOP 
    dbms_output.put_line(v_dept(i).dname);
    END LOOP;
    
END;
/
 
--IF
--ELSE IF --> ELSIF
--END IF;

DECLARE
    ind BINARY_INTEGER;
BEGIN
    ind := 2;
    
    IF ind = 1 THEN
        dbms_output.put_line(ind);
    ELSIF ind = 2 THEN
        dbms_output.put_line('ELSIF ' || ind);
    ELSE
        dbms_output.put_line('ELSE');
    END IF;
END;
/

--FOR LOOP :
--FOR 인덱스 변수 IN 시작값..종료값 LOOP
--END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_line('i : ' || i);
    END LOOP;
END;
/
 
 
--LOOP : 계속 실행 판단 로직을 LOOP 안에서 제어
--java : while(true)
DECLARE
    i NUMBER;
BEGIN
    i := 0;
    
    LOOP
        dbms_output.put_line(i);
        i := i+1;
        --loop 계속 진행여부 판단
        EXIT WHEN i >=5;
   END LOOP;
END;
/

--간격평균 : 5일
DECLARE
    TYPE dt_dt IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER; --인덱스의 타입을 선언
    
    --java : 타입 변수명;
    --pl/sql : 변수명 타입;
    hi dt_dt; 
    hab number := 0;
    
BEGIN
    SELECT *
    BULK COLLECT INTO hi
    FROM dt
    ORDER BY dt desc;
    
    FOR i IN 1..(hi.count)-1 LOOP 
        hab := hab + (hi(i).dt - hi(i+1).dt);
    END LOOP;
    dbms_output.put_line(HAB/7);
END;
/

--lead, lag 현재행의 이전, 이후 데이터를 가져올 수 있다.
SELECT AVG(diff)
FROM
    (SELECT dt - LEAD(dt) OVER (ORDER BY dt DESC) diff
    FROM dt
    ORDER BY dt desc) ;
    
--분석함수를 사용하지 못하는 환경에서
SELECT AVG(a.dt - b.dt)
FROM
    (SELECT ROWNUM rn, dt
    FROM
        (SELECT dt
         FROM dt
         ORDER BY dt DESC)) a,
    
    (SELECT ROWNUM rn, dt
    FROM
        (SELECT dt
         FROM dt
         ORDER BY dt DESC) b     
WHERE a.rn = b.rn(+) - 1;

--동규답
SELECT (MAX(dt) - MIN(dt)) / (COUNT(*)-1)
FROM dt;
/*- 커서란? : 쿼리문에 의해서 반환되는 결과값들을 저장하는 메모리 공간이다.
  - Fetch란 : 커서에서 원하는 결과값을 추출하는 것.
*/

DECLARE
    --커서 선언
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
     
     v_deptno dept.deptno%TYPE;
     v_dname dept.dname%TYPE;
BEGIN
    --커서 열기
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        dbms_output.put_line(v_deptno || ',' || v_dname);
        EXIT WHEN dept_cursor%NOTFOUND; --더이상 읽을 데이터가 없을 때 종료
    END LOOP;
END;
/

--FOR LOOP CURSOR 결합
DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;  
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
        
BEGIN
    FOR rec IN dept_cursor LOOP
        dbms_output.put_line(rec.deptno || ','|| rec.dname);
    END LOOP;
END;
/

--파라미터가 있는 명시적 커서
DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
            SELECT empno, ename, job 
            FROM emp
            WHERE job = p_job;
      
BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP
        dbms_output.put_line(emp.empno || ',' || emp.ename || ',' || emp.job);
    END LOOP;
END;
/