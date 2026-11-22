package com.utp.util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Arrays;

public final class SeguridadContrasena {
    private static final int ITERACIONES = 120_000;
    private static final int BITS = 256;
    private static final int BYTES_SAL = 16;
    private static final SecureRandom RANDOM = new SecureRandom();

    private SeguridadContrasena() {
    }

    public static byte[] nuevoSal() {
        byte[] sal = new byte[BYTES_SAL];
        RANDOM.nextBytes(sal);
        return sal;
    }

    public static byte[] generarHash(String contrasena, byte[] sal) {
        char[] caracteres = contrasena.toCharArray();
        PBEKeySpec especificacion = new PBEKeySpec(caracteres, sal, ITERACIONES, BITS);
        try {
            return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(especificacion).getEncoded();
        } catch (Exception ex) {
            throw new IllegalStateException("No se pudo proteger la contraseña.", ex);
        } finally {
            especificacion.clearPassword();
            Arrays.fill(caracteres, '\0');
        }
    }

    public static boolean verificar(String contrasena, byte[] sal, byte[] hashGuardado) {
        return MessageDigest.isEqual(generarHash(contrasena, sal), hashGuardado);
    }
}
