package hkmu.wadd.onlineshop.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class MvcConfig implements WebMvcConfigurer {

    @Value("${upload.path}")
    private String uploadPath;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Resolve the absolute path of the upload directory
        String projectRoot = System.getProperty("user.dir");
        Path uploadDir = Paths.get(projectRoot, uploadPath).toAbsolutePath().normalize();

        // Map /uploads/** URL to the physical folder on your disk
        // The "file:" prefix is mandatory for external file system access
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadDir.toString() + "/");
    }
}