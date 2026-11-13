

const API_URL = 'http://localhost:8080';

async function test() {
    try {
        console.log("1. Cadastrando psicólogo...");
        const email = `test_${Date.now()}@test.com`;
        const regRes = await fetch(`${API_URL}/psicologos/cadastrar`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                nome: "Test",
                sobrenome: "Psi",
                email: email,
                login: email,
                senha: "password123",
                crp: "12345/SP",
                telefone: "11999999999",
                endereco: "Rua Test",
                sobreMim: "Test",
                genero: "Masculino"
            })
        });
        const regData = await regRes.json();
        const psicologoId = regData.id;
        console.log("Psicólogo cadastrado com ID:", psicologoId);

        console.log("2. Fazendo login...");
        const loginRes = await fetch(`${API_URL}/psicologos/login`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ login: email, senha: "password123" })
        });
        const loginData = await loginRes.json();
        const token = loginData.token;
        console.log("Login feito, token obtido.");

        console.log("3. Criando horário...");
        const postRes = await fetch(`${API_URL}/horarios`, {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            body: JSON.stringify({
                psicologoId: psicologoId,
                diaDaSemana: "Segunda",
                horaInicio: "08:00",
                horaFim: "08:40",
                disponivel: true
            })
        });
        if (!postRes.ok) throw new Error("Falha ao criar horário: " + postRes.status);
        console.log("Horário criado com sucesso.");

        console.log("3.5 Buscando dados do psicólogo (GET /psicologos/{id})...");
        const getPsiRes = await fetch(`${API_URL}/psicologos/${psicologoId}`, {
            method: 'GET',
            headers: { 
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            }
        });
        if (!getPsiRes.ok) {
           console.error("Falha ao buscar dados do Psicólogo! Status:", getPsiRes.status);
        } else {
           console.log("Busca de dados do psicólogo funcionou! Token OK para GETs.");
        }

        console.log("4. Buscando horários...");
        const getRes = await fetch(`${API_URL}/horarios/psicologo/${psicologoId}`, {
            method: 'GET',
            headers: { 
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            }
        });
        
        if (!getRes.ok) {
            console.error("Falha ao buscar horários! Status:", getRes.status);
            const errorText = await getRes.text();
            console.error("Response:", errorText);
            return;
        }

        const getData = await getRes.json();
        console.log("Horários encontrados:", getData);

    } catch (err) {
        console.error("Erro no teste:", err);
    }
}

test();
