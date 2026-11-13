package com.mind_your.mind.service;

import com.mind_your.mind.dto.request.AgendaRequestDTO;
import com.mind_your.mind.dto.response.AgendaResponseDTO;
import com.mind_your.mind.models.Agenda;
import com.mind_your.mind.models.Horario;
import com.mind_your.mind.repository.AgendaRepository;
import com.mind_your.mind.repository.HorarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class AgendaService {

    @Autowired
    private AgendaRepository agendaRepository;

    @Autowired
    private HorarioRepository horarioRepository;

    @Transactional
    @SuppressWarnings("null")
    public AgendaResponseDTO agendar(AgendaRequestDTO dto) {
        if (dto.getHorarioId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "O ID do horário é obrigatório.");
        }

        Horario horario = horarioRepository.findById(dto.getHorarioId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Horário não encontrado."));

        if (Boolean.FALSE.equals(horario.getDisponivel())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "O horário selecionado não está mais disponível.");
        }

        Agenda agenda = new Agenda();
        agenda.setPacienteId(dto.getPacienteId());
        agenda.setPsicologoId(dto.getPsicologoId());
        agenda.setHorarioId(dto.getHorarioId());
        agenda.setStatus("AGENDADO");

        // Atualiza a disponibilidade do horário
        horario.setDisponivel(false);
        horarioRepository.save(horario);

        agenda = agendaRepository.save(agenda);
        return toDTO(agenda);
    }

    public List<AgendaResponseDTO> listarDoPsicologo(@NonNull String psicologoId) {
        return agendaRepository.findByPsicologoId(psicologoId).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    public List<AgendaResponseDTO> listarDoPaciente(@NonNull String pacienteId) {
        return agendaRepository.findByPacienteId(pacienteId).stream()
                .map(this::toDTO)
                .collect(Collectors.toList());
    }

    @Transactional
    @SuppressWarnings("null")
    public void cancelar(@NonNull String id) {
        Agenda agenda = agendaRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Agendamento não encontrado."));

        agenda.setStatus("CANCELADO");
        agendaRepository.save(agenda);

        if (agenda.getHorarioId() == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Horário vinculado não encontrado.");
        }

        // Libera o horário novamente
        Horario horario = horarioRepository.findById(agenda.getHorarioId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Horário vinculado não encontrado."));

        horario.setDisponivel(true);
        horarioRepository.save(horario);
    }

    private AgendaResponseDTO toDTO(Agenda agenda) {
        AgendaResponseDTO dto = new AgendaResponseDTO();
        dto.setId(agenda.getId());
        dto.setPacienteId(agenda.getPacienteId());
        dto.setPsicologoId(agenda.getPsicologoId());
        dto.setHorarioId(agenda.getHorarioId());
        dto.setStatus(agenda.getStatus());
        return dto;
    }
}