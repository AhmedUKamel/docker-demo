package org.ahmedukamel.staticdemo;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@SpringBootApplication
@RestController
@RequiredArgsConstructor
public class StaticDemoApplication {
    final BlogRepository repository;

    public static void main(String[] args) {
        SpringApplication.run(StaticDemoApplication.class, args);
    }

//    @GetMapping
    public ResponseEntity<Object> home() {
        Map<String, Object> data = Map.of(
                "title", "AhmedUKamel v0.0.6",
                "blogs", repository.findAll());
        return ResponseEntity.ok(data);
    }

    @Bean
    CommandLineRunner commandLineRunner(BlogRepository repository) {
        return args -> {
            Blog blog1 = new Blog(null, "Blog 11");
            Blog blog2 = new Blog(null, "Blog 22");
            repository.save(blog1);
            repository.save(blog2);
        };
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Entity(name = "blogs")
    public static class Blog {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Integer id;
        private String name;
    }
}