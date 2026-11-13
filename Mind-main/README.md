<p align="center">
<img align="auto" width="700px" src="frontend/src/assets/img/background&logo_readme.png">
</p>
<h1 align="center"> Mind - your mind </h1>
<p align="center">Aqui nossa missão é tornar o cuidado psicológico acessível a todos, oferecendo uma plataforma intuitiva que conecta você a psicólogos qualificados, de forma simples e segura. </p>

<div align="center">
  
   [Sobre o projeto](#sobre-o-projeto) • [Tecnologias utilizadas](#tecnologias-utilizadas) • [Desenvolvedores](#desenvolvedores) 
   
</div>

## Sobre o projeto

<p>A plataforma Mind é um sistema desenvolvido como iniciativa do Projeto Integrador da <b>Fatec Diadema - Luigi Papaiz</b>, inspirado na ODS 3 da ONU (Saúde e Bem-estar), buscando não apenas oferecer suporte psicológico, mas também contribuir para a promoção da saúde e bem-estar social. Dessa forma, buscamos enfrentar problemáticas relacionadas ao preconceito em torno de consultas psicológicas, promover conhecimento sobre segurança pessoal e oferecer um sistema acessível a todos.</p>

## Tecnologias Utilizadas

<a href="https://skillicons.dev">
    <img src="https://skillicons.dev/icons?i=html,css,js,vite,spring,java" />
</a>

## Desenvolvedores


- Alice Laila -> 
  - :books: Github Institucional https://github.com/AliceLSP </li>
  - :pushpin: Github Profissional https://github.com/Alicelspires </li>
    
<ul>
  <li>Gabriel Rodrigues: https://github.com/GabrielAlves106 </li>
  <li>Gustavo Robson: https://github.com/GustavoRobs-11 </li>

  <li>Janaina Mota: https://github.com/JanainaMotaFatec </li>
  <li>Kauê Vasconcelos Bucciotti: https://github.com/KaueBucciotti </li>
  <li>Luis Gustavo:  https://github.com/LuisCarvalho05095 </li>
  <li>Nycole Ferreira: https://github.com/Nycolete</li>
  <li>Vinícius Martines: https://github.com/Vinicius-Martines-01/Mind_Entrega_1_Semestre </li>
</u>

# Mind 4º Semestre - Protótipo

Este repositório contém o código-fonte do protótipo do projeto Mind, dividido em um backend Spring Boot (Java) e um frontend React (Vite).

## Bug Encontrado e Correções Aplicadas

O problema reportado era que **usuários recém-cadastrados não conseguiam fazer login**. A análise e os testes identificaram as seguintes causas e correções:

### 1. Correção do Bug de Login (Causa Principal)

**Problema:** No momento do cadastro, o campo `login` do modelo `Paciente` não estava sendo preenchido, resultando em falha na busca do usuário pelo Spring Security durante o login.

**Correção:** Adicionada lógica no `PacienteController` para preencher o campo `login` com o `email` do usuário, garantindo que o Spring Security consiga encontrar o registro.

*   **Arquivo:** `backend/src/main/java/com/mind_your/mind/controllers/PacienteController.java`
*   **Detalhe:** Adicionada verificação e atribuição do `email` ao `login` no método `cadastrar`.

### 2. Correção de Comunicação (CORS)

**Problema:** O backend estava configurado para aceitar requisições apenas de `localhost`, o que impedia a comunicação com o frontend quando rodando em ambientes de proxy (como o sandbox ou outros ambientes de desenvolvimento).

**Correção:** Atualizado o filtro CORS para aceitar requisições de `localhost` e de qualquer subdomínio do proxy do sandbox (`*.manus.computer`).

*   **Arquivo:** `backend/src/main/java/com/mind_your/mind/config/CustomCorsFilter.java`

### 3. Correção de Inicialização do Backend

**Problema:** O servidor backend não estava iniciando corretamente devido a uma incompatibilidade entre a versão do Java configurada no projeto e a versão disponível no ambiente.

**Correção:** A versão do Java no `pom.xml` foi atualizada para `21`, garantindo a correta inicialização do servidor Spring Boot.

*   **Arquivo:** `backend/pom.xml`
*   **Detalhe:** `<java.version>21</java.version>`

### 4. Correção de Inicialização do Frontend

**Problema:** O servidor de desenvolvimento Vite (frontend) não permitia acesso via proxy.

**Correção:** Adicionada a configuração `server.allowedHosts` no `vite.config.js`.

*   **Arquivo:** `frontend/vite.config.js`

## Como Executar o Projeto

Para rodar o projeto localmente, siga os passos abaixo:

### Pré-requisitos

1.  **Java Development Kit (JDK):** Versão 21 ou superior.
2.  **Node.js:** Versão LTS (recomendado).
3.  **MongoDB:** o banco fica no **MongoDB Atlas** (online), configurado como explicado abaixo. Um MongoDB local na porta 27017 só é necessário se o Atlas não estiver configurado.

### Banco de dados: MongoDB Atlas

A connection string do Atlas (que tem usuário e senha) **não fica no código**: ela vai num arquivo `backend/.env`, que está no `.gitignore`.

1.  Copie `backend/.env.example` para `backend/.env`.
2.  No Atlas, em **Connect > Drivers**, copie a connection string e cole no `MONGODB_URI`, trocando `<db_password>` pela senha do usuário do banco (sem os `< >` e sem aspas).
3.  Em **Network Access**, libere o IP de quem vai rodar o backend (ou `0.0.0.0/0` para o grupo todo).

Cada pessoa do grupo cria o seu `backend/.env`; a connection string é passada por fora do repositório. Sem esse arquivo, o backend usa o MongoDB local (`mongodb://localhost:27017/mindDB`). Para conferir qual banco está em uso, veja o log de conexão do MongoDB ao subir o backend: endereços terminando em `mongodb.net` são o Atlas.

Na primeira vez que o backend sobe com o banco vazio, o `DataInitializer` cria os usuários de teste. O `npm run reset:db` apaga os dados do mesmo banco que o backend usa e, quando é o Atlas, pede confirmação antes.

### 1. Iniciar o Backend (Spring Boot)

1.  Navegue até o diretório `backend`.
2.  Execute o comando para iniciar o servidor:
    ```bash
    ./mvnw spring-boot:run
    ```
    O servidor estará acessível em `http://localhost:8080`.

### 2. Iniciar o Frontend (React/Vite)

1.  Navegue até o diretório `frontend`.
2.  Instale as dependências:
    ```bash
    npm install
    ```
3.  Inicie o servidor de desenvolvimento:
    ```bash
    npm run dev
    ```
    O frontend estará acessível em `http://localhost:5173`.

Após a inicialização de ambos, o fluxo de cadastro e login deve funcionar corretamente.

# Projeto Mind_3_Semestre_Proto

Este projeto é uma aplicação **Backend** desenvolvida utilizando o **Spring Boot**, um framework que simplifica a criação de aplicações Spring, com foco em microsserviços e desenvolvimento rápido.

## 1. Utilização do Spring Framework

O projeto faz uso de diversos módulos e funcionalidades do ecossistema Spring para construir uma API RESTful robusta e segura.

### 1.1. Módulos do Spring Boot

| Módulo | Descrição | Uso no Projeto |
| :--- | :--- | :--- |
| **Spring Boot Starter Web** | Facilita a criação de aplicações web, incluindo APIs RESTful, com o Tomcat embutido. | Utilizado para definir os `Controllers` (`PacienteController`, `PsicologoController`, `ProdutoController`) que expõem os endpoints da API. |
| **Spring Data MongoDB** | Simplifica a interação com o banco de dados NoSQL MongoDB. | Utilizado para definir as interfaces `Repository` (`PacienteRepository`, `PsicologoRepository`, `ProdutoRepository`) que gerenciam as operações de CRUD (Create, Read, Update, Delete) com o banco. |
| **Spring Boot Starter Security** | Fornece autenticação e autorização robustas para a aplicação. | Utilizado para configurar a segurança da aplicação, incluindo a autenticação baseada em JWT (JSON Web Tokens) e a criptografia de senhas (`PasswordEncoder`). |
| **Spring Boot Starter Thymeleaf** | Motor de template para aplicações web. | Embora presente nas dependências, seu uso principal em uma API RESTful é geralmente limitado a páginas de erro ou documentação simples, mas é um componente padrão para aplicações web completas. |
| **Springdoc OpenAPI UI** | Geração automática de documentação da API no formato OpenAPI (Swagger UI). | Facilita a visualização e teste dos endpoints da API. |

### 1.2. Componentes Principais do Spring

O projeto segue a arquitetura padrão do Spring para aplicações web:

*   **`@SpringBootApplication`**: Presente na classe `MindApplication`, é a anotação principal que combina `@Configuration`, `@EnableAutoConfiguration` e `@ComponentScan`, iniciando a aplicação e configurando automaticamente o Spring Boot.
*   **`@RestController`**: Presente nos `Controllers` (ex: `PacienteController`), indica que a classe é um *Controller* e que todos os métodos retornam dados diretamente (JSON/XML), sendo ideal para APIs RESTful.
*   **`@RequestMapping`, `@GetMapping`, `@PostMapping`, `@PutMapping`, `@DeleteMapping`**: Anotações de roteamento que mapeiam requisições HTTP para métodos específicos nos *Controllers*.
*   **`@Autowired`**: Utilizado para injeção de dependência, como visto na injeção do `PasswordEncoder` no `PacienteController`.
*   **`@Document`**: Presente nos modelos (ex: `Paciente`), indica que a classe é um documento a ser persistido no MongoDB.
*   **`MongoRepository`**: Interfaces (ex: `PacienteRepository`) que estendem esta classe, fornecendo automaticamente métodos de CRUD sem a necessidade de implementação manual (convenção do Spring Data).

## 2. Design Patterns Aplicados

O Spring Framework é fortemente baseado em design patterns, e este projeto demonstra a aplicação de vários padrões essenciais:

### 2.1. Padrões Fundamentais do Spring

| Padrão | Descrição | Aplicação no Projeto |
| :--- | :--- | :--- |
| **Inversion of Control (IoC)** | Princípio onde o controle de fluxo e a criação de objetos são transferidos para um contêiner (o Contêiner IoC do Spring). | O Spring gerencia o ciclo de vida de todos os componentes anotados (`@RestController`, `@Document`, etc.), injetando-os onde são necessários. |
| **Dependency Injection (DI)** | Uma forma de IoC onde as dependências de um objeto são fornecidas externamente, em vez de serem criadas pelo próprio objeto. | Visto claramente na injeção do `PacienteRepository` no construtor do `PacienteController` e do `PasswordEncoder` via `@Autowired`. |
| **Singleton** | Garante que uma classe tenha apenas uma instância e fornece um ponto de acesso global a ela. | Por padrão, todos os *Beans* (componentes) gerenciados pelo Spring são *Singletons*. Por exemplo, haverá apenas uma instância do `PacienteController` e do `PacienteRepository` em toda a aplicação. |

### 2.2. Padrões de Arquitetura

| Padrão | Descrição | Aplicação no Projeto |
| :--- | :--- | :--- |
| **MVC (Model-View-Controller)** | Separa a aplicação em três partes interconectadas: a lógica de dados (Model), a interface do usuário (View) e a lógica de controle (Controller). | O projeto implementa a camada **Model** (`Paciente`, `Psicologo`, `Produto`) e a camada **Controller** (`PacienteController`, etc.). A camada **View** é omitida, pois o projeto é uma API RESTful que retorna dados (JSON) em vez de páginas HTML. |
| **Camadas (Layered Architecture)** | Organiza o código em camadas horizontais (Apresentação, Lógica de Negócio, Persistência) com responsabilidades bem definidas. | O projeto segue claramente esta arquitetura: **Controller** (Apresentação/API), **Repository** (Persistência) e, implicitamente, a lógica de negócio dentro dos *Controllers* (como a criptografia de senha e validação de login). |

### 2.3. Padrões de Criação (Creational Patterns)

| Padrão | Descrição | Aplicação no Projeto |
| :--- | :--- | :--- |
| **Factory Method / Abstract Factory** | Define uma interface para criar um objeto, mas permite que as subclasses decidam qual classe instanciar. | O Spring Data (ex: `MongoRepository`) atua como uma **Factory** que cria implementações concretas dos *Repositories* em tempo de execução, sem que o desenvolvedor precise escrever o código de fábrica. |
| **Template Method** | Define o esqueleto de um algoritmo em uma operação, delegando alguns passos para subclasses. | O Spring Data utiliza o **Template Method** em suas classes de template (como `MongoTemplate` internamente) para definir o fluxo de operações de banco de dados, permitindo que o desenvolvedor personalize apenas os passos necessários (como a criação de métodos de consulta personalizados). |

### 2.4. Padrões Estruturais (Structural Patterns)

| Padrão | Descrição | Aplicação no Projeto |
| :--- | :--- | :--- |
| **Adapter** | Converte a interface de uma classe em outra interface que os clientes esperam. | O Spring Security usa o padrão **Adapter** para integrar diferentes mecanismos de autenticação (como JWT) ao fluxo de segurança principal do Spring. O `AuthTokenFilter` atua como um adaptador para processar o token JWT. |
| **Proxy** | Fornece um substituto ou um espaço reservado para outro objeto para controlar o acesso a ele. | O Spring Data usa o padrão **Proxy** para criar implementações de `Repository` em tempo de execução. O objeto que você injeta (`PacienteRepository`) é, na verdade, um *Proxy* que adiciona a lógica de transação e persistência. |
| **Decorator** | Anexa responsabilidades adicionais a um objeto dinamicamente. | O Spring usa o **Decorator** em muitos lugares, como em *wrappers* de *DataSource* para adicionar recursos como *pooling* de conexões ou em objetos de segurança para adicionar informações de autenticação. |

### 2.5. Padrões Comportamentais (Behavioral Patterns)

| Padrão | Descrição | Aplicação no Projeto |
| :--- | :--- | :--- |
| **Strategy** | Define uma família de algoritmos, encapsula cada um e os torna intercambiáveis. | O `PasswordEncoder` é um exemplo de **Strategy**. Ele define a interface para criptografia de senhas, e o Spring permite que diferentes implementações (como BCrypt, Argon2, etc.) sejam injetadas e usadas de forma intercambiável. |
| **Observer** | Define uma dependência um-para-muitos entre objetos, de modo que quando um objeto muda de estado, todos os seus dependentes são notificados e atualizados automaticamente. | O Spring usa o padrão **Observer** em seu sistema de eventos. Por exemplo, o `DataInitializer` pode ser considerado um *Observer* que reage ao evento de inicialização da aplicação para popular o banco de dados. |
| **Chain of Responsibility** | Evita acoplar o remetente de uma solicitação ao seu receptor, dando a mais de um objeto a chance de lidar com a solicitação. | O Spring Security utiliza este padrão com seus filtros (`AuthTokenFilter` é um deles). Uma requisição HTTP passa por uma **Chain of Responsibility** de filtros de segurança antes de chegar ao *Controller*. |

## 3. Configuração e Execução

O projeto é construído com **Maven**.



