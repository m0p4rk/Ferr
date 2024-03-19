package com.warr.ferr;

import com.warr.ferr.config.MyBatisConfig;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;

@Import(MyBatisConfig.class)
@SpringBootApplication
@MapperScan(basePackages = "com.warr.ferr.mapper")
public class FerrApplication {

	public static void main(String[] args) {
		SpringApplication.run(FerrApplication.class, args);
		System.out.println("서버 실행!");
	}

}
