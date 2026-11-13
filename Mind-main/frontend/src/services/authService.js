const API_URL = "http://localhost:8080";

export const authService = {

    // Login — chama o endpoint correto baseado no tipo
    async login(login, senha, tipo) {
        const endpoint = tipo === "psicologo" ? "/psicologos/login" : "/pacientes/login";

        const res = await fetch(`${API_URL}${endpoint}`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ login, senha }),
        });

        if (!res.ok) {
            throw new Error("Login ou senha inválidos");
        }

        const data = await res.json();
        // data = { token, type, username, tipo, refreshToken }

        localStorage.setItem("token", data.token);
        localStorage.setItem("username", data.username);
        localStorage.setItem("tipo", data.tipo);
        localStorage.setItem("refreshToken", data.refreshToken);

        return data;
    },

    // Busca dados completos do usuário após o login
    async getUserData(username, tipo) {
        const token = this.getToken();
        const endpoint = tipo === "psicologo" ? "psicologos" : "pacientes";

        const res = await fetch(`${API_URL}/${endpoint}/login/${username}`, {
            headers: {
                "Authorization": `Bearer ${token}`,
                "Content-Type": "application/json",
            },
        });

        if (!res.ok) throw new Error("Erro ao buscar dados do usuário");

        const data = await res.json();
        return { ...data, tipo };
    },

    // Renovar JWT usando o refresh token
    async refreshJwt() {
        const refreshToken = this.getRefreshToken();

        if (!refreshToken) throw new Error("Sem refresh token");

        const res = await fetch(`${API_URL}/api/auth/refresh`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ refreshToken }),
        });

        if (!res.ok) {
            this.logout();
            throw new Error("Sessão expirada. Faça login novamente.");
        }

        const data = await res.json();
        localStorage.setItem("token", data.token);
        return data.token;
    },

    // Cadastrar paciente
    async registerPaciente(userData) {
        const res = await fetch(`${API_URL}/pacientes/cadastrar`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(userData),
        });

        if (!res.ok) throw new Error("Erro ao cadastrar paciente");
        return res.json();
    },

    // Cadastrar psicólogo
    async registerPsicologo(userData) {
        const res = await fetch(`${API_URL}/psicologos/cadastrar`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(userData),
        });

        if (!res.ok) throw new Error("Erro ao cadastrar psicólogo");
        return res.json();
    },

    // Cadastrar voluntário
    async registerVoluntario(userData) {
        const res = await fetch(`${API_URL}/voluntarios/cadastrar`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(userData),
        });

        if (!res.ok) throw new Error("Erro ao cadastrar voluntário");
        return res.json();
    },

    // Logout — invalida o refresh token no backend
    async logout() {
        const token = this.getToken();

        if (token) {
            try {
                await fetch(`${API_URL}/api/auth/logout`, {
                    method: "POST",
                    headers: { "Authorization": `Bearer ${token}` },
                });
            } catch (e) {
                // Ignorar erro de rede no logout
            }
        }

        localStorage.removeItem("token");
        localStorage.removeItem("username");
        localStorage.removeItem("tipo");
        localStorage.removeItem("refreshToken");
        localStorage.removeItem("user");
    },

    // Verificar se está autenticado
    isAuthenticated() {
        return !!this.getToken();
    },

    // Getters
    getToken() { return localStorage.getItem("token"); },
    getUsername() { return localStorage.getItem("username"); },
    getTipo() { return localStorage.getItem("tipo"); },
    getRefreshToken() { return localStorage.getItem("refreshToken"); },

    // Requisição autenticada — renova o JWT automaticamente se expirar
    async authenticatedFetch(url, options = {}) {
        const token = this.getToken();

        if (!token) throw new Error("Não autenticado");

        const makeRequest = (t) => fetch(url, {
            ...options,
            headers: {
                ...options.headers,
                "Authorization": `Bearer ${t}`,
                "Content-Type": "application/json",
            },
        });

        let res = await makeRequest(token);

        // Se receber 401, tenta renovar o JWT e repetir
        if (res.status === 401) {
            try {
                const novoToken = await this.refreshJwt();
                res = await makeRequest(novoToken);
            } catch (e) {
                this.logout();
                throw new Error("Sessão expirada. Faça login novamente.");
            }
        }

        return res;
    },
};