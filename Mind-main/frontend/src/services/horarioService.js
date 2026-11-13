import { authService } from './authService';

const API_URL = "http://localhost:8080/horarios";

// Helper para extrair a mensagem de erro do Spring de forma segura
async function extrairMensagemErro(res, fallback = "Erro desconhecido") {
    try {
        const text = await res.text();
        if (!text) return fallback;
        const json = JSON.parse(text);
        return json.message || json.error || fallback;
    } catch {
        return fallback;
    }
}

// Criar novo horário
export async function criarHorario(horarioData) {
    const res = await authService.authenticatedFetch(`${API_URL}`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(horarioData),
    });

    if (!res.ok) {
        const mensagem = await extrairMensagemErro(res, "Este horário já está ocupado. Escolha outro período para criar esta grade.");
        throw new Error(mensagem);
    }

    return res.json();
}

// Listar todos os horários de um psicólogo
export async function listarTodosDoPsicologo(psicologoId) {
    const res = await authService.authenticatedFetch(`${API_URL}/psicologo/${psicologoId}`);

    if (!res.ok) {
        throw new Error("Erro ao buscar horários do psicólogo");
    }

    return res.json();
}

// Listar horários disponíveis de um psicólogo
export async function listarDisponiveisDoPsicologo(psicologoId) {
    const res = await authService.authenticatedFetch(`${API_URL}/psicologo/${psicologoId}/disponiveis`);

    if (!res.ok) {
        throw new Error("Erro ao buscar horários disponíveis do psicólogo");
    }

    return res.json();
}

// Deletar horário
export async function deletarHorario(id) {
    const res = await authService.authenticatedFetch(`${API_URL}/${id}`, {
        method: "DELETE",
    });

    if (!res.ok) {
        throw new Error("Erro ao deletar horário");
    }

    return res.status === 204 ? { mensagem: "Horário deletado com sucesso" } : res.json();
}
