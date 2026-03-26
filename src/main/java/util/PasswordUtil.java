package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {
    
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * 비밀번호를 해시화합니다.
     * @param password 원본 비밀번호
     * @return 해시화된 비밀번호 (salt + hash)
     */
    public static String hashPassword(String password) {
        try {
            // Salt 생성
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            // 비밀번호 + Salt 해시화
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes("UTF-8"));
            
            // Salt + Hash를 Base64로 인코딩
            byte[] saltAndHash = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, saltAndHash, 0, salt.length);
            System.arraycopy(hashedPassword, 0, saltAndHash, salt.length, hashedPassword.length);
            
            return Base64.getEncoder().encodeToString(saltAndHash);
            
        } catch (Exception e) {
            throw new RuntimeException("비밀번호 해시화 중 오류가 발생했습니다.", e);
        }
    }
    
    /**
     * 비밀번호를 검증합니다.
     * @param password 입력된 비밀번호
     * @param hashedPassword 저장된 해시화된 비밀번호
     * @return 일치 여부
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        try {
            // Base64 디코딩
            byte[] saltAndHash = Base64.getDecoder().decode(hashedPassword);
            
            // Salt 추출
            byte[] salt = new byte[SALT_LENGTH];
            System.arraycopy(saltAndHash, 0, salt, 0, SALT_LENGTH);
            
            // 저장된 Hash 추출
            byte[] storedHash = new byte[saltAndHash.length - SALT_LENGTH];
            System.arraycopy(saltAndHash, SALT_LENGTH, storedHash, 0, storedHash.length);
            
            // 입력된 비밀번호를 같은 Salt로 해시화
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] inputHash = md.digest(password.getBytes("UTF-8"));
            
            // 해시 비교
            return MessageDigest.isEqual(storedHash, inputHash);
            
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 간단한 MD5 해시 (기존 시스템 호환용)
     * @param password 비밀번호
     * @return MD5 해시
     */
    public static String md5Hash(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hash = md.digest(password.getBytes("UTF-8"));
            
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
            
        } catch (Exception e) {
            throw new RuntimeException("MD5 해시화 중 오류가 발생했습니다.", e);
        }
    }
}