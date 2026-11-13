package com.mind_your.mind.dto.response;

import org.springframework.lang.NonNull;

public class EnderecoResponseDTO {
    private String cep;
    private String logradouro;
    private String cidade;
    private String rua;
    private String uf;

    // Construtor padrão necessário para frameworks de serialização/deserialização
    public EnderecoResponseDTO() {
    }

    public EnderecoResponseDTO(@NonNull String cep, @NonNull String logradouro, 
                               @NonNull String cidade, @NonNull String rua, 
                               @NonNull String uf) {
        this.cep = cep;
        this.logradouro = logradouro;
        this.cidade = cidade;
        this.rua = rua;
        this.uf = uf;
    }

    public String getCep() { return cep; }

    public void setCep(@NonNull String cep) { this.cep = cep; }

    public String getLogradouro() { return logradouro; }

    public void setLogradouro(@NonNull String logradouro) { this.logradouro = logradouro; }

    public String getCidade() { return cidade; }

    public void setCidade(@NonNull String cidade) { this.cidade = cidade; }

    public String getRua() { return rua; }

    public void setRua(@NonNull String rua) { this.rua = rua; }

    public String getUf() { return uf; }

    public void setUf(@NonNull String uf) { this.uf = uf; }
}