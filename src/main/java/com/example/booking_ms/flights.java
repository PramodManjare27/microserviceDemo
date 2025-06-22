package com.example.booking_ms;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.*;


@RestController
public class flights {
    @GetMapping("/flight")
    public String getData() {
        return "Please return flight ticket with 30% discount";
    }

}