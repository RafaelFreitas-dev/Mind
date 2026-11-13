# Mind — App mobile (Flutter)

App Flutter do Mind, ligado ao backend Spring Boot (`../backend`) e ao
MongoDB (`mindDB`). As telas consomem a mesma API usada pelo site.

---

## 1. Subir o ambiente

**1. MongoDB.** O banco fica no MongoDB Atlas (online): copie
`backend/.env.example` para `backend/.env` e cole a connection string do
Atlas (passo a passo no README da raiz). O app não fala com o banco — ele
só conversa com o backend, então nada muda do lado do Flutter.

Sem o `backend/.env`, o backend usa o MongoDB local
(`mongodb://localhost:27017/mindDB`):

```bash
mongod            # ou: docker run -d -p 27017:27017 --name mind-mongo mongo:7
```

**2. Backend** (porta 8080):

```bash
cd backend
./mvnw spring-boot:run
```

Na primeira execução o `DataInitializer` popula usuários de teste. Alguns:

| Tipo      | Login      | Senha  |
|-----------|------------|--------|
| Paciente  | `gabriel`  | `2000` |
| Paciente  | `snoopy`   | `1950` |
| Psicólogo | `ana`      | `1234` |
| Psicólogo | `bruno`    | `5678` |

O campo de login aceita usuário **ou** e-mail (`gabriel@gmail.com`).

**3. App**:

```bash
cd mobile
flutter pub get
flutter run
```

---

## 2. Para onde o app aponta

`lib/core/config/api_config.dart` resolve a URL base sozinho:

| Onde roda              | URL usada               |
|------------------------|-------------------------|
| Emulador Android       | `http://10.0.2.2:8080`  |
| iOS / desktop / web    | `http://localhost:8080` |

Para celular físico ou outro servidor, passe o endereço na execução — sem
editar código:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.0.15:8080
```

No Android, o tráfego HTTP (sem TLS) é liberado apenas para endereços
locais em `android/app/src/main/res/xml/network_security_config.xml`. Ao
usar um IP de rede local, acrescente esse IP no arquivo.

---

## 3. Como a integração está organizada

```
lib/
├── core/
│   ├── config/api_config.dart        URL base da API (+ URL das imagens)
│   ├── network/api_client.dart       HTTP + JWT + refresh automático
│   ├── network/api_exception.dart    erro único, com mensagem pronta
│   ├── storage/auth_storage.dart     JWT/refresh/usuário no dispositivo
│   └── state/auth_controller.dart    sessão global (ChangeNotifier)
├── services/                         uma classe por recurso da API
│   ├── auth_service.dart
│   ├── psicologo_service.dart
│   ├── horario_service.dart
│   └── agenda_service.dart
└── models/                           *.fromJson espelhando os DTOs
```

**Autenticação.** O login chama `POST /pacientes/login` ou
`POST /psicologos/login` (o backend tem um endpoint por tipo de conta — daí
o seletor "Paciente / Psicólogo" na tela). O JWT e o refresh token ficam
salvos via `shared_preferences`, então o app reabre já logado: a `AuthGate`
(em `main.dart`) mostra um splash, restaura a sessão e decide entre
onboarding, login ou a navegação principal.

**Renovação de token.** O JWT dura 15 minutos. Quando uma chamada volta
401, o `ApiClient` chama `POST /api/auth/refresh`, troca o token (o backend
rotaciona o refresh token) e repete a requisição uma única vez. Se o
refresh também falhar, a sessão é limpa e a tela de login aparece com o
aviso de sessão expirada.

### Endpoints por tela

| Tela                 | Chamadas                                                        |
|----------------------|-----------------------------------------------------------------|
| Login                | `POST /{pacientes\|psicologos}/login`, `GET /{tipo}/login/{login}`, `GET /{tipo}/{id}/configuracoes` |
| Cadastro             | `POST /{pacientes\|psicologos}/cadastrar` e login em seguida     |
| Home                 | `GET /psicologos`, `GET /agendas/{paciente\|psicologo}/{id}`     |
| Busca                | `GET /psicologos` (filtro por texto/abordagem é local)          |
| Perfil do psicólogo  | `GET /horarios/psicologo/{id}/disponiveis`, `POST /agendas`      |
| Consultas            | `GET /agendas/.../{id}`, `PUT /agendas/{id}/cancelar`            |
| Perfil               | dados da sessão; `POST /api/auth/logout` no "Sair da conta"      |
| Fotos de perfil      | `GET /api/images/{arquivo}`                                     |

### Termos de Uso

`lib/screens/legal/terms_of_use_screen.dart` mostra os Termos de Uso
(rota `AppRoutes.terms`). O texto vem de `assets/termos_de_uso.json`, o
mesmo arquivo da página do site (`frontend/src/data/termos_de_uso.json`):
para mudar o texto, edite o JSON e copie a versão nova para os dois
lugares. No cadastro, o aceite é obrigatório, igual ao site: o link abre a
tela com o botão "Li e aceito", que já marca o checkbox. No perfil há um
item "Termos de Uso" para reler a qualquer momento.

---

## 4. Diferenças conhecidas entre app e backend

Pontos em que a API ainda não cobre o que o design previa — tratados sem
inventar dados na tela:

- **Avaliação, preço da sessão e anos de experiência** não existem em
  `PsicologoResponseDTO`. São campos opcionais no `PsychologistModel` e
  simplesmente não aparecem no card enquanto forem nulos.
- **Horários são semanais** (`diaDaSemana` + `horaInicio`), não datas.
  `HorarioModel.proximaOcorrencia()` calcula a próxima data para montar a
  agenda; consultas sem horário resolvido mostram "A confirmar".
- **Notificações** continuam com dados de exemplo — não há endpoint.
- **Recuperação de senha e videochamada** existem no site, mas sem
  endpoint próprio na API; no app avisam que estão disponíveis na web.
- **Modalidade (online/presencial)** não é persistida; o filtro da busca
  passou a usar abordagem terapêutica, que vem de `especialidades`.

## 5. Ajustes feitos no backend

- `SecurityConfig` e `CustomCorsFilter` agora aceitam qualquer porta de
  `localhost`/`127.0.0.1`. Isso só importa para rodar o app como Flutter
  Web (que sobe numa porta aleatória); Android e iOS não passam por CORS.
