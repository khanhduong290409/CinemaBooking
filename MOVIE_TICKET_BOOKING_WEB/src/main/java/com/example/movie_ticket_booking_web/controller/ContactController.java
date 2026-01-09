package com.example.movie_ticket_booking_web.controller;

import com.example.movie_ticket_booking_web.dao.ContactFeedbackDAO;
import com.example.movie_ticket_booking_web.model.ContactFeedback;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/contact")
public class ContactController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        // lấy dữ liệu từ AJAX
        String city = request.getParameter("city");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String message = request.getParameter("message");

        // validate
        if (name == null || email == null || phone == null || message == null ||
                name.isEmpty() || email.isEmpty() || phone.isEmpty() || message.isEmpty()) {

            out.print("""
                {
                  "success": false,
                  "message": "Vui lòng điền đầy đủ thông tin!"
                }
            """);
            return;
        }

        // tạo model
        ContactFeedback feedback = new ContactFeedback(city, name, email, phone, message);

        // gọi DAO (DAO tự dùng DBConnection)
        ContactFeedbackDAO dao = new ContactFeedbackDAO();
        boolean success = dao.insert(feedback);

        if (success) {
            out.print("""
                {
                  "success": true,
                  "message": "Gửi phản hồi thành công!"
                }
            """);
        } else {
            out.print("""
                {
                  "success": false,
                  "message": "Gửi phản hồi thất bại!"
                }
            """);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/contact.jsp").forward(req, resp);
    }
}
