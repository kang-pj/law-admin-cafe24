package model;

import java.sql.Timestamp;

public class Company {
    private String id;
    private String name;
    private String description;
    private String isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // 추가 필드
    private String companyName;
    private String representative;
    private String businessNumber;
    private String phone;
    private String fax;
    private String address;
    private String postalCode;
    private String email;
    private String weekdayStart;
    private String weekdayEnd;
    private String weekendStart;
    private String weekendEnd;
    private String siteTitle;
    private String siteSubtitle;
    private String siteDescription;
    private String siteKeywords;
    private String logoUrl;
    private String faviconUrl;
    private String scheduleJson;
    
    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getIsActive() { return isActive; }
    public void setIsActive(String isActive) { this.isActive = isActive; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }
    
    public String getRepresentative() { return representative; }
    public void setRepresentative(String representative) { this.representative = representative; }
    
    public String getBusinessNumber() { return businessNumber; }
    public void setBusinessNumber(String businessNumber) { this.businessNumber = businessNumber; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getFax() { return fax; }
    public void setFax(String fax) { this.fax = fax; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getWeekdayStart() { return weekdayStart; }
    public void setWeekdayStart(String weekdayStart) { this.weekdayStart = weekdayStart; }
    
    public String getWeekdayEnd() { return weekdayEnd; }
    public void setWeekdayEnd(String weekdayEnd) { this.weekdayEnd = weekdayEnd; }
    
    public String getWeekendStart() { return weekendStart; }
    public void setWeekendStart(String weekendStart) { this.weekendStart = weekendStart; }
    
    public String getWeekendEnd() { return weekendEnd; }
    public void setWeekendEnd(String weekendEnd) { this.weekendEnd = weekendEnd; }
    
    public String getSiteTitle() { return siteTitle; }
    public void setSiteTitle(String siteTitle) { this.siteTitle = siteTitle; }
    
    public String getSiteSubtitle() { return siteSubtitle; }
    public void setSiteSubtitle(String siteSubtitle) { this.siteSubtitle = siteSubtitle; }
    
    public String getSiteDescription() { return siteDescription; }
    public void setSiteDescription(String siteDescription) { this.siteDescription = siteDescription; }
    
    public String getSiteKeywords() { return siteKeywords; }
    public void setSiteKeywords(String siteKeywords) { this.siteKeywords = siteKeywords; }
    
    public String getLogoUrl() { return logoUrl; }
    public void setLogoUrl(String logoUrl) { this.logoUrl = logoUrl; }
    
    public String getFaviconUrl() { return faviconUrl; }
    public void setFaviconUrl(String faviconUrl) { this.faviconUrl = faviconUrl; }
    
    public String getScheduleJson() { return scheduleJson; }
    public void setScheduleJson(String scheduleJson) { this.scheduleJson = scheduleJson; }
}
