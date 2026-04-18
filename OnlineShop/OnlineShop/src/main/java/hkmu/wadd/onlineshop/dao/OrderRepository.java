package hkmu.wadd.onlineshop.dao;

import hkmu.wadd.onlineshop.model.Order;
import hkmu.wadd.onlineshop.model.User;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    // 這裡以後可以擴展根據用戶查詢訂單的方法
    List<Order> findByCustomerOrderByOrderDateDesc(User customer);
}