package com.mind_your.mind.mapper;

import com.mind_your.mind.dto.response.EnderecoResponseDTO;
import com.mind_your.mind.models.Endereco;

public class EnderecoMapper {

    @SuppressWarnings("null")
    public static EnderecoResponseDTO toResponseDTO(Endereco endereco) {
        if (endereco == null) {
            return null;
        }

        return new EnderecoResponseDTO(
                endereco.getCep() != null ? endereco.getCep() : "",
                endereco.getLogradouro() != null ? endereco.getLogradouro() : "",
                endereco.getLocalidade() != null ? endereco.getLocalidade() : "",
                endereco.getLogradouro() != null ? endereco.getLogradouro() : "",
                endereco.getUf() != null ? endereco.getUf() : ""
        );
    }
}