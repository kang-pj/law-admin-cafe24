-- 에이스 컴퍼니 생성
INSERT INTO companies (
    id, 
    name, 
    description, 
    is_active,
    company_name,
    representative,
    business_number,
    phone,
    fax,
    address,
    postal_code,
    email,
    weekday_start,
    weekday_end,
    weekend_start,
    weekend_end,
    site_title,
    site_subtitle,
    site_description,
    site_keywords,
    created_at,
    updated_at
) VALUES (
    'ACE',
    '에이스',
    '에이스 컴퍼니',
    'Y',
    '에이스 컴퍼니',
    '대표자명',
    '000-00-00000',
    '02-0000-0000',
    '02-0000-0001',
    '서울특별시',
    '00000',
    'the_ace98@naver.com',
    '09:00',
    '18:00',
    '10:00',
    '15:00',
    '에이스 컴퍼니',
    '법률 상담 서비스',
    '에이스 컴퍼니 법률 상담',
    '법률상담,변호사,법률자문',
    NOW(),
    NOW()
);

-- 에이스 컴퍼니 관리자 계정 생성 (MASTER 권한)
INSERT INTO admins (
    id,
    password,
    name,
    role,
    company_id,
    is_active,
    created_at,
    updated_at
) VALUES (
    'the_ace98@naver.com',
    'dpdltm0203!!',
    '에이스 관리자',
    'MASTER',
    'ACE',
    'Y',
    NOW(),
    NOW()
);

-- 확인
SELECT * FROM companies WHERE id = 'ACE';
SELECT * FROM admins WHERE id = 'the_ace98@naver.com';
