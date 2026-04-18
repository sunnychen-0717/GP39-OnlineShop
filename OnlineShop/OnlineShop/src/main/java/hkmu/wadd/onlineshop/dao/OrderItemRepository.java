package hkmu.wadd.onlineshop.dao;

import hkmu.wadd.onlineshop.model.OrderItem;
import hkmu.wadd.onlineshop.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {
    // 讓商家能看到屬於自己的訂單明細
    List<OrderItem> findByMerchant(User merchant);
}