package hkmu.wadd.onlineshop.controller;

import hkmu.wadd.onlineshop.dao.UserRepository;
import hkmu.wadd.onlineshop.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@Controller
public class RegistrationController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // --- 註冊功能 ---
    @GetMapping("/register")
    public String showRegisterForm() {
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@ModelAttribute User user) {
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            return "redirect:/register?error=user_exists";
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setEnabled(true);
        userRepository.save(user);
        return "redirect:/login?success=registered";
    }

    // --- 個人資料查看 (Profile) ---
    @GetMapping("/profile")
    public String showProfile(Model model, Principal principal) {
        String username = principal.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        model.addAttribute("user", user);
        return "profile";
    }

    // --- 處理個人資料更新 ---
    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute User updatedData,
                                @RequestParam(value = "newPassword", required = false) String newPassword,
                                Principal principal) {
        // 1. 從安全上下文獲取當前用戶，確保安全
        String username = principal.getName();
        User existingUser = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // 2. 更新允許修改的欄位 (username 不被修改)
        existingUser.setFirstName(updatedData.getFirstName());
        existingUser.setLastName(updatedData.getLastName());
        existingUser.setEmail(updatedData.getEmail());

        // 3. 只有當用戶輸入了新密碼時才進行加密並更新
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            existingUser.setPassword(passwordEncoder.encode(newPassword));
        }

        userRepository.save(existingUser);
        return "redirect:/profile?success=updated";
    }
}