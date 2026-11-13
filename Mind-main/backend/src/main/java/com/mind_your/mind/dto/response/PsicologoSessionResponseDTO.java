package com.mind_your.mind.dto.response;

public class PsicologoSessionResponseDTO {
    private String id;
    private String nome;
    private String sobrenome;
    private String imgPerfil;
    private String tipo = "psicologo";

    public PsicologoSessionResponseDTO(String id, String nome, String sobrenome, String imgPerfil) {
        this.id = id;
        this.nome = nome;
        this.sobrenome = sobrenome;
        this.imgPerfil = imgPerfil;
    }

    public String getId() { return id; }
    public String getNome() { return nome; }
    public String getSobrenome() { return sobrenome; }
    public String getImgPerfil() { return imgPerfil; }
    public String getTipo() { return tipo; }
}
