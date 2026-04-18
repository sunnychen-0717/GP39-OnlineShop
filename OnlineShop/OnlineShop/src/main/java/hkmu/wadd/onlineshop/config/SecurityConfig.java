package hkmu.wadd.onlineshop.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;


@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Autowired
    private CustomUserDetailsService userDetailsService;
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // 暫時禁用 CSRF 以確保 H2 和簡單 POST 請求能運作
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        // 1. 公開路徑：包含登入、註冊、H2 控制台、以及 JSP 目錄
                        .requestMatchers(
                                "/register", "/login", "/h2-console/**", "/error",
                                "/WEB-INF/jsp/**", "/css/**", "/js/**"
                        ).permitAll()

                        // 2. 角色權限設定 (對應你的 OnlineShop 用戶類型)
                        .requestMatchers("/merchant/**").hasRole("MERCHANT")
                        .requestMatchers("/customer/**").hasRole("CUSTOMER")

                        // 3. 剩下所有頁面都需要登入
                        .anyRequest().authenticated()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .defaultSuccessUrl("/index", true) // 登入成功後跳轉
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")            // 指定登出處理的路徑
                        .logoutSuccessUrl("/login?logout") // 登出成功後去哪
                        .permitAll()
                )
                // 允許 H2 Console 使用 Frame
                .headers(headers -> headers.frameOptions(frame -> frame.sameOrigin()));

        return http.build();
    }
}