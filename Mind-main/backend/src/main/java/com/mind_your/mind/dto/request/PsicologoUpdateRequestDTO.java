package com.mind_your.mind.dto.request;

import java.time.LocalDate;
import java.util.List;

public class PsicologoUpdateRequestDTO {

    private String nome;
    private String sobrenome;
    private String login;
    private String email;
    private String senha;
    private LocalDate dtNascimento;
    private String genero;
    private String telefone;
    private String cep;
    private String numeroResidencia;
    private String cidade;
    private String uf;
    private String endereco;
    private String imgPerfil;
    private String sobreMim;
    private String medicamentos;
    private String preferencias;
    private String crp;
    private List<String> especialidades;

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getSobrenome() { return sobrenome; }
    public void setSobrenome(String sobrenome) { this.sobrenome = sobrenome; }

    public String getLogin() { return login; }
    public void setLogin(String login) { this.login = login; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }

    public LocalDate getDtNascimento() { return dtNascimento; }
    public void setDtNascimento(LocalDate dtNascimento) { this.dtNascimento = dtNascimento; }

    public String getGenero() { return genero; }
    public void setGenero(String genero) { this.genero = genero; }

    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }

    public String getCep() { return cep; }
    public void setCep(String cep) { this.cep = cep; }

    public String getNumeroResidencia() { return numeroResidencia; }
    public void setNumeroResidencia(String numeroResidencia) { this.numeroResidencia = numeroResidencia; }

    public String getCidade() { return cidade; }
    public void setCidade(String cidade) { this.cidade = cidade; }

    public String getUf() { return uf; }
    public void setUf(String uf) { this.uf = uf; }

    public String getEndereco() { return endereco; }
    public void setEndereco(String endereco) { this.endereco = endereco; }

    public String getImgPerfil() { return imgPerfil; }
    public void setImgPerfil(String imgPerfil) { this.imgPerfil = imgPerfil; }

    public String getSobreMim() { return sobreMim; }
    public void setSobreMim(String sobreMim) { this.sobreMim = sobreMim; }

    public String getMedicamentos() { return medicamentos; }
    public void setMedicamentos(String medicamentos) { this.medicamentos = medicamentos; }

    public String getPreferencias() { return preferencias; }
    public void setPreferencias(String preferencias) { this.preferencias = preferencias; }

    public String getCrp() { return crp; }
    public void setCrp(String crp) { this.crp = crp; }

    public List<String> getEspecialidades() { return especialidades; }
    public void setEspecialidades(List<String> especialidades) { this.especialidades = especialidades; }
}