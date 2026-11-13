package com.mind_your.mind.mapper;

import com.mind_your.mind.dto.request.PsicologoUpdateRequestDTO;
import com.mind_your.mind.dto.response.PsicologoCadastroResponseDTO;
import com.mind_your.mind.dto.response.PsicologoSessionResponseDTO;
import com.mind_your.mind.dto.response.PsicologoConfiguracoesResponseDTO;
import com.mind_your.mind.dto.response.PsicologoResponseDTO;
import com.mind_your.mind.models.Psicologo;
import org.springframework.security.crypto.password.PasswordEncoder;


public class PsicologoMapper {

    public static PsicologoResponseDTO toResponseDTO(Psicologo p) {
        String local = "";
        if (p.getCidade() != null && !p.getCidade().trim().isEmpty() &&
            p.getUf() != null && !p.getUf().trim().isEmpty()) {
            local = p.getCidade().trim() + " - " + p.getUf().trim().toUpperCase();
        }

        return new PsicologoResponseDTO(
                p.getId(),
                p.getNome(),
                p.getSobrenome(),
                p.getIdade(),
                local,
                p.getImgPerfil(),
                p.getCrp(),
                p.getEspecialidades(),
                p.getTelefone(),
                p.getSobreMim()
        );
    }

    public static PsicologoCadastroResponseDTO toCadastroResponseDTO(Psicologo p) {
        return new PsicologoCadastroResponseDTO(
                p.getId(),
                p.getNome(),
                p.getEmail(),
                p.getLogin(),
                p.getCrp(),
                p.getEspecialidades()
        );
    }

    public static PsicologoSessionResponseDTO toSessionDTO(Psicologo p) {
        return new PsicologoSessionResponseDTO(
                p.getId(),
                p.getNome(),
                p.getSobrenome(),
                p.getImgPerfil()
        );
    }

    public static PsicologoConfiguracoesResponseDTO toConfiguracoesResponseDTO(Psicologo p) {
        PsicologoConfiguracoesResponseDTO dto = new PsicologoConfiguracoesResponseDTO();
        dto.setId(p.getId());
        dto.setNome(p.getNome());
        dto.setSobrenome(p.getSobrenome());
        dto.setDtNascimento(p.getDtNascimento());
        dto.setTelefone(p.getTelefone());
        dto.setGenero(p.getGenero());
        dto.setLogin(p.getLogin());
        dto.setEmail(p.getEmail());
        dto.setCep(p.getCep());
        dto.setNumeroResidencia(p.getNumeroResidencia());
        dto.setCidade(p.getCidade());
        dto.setUf(p.getUf());
        dto.setEndereco(p.getEndereco()); // Rua
        dto.setSobreMim(p.getSobreMim());
        dto.setMedicamentos(p.getMedicamentos());
        dto.setPreferencias(p.getPreferencias());
        dto.setImgPerfil(p.getImgPerfil());
        dto.setCrp(p.getCrp());
        dto.setEspecialidades(p.getEspecialidades());
        return dto;
    }

    public static void updatePsicologoFromDTO(PsicologoUpdateRequestDTO dto, Psicologo psicologo, PasswordEncoder encoder) {
        if (dto.getNome() != null) psicologo.setNome(dto.getNome());
        if (dto.getSobrenome() != null) psicologo.setSobrenome(dto.getSobrenome());
        if (dto.getLogin() != null) psicologo.setLogin(dto.getLogin());
        if (dto.getEmail() != null) psicologo.setEmail(dto.getEmail());
        if (dto.getSenha() != null && !dto.getSenha().trim().isEmpty()) psicologo.setSenha(encoder.encode(dto.getSenha()));
        if (dto.getDtNascimento() != null) psicologo.setDtNascimento(dto.getDtNascimento());
        if (dto.getGenero() != null) psicologo.setGenero(dto.getGenero());
        if (dto.getTelefone() != null) psicologo.setTelefone(dto.getTelefone());
        if (dto.getImgPerfil() != null) psicologo.setImgPerfil(dto.getImgPerfil());
        if (dto.getSobreMim() != null) psicologo.setSobreMim(dto.getSobreMim());
        if (dto.getMedicamentos() != null) psicologo.setMedicamentos(dto.getMedicamentos());
        if (dto.getPreferencias() != null) psicologo.setPreferencias(dto.getPreferencias());
        if (dto.getCrp() != null) psicologo.setCrp(dto.getCrp());
        if (dto.getEspecialidades() != null) psicologo.setEspecialidades(dto.getEspecialidades());
        
        // Granular address
        if (dto.getCep() != null) psicologo.setCep(dto.getCep());
        if (dto.getNumeroResidencia() != null) psicologo.setNumeroResidencia(dto.getNumeroResidencia());
        if (dto.getCidade() != null) psicologo.setCidade(dto.getCidade());
        if (dto.getUf() != null) psicologo.setUf(dto.getUf());
        if (dto.getEndereco() != null) psicologo.setEndereco(dto.getEndereco()); // Rua
    }
}