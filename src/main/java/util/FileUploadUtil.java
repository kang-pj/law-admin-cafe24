package util;

import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

public class FileUploadUtil {
    
    private static final String UPLOAD_DIR = "uploads";
    
    public static String saveFile(Part filePart, String uploadPath) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileExtension = "";
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex > 0) {
            fileExtension = fileName.substring(dotIndex);
        }
        
        // 고유한 파일명 생성
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        
        // 업로드 디렉토리 생성
        File uploadDir = new File(uploadPath, UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // 파일 저장
        String filePath = uploadDir.getAbsolutePath() + File.separator + uniqueFileName;
        filePart.write(filePath);
        
        // 웹 경로 반환
        return "/" + UPLOAD_DIR + "/" + uniqueFileName;
    }
    
    /**
     * 기존 파일 삭제
     * @param fileUrl 웹 경로 (예: /uploads/xxx.jpg)
     * @param uploadPath 서버의 실제 경로
     */
    public static void deleteFile(String fileUrl, String uploadPath) {
        if (fileUrl == null || fileUrl.isEmpty()) {
            return;
        }
        
        try {
            // 웹 경로에서 파일명 추출
            String fileName = fileUrl.substring(fileUrl.lastIndexOf('/') + 1);
            File file = new File(uploadPath, UPLOAD_DIR + File.separator + fileName);
            
            if (file.exists()) {
                boolean deleted = file.delete();
                if (deleted) {
                    System.out.println("[FileUploadUtil] Deleted old file: " + fileName);
                } else {
                    System.out.println("[FileUploadUtil] Failed to delete file: " + fileName);
                }
            }
        } catch (Exception e) {
            System.err.println("[FileUploadUtil] Error deleting file: " + e.getMessage());
        }
    }
}
