package com.mind_your.mind.dto.response;

import java.util.List;

public class PsicologoCadastroResponseDTO {

    private String id;
    private String nome;
    private String email;
    private String login;
    private String crp;
    private List<String> especialidades;

    public PsicologoCadastroResponseDTO(String id, String nome, String email, String login,
                                         String crp, List<String> especialidades) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.login = login;
        this.crp = crp;
        this.especialidades = especialidades;
    }

    public String getId() { return id; }
    public String getNome() { return nome; }
    public String getEmail() { return email; }
    public String getLogin() { return login; }
    public String getCrp() { return crp; }

    public List<String> getEspecialidades() { 
        return especialidades; 
    }
}