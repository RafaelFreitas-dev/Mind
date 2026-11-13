package com.mind_your.mind.controllers;

import com.mind_your.mind.dto.request.PsicologoCadastroRequestDTO;
import com.mind_your.mind.dto.request.PsicologoLoginRequestDTO;
import com.mind_your.mind.dto.request.PsicologoUpdateRequestDTO;
import com.mind_your.mind.dto.response.JwtResponseDTO;
import com.mind_your.mind.dto.response.PsicologoCadastroResponseDTO;
import com.mind_your.mind.dto.response.PsicologoResponseDTO;
import com.mind_your.mind.dto.response.PsicologoConfiguracoesResponseDTO;
import com.mind_your.mind.dto.response.PsicologoSessionResponseDTO;
import com.mind_your.mind.dto.response.UploadImagemResponseDTO;
import com.mind_your.mind.service.PsicologoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.NonNull;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/psicologos")
public class PsicologoController {

    @Autowired
    private PsicologoService psicologoService;

    // Cadastrar
    @PostMapping("/cadastrar")
    @SuppressWarnings("null")
    public ResponseEntity<PsicologoCadastroResponseDTO> cadastrar(@RequestBody @NonNull PsicologoCadastroRequestDTO dados) {
        return ResponseEntity.ok(psicologoService.cadastrar(dados));
    }

    // Listar todos
    @GetMapping
    @SuppressWarnings("null")
    public ResponseEntity<List<PsicologoResponseDTO>> listarTodos() {
        return ResponseEntity.ok(psicologoService.buscarTodos());
    }

    // Buscar por ID
    @GetMapping("/{id}")
    @SuppressWarnings("null")
    public ResponseEntity<PsicologoResponseDTO> buscarPorId(@PathVariable("id") @NonNull String id) {
        return psicologoService.buscarPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Buscar configurações completas por ID
    @GetMapping("/{id}/configuracoes")
    @SuppressWarnings("null")
    public ResponseEntity<PsicologoConfiguracoesResponseDTO> buscarConfiguracoesPorId(@PathVariable("id") @NonNull String id) {
        return psicologoService.buscarConfiguracoesPorId(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Buscar por email
    @GetMapping("/email/{email}")
    @SuppressWarnings("null")
    public ResponseEntity<PsicologoResponseDTO> buscarPorEmail(@PathVariable("email") @NonNull String email) {
        return psicologoService.buscarPorEmail(email)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Buscar por nome
    @GetMapping("/nome/{nome}")
    @SuppressWarnings("null")
    public ResponseEntity<PsicologoResponseDTO> buscarPorNome(@PathVariable("nome") @NonNull String nome) {
        return psicologoService.buscarPorNome(nome)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Buscar SESSÃO por login
    @GetMapping("/login/{login}")
    @SuppressWarnings("null")
    public ResponseEntity<PsicologoSessionResponseDTO> buscarSessaoPorLogin(@PathVariable("login") @NonNull String login) {
        return psicologoService.buscarSessaoPorLogin(login)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Atualizar
    @PutMapping("/{id}")
    @SuppressWarnings("null")
    public ResponseEntity<PsicologoResponseDTO> atualizar(
            @PathVariable("id") @NonNull String id,
            @RequestBody @NonNull PsicologoUpdateRequestDTO dados) {
        return psicologoService.atualizar(id, dados)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // Deletar
    @DeleteMapping("/{id}")
    @SuppressWarnings("null")
    public ResponseEntity<Void> deletar(@PathVariable("id") @NonNull String id) {
        return psicologoService.deletarPorId(id)
                ? ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }

    // Login com JWT
    @PostMapping("/login")
    @SuppressWarnings("null")
    public ResponseEntity<JwtResponseDTO> login(@RequestBody @NonNull PsicologoLoginRequestDTO dados) {
        return psicologoService.fazerLogin(dados.getLogin(), dados.getSenha())
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.status(401).build());
    }

    // Upload de imagem
    @PostMapping("/{id}/imagem")
    @SuppressWarnings("null")
    public ResponseEntity<UploadImagemResponseDTO> uploadImagem(
            @PathVariable("id") @NonNull String id,
            @RequestParam("imagem") @NonNull MultipartFile file) {
        return psicologoService.uploadImagem(id, file)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}