-- companies 테이블에 schedule_json 컬럼 추가
ALTER TABLE companies ADD COLUMN schedule_json TEXT COMMENT '요일별 운영시간 JSON';

-- 기존 데이터 마이그레이션 (선택사항)
-- 기존 weekday/weekend 시간을 JSON으로 변환
UPDATE companies 
SET schedule_json = JSON_OBJECT(
    'mon', JSON_OBJECT('enabled', true, 'start', weekday_start, 'end', weekday_end),
    'tue', JSON_OBJECT('enabled', true, 'start', weekday_start, 'end', weekday_end),
    'wed', JSON_OBJECT('enabled', true, 'start', weekday_start, 'end', weekday_end),
    'thu', JSON_OBJECT('enabled', true, 'start', weekday_start, 'end', weekday_end),
    'fri', JSON_OBJECT('enabled', true, 'start', weekday_start, 'end', weekday_end),
    'sat', JSON_OBJECT('enabled', true, 'start', weekend_start, 'end', weekend_end),
    'sun', JSON_OBJECT('enabled', true, 'start', weekend_start, 'end', weekend_end)
)
WHERE schedule_json IS NULL;

-- 확인
SELECT id, name, schedule_json FROM companies;
