package com.mind_your.mind.controllers;

import com.mind_your.mind.dto.request.AgendaRequestDTO;
import com.mind_your.mind.dto.response.AgendaResponseDTO;
import com.mind_your.mind.service.AgendaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/agendas")
public class AgendaController {

    @Autowired
    private AgendaService agendaService;

    @PostMapping
    @SuppressWarnings("null")
    public ResponseEntity<AgendaResponseDTO> agendar(@RequestBody @NonNull AgendaRequestDTO dto) {
        return ResponseEntity.ok(agendaService.agendar(dto));
    }

    @GetMapping("/psicologo/{psicologoId}")
    @SuppressWarnings("null")
    public ResponseEntity<List<AgendaResponseDTO>> listarDoPsicologo(
            @PathVariable("psicologoId") @NonNull String psicologoId) {
        return ResponseEntity.ok(agendaService.listarDoPsicologo(psicologoId));
    }

    @GetMapping("/paciente/{pacienteId}")
    @SuppressWarnings("null")
    public ResponseEntity<List<AgendaResponseDTO>> listarDoPaciente(
            @PathVariable("pacienteId") @NonNull String pacienteId) {
        return ResponseEntity.ok(agendaService.listarDoPaciente(pacienteId));
    }

    @PutMapping("/{id}/cancelar")
    @SuppressWarnings("null")
    public ResponseEntity<Void> cancelar(@PathVariable("id") @NonNull String id) {
        agendaService.cancelar(id);
        return ResponseEntity.noContent().build();
    }
}