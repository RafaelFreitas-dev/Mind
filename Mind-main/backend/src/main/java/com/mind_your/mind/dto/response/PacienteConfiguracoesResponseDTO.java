package com.mind_your.mind.dto.response;

import java.time.LocalDate;

public class PacienteConfiguracoesResponseDTO {
    private String id;
    private String nome;
    private String sobrenome;
    private String email;
    private String login;
    private String imgPerfil;
    private LocalDate dtNascimento;
    private String genero;
    private String telefone;
    private String endereco; // Rua
    private String cep;
    private String numeroResidencia;
    private String cidade;
    private String uf;
    private String sobreMim;
    private String medicamentos;
    private String preferencias;

    public PacienteConfiguracoesResponseDTO(String id, String nome, String sobrenome, String email, String login,
                                            String imgPerfil, LocalDate dtNascimento, String genero, String telefone,
                                            String endereco, String cep, String numeroResidencia, String cidade, String uf,
                                            String sobreMim, String medicamentos, String preferencias) {
        this.id = id;
        this.nome = nome;
        this.sobrenome = sobrenome;
        this.email = email;
        this.login = login;
        this.imgPerfil = imgPerfil;
        this.dtNascimento = dtNascimento;
        this.genero = genero;
        this.telefone = telefone;
        this.endereco = endereco;
        this.cep = cep;
        this.numeroResidencia = numeroResidencia;
        this.cidade = cidade;
        this.uf = uf;
        this.sobreMim = sobreMim;
        this.medicamentos = medicamentos;
        this.preferencias = preferencias;
    }

    // Getters
    public String getId() { return id; }
    public String getNome() { return nome; }
    public String getSobrenome() { return sobrenome; }
    public String getEmail() { return email; }
    public String getLogin() { return login; }
    public String getImgPerfil() { return imgPerfil; }
    public LocalDate getDtNascimento() { return dtNascimento; }
    public String getGenero() { return genero; }
    public String getTelefone() { return telefone; }
    public String getEndereco() { return endereco; }
    public String getCep() { return cep; }
    public String getNumeroResidencia() { return numeroResidencia; }
    public String getCidade() { return cidade; }
    public String getUf() { return uf; }
    public String getSobreMim() { return sobreMim; }
    public String getMedicamentos() { return medicamentos; }
    public String getPreferencias() { return preferencias; }
}
