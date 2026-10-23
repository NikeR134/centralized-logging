package ru.netology.centralizedlogging;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LogController {
    private static final Logger logger = LoggerFactory.getLogger(LogController.class);

    @GetMapping("/logs/sample")
    public String createLog(@RequestParam(defaultValue = "sample event") String message) {
        logger.info("Application event: {}", message);
        return "Log event created";
    }
}

