--pro_4
--요일 -1 일요일부터
--해당월의 일자 구하기
SELECT TO_CHAR(TO_DATE('201911','YYYYMM')+ (LEVEL-1),'YYYYMMDD') dt ,
        TO_CHAR(TO_DATE('201911','YYYYMM')+ (LEVEL-1),'D') d 
FROM dual 
CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911','YYYYMM')), 'DD'));
--레코드타입, 테이블타입, 행타입이 필요함


CREATE OR REPLACE PROCEDURE create_daily_sales(p_yyyymm VARCHAR2)
IS
    --달력의 행정보를 저장할 RECORD TYPE
    TYPE cal_row IS RECORD(
        dt VARCHAR2(8),
        d VARCHAR2(1));
    
    --달력정보를 저장할 table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
    
    --애음주기 cursor
    CURSOR cycle_cursor IS
        SELECT *
        FROM cycle;
        
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm,'YYYYMM')+ (LEVEL-1),'YYYYMMDD') dt ,
        TO_CHAR(TO_DATE(p_yyyymm,'YYYYMM')+ (LEVEL-1),'D') d 
        BULK COLLECT INTO cal
    FROM dual 
    CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm,'YYYYMM')), 'DD'));
    
    --생성하려고 하는 년월의 실적 데이터를 삭제한다.
    DELETE daily
    WHERE dt LIKE p_yyyymm || '%';
    
    --애음주기 loop
    FOR rec IN cycle_cursor LOOP
        dbms_output.put_line(rec.day); --애음주기 테이블 건수만큼 나와야함
         FOR i IN 1..cal.count LOOP
         --애음주기의 요일이랑 일자의 요일이랑 같은지 비교
            IF rec.day = cal(i).d THEN
                INSERT INTO daily VALUES(rec.cid, rec.pid,cal(i).dt,rec.cnt);
            END IF;
        END LOOP;
    END LOOP;
    
   COMMIT;
END;
/
exec CREATE_DAILY_SALES('201911');

select * from daily;


