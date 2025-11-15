-- 샘플 문의 데이터 INSERT

-- 문의게시판 (INQ) 샘플
INSERT INTO inquiries (type, company_id, name, email, phone, title, content, debt_amount, monthly_income, status, is_read, created_at, updated_at) VALUES
('INQ', 'COMP001', '홍길동', 'hong@example.com', '010-1234-5678', '채무 관련 문의드립니다', '안녕하세요.\n\n현재 채무 문제로 어려움을 겪고 있어 상담을 요청드립니다.\n\n총 채무액은 약 5천만원 정도이며, 월 소득은 300만원 정도입니다.\n개인회생이나 파산 절차에 대해 자세히 알고 싶습니다.\n\n빠른 답변 부탁드립니다.\n감사합니다.', '5,000만원', '300만원', 'pending', false, NOW(), NOW()),

('INQ', 'COMP001', '김철수', 'kim@example.com', '010-2345-6789', '개인회생 절차 문의', '개인회생 절차에 대해 궁금한 점이 있습니다.\n\n현재 신용카드 빚이 3천만원 정도 있고, 대출도 2천만원 있습니다.\n월급은 250만원 정도 받고 있습니다.\n\n개인회생이 가능한지 상담받고 싶습니다.', '5,000만원', '250만원', 'processing', true, DATE_SUB(NOW(), INTERVAL 1 DAY), NOW()),

('INQ', 'COMP002', '이영희', 'lee@example.com', '010-3456-7890', '파산 신청 문의', '파산 신청을 고려하고 있습니다.\n\n현재 채무가 1억원 정도이고, 수입이 거의 없는 상태입니다.\n파산 절차와 필요한 서류에 대해 알고 싶습니다.', '1억원', '0원', 'completed', true, DATE_SUB(NOW(), INTERVAL 2 DAY), NOW()),

('INQ', 'COMP001', '박민수', 'park@example.com', '010-4567-8901', '채무조정 상담 요청', '여러 금융기관에 빚이 있어서 채무조정을 받고 싶습니다.\n\n은행 대출 3천만원, 카드빚 2천만원이 있습니다.\n월 소득은 350만원입니다.', '5,000만원', '350만원', 'pending', false, DATE_SUB(NOW(), INTERVAL 3 DAY), NOW()),

('INQ', 'COMP002', '최지훈', 'choi@example.com', '010-5678-9012', '법률 상담 문의', '채무 관련 법률 상담을 받고 싶습니다.\n\n현재 압류 통지를 받은 상태입니다.\n어떻게 대응해야 할지 조언 부탁드립니다.', '7,000만원', '200만원', 'completed', true, DATE_SUB(NOW(), INTERVAL 4 DAY), NOW());

-- 자가진단 (SELF) 샘플
INSERT INTO inquiries (type, company_id, name, email, phone, title, content, debt_amount, monthly_income, status, is_read, created_at, updated_at) VALUES
('SELF', 'COMP001', '정수진', 'jung@example.com', '010-6789-0123', '자가진단 결과 상담', '자가진단을 해봤는데 개인회생이 가능하다고 나왔습니다.\n\n구체적인 절차와 비용에 대해 상담받고 싶습니다.\n채무액: 4천만원\n월소득: 280만원', '4,000만원', '280만원', 'pending', false, DATE_SUB(NOW(), INTERVAL 1 DAY), NOW()),

('SELF', 'COMP002', '강민호', 'kang@example.com', '010-7890-1234', '자가진단 후 문의', '자가진단 결과 파산이 적합하다고 나왔습니다.\n\n파산 절차에 대해 자세히 알고 싶습니다.', '8,000만원', '150만원', 'processing', true, DATE_SUB(NOW(), INTERVAL 2 DAY), NOW()),

('SELF', 'COMP001', '윤서연', 'yoon@example.com', '010-8901-2345', '자가진단 상담 요청', '자가진단을 해보니 채무조정이 필요하다고 나왔습니다.\n\n어떤 방법이 가장 좋을지 상담받고 싶습니다.', '3,500만원', '320만원', 'completed', true, DATE_SUB(NOW(), INTERVAL 3 DAY), NOW());

-- 카카오 문의 (KAKAO) 샘플
INSERT INTO inquiries (type, company_id, name, email, phone, title, content, debt_amount, monthly_income, status, is_read, created_at, updated_at) VALUES
('KAKAO', 'COMP001', '임재현', 'lim@example.com', '010-9012-3456', '카카오톡 상담 문의', '카카오톡으로 간단히 문의드립니다.\n\n채무 상담 가능한가요?\n채무액: 2천만원\n월소득: 250만원', '2,000만원', '250만원', 'pending', false, DATE_SUB(NOW(), INTERVAL 1 HOUR), NOW()),

('KAKAO', 'COMP002', '송하은', 'song@example.com', '010-0123-4567', '카톡 상담 요청', '카카오톡으로 상담 예약하고 싶습니다.\n\n개인회생 관련해서 문의드리고 싶습니다.', '4,500만원', '300만원', 'processing', true, DATE_SUB(NOW(), INTERVAL 5 HOUR), NOW());

-- 이메일 문의 (EMAIL) 샘플
INSERT INTO inquiries (type, company_id, name, email, phone, title, content, debt_amount, monthly_income, status, is_read, created_at, updated_at) VALUES
('EMAIL', 'COMP001', '한지우', 'han@example.com', '010-1111-2222', '이메일 문의드립니다', '이메일로 문의드립니다.\n\n채무 관련 상담을 받고 싶은데, 방문 상담이 가능한가요?\n\n채무액: 6천만원\n월소득: 400만원', '6,000만원', '400만원', 'completed', true, DATE_SUB(NOW(), INTERVAL 1 DAY), NOW()),

('EMAIL', 'COMP002', '오민지', 'oh@example.com', '010-2222-3333', '상담 예약 문의', '이메일로 상담 예약하고 싶습니다.\n\n평일 오후 시간대에 방문 가능합니다.', '3,000만원', '280만원', 'pending', false, DATE_SUB(NOW(), INTERVAL 2 DAY), NOW());

-- 기타 문의 (ETC) 샘플
INSERT INTO inquiries (type, company_id, name, email, phone, title, content, debt_amount, monthly_income, status, is_read, created_at, updated_at) VALUES
('ETC', 'COMP001', '서준호', 'seo@example.com', '010-3333-4444', '기타 문의사항', '홈페이지를 통해 문의드립니다.\n\n채무 상담 비용은 얼마인가요?\n무료 상담도 가능한가요?', '2,500만원', '200만원', 'pending', false, DATE_SUB(NOW(), INTERVAL 3 HOUR), NOW()),

('ETC', 'COMP002', '장서현', 'jang@example.com', '010-4444-5555', '서비스 문의', '서비스 이용 절차에 대해 문의드립니다.\n\n온라인으로도 상담이 가능한가요?', '4,000만원', '350만원', 'processing', true, DATE_SUB(NOW(), INTERVAL 6 HOUR), NOW()),

('ETC', 'COMP001', '권태양', 'kwon@example.com', '010-5555-6666', '일반 문의', '채무 관련 일반적인 문의사항입니다.\n\n상담 시간은 어떻게 되나요?', '1,500만원', '180만원', 'completed', true, DATE_SUB(NOW(), INTERVAL 1 DAY), NOW());

-- 추가 샘플 데이터 (다양한 상태와 날짜)
INSERT INTO inquiries (type, company_id, name, email, phone, title, content, debt_amount, monthly_income, status, is_read, created_at, updated_at) VALUES
('INQ', 'COMP001', '신동욱', 'shin@example.com', '010-6666-7777', '긴급 상담 요청', '긴급하게 상담이 필요합니다.\n\n압류 예정 통지를 받았습니다.\n빠른 상담 부탁드립니다.', '9,000만원', '250만원', 'pending', false, NOW(), NOW()),

('SELF', 'COMP002', '배수지', 'bae@example.com', '010-7777-8888', '자가진단 후 추가 문의', '자가진단 결과에 대해 추가로 궁금한 점이 있습니다.\n\n전화 상담 가능한가요?', '5,500만원', '300만원', 'processing', true, DATE_SUB(NOW(), INTERVAL 2 HOUR), NOW()),

('KAKAO', 'COMP001', '류현진', 'ryu@example.com', '010-8888-9999', '카톡 빠른 상담', '카카오톡으로 빠른 상담 부탁드립니다.\n\n오늘 중으로 답변 가능한가요?', '3,200만원', '270만원', 'pending', false, DATE_SUB(NOW(), INTERVAL 30 MINUTE), NOW()),

('EMAIL', 'COMP002', '안유진', 'ahn@example.com', '010-9999-0000', '이메일 상담 신청', '이메일로 상세한 상담을 받고 싶습니다.\n\n서류 준비 목록도 보내주시면 감사하겠습니다.', '7,500만원', '380만원', 'completed', true, DATE_SUB(NOW(), INTERVAL 3 DAY), NOW()),

('ETC', 'COMP001', '조세호', 'cho@example.com', '010-0000-1111', '홈페이지 문의', '홈페이지를 통해 문의드립니다.\n\n상담 예약은 어떻게 하나요?', '2,800만원', '220만원', 'pending', false, DATE_SUB(NOW(), INTERVAL 4 HOUR), NOW());

-- 통계를 위한 추가 데이터
INSERT INTO inquiries (type, company_id, name, email, phone, title, content, status, is_read, created_at, updated_at) VALUES
('INQ', 'COMP001', '테스트1', 'test1@example.com', '010-1000-0001', '테스트 문의 1', '테스트 내용입니다.', 'completed', true, DATE_SUB(NOW(), INTERVAL 5 DAY), NOW()),
('INQ', 'COMP001', '테스트2', 'test2@example.com', '010-1000-0002', '테스트 문의 2', '테스트 내용입니다.', 'completed', true, DATE_SUB(NOW(), INTERVAL 6 DAY), NOW()),
('SELF', 'COMP002', '테스트3', 'test3@example.com', '010-1000-0003', '테스트 문의 3', '테스트 내용입니다.', 'completed', true, DATE_SUB(NOW(), INTERVAL 7 DAY), NOW()),
('KAKAO', 'COMP001', '테스트4', 'test4@example.com', '010-1000-0004', '테스트 문의 4', '테스트 내용입니다.', 'processing', true, DATE_SUB(NOW(), INTERVAL 8 DAY), NOW()),
('EMAIL', 'COMP002', '테스트5', 'test5@example.com', '010-1000-0005', '테스트 문의 5', '테스트 내용입니다.', 'pending', false, DATE_SUB(NOW(), INTERVAL 9 DAY), NOW());
