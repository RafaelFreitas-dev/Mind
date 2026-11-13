package com.mind_your.mind.service;

import java.util.Optional;

import com.mind_your.mind.dto.response.EnderecoResponseDTO;
import com.mind_your.mind.models.Endereco;

/**
 * Interface para obter o endereco da api ViaCEP
 * 
 * @param cep
 * @return o json da api ViaCEP
 */
public interface IEnderecoService {
    public Optional<Endereco> obtemLogradouroPorCep(String cep);
    public Optional<EnderecoResponseDTO> obtemEnderecoPorCep(String cep);

}