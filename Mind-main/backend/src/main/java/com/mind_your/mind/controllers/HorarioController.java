package com.mind_your.mind.controllers;

import com.mind_your.mind.dto.request.HorarioRequestDTO;
import com.mind_your.mind.dto.response.HorarioResponseDTO;
import com.mind_your.mind.service.HorarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/horarios")
public class HorarioController {

    @Autowired
    private HorarioService horarioService;

    @PostMapping
    @SuppressWarnings("null")
    public ResponseEntity<HorarioResponseDTO> criar(@RequestBody @NonNull HorarioRequestDTO dto) {
        return ResponseEntity.ok(horarioService.criar(dto));
    }

    @GetMapping("/psicologo/{psicologoId}")
    @SuppressWarnings("null")
    public ResponseEntity<List<HorarioResponseDTO>> listarTodosDoPsicologo(
            @PathVariable("psicologoId") @NonNull String psicologoId) {
        return ResponseEntity.ok(horarioService.listarTodosDoPsicologo(psicologoId));
    }

    @GetMapping("/psicologo/{psicologoId}/disponiveis")
    @SuppressWarnings("null")
    public ResponseEntity<List<HorarioResponseDTO>> listarDisponiveisDoPsicologo(
            @PathVariable("psicologoId") @NonNull String psicologoId) {
        return ResponseEntity.ok(horarioService.listarDisponiveisDoPsicologo(psicologoId));
    }

    @DeleteMapping("/{id}")
    @SuppressWarnings("null")
    public ResponseEntity<Void> deletar(@PathVariable("id") @NonNull String id) {
        horarioService.deletar(id);
        return ResponseEntity.noContent().build();
    }
}