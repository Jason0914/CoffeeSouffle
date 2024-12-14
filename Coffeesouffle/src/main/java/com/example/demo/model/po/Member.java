package com.example.demo.model.po;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Member {
	private Integer memberId;
	private String account;
	private String password;
	private String salt;
	private String name;
	private String gender;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date birthday;
	private String email;
	private String phone;
	private Integer isMember;

	 // 添加一個方法來打印成員信息，用於調試
    @Override
    public String toString() {
        return "Member{" +
                "memberId=" + memberId +
                ", account='" + account + '\'' +
                ", name='" + name + '\'' +
                ", gender='" + gender + '\'' +
                ", birthday=" + birthday +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", isMember=" + isMember +
                '}';
    }
	
	
}
