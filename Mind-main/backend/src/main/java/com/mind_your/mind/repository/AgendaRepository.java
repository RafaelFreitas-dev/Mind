package com.mind_your.mind.repository;

import com.mind_your.mind.models.Agenda;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AgendaRepository extends MongoRepository<Agenda, String> {
    List<Agenda> findByPsicologoId(String psicologoId);
    List<Agenda> findByPacienteId(String pacienteId);
    List<Agenda> findByHorarioId(String horarioId);
}
