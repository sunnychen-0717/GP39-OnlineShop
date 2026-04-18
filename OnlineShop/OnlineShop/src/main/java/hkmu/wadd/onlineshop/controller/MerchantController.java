package hkmu.wadd.onlineshop.controller;

import hkmu.wadd.onlineshop.dao.*;
import hkmu.wadd.onlineshop.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.util.List;
import java.util.UUID;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/merchant")
public class MerchantController {

    @Autowired private ProductRepository productRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private OrderItemRepository orderItemRepository; // 用於查看訂單
    @Autowired private OrderRepository orderRepository;

    @Value("${upload.path}")
    private String uploadPath;

    // 1. 商家商品管理清單 (Inventory)
    @GetMapping("/my-products")
    public String showMyProducts(Model model, Principal principal) {
        User merchant = getCurrentUser(principal);
        List<Product> myProducts = productRepository.findByMerchant(merchant);
        model.addAttribute("products", myProducts);
        return "my-products";
    }

    // 2. 顯示新增商品表單
    @GetMapping("/add-product")
    public String showAddProductForm(Model model) {
        model.addAttribute("product", new Product());
        return "add-product";
    }

    // 3. 處理新增商品
    @PostMapping("/add-product")
    public String addProduct(@ModelAttribute Product product,
                             @RequestParam("file") MultipartFile file,
                             Principal principal) {
        User merchant = getCurrentUser(principal);
        product.setMerchant(merchant);

        // 處理上傳並設定圖片路徑
        String imageUrl = handleFileUpload(file);
        product.setImageUrl(imageUrl != null ? imageUrl : "/uploads/default_product.png");

        productRepository.save(product);
        return "redirect:/merchant/my-products?success=added";
    }

    // 4. 顯示編輯商品頁面
    @GetMapping("/edit-product/{id}")
    public String showEditProductForm(@PathVariable Long id, Model model, Principal principal) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));

        // 安全檢查：確保商家只能編輯自己的商品
        User merchant = getCurrentUser(principal);
        if (!product.getMerchant().getId().equals(merchant.getId())) {
            return "redirect:/merchant/my-products";
        }

        model.addAttribute("product", product);
        return "edit-product";
    }

    // 5. 處理更新商品
    @PostMapping("/edit-product")
    public String updateProduct(@ModelAttribute Product product,
                                @RequestParam(value = "file", required = false) MultipartFile file,
                                Principal principal) {
        User merchant = getCurrentUser(principal);

        // 抓取資料庫中的舊數據以獲取原始圖片
        Product existingProduct = productRepository.findById(product.getId())
                .orElseThrow(() -> new RuntimeException("Product not found"));

        if (!existingProduct.getMerchant().getId().equals(merchant.getId())) {
            return "redirect:/merchant/my-products";
        }

        // 更新圖片處理
        if (file != null && !file.isEmpty()) {
            product.setImageUrl(handleFileUpload(file));
        } else {
            product.setImageUrl(existingProduct.getImageUrl()); // 保留舊圖
        }

        product.setMerchant(merchant);
        productRepository.save(product);
        return "redirect:/merchant/my-products?success=updated";
    }

    // 6. 處理刪除商品
    @PostMapping("/delete-product/{id}")
    public String deleteProduct(@PathVariable Long id, Principal principal) {
        try {
            Product product = productRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Product not found"));
            User merchant = getCurrentUser(principal);

            // 安全檢查：確保商家擁有此商品且 merchant 不為 null (防止舊數據導致 NPE)
            if (product.getMerchant() != null && product.getMerchant().getId().equals(merchant.getId())) {
                productRepository.delete(product);
                return "redirect:/merchant/my-products?success=deleted";
            } else {
                return "redirect:/merchant/my-products?error=unauthorized";
            }

        } catch (org.springframework.dao.DataIntegrityViolationException e) {
            // 核心修正：捕獲「商品已被下單」導致的刪除失敗
            System.err.println("Cannot delete product: It is linked to existing orders.");
            return "redirect:/merchant/my-products?error=conflict";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/merchant/my-products?error=unknown";
        }
    }

    // 7. 查看買家訂單 (Sales)
    @GetMapping("/orders")
    public String viewOrders(Model model, Principal principal) {
        User merchant = userRepository.findByUsername(principal.getName()).get();
        List<OrderItem> allItems = orderItemRepository.findByMerchant(merchant);

        // 保持邏輯不變，只修改最後的 return 名稱
        Map<Order, List<OrderItem>> groupedOrders = allItems.stream()
                .collect(Collectors.groupingBy(OrderItem::getOrder));

        model.addAttribute("groupedOrders", groupedOrders);

        return "merchant-orders";
    }

    @PostMapping("/order/updateStatus")
    public String updateOrderStatus(@RequestParam("orderId") Long orderId,
                                    @RequestParam("newStatus") String newStatus,
                                    RedirectAttributes ra) {
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order != null) {
            order.setStatus(newStatus); // 這裡更新狀態
            orderRepository.save(order); // 這裡寫入資料庫
            ra.addFlashAttribute("success", "Status updated successfully!");
        } else {
            ra.addFlashAttribute("error", "Order not found!");
        }
        return "redirect:/merchant/orders";
    }

    // --- Helper Methods (輔助工具) ---

    private User getCurrentUser(Principal principal) {
        return userRepository.findByUsername(principal.getName())
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    private String handleFileUpload(MultipartFile file) {
        if (file.isEmpty()) return null;
        try {
            String projectRoot = System.getProperty("user.dir");
            Path uploadDir = Paths.get(projectRoot, uploadPath).toAbsolutePath().normalize();

            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }

            String originalFilename = file.getOriginalFilename();
            String fileExtension = (originalFilename != null && originalFilename.contains(".")) ?
                    originalFilename.substring(originalFilename.lastIndexOf(".")) : "";

            String newFilename = UUID.randomUUID().toString() + fileExtension;
            Path targetPath = uploadDir.resolve(newFilename);
            Files.write(targetPath, file.getBytes());

            return "/uploads/" + newFilename;
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}