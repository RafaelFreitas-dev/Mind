package com.mind_your.mind.controllers;

import com.mind_your.mind.dto.request.RefreshTokenRequestDTO;
import com.mind_your.mind.dto.response.JwtResponseDTO;
import com.mind_your.mind.models.RefreshToken;
import com.mind_your.mind.security.JwtUtil;
import com.mind_your.mind.service.RefreshTokenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private RefreshTokenService refreshTokenService;

    // Renovar JWT usando refresh token
    @PostMapping("/refresh")
    public ResponseEntity<?> refreshToken(@RequestBody RefreshTokenRequestDTO request) {
        Optional<RefreshToken> refreshTokenOpt = refreshTokenService.buscarPorToken(request.getRefreshToken());

        if (refreshTokenOpt.isEmpty()) {
            return ResponseEntity.status(401).body("Refresh token inválido");
        }

        RefreshToken refreshToken = refreshTokenOpt.get();

        if (refreshTokenService.isExpirado(refreshToken)) {
            refreshTokenService.deletarPorUsername(refreshToken.getUsername());
            return ResponseEntity.status(401).body("Refresh token expirado. Faça login novamente.");
        }

        // Rotacionar o refresh token
        RefreshToken novoRefreshToken = refreshTokenService.rotacionar(refreshToken);

        // Gerar novo JWT
        String novoJwt = jwtUtil.generateJwtTokenFromUsername(novoRefreshToken.getUsername());

        return ResponseEntity.ok(new JwtResponseDTO(novoJwt, novoRefreshToken.getUsername(), null, novoRefreshToken.getToken()));
    }

    // Logout — invalida o refresh token
    @PostMapping("/logout")
    public ResponseEntity<?> logout(@AuthenticationPrincipal UserDetails userDetails) {
        refreshTokenService.deletarPorUsername(userDetails.getUsername());
        return ResponseEntity.ok("Logout realizado com sucesso");
    }
}