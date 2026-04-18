package hkmu.wadd.onlineshop.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "order_items")
public class OrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order; // 所屬的總訂單

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product; // 購買的商品

    @ManyToOne
    @JoinColumn(name = "merchant_id")
    private User merchant; // 該商品的賣家 (商家)

    private int quantity; // 購買數量

    private BigDecimal priceAtPurchase; // 購買時的價格 (避免日後商品漲價影響舊訂單)

    public OrderItem() {
    }

    public OrderItem(Order order, Product product, User merchant, int quantity, BigDecimal priceAtPurchase) {
        this.order = order;
        this.product = product;
        this.merchant = merchant;
        this.quantity = quantity;
        this.priceAtPurchase = priceAtPurchase;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public User getMerchant() { return merchant; }
    public void setMerchant(User merchant) { this.merchant = merchant; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getPriceAtPurchase() { return priceAtPurchase; }
    public void setPriceAtPurchase(BigDecimal priceAtPurchase) { this.priceAtPurchase = priceAtPurchase; }
}