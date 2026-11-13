package com.mind_your.mind.mapper;

import com.mind_your.mind.dto.request.PacienteUpdateRequestDTO;
import com.mind_your.mind.dto.response.PacienteCadastroResponseDTO;
import com.mind_your.mind.dto.response.PacienteResponseDTO;
import com.mind_your.mind.dto.response.PacienteSessionResponseDTO;
import com.mind_your.mind.models.Paciente;
import org.springframework.security.crypto.password.PasswordEncoder;

public class PacienteMapper {

    public static PacienteResponseDTO toResponseDTO(Paciente p) {
        Integer idadeCalculada = null;
        if (p.getDtNascimento() != null) {
            idadeCalculada = java.time.Period.between(p.getDtNascimento(), java.time.LocalDate.now()).getYears();
        }

        String localFormatado = null;
        if (p.getCidade() != null && !p.getCidade().isEmpty() && p.getUf() != null && !p.getUf().isEmpty()) {
            localFormatado = p.getCidade() + " - " + p.getUf();
        } else if (p.getCidade() != null && !p.getCidade().isEmpty()) {
            localFormatado = p.getCidade();
        } else if (p.getUf() != null && !p.getUf().isEmpty()) {
            localFormatado = p.getUf();
        }

        return new PacienteResponseDTO(
                p.getId(),
                p.getNome(),
                p.getSobrenome(),
                p.getImgPerfil(),
                p.getTelefone(),
                p.getSobreMim(),
                p.getMedicamentos(),
                p.getPreferencias(),
                idadeCalculada,
                localFormatado
        );
    }

    public static PacienteSessionResponseDTO toSessionDTO(Paciente p) {
        return new PacienteSessionResponseDTO(
                p.getId(),
                p.getNome(),
                p.getSobrenome(),
                p.getImgPerfil()
        );
    }

    public static com.mind_your.mind.dto.response.PacienteConfiguracoesResponseDTO toConfiguracoesResponseDTO(Paciente p) {
        return new com.mind_your.mind.dto.response.PacienteConfiguracoesResponseDTO(
                p.getId(),
                p.getNome(),
                p.getSobrenome(),
                p.getEmail(),
                p.getLogin(),
                p.getImgPerfil(),
                p.getDtNascimento(),
                p.getGenero(),
                p.getTelefone(),
                p.getEndereco(),
                p.getCep(),
                p.getNumeroResidencia(),
                p.getCidade(),
                p.getUf(),
                p.getSobreMim(),
                p.getMedicamentos(),
                p.getPreferencias()
        );
    }

    public static void updatePacienteFromDTO(PacienteUpdateRequestDTO dto, Paciente paciente, PasswordEncoder encoder) {
        if (dto.getNome() != null)
            paciente.setNome(dto.getNome());
        if (dto.getSobrenome() != null)
            paciente.setSobrenome(dto.getSobrenome());
        if (dto.getLogin() != null)
            paciente.setLogin(dto.getLogin());
        if (dto.getEmail() != null)
            paciente.setEmail(dto.getEmail());
        if (dto.getSenha() != null)
            paciente.setSenha(encoder.encode(dto.getSenha()));
        if (dto.getDtNascimento() != null)
            paciente.setDtNascimento(dto.getDtNascimento());
        if (dto.getGenero() != null)
            paciente.setGenero(dto.getGenero());
        if (dto.getTelefone() != null)
            paciente.setTelefone(dto.getTelefone());
        if (dto.getImgPerfil() != null)
            paciente.setImgPerfil(dto.getImgPerfil());
        if (dto.getSobreMim() != null)
            paciente.setSobreMim(dto.getSobreMim());
        if (dto.getMedicamentos() != null)
            paciente.setMedicamentos(dto.getMedicamentos());
        if (dto.getPreferencias() != null)
            paciente.setPreferencias(dto.getPreferencias());

        // Dados do Endereço
        if (dto.getCep() != null) {
            paciente.setCep(dto.getCep());
        }
        if (dto.getNumeroResidencia() != null) {
            paciente.setNumeroResidencia(dto.getNumeroResidencia());
        }
        if (dto.getCidade() != null) {
            paciente.setCidade(dto.getCidade());
        }
        if (dto.getUf() != null) {
            paciente.setUf(dto.getUf());
        }
        if (dto.getRua() != null) {
            paciente.setEndereco(dto.getRua());
        }

    }

    public static PacienteCadastroResponseDTO toCadastroResponseDTO(Paciente paciente) {
        return new PacienteCadastroResponseDTO(
                paciente.getId(),
                paciente.getNome(),
                paciente.getEmail(),
                paciente.getLogin());
    }
}