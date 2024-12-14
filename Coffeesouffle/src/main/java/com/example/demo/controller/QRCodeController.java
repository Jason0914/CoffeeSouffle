package com.example.demo.controller;



import com.example.demo.service.*;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class QRCodeController {

    @Autowired
    private QRCodeGenerator qrCodeGenerator;

    @GetMapping("/generate-qr")
    public ResponseEntity<byte[]> generateQRCode(@RequestParam String text,
                                                 @RequestParam(defaultValue = "200") int width,
                                                 @RequestParam(defaultValue = "200") int height) {
        try {
            byte[] qrCodeImage = qrCodeGenerator.generateQRCode(text, width, height);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=qr_code.png")
                    .contentType(MediaType.IMAGE_PNG)
                    .body(qrCodeImage);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(null);
        }
    }
}//QRcode網址:http://localhost:8080/generate-qr?text=HelloWorld&width=300&height=300
 //QRcode:http://localhost:8080/generate-qr?text=Hello%20World
