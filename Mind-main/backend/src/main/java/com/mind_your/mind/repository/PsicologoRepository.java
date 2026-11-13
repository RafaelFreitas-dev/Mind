package com.mind_your.mind.repository;

import com.mind_your.mind.models.Psicologo;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.Optional;

public interface PsicologoRepository extends MongoRepository<Psicologo, String> {
    Optional<Psicologo> findByEmail(String email);
    Optional<Psicologo> findByNome(String nome);
    Optional<Psicologo> findByLogin(String login);
}
