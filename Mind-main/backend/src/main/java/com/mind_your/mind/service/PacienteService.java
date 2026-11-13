package com.mind_your.mind.service;

import com.mind_your.mind.dto.request.PacienteCadastroRequestDTO;
import com.mind_your.mind.dto.request.PacienteUpdateRequestDTO;
import com.mind_your.mind.dto.response.JwtResponseDTO;
import com.mind_your.mind.dto.response.PacienteCadastroResponseDTO;
import com.mind_your.mind.dto.response.PacienteResponseDTO;
import com.mind_your.mind.dto.response.PacienteConfiguracoesResponseDTO;
import com.mind_your.mind.dto.response.PacienteSessionResponseDTO;
import com.mind_your.mind.dto.response.UploadImagemResponseDTO;
import com.mind_your.mind.models.Paciente;
import com.mind_your.mind.repository.PacienteRepository;
import com.mind_your.mind.mapper.PacienteMapper;
import com.mind_your.mind.security.UserDetailsImpl;
import org.springframework.security.core.Authentication;

import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.AuthenticationManager;
import com.mind_your.mind.models.RefreshToken;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import com.mind_your.mind.security.JwtUtil;

@Service
public class PacienteService {

    @Autowired
    private PacienteRepository pacienteRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private RefreshTokenService refreshTokenService;

    @Autowired
    private EnderecoService enderecoService;

    @SuppressWarnings("null")
    public PacienteCadastroResponseDTO cadastrar(@NonNull PacienteCadastroRequestDTO dados) {
        Paciente paciente = new Paciente();

        paciente.setNome(dados.getNome());
        paciente.setSobrenome(dados.getSobrenome());
        paciente.setEmail(dados.getEmail());

        paciente.setGenero(dados.getGenero());
        paciente.setTelefone(dados.getTelefone());

        if (dados.getDtNascimento() != null) {
            paciente.setDtNascimento(dados.getDtNascimento());
        }

        paciente.setNumeroResidencia(dados.getNumeroResidencia());

        if (dados.getCep() != null) {
            enderecoService.obtemEnderecoPorCep(dados.getCep()).ifPresent(dadosEndereco -> {
                paciente.setCep(dados.getCep());
                paciente.setCidade(dadosEndereco.getCidade());
                paciente.setEndereco(dadosEndereco.getLogradouro());
                paciente.setUf(dadosEndereco.getUf());
            });
        }

        if (dados.getLogin() == null || dados.getLogin().isEmpty()) {
            paciente.setLogin(dados.getEmail());
        } else {
            paciente.setLogin(dados.getLogin());
        }

        paciente.setSenha(passwordEncoder.encode(dados.getSenha()));

        Paciente salvo = pacienteRepository.save(paciente);

        return PacienteMapper.toCadastroResponseDTO(salvo);
    }

    // buscar todos
    public List<PacienteResponseDTO> buscarTodos() {
        return pacienteRepository.findAll()
                .stream()
                .map(PacienteMapper::toResponseDTO)
                .toList();
    }

    // buscar por email
    @SuppressWarnings("null")
    public Optional<PacienteResponseDTO> buscarPorEmail(@NonNull String email) {
        return pacienteRepository.findByEmail(email)
                .map(PacienteMapper::toResponseDTO);
    }

    // buscar por Id
    @SuppressWarnings("null")
    public Optional<PacienteResponseDTO> buscarPorId(@NonNull String id) {
        return pacienteRepository.findById(id)
                .map(PacienteMapper::toResponseDTO);
    }

    // buscar configuracoes por Id
    @SuppressWarnings("null")
    public Optional<PacienteConfiguracoesResponseDTO> buscarConfiguracoesPorId(@NonNull String id) {
        checarPropriedade(id);
        return pacienteRepository.findById(id)
                .map(PacienteMapper::toConfiguracoesResponseDTO);
    }

    // buscar por nome
    @SuppressWarnings("null")
    public Optional<PacienteResponseDTO> buscarPorNome(@NonNull String nome) {
        return pacienteRepository.findByNome(nome)
                .map(PacienteMapper::toResponseDTO);
    }

    // buscar por login (email ou login) - Perfil Completo
    public Optional<PacienteResponseDTO> buscarPorLogin(@NonNull String login) {
        Optional<Paciente> paciente = buscarPorLoginAuth(login);
        return paciente.map(PacienteMapper::toResponseDTO);
    }

    // buscar por login (email ou login) - Sessao
    public Optional<PacienteSessionResponseDTO> buscarSessaoPorLogin(@NonNull String login) {
        Optional<Paciente> paciente = buscarPorLoginAuth(login);
        return paciente.map(PacienteMapper::toSessionDTO);
    }

    @SuppressWarnings("null")
    private Optional<Paciente> buscarPorLoginAuth(@NonNull String login) {
        if (login.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            return pacienteRepository.findByEmail(login);
        }
        return pacienteRepository.findByLogin(login);
    }

    // atualizar
    @SuppressWarnings("null")
    public Optional<PacienteResponseDTO> atualizar(@NonNull String id, @NonNull PacienteUpdateRequestDTO dados) {
        checarPropriedade(id);
        return pacienteRepository.findById(id).map(paciente -> {
            PacienteMapper.updatePacienteFromDTO(dados, paciente, passwordEncoder);
            Paciente atualizado = pacienteRepository.save(paciente);
            return PacienteMapper.toResponseDTO(atualizado);
        });
    }

    // deletar por ID
    @SuppressWarnings("null")
    public boolean deletarPorId(@NonNull String id) {
        checarPropriedade(id);
        if (pacienteRepository.existsById(id)) {
            pacienteRepository.deleteById(id);
            return true;
        }
        return false;
    }

    // fazer login com JWT
    public Optional<JwtResponseDTO> fazerLogin(@NonNull String login, @NonNull String senha) {
        return buscarPorLoginAuth(login)
                .filter(p -> passwordEncoder.matches(senha, p.getSenha()))
                .map(p -> {
                    Authentication authentication = authenticationManager.authenticate(
                            new UsernamePasswordAuthenticationToken(p.getLogin(), senha)
                    );
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                    String token = jwtUtil.generateJwtToken(authentication);
                    RefreshToken refreshToken = refreshTokenService.criar(p.getLogin());
                    return new JwtResponseDTO(token, p.getLogin(), "paciente", refreshToken.getToken());
                });
    }

    // upload imagem de perfil
    @SuppressWarnings("null")
    public Optional<UploadImagemResponseDTO> uploadImagem(@NonNull String id, @NonNull MultipartFile file) {
        checarPropriedade(id);
        try {
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                throw new RuntimeException("Arquivo deve ser uma imagem");
            }

            if (file.getSize() > 5 * 1024 * 1024) {
                throw new RuntimeException("Imagem deve ter no máximo 5MB");
            }

            Optional<Paciente> pacienteOpt = pacienteRepository.findById(id);
            if (pacienteOpt.isEmpty()) {
                return Optional.empty();
            }

            Paciente paciente = pacienteOpt.get();

            Path uploadPath = Paths.get("uploads/users-pictures")
                    .toAbsolutePath()
                    .normalize();

            Files.createDirectories(uploadPath);

            if (paciente.getImgPerfil() != null && !paciente.getImgPerfil().isEmpty()) {
                Path oldImage = uploadPath.resolve(paciente.getImgPerfil());
                Files.deleteIfExists(oldImage);
            }

            String originalFilename = file.getOriginalFilename();
            String extension = (originalFilename != null && originalFilename.contains("."))
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".png";

            String filename = "perfil-" + paciente.getLogin() + "-"
                    + UUID.randomUUID().toString().substring(0, 8) + extension;

            Path targetLocation = uploadPath.resolve(filename);
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

            paciente.setImgPerfil(filename);
            pacienteRepository.save(paciente);

            return Optional.of(new UploadImagemResponseDTO("Imagem enviada com sucesso", filename));

        } catch (Exception e) {
            throw new RuntimeException("Erro ao fazer upload da imagem", e);
        }
    }

    private void checarPropriedade(@NonNull String id) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof UserDetailsImpl user) {
            if (!user.getId().equals(id)) {
                throw new RuntimeException("Acesso negado: Você não tem permissão para acessar ou modificar dados de outro usuário.");
            }
        }
    }
}