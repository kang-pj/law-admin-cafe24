package controller;

import dao.AccessLogDAO;
import model.AccessLog;
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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/admin/access/stats/excel")
public class AccessStatsExcelServlet extends HttpServlet {

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
                case "yesterday":
                    startDate = endDate.minusDays(1);
                    endDate = endDate.minusDays(1);
                    break;
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

        // 업체 필터
        String companyId = null;
        if ("MASTER".equals(admin.getRole())) {
            companyId = request.getParameter("company");
        } else {
            companyId = admin.getCompanyId();
        }

        try (Connection conn = DBConnection.getConnection()) {
            AccessLogDAO dao = new AccessLogDAO(conn);
            List<AccessLog> logs = dao.getAllLogs(companyId, startDateStr, endDateStr);

            // 엑셀 생성
            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("접속 통계");

            // 헤더 스타일
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setBorderBottom(BorderStyle.THIN);

            // 헤더 행 - 시간, IP, 요청URI
            String[] headers = {"시간", "IP", "요청 URI"};
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // 데이터 행
            int rowNum = 1;
            for (AccessLog log : logs) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(log.getCreatedAt() != null ? log.getCreatedAt().toString() : "");
                row.createCell(1).setCellValue(safeStr(log.getIpAddress()));
                row.createCell(2).setCellValue(decode(log.getPageUrl()));
            }

            // 컬럼 너비 자동 조정
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // 응답 헤더
            String fileName = "접속통계_" + startDateStr + "_" + endDateStr + ".xlsx";
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
