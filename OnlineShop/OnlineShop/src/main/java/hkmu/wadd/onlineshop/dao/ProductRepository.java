package hkmu.wadd.onlineshop.dao;

import hkmu.wadd.onlineshop.model.Product;
import hkmu.wadd.onlineshop.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ProductRepository extends JpaRepository<Product, Long> {
    // 必須與 Product.java 中的變數名一致
    List<Product> findByMerchant(User merchant);
    List<Product> findByNameContainingIgnoreCase(String name);
}