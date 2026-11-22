package com.utp.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class ConexionBD {
    private static final String URL = System.getenv().getOrDefault(
            "INKFINITY_DB_URL",
            "jdbc:mysql://localhost:3306/inkfinity_sublimados?useSSL=false&serverTimezone=America/Lima&allowPublicKeyRetrieval=true");
    private static final String USUARIO = System.getenv().getOrDefault("INKFINITY_DB_USER", "root");
    private static final String CLAVE = System.getenv().getOrDefault("INKFINITY_DB_PASSWORD", "");

    private ConexionBD() {
    }

    public static Connection obtenerConexion() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, CLAVE);
    }
}
