package com.mind_your.mind.config;

import com.mind_your.mind.models.Paciente;
import com.mind_your.mind.models.Psicologo;
import com.mind_your.mind.repository.PacienteRepository;
import com.mind_your.mind.repository.PsicologoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.time.LocalDate;
import java.util.List;

@Configuration
public class DataInitializer {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Bean
    @SuppressWarnings("null")
    CommandLineRunner initPsicologos(PsicologoRepository repository) {
        return args -> {
            if (repository.count() == 0) {
                List<Psicologo> psicologos = List.of(
                        createPsicologo("ana", "1234", "ana@gmail.com", "Ana", "Silva", "Feminino", "1985-05-20", "(11) 98765-4321", "São Paulo", "perfil-ana.png", "123456", "Terapia Cognitivo-Comportamental"),
                        createPsicologo("bruno", "5678", "bruno@gmail.com", "Bruno", "Ferreira", "Masculino", "1990-11-10", "(21) 91234-5678", "Rio de Janeiro", "perfil-bruno.png", "654321", "Psicanálise"),
                        createPsicologo("carla1", "ab3cd", "carla1@gmail.com", "Carla", "Souza", "Feminino", "1988-03-15", "(31) 99876-5432", "Diadema", "perfil-carla.png", "112233", "Terapia Infantil"),
                        createPsicologo("carla2", "ab4cd", "carla2@gmail.com", "Carla", "Souza", "Feminino", "1988-03-15", "(19) 99876-5432", "Campinas", "perfil-carla.png", "112233", "Terapia de Casal"),
                        createPsicologo("daniel", "ef5gh", "daniel@gmail.com", "Daniel", "Oliveira", "Masculino", "1979-07-22", "(12) 98765-1234", "São José dos Campos", "perfil-daniel.png", "445566", "Neuropsicologia"),
                        createPsicologo("elisa", "ij6kl", "elisa@gmail.com", "Elisa", "Costa", "Feminino", "1992-12-05", "(16) 91234-8765", "Ribeirão Preto", "perfil-elisa.png", "778899", "Terapia Familiar"),
                        createPsicologo("felipe", "mn7op", "felipe@gmail.com", "Felipe", "Martins", "Masculino", "1983-09-30", "(13) 99876-4321", "Santos", "perfil-felipe.png", "334455", "Terapia Ocupacional"),
                        createPsicologo("gabriela", "qr8st", "gabriela@gmail.com", "Gabriela", "Ramos", "Feminino", "1995-06-18", "(15) 98765-6789", "Sorocaba", "perfil-gabriela.png", "667788", "Psicologia Clínica"),
                        createPsicologo("henrique", "uv9wx", "henrique@gmail.com", "Henrique", "Lima", "Masculino", "1987-01-12", "(17) 91234-5678", "São José do Rio Preto", "perfil-henrique.png", "990011", "Terapia Cognitiva"),
                        createPsicologo("isabela", "yz12", "isabela@gmail.com", "Isabela", "Mendes", "Feminino", "1993-04-25", "(14) 99876-5432", "Bauru", "perfil-isabela.png", "223344", "Psicologia do Desenvolvimento"),
                        createPsicologo("joao", "3456", "joao@gmail.com", "João", "Pereira", "Masculino", "1980-08-08", "(18) 98765-4321", "Presidente Prudente", "perfil-joao.png", "556677", "Psicologia Organizacional")
                );

                repository.saveAll(psicologos);
                System.out.println("Psicólogos de teste criados!");
            }
        };
    }

    @Bean
    @SuppressWarnings("null")
    CommandLineRunner init(PacienteRepository repository) {
        return args -> {
            if (repository.count() == 0) {
                List<Paciente> usuarios = List.of(
                        createPaciente("gabriel", "2000", "gabriel@gmail.com", "Gabriel", "", "Masculino", "2000-09-13", "(12) 2959-7375", "São Paulo", "perfil-snoopy.png"),
                        createPaciente("snoopy", "1950", "snoopy@gmail.com", "Snoopy", "", "Masculino", "1969-09-13", "(79) 2337-2615", "São Paulo", "perfil-snoopy.png"),
                        createPaciente("scooby", "1950", "scooby@gmail.com", "Scoobert", "Cornelius Doo", "Masculino", "1950-10-04", "(61) 3070-0787", "São Paulo", "perfil-scooby.png")
                );

                repository.saveAll(usuarios);
                System.out.println("Usuários de teste criados!");
            }
        };
    }

    private Paciente createPaciente(String login, String senha, String email, String nome, String sobrenome,
                                    String genero, String dtNascimento, String telefone, String local, String imgPerfil) {
        Paciente p = new Paciente();
        p.setLogin(login);
        p.setSenha(passwordEncoder.encode(senha));
        p.setEmail(email);
        p.setNome(nome);
        p.setSobrenome(sobrenome);
        p.setGenero(genero);
        p.setDtNascimento(LocalDate.parse(dtNascimento));
        p.setTelefone(telefone);
        p.setEndereco(local);
        p.setImgPerfil(imgPerfil);
        return p;
    }

    private Psicologo createPsicologo(String login, String senha, String email, String nome, String sobrenome,
                                      String genero, String dtNascimento, String telefone, String local, String imgPerfil, String crp, String especialidade) {
        Psicologo p = new Psicologo();
        p.setLogin(login);
        p.setSenha(passwordEncoder.encode(senha));
        p.setEmail(email);
        p.setNome(nome);
        p.setSobrenome(sobrenome);
        p.setGenero(genero);
        p.setDtNascimento(LocalDate.parse(dtNascimento));
        p.setTelefone(telefone);
        p.setEndereco(local);
        p.setImgPerfil(imgPerfil);
        p.setCrp(crp);
        p.setEspecialidades(List.of(especialidade));
        return p;
    }
}