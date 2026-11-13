package com.mind_your.mind.dto.response;

public class PacienteCadastroResponseDTO {

    private String id;
    private String nome;
    private String email;
    private String login;

    public PacienteCadastroResponseDTO(String id, String nome, String email, String login) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.login = login;
    }

    public String getId() { return id; }
    public String getNome() { return nome; }
    public String getEmail() { return email; }
    public String getLogin() { return login; }
}