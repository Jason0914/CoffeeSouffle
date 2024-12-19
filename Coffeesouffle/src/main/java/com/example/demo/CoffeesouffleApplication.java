package com.example.demo;

import javax.sql.DataSource;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.jdbc.DataSourceBuilder;

@SpringBootApplication
@ServletComponentScan
public class CoffeesouffleApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(CoffeesouffleApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(CoffeesouffleApplication.class, args);
    }
    
    @Bean
    public DataSource dataSource() {
        return DataSourceBuilder.create()
            .url(System.getenv("MYSQL_URL"))
            .username(System.getenv("MYSQLUSER"))
            .password(System.getenv("MYSQLPASSWORD"))
            .driverClassName("com.mysql.cj.jdbc.Driver")
            .build();
    }
}