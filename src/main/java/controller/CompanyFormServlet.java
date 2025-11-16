package controller;

import dao.CompanyDAO;
import model.Admin;
import model.Company;
import util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import jakarta.servlet.http.Part;
import util.FileUploadUtil;

@WebServlet({"/admin/company/add", "/admin/company/edit"})
@jakarta.servlet.annotation.MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class CompanyFormServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null || !"MASTER".equals(admin.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return;
        }
        
        String id = request.getParameter("id");
        
        if (id != null) {
            // 수정 모드
            try (Connection conn = DBConnection.getConnection()) {
                CompanyDAO dao = new CompanyDAO(conn);
                Company company = dao.getById(id);
                
                if (company == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "업체를 찾을 수 없습니다.");
                    return;
                }
                
                request.setAttribute("company", company);
                request.setAttribute("mode", "edit");
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터 조회 중 오류가 발생했습니다.");
                return;
            }
        } else {
            // 추가 모드
            request.setAttribute("mode", "add");
        }
        
        request.getRequestDispatcher("/company-form.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null || !"MASTER".equals(admin.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다.");
            return;
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            CompanyDAO dao = new CompanyDAO(conn);
            
            // 파일 업로드 처리
            String uploadPath = getServletContext().getRealPath("");
            Part logoPart = request.getPart("logo_file");
            Part faviconPart = request.getPart("favicon_file");
            
            String logoUrl = request.getParameter("logo_url");
            String faviconUrl = request.getParameter("favicon_url");
            
            String mode = request.getParameter("mode");
            
            // 수정 모드일 때 기존 파일 정보 가져오기
            if ("edit".equals(mode)) {
                String companyId = request.getParameter("id");
                Company existingCompany = dao.getById(companyId);
                
                // 새 로고 파일이 업로드되면 기존 파일 삭제 후 저장
                if (logoPart != null && logoPart.getSize() > 0) {
                    if (existingCompany != null && existingCompany.getLogoUrl() != null) {
                        FileUploadUtil.deleteFile(existingCompany.getLogoUrl(), uploadPath);
                    }
                    logoUrl = FileUploadUtil.saveFile(logoPart, uploadPath);
                }
                
                // 새 파비콘 파일이 업로드되면 기존 파일 삭제 후 저장
                if (faviconPart != null && faviconPart.getSize() > 0) {
                    if (existingCompany != null && existingCompany.getFaviconUrl() != null) {
                        FileUploadUtil.deleteFile(existingCompany.getFaviconUrl(), uploadPath);
                    }
                    faviconUrl = FileUploadUtil.saveFile(faviconPart, uploadPath);
                }
            } else {
                // 추가 모드일 때는 그냥 저장
                if (logoPart != null && logoPart.getSize() > 0) {
                    logoUrl = FileUploadUtil.saveFile(logoPart, uploadPath);
                }
                if (faviconPart != null && faviconPart.getSize() > 0) {
                    faviconUrl = FileUploadUtil.saveFile(faviconPart, uploadPath);
                }
            }
            
            Company company = new Company();
            company.setId(request.getParameter("id"));
            company.setName(request.getParameter("name"));
            company.setDescription(request.getParameter("description"));
            company.setIsActive(request.getParameter("is_active"));
            company.setCompanyName(request.getParameter("company_name"));
            company.setRepresentative(request.getParameter("representative"));
            company.setBusinessNumber(request.getParameter("business_number"));
            company.setPhone(request.getParameter("phone"));
            company.setFax(request.getParameter("fax"));
            company.setAddress(request.getParameter("address"));
            company.setPostalCode(request.getParameter("postal_code"));
            company.setEmail(request.getParameter("email"));
            company.setWeekdayStart(request.getParameter("weekday_start"));
            company.setWeekdayEnd(request.getParameter("weekday_end"));
            company.setWeekendStart(request.getParameter("weekend_start"));
            company.setWeekendEnd(request.getParameter("weekend_end"));
            company.setSiteTitle(request.getParameter("site_title"));
            company.setSiteSubtitle(request.getParameter("site_subtitle"));
            company.setSiteDescription(request.getParameter("site_description"));
            company.setSiteKeywords(request.getParameter("site_keywords"));
            company.setLogoUrl(logoUrl);
            company.setFaviconUrl(faviconUrl);
            company.setScheduleJson(request.getParameter("schedule_json"));
            
            if ("add".equals(mode)) {
                dao.insert(company);
                response.sendRedirect(request.getContextPath() + "/admin/company/list?success=1");
            } else {
                dao.update(company);
                response.sendRedirect(request.getContextPath() + "/admin/company/edit?id=" + company.getId() + "&success=1");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            String mode = request.getParameter("mode");
            if ("add".equals(mode)) {
                response.sendRedirect(request.getContextPath() + "/admin/company/add?error=1");
            } else {
                String id = request.getParameter("id");
                response.sendRedirect(request.getContextPath() + "/admin/company/edit?id=" + id + "&error=1");
            }
        }
    }
}
