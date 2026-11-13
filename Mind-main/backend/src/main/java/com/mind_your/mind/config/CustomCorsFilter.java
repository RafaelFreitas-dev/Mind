package com.mind_your.mind.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.regex.Pattern;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class CustomCorsFilter extends OncePerRequestFilter {

    /** Aceita http://localhost:<porta> ou http://127.0.0.1:<porta> */
    private static final Pattern ORIGEM_LOCAL =
            Pattern.compile("^http://(localhost|127\\.0\\.0\\.1)(:\\d+)?$", Pattern.CASE_INSENSITIVE);

    @Override
    protected void doFilterInternal(@NonNull HttpServletRequest request,
                                    @NonNull HttpServletResponse response,
                                    @NonNull FilterChain filterChain)
            throws ServletException, IOException {
        
        String origin = request.getHeader("Origin");

        if (origin != null && !origin.isBlank()) {
            if (ORIGEM_LOCAL.matcher(origin).matches()) {
                response.setHeader("Access-Control-Allow-Origin", origin);
            } else {
                // Origem padrão fallback para desenvolvimento Web
                response.setHeader("Access-Control-Allow-Origin", "http://localhost:3000");
            }

            response.setHeader("Vary", "Origin");
            response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS");
            response.setHeader("Access-Control-Max-Age", "3600");
            response.setHeader("Access-Control-Allow-Headers", "Authorization, Content-Type, Accept, X-Requested-With, X-XSRF-TOKEN");
            response.setHeader("Access-Control-Expose-Headers", "Authorization, X-XSRF-TOKEN");
            response.setHeader("Access-Control-Allow-Credentials", "true");
        }

        // Requisições Preflight do CORS (OPTIONS) devem encerrar aqui com 200 OK
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        filterChain.doFilter(request, response);
    }
}