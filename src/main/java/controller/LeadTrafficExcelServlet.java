package controller;

import dao.LeadWithTrafficDAO;
import model.Admin;
import util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/stats/lead-traffic/excel")
public class LeadTrafficExcelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            admin = new Admin();
            admin.setEmail((String) session.getAttribute("adminId"));
            admin.setRole((String) session.getAttribute("adminRole"));
            admin.setCompanyId((String) session.getAttribute("companyId"));
        }

        // 날짜 파라미터
        String period = request.getParameter("period");
        if (period == null) period = "today";

        LocalDate endDate = LocalDate.now();
        LocalDate startDate;

        if ("custom".equals(period)) {
            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");
            if (startDateParam != null && endDateParam != null) {
                startDate = LocalDate.parse(startDateParam);
                endDate = LocalDate.parse(endDateParam);
            } else {
                startDate = endDate;
            }
        } else {
            switch (period) {
                case "week":
                    startDate = endDate.minusDays(6);
                    break;
                case "month":
                    startDate = endDate.withDayOfMonth(1);
                    break;
                case "30days":
                    startDate = endDate.minusDays(29);
                    break;
                case "today":
                default:
                    startDate = endDate;
                    break;
            }
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String startDateStr = startDate.format(formatter);
        String endDateStr = endDate.format(formatter);

        String companyId = null;
        if (!"MASTER".equals(admin.getRole())) {
            companyId = admin.getCompanyId();
        }

        try (Connection conn = DBConnection.getConnection()) {
            LeadWithTrafficDAO dao = new LeadWithTrafficDAO(conn);
            List<Map<String, Object>> leads = dao.getAllLeadsWithTraffic(companyId, startDateStr, endDateStr);

            // 엑셀 생성
            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("상담 신청 목록");

            // 헤더 스타일
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setBorderBottom(BorderStyle.THIN);

            // 헤더 행
            String[] headers = {"신청일시", "이름", "연락처", "이메일", "상담 경로", "채무액", "월 소득",
                    "메시지", "상태", "UTM Source", "UTM Medium", "UTM Campaign",
                    "유입 경로(Referrer)", "랜딩 페이지", "디바이스", "OS", "브라우저", "IP"};

            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // 데이터 행
            int rowNum = 1;
            for (Map<String, Object> lead : leads) {
                Row row = sheet.createRow(rowNum++);

                row.createCell(0).setCellValue(lead.get("createdAt") != null ? lead.get("createdAt").toString() : "");
                row.createCell(1).setCellValue(safeStr(lead.get("name")));
                row.createCell(2).setCellValue(safeStr(lead.get("phone")));
                row.createCell(3).setCellValue(safeStr(lead.get("email")));
                row.createCell(4).setCellValue(safeStr(lead.get("consultationSource")));
                row.createCell(5).setCellValue(safeStr(lead.get("debtAmount")));
                row.createCell(6).setCellValue(safeStr(lead.get("monthlyIncome")));
                row.createCell(7).setCellValue(safeStr(lead.get("message")));
                row.createCell(8).setCellValue("pending".equals(safeStr(lead.get("status"))) ? "대기" : "완료");
                row.createCell(9).setCellValue(decode(lead.get("utmSource")));
                row.createCell(10).setCellValue(decode(lead.get("utmMedium")));
                row.createCell(11).setCellValue(decode(lead.get("utmCampaign")));
                row.createCell(12).setCellValue(decode(lead.get("referrerUrl")));
                row.createCell(13).setCellValue(decode(lead.get("landingPage")));
                row.createCell(14).setCellValue(safeStr(lead.get("deviceType")));
                row.createCell(15).setCellValue(safeStr(lead.get("os")));
                row.createCell(16).setCellValue(safeStr(lead.get("browser")));
                row.createCell(17).setCellValue(safeStr(lead.get("ipAddress")));
            }

            // 컬럼 너비 자동 조정
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // 응답 헤더 설정
            String fileName = "상담신청목록_" + startDateStr + "_" + endDateStr + ".xlsx";
            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20");

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition",
                    "attachment; filename=\"" + encodedFileName + "\"; filename*=UTF-8''" + encodedFileName);

            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
            }
            workbook.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "엑셀 다운로드 중 오류가 발생했습니다.");
        }
    }

    private String safeStr(Object value) {
        return value != null ? value.toString() : "";
    }

    private String decode(Object value) {
        if (value == null) return "";
        try {
            return URLDecoder.decode(value.toString(), StandardCharsets.UTF_8);
        } catch (Exception e) {
            return value.toString();
        }
    }
}
