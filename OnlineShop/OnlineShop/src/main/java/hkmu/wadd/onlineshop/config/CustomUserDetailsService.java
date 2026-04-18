package hkmu.wadd.onlineshop.config;

import hkmu.wadd.onlineshop.dao.UserRepository;
import hkmu.wadd.onlineshop.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 1. 取得用戶，如果找不到就丟出 Security 專用的異常
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("找不到用戶: " + username));

        // 2. 關鍵修正：Spring Security 要求的權限必須以 "ROLE_" 開頭
        // 如果你資料庫存的是 "MERCHANT"，這裡必須補上 "ROLE_"
        String roleName = user.getRole();
        if (!roleName.startsWith("ROLE_")) {
            roleName = "ROLE_" + roleName;
        }

        return org.springframework.security.core.userdetails.User
                .withUsername(user.getUsername())
                .password(user.getPassword())
                .authorities(roleName)
                .build();
    }
}