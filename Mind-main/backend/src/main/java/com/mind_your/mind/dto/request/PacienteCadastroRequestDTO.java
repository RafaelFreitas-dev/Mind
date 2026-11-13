package com.mind_your.mind.dto.request;

import java.time.LocalDate;

public class PacienteCadastroRequestDTO {

    private String nome;
    private String sobrenome;
    private String email;
    private String login;
    private String senha;
    private String genero;
    private String telefone;
    private String cep;
    private String numeroResidencia;
    private LocalDate dtNascimento;


    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getSobrenome() { return sobrenome; }
    public void setSobrenome(String sobrenome) { this.sobrenome = sobrenome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getLogin() { return login; }
    public void setLogin(String login) { this.login = login; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }

    public String getGenero() { return genero; }
    public void setGenero(String genero) { this.genero = genero; }

    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }

    public String getCep() { return cep; }
    public void setCep(String cep) { this.cep = cep; }

    public String getNumeroResidencia() { return numeroResidencia; }
    public void setNumeroResidencia(String numeroResidencia) { this.numeroResidencia = numeroResidencia; }

    public LocalDate getDtNascimento() { return dtNascimento; }
    public void setDtNascimento(LocalDate dtNascimento) { this.dtNascimento = dtNascimento; }
}