package com.oceanview.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.atomic.AtomicInteger;

public class ReservationNumberGenerator {
    private static ReservationNumberGenerator instance;
    private AtomicInteger counter;
    private SimpleDateFormat dateFormat;

    private ReservationNumberGenerator() {
        this.counter = new AtomicInteger(1);
        this.dateFormat = new SimpleDateFormat("yyyyMMdd");
    }

    public static ReservationNumberGenerator getInstance() {
        if (instance == null) {
            synchronized (ReservationNumberGenerator.class) {
                if (instance == null) {
                    instance = new ReservationNumberGenerator();
                }
            }
        }
        return instance;
    }

    public String generateNumber() {
        String date = dateFormat.format(new Date());
        int sequence = counter.getAndIncrement();
        return "RES" + date + String.format("%04d", sequence);
    }
}