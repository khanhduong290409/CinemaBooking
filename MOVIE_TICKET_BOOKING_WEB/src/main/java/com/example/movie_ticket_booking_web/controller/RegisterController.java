package com.example.movie_ticket_booking_web.controller;
import com.example.movie_ticket_booking_web.dao.UserDAO;
import com.example.movie_ticket_booking_web.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // dùng form Sign: name="User", "pass", "repass"
        String userOrEmail = request.getParameter("User");
        String password = request.getParameter("pass");
        String repass = request.getParameter("repass");

        if (userOrEmail == null || password == null || repass == null ||
                userOrEmail.isEmpty() || password.isEmpty() || repass.isEmpty()) {

            request.setAttribute("signupError", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        if (!password.equals(repass)) {
            request.setAttribute("signupError", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Ở đây mình giả sử userOrEmail là username luôn,
        // nếu bạn muốn tách username + email thì chỉnh form & code lại
        User user = new User();
        user.setUsername(userOrEmail);
        user.setEmail(userOrEmail); // tạm dùng giống nhau cho đơn giản
        user.setPassword(password); // thực tế: hash mật khẩu

        boolean ok = userDAO.insert(user);

//        if (ok) {
//            // đăng ký xong → cho login luôn, hoặc auto login tùy ý
//            request.setAttribute("signupSuccess", "Đăng ký thành công, hãy đăng nhập!");
//            request.getRequestDispatcher("login.jsp").forward(request, response);
//        } else {
//            request.setAttribute("signupError", "Tài khoản hoặc email đã tồn tại!");
//            request.getRequestDispatcher("login.jsp").forward(request, response);
//
//        }
        if (!ok) {
            request.setAttribute("signupError", "Tài khoản hoặc email đã tồn tại!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

// Đăng ký thành công
        request.setAttribute("signupSuccess", "Đăng ký thành công, hãy đăng nhập!");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    // nếu GET /register → quay lại login.jsp
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
