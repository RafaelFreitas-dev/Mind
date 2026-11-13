package com.mind_your.mind.dto.response;


public class PacienteResponseDTO {
    private String id;
    private String nome;
    private String sobrenome;
    private String imgPerfil;
    private String telefone;
    private String sobreMim;
    private String medicamentos;
    private String preferencias;
    private Integer idade;
    private String local;

    public PacienteResponseDTO(String id, String nome, String sobrenome, String imgPerfil, 
                               String telefone, String sobreMim, String medicamentos, 
                               String preferencias, Integer idade, String local) {
        this.id = id;
        this.nome = nome;
        this.sobrenome = sobrenome;
        this.imgPerfil = imgPerfil;
        this.telefone = telefone;
        this.sobreMim = sobreMim;
        this.medicamentos = medicamentos;
        this.preferencias = preferencias;
        this.idade = idade;
        this.local = local;
    }

    public String getId() { return id; }
    public String getNome() { return nome; }
    public String getSobrenome() { return sobrenome; }
    public String getImgPerfil() { return imgPerfil; }
    public String getTelefone() { return telefone; }
    public String getSobreMim() { return sobreMim; }
    public String getMedicamentos() { return medicamentos; }
    public String getPreferencias() { return preferencias; }
    public Integer getIdade() { return idade; }
    public String getLocal() { return local; }
}