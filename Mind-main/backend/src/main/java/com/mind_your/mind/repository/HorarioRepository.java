package com.mind_your.mind.repository;

import com.mind_your.mind.models.Horario;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HorarioRepository extends MongoRepository<Horario, String> {
    List<Horario> findByPsicologoId(String psicologoId);
    List<Horario> findByPsicologoIdAndDiaDaSemana(String psicologoId, String diaDaSemana);
    List<Horario> findByPsicologoIdAndDisponivelTrue(String psicologoId);
}
