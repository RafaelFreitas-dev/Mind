package com.mind_your.mind.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Transient;
import org.springframework.data.mongodb.core.mapping.Document;


import java.time.LocalDate;
import java.time.Period;

@Document(collection = "pacientes")
public class Paciente {

    @Id
    private String id; // Mongo usa String para ObjectId

    private String login;
    private String email;
    private String senha;
    private String nome = "";
    private String sobrenome = "";
    private LocalDate dtNascimento = LocalDate.of(1999, 1, 1);

    @Transient
    private Integer idade;

    private String genero = "";
    private String telefone = "";

    private String imgPerfil = "";
    private String sobreMim;
    private String medicamentos;
    private String preferencias;
    private String especialidade;


    private String endereco = ""; // Logradouro
    private String cep = "";
    private String cidade = "";
    private String uf = "";
    private String numeroResidencia = "";


    // Getters e Setters

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getLogin() { return login; }
    public void setLogin(String login) { this.login = login; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSenha() { return senha; }  
    public void setSenha(String senha) { this.senha = senha; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getSobrenome() { return sobrenome; }
    public void setSobrenome(String sobrenome) { this.sobrenome = sobrenome; }

    public LocalDate getDtNascimento() { return dtNascimento; }
    public void setDtNascimento(LocalDate dtNascimento) { this.dtNascimento = dtNascimento; }

    public Integer getIdade() {
        if (dtNascimento != null) {
            return Period.between(dtNascimento, LocalDate.now()).getYears();
        }
        return null;
    }

    public String getGenero() { return genero; }
    public void setGenero(String genero) { this.genero = genero; }

    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }

    public String getEndereco() { return endereco; }
    public void setEndereco(String endereco) { this.endereco = endereco; }

    public String getCep() { return cep; }
    public void setCep(String cep) { this.cep = cep; }

    public String getCidade() { return cidade; }
    public void setCidade(String cidade) { this.cidade = cidade; }

    public String getUf() { return uf; }
    public void setUf(String uf) { this.uf = uf; }

    public String getNumeroResidencia() { return numeroResidencia; }
    public void setNumeroResidencia(String numeroResidencia) { this.numeroResidencia = numeroResidencia; }

    public String getImgPerfil() { return imgPerfil; }
    public void setImgPerfil(String imgPerfil) { this.imgPerfil = imgPerfil; }

    public String getSobreMim() { return sobreMim; }
    public void setSobreMim(String sobreMim) { this.sobreMim = sobreMim; }

    public String getMedicamentos() { return medicamentos; }
    public void setMedicamentos(String medicamentos) { this.medicamentos = medicamentos; }

    public String getPreferencias() { return preferencias; }
    public void setPreferencias(String preferencias) { this.preferencias = preferencias; }

    public String getEspecialidade() { return  especialidade; }
    public void setEspecialidade(String especialidade) { this.especialidade = especialidade; }
}
