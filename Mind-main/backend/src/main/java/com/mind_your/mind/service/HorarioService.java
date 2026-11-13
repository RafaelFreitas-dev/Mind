package com.mind_your.mind.service;

import com.mind_your.mind.dto.request.HorarioRequestDTO;
import com.mind_your.mind.dto.response.HorarioResponseDTO;
import com.mind_your.mind.models.Horario;
import com.mind_your.mind.repository.HorarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class HorarioService {

    @Autowired
    private HorarioRepository horarioRepository;

    @SuppressWarnings("null")
    public HorarioResponseDTO criar(@NonNull HorarioRequestDTO dto) {
        // Validação: não pode sobrepor um horário existente no mesmo dia da semana
        List<Horario> horariosDoDia = horarioRepository.findByPsicologoIdAndDiaDaSemana(
                dto.getPsicologoId(), dto.getDiaDaSemana());

        for (Horario h : horariosDoDia) {
            // Comparação de strings no formato "HH:mm" — funciona corretamente em ordem lexicográfica
            boolean isSobreposto = dto.getHoraInicio().compareTo(h.getHoraFim()) < 0
                    && dto.getHoraFim().compareTo(h.getHoraInicio()) > 0;
            if (isSobreposto) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "Já existe um horário conflitante em " + dto.getDiaDaSemana()
                        + " entre " + h.getHoraInicio() + " e " + h.getHoraFim() + ".");
            }
        }

        Horario horario = new Horario();
        horario.setPsicologoId(dto.getPsicologoId());
        horario.setDiaDaSemana(dto.getDiaDaSemana());
        horario.setHoraInicio(dto.getHoraInicio());
        horario.setHoraFim(dto.getHoraFim());
        horario.setDisponivel(dto.getDisponivel() != null ? dto.getDisponivel() : true);

        horario = horarioRepository.save(horario);
        return toDTO(horario);
    }

    public List<HorarioResponseDTO> listarTodosDoPsicologo(@NonNull String psicologoId) {
        return horarioRepository.findByPsicologoId(psicologoId).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<HorarioResponseDTO> listarDisponiveisDoPsicologo(@NonNull String psicologoId) {
        return horarioRepository.findByPsicologoIdAndDisponivelTrue(psicologoId).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @SuppressWarnings("null")
    public void deletar(@NonNull String id) {
        if (!horarioRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Horário não encontrado.");
        }
        horarioRepository.deleteById(id);
    }

    private HorarioResponseDTO toDTO(Horario horario) {
        HorarioResponseDTO dto = new HorarioResponseDTO();
        dto.setId(horario.getId());
        dto.setPsicologoId(horario.getPsicologoId());
        dto.setDiaDaSemana(horario.getDiaDaSemana());
        dto.setHoraInicio(horario.getHoraInicio());
        dto.setHoraFim(horario.getHoraFim());
        dto.setDisponivel(horario.getDisponivel());
        return dto;
    }
}