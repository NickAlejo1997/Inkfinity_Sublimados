package com.utp.dto;

public class ClienteSesionDTO {
    private long id;
    private String dni;
    private String nombres;
    private String apellidos;
    private String celular;

    public ClienteSesionDTO(long id, String dni, String nombres, String apellidos, String celular) {
        this.id = id;
        this.dni = dni;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.celular = celular;
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

    public String getNombreCompleto() {
        return nombres + " " + apellidos;
    }
}
