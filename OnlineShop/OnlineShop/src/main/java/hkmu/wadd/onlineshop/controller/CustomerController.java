package hkmu.wadd.onlineshop.controller;

import hkmu.wadd.onlineshop.dao.*;
import hkmu.wadd.onlineshop.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/customer")
public class CustomerController {

    @Autowired private ProductRepository productRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private FavouriteRepository favouriteRepository;
    @Autowired private CartItemRepository cartItemRepository;
    @Autowired private OrderRepository orderRepository;
    @Autowired private OrderItemRepository orderItemRepository;

    // 1. 商城瀏覽 (加入 filter 防止已刪除產品導致 NPE)
    @GetMapping("/browse")
    public String browse(@RequestParam(value = "search", required = false) String search,
                         Model model, Principal principal) {
        List<Product> products = (search != null && !search.trim().isEmpty())
                ? productRepository.findByNameContainingIgnoreCase(search)
                : productRepository.findAll();

        model.addAttribute("products", products);
        model.addAttribute("searchKeyword", search);

        if (principal != null) {
            userRepository.findByUsername(principal.getName()).ifPresent(user -> {
                List<Long> favIds = favouriteRepository.findByUser(user).stream()
                        .filter(f -> f.getProduct() != null)
                        .map(f -> f.getProduct().getId())
                        .collect(Collectors.toList());
                model.addAttribute("favProductIds", favIds);
            });
        }
        return "browse";
    }

    // 2. 商品詳情
    @GetMapping("/detail/{id}")
    public String productDetail(@PathVariable("id") Long id, Model model, Principal principal) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        model.addAttribute("product", product);

        if (principal != null) {
            userRepository.findByUsername(principal.getName()).ifPresent(user -> {
                model.addAttribute("isFavourite", favouriteRepository.findByUserAndProductId(user, id).isPresent());
            });
        }
        return "detail";
    }

    // 3. 加入購物車 (確保累加)
    @PostMapping("/cart/add/{productId}")
    @ResponseBody
    public String addToCart(@PathVariable Long productId,
                            @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                            Principal principal) {
        if (principal == null) return "UNAUTHORIZED";

        User user = userRepository.findByUsername(principal.getName()).orElseThrow();
        Optional<CartItem> existing = cartItemRepository.findByUserAndProductId(user, productId);

        if (existing.isPresent()) {
            CartItem item = existing.get();
            item.setQuantity(item.getQuantity() + quantity);
            cartItemRepository.save(item);
        } else {
            Product p = productRepository.findById(productId).orElseThrow();
            cartItemRepository.save(new CartItem(user, p, quantity));
        }
        return "SUCCESS";
    }

    // 4. 查看購物車
    @GetMapping("/cart")
    public String viewCart(Model model, Principal principal) {
        User user = userRepository.findByUsername(principal.getName()).orElseThrow();
        List<CartItem> items = cartItemRepository.findByUser(user).stream()
                .filter(i -> i.getProduct() != null)
                .collect(Collectors.toList());

        BigDecimal total = items.stream()
                .map(i -> i.getProduct().getPrice().multiply(BigDecimal.valueOf(i.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        model.addAttribute("cartItems", items);
        model.addAttribute("total", total);
        return "cart";
    }

    // 5. 買家 Dashboard (核心修正：移除嚴格角色判斷以顯示 Wishlist)
    @GetMapping("/index")
    public String showDashboard(Model model, Principal principal) {
        if (principal != null) {
            userRepository.findByUsername(principal.getName()).ifPresent(user -> {
                // 只要是進入此方法的登入用戶，直接獲取其收藏與購物車數量
                List<Favourite> activeFavs = favouriteRepository.findByUser(user).stream()
                        .filter(f -> f.getProduct() != null)
                        .collect(Collectors.toList());
                model.addAttribute("favs", activeFavs);

                int count = cartItemRepository.findByUser(user).stream()
                        .filter(ci -> ci.getProduct() != null)
                        .mapToInt(CartItem::getQuantity).sum();
                model.addAttribute("cartCount", count);

                System.out.println(">>> Dashboard Loaded for: " + user.getUsername() + " | Favs: " + activeFavs.size());
            });
        }
        return "index";
    }

    // 6. 收藏切換
    @PostMapping("/favourite/toggle/{productId}")
    @ResponseBody
    public String toggleFavourite(@PathVariable Long productId, Principal principal) {
        if (principal == null) return "UNAUTHORIZED";
        User user = userRepository.findByUsername(principal.getName()).get();
        Optional<Favourite> existing = favouriteRepository.findByUserAndProductId(user, productId);
        if (existing.isPresent()) {
            favouriteRepository.delete(existing.get());
            return "REMOVED";
        } else {
            Product product = productRepository.findById(productId).get();
            favouriteRepository.save(new Favourite(user, product));
            return "ADDED";
        }
    }

    // 7. 結帳頁面
    @GetMapping("/cart/checkout")
    public String showCheckout(Model model, Principal principal) {
        User user = userRepository.findByUsername(principal.getName()).get();
        List<CartItem> items = cartItemRepository.findByUser(user);
        if (items.isEmpty()) return "redirect:/customer/cart";

        BigDecimal total = items.stream()
                .filter(i -> i.getProduct() != null)
                .map(i -> i.getProduct().getPrice().multiply(BigDecimal.valueOf(i.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        model.addAttribute("cartItems", items);
        model.addAttribute("total", total);
        return "checkout";
    }

    // 8. 處理訂單 (加入防禦性檢查)
    @PostMapping("/cart/placeOrder")
    public String placeOrder(@RequestParam String address,
                             @RequestParam String contactMethod, // 接收整合後的聯絡方式
                             @RequestParam String paymentMethod,
                             @RequestParam String shippingMethod,
                             Principal principal, RedirectAttributes ra) {
        User customer = userRepository.findByUsername(principal.getName()).get();
        List<CartItem> items = cartItemRepository.findByUser(customer);

        if (items.isEmpty()) return "redirect:/customer/index";

        Order order = new Order();
        order.setCustomer(customer);
        order.setOrderDate(LocalDateTime.now());
        order.setStatus("PAID");
        order.setAddress(address);
        order.setContactMethod(contactMethod);

        order.setPaymentMethod(paymentMethod);
        order.setShippingMethod(shippingMethod);

        BigDecimal total = items.stream()
                .filter(i -> i.getProduct() != null)
                .map(i -> i.getProduct().getPrice().multiply(BigDecimal.valueOf(i.getQuantity())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        order.setTotalAmount(total);
        orderRepository.save(order);

        for (CartItem ci : items) {
            Product p = ci.getProduct();
            if (p == null) continue; // 防止產品被刪除導致崩潰

            OrderItem oi = new OrderItem();
            oi.setOrder(order);
            oi.setProduct(p);
            oi.setMerchant(p.getMerchant());
            oi.setQuantity(ci.getQuantity());
            oi.setPriceAtPurchase(p.getPrice());
            orderItemRepository.save(oi);

            p.setStock(p.getStock() - ci.getQuantity());
            productRepository.save(p);
        }

        cartItemRepository.deleteAll(items);
        ra.addFlashAttribute("success", "Order placed successfully!");
        return "redirect:/customer/index";
    }

    // 9. 從購物車移除
    @PostMapping("/cart/remove/{itemId}")
    public String removeFromCart(@PathVariable Long itemId) {
        cartItemRepository.deleteById(itemId);
        return "redirect:/customer/cart";
    }

    @GetMapping("/orders")
    public String showMyOrders(Principal principal, Model model) {
        // 獲取當前登入的買家
        User customer = userRepository.findByUsername(principal.getName()).get();

        // 查詢該買家的所有訂單 (建議按時間倒序排列)
        List<Order> orders = orderRepository.findByCustomerOrderByOrderDateDesc(customer);

        model.addAttribute("orders", orders);
        return "customerOrders"; // 對應 customerOrders.jsp
    }
}