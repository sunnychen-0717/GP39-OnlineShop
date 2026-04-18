package hkmu.wadd.onlineshop.dao;

import hkmu.wadd.onlineshop.model.Favourite;
import hkmu.wadd.onlineshop.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface FavouriteRepository extends JpaRepository<Favourite, Long> {
    List<Favourite> findByUser(User user);
    Optional<Favourite> findByUserAndProductId(User user, Long productId);
}