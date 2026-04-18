package hkmu.wadd.onlineshop.dao;

import hkmu.wadd.onlineshop.model.CartItem;
import hkmu.wadd.onlineshop.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByUser(User user);
    Optional<CartItem> findByUserAndProductId(User user, Long productId);
}