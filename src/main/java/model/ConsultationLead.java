package model;

import java.sql.Timestamp;

public class ConsultationLead {
    private long id;
    private String sessionId;
    private String consultationSource;
    private String name;
    private String phone;
    private String email;
    private String debtAmount;
    private String monthlyIncome;
    private String message;
    private String status;
    private String userAgent;
    private String ipAddress;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Getters and Setters
    public long getId() {
        return id;
    }
    
    public void setId(long id) {
        this.id = id;
    }
    
    public String getSessionId() {
        return sessionId;
    }
    
    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }
    
    public String getConsultationSource() {
        return consultationSource;
    }
    
    public void setConsultationSource(String consultationSource) {
        this.consultationSource = consultationSource;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getDebtAmount() {
        return debtAmount;
    }
    
    public void setDebtAmount(String debtAmount) {
        this.debtAmount = debtAmount;
    }
    
    public String getMonthlyIncome() {
        return monthlyIncome;
    }
    
    public void setMonthlyIncome(String monthlyIncome) {
        this.monthlyIncome = monthlyIncome;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getUserAgent() {
        return userAgent;
    }
    
    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
    
    public String getIpAddress() {
        return ipAddress;
    }
    
    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
