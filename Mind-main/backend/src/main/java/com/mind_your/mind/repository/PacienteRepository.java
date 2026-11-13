package com.mind_your.mind.repository;


import com.mind_your.mind.models.Paciente;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.Optional;

public interface PacienteRepository extends MongoRepository<Paciente, String> {
    Optional<Paciente> findByEmail(String email);
    Optional<Paciente> findByNome(String nome);
    Optional<Paciente> findByLogin(String login);
}