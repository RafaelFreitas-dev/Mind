package com.mind_your.mind.dto.response;

import java.util.List;

public class PsicologoResponseDTO {

    private String id;
    private String nome;
    private String sobrenome;
    private Integer idade;
    private String local;
    private String imgPerfil;
    private String crp;
    private List<String> especialidades;
    private String telefone;
    private String sobreMim;

    public PsicologoResponseDTO(String id, String nome, String sobrenome, Integer idade, String local,
                                 String imgPerfil, String crp, List<String> especialidades,
                                 String telefone, String sobreMim) {

        this.id = id;
        this.nome = nome;
        this.sobrenome = sobrenome;
        this.idade = idade;
        this.local = local;
        this.imgPerfil = imgPerfil;
        this.crp = crp;
        this.especialidades = especialidades;
        this.telefone = telefone;
        this.sobreMim = sobreMim;
    }

    public String getId() { return id; }
    public String getNome() { return nome; }
    public String getSobrenome() { return sobrenome; }
    public Integer getIdade() { return idade; }
    public String getLocal() { return local; }
    public String getImgPerfil() { return imgPerfil; }
    public String getCrp() { return crp; }

    public List<String> getEspecialidades() { return especialidades; }

    public String getTelefone() { return telefone; }
    public String getSobreMim() { return sobreMim; }
}