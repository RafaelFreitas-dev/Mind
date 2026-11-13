import { authService } from './authService';

const API_URL = "http://localhost:8080/psicologos";

// Login
export async function loginPsicologo(login, senha) {
    const res = await fetch(`${API_URL}/login`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ login, senha }),
    });

    if (!res.ok) {
        throw new Error("Login ou senha inválidos");
    }

    return res.json();
}

// Cadastrar
export async function registerPsicologo(userData) {
    const res = await fetch(`${API_URL}/cadastrar`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(userData),
    });

    if (!res.ok) {
        throw new Error("Erro ao cadastrar");
    }

    return res.json();
}

// Listar todos os psicólogos (SEM autenticação - endpoint público)
export async function listarTodos() {
    const res = await fetch(`${API_URL}`);

    if (!res.ok) {
        throw new Error("Erro ao listar psicólogos");
    }

    return res.json();
}

// Buscar por email (com autenticação)
export async function buscarPorEmail(email) {
    const res = await authService.authenticatedFetch(`${API_URL}/email/${email}`);

    if (!res.ok) {
        throw new Error("Psicólogo não encontrado");
    }

    return res.json();
}

// Buscar por nome (com autenticação)
export async function buscarPorNome(nome) {
    const res = await authService.authenticatedFetch(`${API_URL}/nome/${nome}`);

    if (!res.ok) {
        throw new Error("Psicólogo não encontrado");
    }

    return res.json();
}

// Buscar por login (com autenticação)
export async function buscarPorLogin(login) {
    const res = await authService.authenticatedFetch(`${API_URL}/login/${login}`);

    if (!res.ok) {
        throw new Error("Psicólogo não encontrado");
    }

    return res.json();
}

// Buscar por ID (com autenticação)
export async function buscarPorId(id) {
    const res = await authService.authenticatedFetch(`${API_URL}/${id}`);

    if (!res.ok) {
        throw new Error("Psicólogo não encontrado");
    }

    return res.json();
}

// Buscar configurações do perfil (com endereço completo)
export async function buscarConfiguracoes(id) {
    const res = await authService.authenticatedFetch(`${API_URL}/${id}/configuracoes`);

    if (!res.ok) {
        throw new Error("Configurações do psicólogo não encontradas");
    }

    return res.json();
}

// Atualizar psicólogo (com autenticação)
export async function atualizar(id, camposAtualizados) {
    const res = await authService.authenticatedFetch(`${API_URL}/${id}`, {
        method: "PUT",
        body: JSON.stringify(camposAtualizados),
    });

    if (!res.ok) {
        throw new Error("Erro ao atualizar psicólogo");
    }

    return res.json();
}

// Deletar psicólogo (com autenticação)
export async function deletar(id) {
    const res = await authService.authenticatedFetch(`${API_URL}/${id}`, {
        method: "DELETE",
    });

    if (!res.ok) {
        throw new Error("Erro ao deletar psicólogo");
    }

    return res.status === 204 ? { mensagem: "Psicólogo deletado com sucesso" } : res.json();
}

// Upload de imagem (com autenticação)
export async function uploadImagem(id, file) {
    const formData = new FormData();
    formData.append('imagem', file);

    const token = authService.getToken();

    if (!token) {
        throw new Error("Não autenticado");
    }

    const res = await fetch(`${API_URL}/${id}/imagem`, {
        method: "POST",
        headers: {
            "Authorization": `Bearer ${token}`
        },
        body: formData
        // NÃO adicionar Content-Type, o browser define automaticamente com boundary
    });

    if (!res.ok) {
        const errorText = await res.text();
        throw new Error(errorText || "Erro ao fazer upload da imagem");
    }

    return res.json();
}