package com.example.movie_ticket_booking_web.util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordHashUtil {

    private static final String ALGO = "PBKDF2WithHmacSHA256";
    private static final int ITERATIONS = 65536;
    private static final int KEY_LENGTH_BITS = 256;
    private static final int SALT_LENGTH_BYTES = 16;

    private static final SecureRandom RANDOM = new SecureRandom();

    // Format lưu: pbkdf2$iterations$saltBase64$hashBase64
    public static String hash(String rawPassword) {
        if (rawPassword == null) return null;

        byte[] salt = new byte[SALT_LENGTH_BYTES];
        RANDOM.nextBytes(salt);

        byte[] derived = pbkdf2(rawPassword.toCharArray(), salt, ITERATIONS, KEY_LENGTH_BITS);
        String saltB64 = Base64.getEncoder().encodeToString(salt);
        String hashB64 = Base64.getEncoder().encodeToString(derived);

        return "pbkdf2$" + ITERATIONS + "$" + saltB64 + "$" + hashB64;
    }

    public static boolean verify(String rawPassword, String stored) {
        if (rawPassword == null || stored == null) return false;
        if (!isHashed(stored)) return false;

        String[] parts = stored.split("\\$");
        if (parts.length != 4) return false;

        int iterations;
        try {
            iterations = Integer.parseInt(parts[1]);
        } catch (NumberFormatException e) {
            return false;
        }

        byte[] salt = Base64.getDecoder().decode(parts[2]);
        byte[] expected = Base64.getDecoder().decode(parts[3]);

        byte[] actual = pbkdf2(rawPassword.toCharArray(), salt, iterations, expected.length * 8);

        return MessageDigest.isEqual(expected, actual);
    }

    public static boolean isHashed(String stored) {
        return stored != null && stored.startsWith("pbkdf2$");
    }

    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int keyLengthBits) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, keyLengthBits);
            SecretKeyFactory skf = SecretKeyFactory.getInstance(ALGO);
            return skf.generateSecret(spec).getEncoded();
        } catch (Exception e) {
            throw new RuntimeException("Hash password failed", e);
        }
    }
}
