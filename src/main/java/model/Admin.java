package model;

import java.sql.Timestamp;

public class Admin {
    private int id;
    private String email;
    private String password;
    private String name;
    private String role;
    private String isActive;
    private String companyId;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp lastLogin;
    
    public Admin() {}
    
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getIsActive() { return isActive; }
    public void setIsActive(String isActive) { this.isActive = isActive; }
    
    public String getCompanyId() { return companyId; }
    public void setCompanyId(String companyId) { this.companyId = companyId; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(Timestamp lastLogin) { this.lastLogin = lastLogin; }
    
    public boolean isSuperAdmin() {
        return "0000".equals(companyId);
    }
}
