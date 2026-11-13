package com.mind_your.mind.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

// Imports updated to remove unused items if any are detected as purely redundant by lint
import java.util.Arrays;
import org.springframework.http.HttpMethod;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        // O site roda em portas fixas (3000/5173); o app Flutter Web em
        // desenvolvimento sobe numa porta aleatória, por isso o padrão com "*".
        // Apps Android/iOS não passam por CORS — só o Flutter Web precisa disso.
        configuration.setAllowedOriginPatterns(Arrays.asList(
                "http://localhost:*",
                "http://127.0.0.1:*"
        ));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("Authorization", "Cache-Control", "Content-Type", "Accept"));
        configuration.setAllowCredentials(true);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    @Autowired
    UserDetailsServiceImpl userDetailsService;

    @Autowired
    private AuthEntryPointJwt unauthorizedHandler;

    @Bean
    public AuthTokenFilter authenticationJwtTokenFilter() {
        return new AuthTokenFilter();
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
            .exceptionHandling(exception -> exception.authenticationEntryPoint(unauthorizedHandler))
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                // Login e cadastro públicos
                .requestMatchers("/pacientes/login", "/pacientes/cadastrar").permitAll()
                .requestMatchers("/psicologos/login", "/psicologos/cadastrar").permitAll()
                .requestMatchers("/voluntarios/login", "/voluntarios/cadastrar").permitAll()

                // Refresh token público, logout exige autenticação
                .requestMatchers("/api/auth/refresh").permitAll()

                // Imagens públicas
                .requestMatchers("/api/images/**").permitAll()

                // Listar psicólogos público
                .requestMatchers(HttpMethod.GET, "/psicologos").permitAll()

                // Swagger/OpenAPI
                .requestMatchers("/swagger-ui/**", "/swagger-ui.html", "/v3/api-docs/**", "/api-docs/**", "/swagger-resources/**", "/webjars/**").permitAll()

                // OPTIONS para CORS
                .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                
                // Agendas e Horários
                .requestMatchers(HttpMethod.POST, "/horarios/**").hasRole("PSICOLOGO")
                .requestMatchers(HttpMethod.DELETE, "/horarios/**").hasRole("PSICOLOGO")
                .requestMatchers("/horarios/**").authenticated()
                .requestMatchers("/agendas/**").authenticated()
                
                // Endereços (ViaCEP)
                .requestMatchers(HttpMethod.GET, "/enderecos/**").permitAll()
                
                .anyRequest().authenticated()
            );

        http.cors(cors -> cors.configurationSource(corsConfigurationSource()));
        http.authenticationProvider(authenticationProvider());
        http.addFilterBefore(authenticationJwtTokenFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}