package com.utp.dto;

public class CuentaClienteDTO {
    private long id;
    private String dni;
    private String nombres;
    private String apellidos;
    private String celular;
    private byte[] sal;
    private byte[] hashContrasena;

    public CuentaClienteDTO(long id, String dni, String nombres, String apellidos, String celular, byte[] sal, byte[] hashContrasena) {
        this.id = id;
        this.dni = dni;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.celular = celular;
        this.sal = sal;
        this.hashContrasena = hashContrasena;
    }

    public long getId() {
        return id;
    }

    public String getDni() {
        return dni;
    }

    public String getNombres() {
        return nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public String getCelular() {
        return celular;
    }

    public byte[] getSal() {
        return sal;
    }

    public byte[] getHashContrasena() {
        return hashContrasena;
    }
}
