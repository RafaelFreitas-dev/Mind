package com.mind_your.mind.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.mind_your.mind.dto.request.PacienteCadastroRequestDTO;
import com.mind_your.mind.dto.request.PacienteLoginRequestDTO;
import com.mind_your.mind.dto.request.PacienteUpdateRequestDTO;
import com.mind_your.mind.dto.response.JwtResponseDTO;
import com.mind_your.mind.dto.response.PacienteCadastroResponseDTO;
import com.mind_your.mind.dto.response.PacienteResponseDTO;
import com.mind_your.mind.dto.response.PacienteSessionResponseDTO;
import com.mind_your.mind.dto.response.PacienteConfiguracoesResponseDTO;
import com.mind_your.mind.dto.response.UploadImagemResponseDTO;
import com.mind_your.mind.service.PacienteService;

@RestController
@RequestMapping("/pacientes")
public class PacienteController {

    @Autowired
    private PacienteService pacienteService;

    // Cadastrar
    @PostMapping("/cadastrar")
    @SuppressWarnings("null")
    public ResponseEntity<PacienteCadastroResponseDTO> cadastrar(
            @RequestBody @NonNull PacienteCadastroRequestDTO dados) {

        return ResponseEntity.ok(pacienteService.cadastrar(dados));
    }

    // buscar todos
    @GetMapping
    @SuppressWarnings("null")
    public ResponseEntity<List<PacienteResponseDTO>> listarTodos() {
        return ResponseEntity.ok(pacienteService.buscarTodos());
    }

    // Buscar por email
    @GetMapping("/email/{email}")
    @SuppressWarnings("null")
    public ResponseEntity<PacienteResponseDTO> buscarUsuarioPorEmail(@PathVariable("email") @NonNull String email) {
        return pacienteService.buscarPorEmail(email)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Buscar por nome
    @GetMapping("/nome/{nome}")
    @SuppressWarnings("null")
    public ResponseEntity<PacienteResponseDTO> buscarPorNome(@PathVariable("nome") @NonNull String nome) {
        return pacienteService.buscarPorNome(nome)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Buscar SESSÃO por login (email ou nome de usuário) - Retorna apenas dados essenciais de login
    @GetMapping("/login/{login}")
    @SuppressWarnings("null")
    public ResponseEntity<PacienteSessionResponseDTO> buscarSessaoPorLogin(@PathVariable("login") @NonNull String login) {
        return pacienteService.buscarSessaoPorLogin(login)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Buscar por ID
    @GetMapping("/{id}")
    @SuppressWarnings("null")
    public ResponseEntity<PacienteResponseDTO> buscarPorId(@PathVariable("id") @NonNull String id) {
        return pacienteService.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Buscar configurações por ID
    @GetMapping("/{id}/configuracoes")
    @SuppressWarnings("null")
    public ResponseEntity<PacienteConfiguracoesResponseDTO> buscarConfiguracoes(@PathVariable("id") @NonNull String id) {
        return pacienteService.buscarConfiguracoesPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Atualizar
    @PutMapping("/{id}")
    @SuppressWarnings("null")
    public ResponseEntity<PacienteResponseDTO> atualizar(
            @PathVariable("id") @NonNull String id,
            @RequestBody @NonNull PacienteUpdateRequestDTO dados) {

        return pacienteService.atualizar(id, dados)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Deletar por ID
    @DeleteMapping("/{id}")
    @SuppressWarnings("null")
    public ResponseEntity<Void> deletar(@PathVariable("id") @NonNull String id) {
        return pacienteService.deletarPorId(id)
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }

    @PostMapping("/login")
    @SuppressWarnings("null")
    public ResponseEntity<JwtResponseDTO> login(@RequestBody @NonNull PacienteLoginRequestDTO dados) {
        return pacienteService.fazerLogin(dados.getLogin(), dados.getSenha())
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(401).build());
    }

    @PostMapping("/{id}/imagem")
    @SuppressWarnings("null")
    public ResponseEntity<UploadImagemResponseDTO> uploadImagem(
            @PathVariable("id") @NonNull String id,
            @RequestParam("imagem") @NonNull MultipartFile file) {

        return pacienteService.uploadImagem(id, file)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}