package hkmu.wadd.onlineshop.model;

import jakarta.persistence.*;

@Entity
@Table(name = "favourites")
public class Favourite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false) // optional = false 確保關聯產品不能為 null
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false) // 確保這條紀錄必須對應一個產品
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    // 空構造函數 (JPA 必須)
    public Favourite() {}

    // 便利構造函數
    public Favourite(User user, Product product) {
        this.user = user;
        this.product = product;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
}