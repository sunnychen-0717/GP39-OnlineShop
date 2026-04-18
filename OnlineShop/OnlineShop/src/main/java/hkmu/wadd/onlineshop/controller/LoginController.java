package hkmu.wadd.onlineshop.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {

    @GetMapping("/login")
    public String login() {
        return "login"; // 對應 /WEB-INF/jsp/login.jsp
    }

    @GetMapping("/index")
    public String index() {
        return "index"; // 登入成功後跳轉的頁面
    }
}