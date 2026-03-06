package com.oceanview.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Random;

public class PasswordUtils {

    private static final int SALT_LENGTH = 16;
    private static final String HASH_ALGORITHM = "SHA-256";
    private static final Random RANDOM = new SecureRandom();

    /**
     * Generate a random salt for password hashing
     */
    public static String generateSalt() {
        byte[] salt = new byte[SALT_LENGTH];
        RANDOM.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    /**
     * Hash a password with a given salt using SHA-256
     */
    public static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
            md.update(salt.getBytes());
            byte[] hashedPassword = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Verify if a plain text password matches the hashed password
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword, String salt) {
        String newHashedPassword = hashPassword(plainPassword, salt);
        return newHashedPassword != null && newHashedPassword.equals(hashedPassword);
    }

    /**
     * Validate password strength
     * Returns true if password meets criteria:
     * - At least 8 characters long
     * - Contains at least one digit
     * - Contains at least one uppercase letter
     * - Contains at least one lowercase letter
     * - Contains at least one special character
     */
    public static boolean isStrongPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }

        boolean hasDigit = false;
        boolean hasUpper = false;
        boolean hasLower = false;
        boolean hasSpecial = false;

        for (char c : password.toCharArray()) {
            if (Character.isDigit(c)) {
                hasDigit = true;
            } else if (Character.isUpperCase(c)) {
                hasUpper = true;
            } else if (Character.isLowerCase(c)) {
                hasLower = true;
            } else if (!Character.isLetterOrDigit(c)) {
                hasSpecial = true;
            }
        }

        return hasDigit && hasUpper && hasLower && hasSpecial;
    }

    /**
     * Generate a random temporary password
     */
    public static String generateTemporaryPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%";
        StringBuilder password = new StringBuilder();

        for (int i = 0; i < 10; i++) {
            int index = RANDOM.nextInt(chars.length());
            password.append(chars.charAt(index));
        }

        return password.toString();
    }

    /**
     * Simple password validation (for demo purposes)
     * In production, use isStrongPassword()
     */
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }
}