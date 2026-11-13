package com.mind_your.mind.service;

import com.mind_your.mind.models.RefreshToken;
import com.mind_your.mind.repository.RefreshTokenRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

@Service
public class RefreshTokenService {

    @Value("${jwt.refresh.expiration.ms}")
    private Long refreshExpirationMs;

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    // Criar novo refresh token para o usuário
    public RefreshToken criar(String username) {
        // Deletar token antigo se existir
        refreshTokenRepository.deleteByUsername(username);

        RefreshToken refreshToken = new RefreshToken();
        refreshToken.setUsername(username);
        refreshToken.setToken(UUID.randomUUID().toString());
        refreshToken.setExpiryDate(Instant.now().plusMillis(refreshExpirationMs));

        return refreshTokenRepository.save(refreshToken);
    }

    // Buscar por token
    public Optional<RefreshToken> buscarPorToken(String token) {
        return refreshTokenRepository.findByToken(token);
    }

    // Verificar se expirou
    public boolean isExpirado(RefreshToken token) {
        return token.getExpiryDate().isBefore(Instant.now());
    }

    // Rotacionar token: Gera um novo e deleta o antigo
    public RefreshToken rotacionar(RefreshToken oldToken) {
        String username = oldToken.getUsername();
        refreshTokenRepository.delete(oldToken);
        return criar(username);
    }

    // Deletar por username (logout)
    public void deletarPorUsername(String username) {
        refreshTokenRepository.deleteByUsername(username);
    }
}