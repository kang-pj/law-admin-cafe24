package model;

import java.sql.Timestamp;

public class Inquiry {
    private int id;
    private String type; // INQ, SELF, KAKAO, EMAIL, ETC
    private String companyId;
    private String name;
    private String email;
    private String phone;
    private String title;
    private String content;
    private String debtAmount;
    private String monthlyIncome;
    private String status; // pending, processing, completed
    private boolean isRead;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private int memoCount;
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public String getCompanyId() { return companyId; }
    public void setCompanyId(String companyId) { this.companyId = companyId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public String getDebtAmount() { return debtAmount; }
    public void setDebtAmount(String debtAmount) { this.debtAmount = debtAmount; }
    
    public String getMonthlyIncome() { return monthlyIncome; }
    public void setMonthlyIncome(String monthlyIncome) { this.monthlyIncome = monthlyIncome; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public int getMemoCount() { return memoCount; }
    public void setMemoCount(int memoCount) { this.memoCount = memoCount; }
    
    public String getTypeLabel() {
        switch(type) {
            case "INQ": return "문의게시판";
            case "SELF": return "자가진단";
            case "KAKAO": return "카카오";
            case "EMAIL": return "이메일";
            case "ETC": return "기타";
            default: return type;
        }
    }
    
    public String getStatusLabel() {
        switch(status) {
            case "pending": return "대기";
            case "processing": return "처리중";
            case "completed": return "완료";
            default: return status;
        }
    }
}
