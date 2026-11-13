import { useState } from "react";
import { loginUser, registerUser } from "../services/pacienteService";

export function useAuth() {
    const [user, setUser] = useState(() => {
        const saved = localStorage.getItem("user");
        return saved ? JSON.parse(saved) : null;
    });

    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");

    async function login(login, senha) {
        setLoading(true);
        setError("");
        try {
            const data = await loginUser(login, senha);
            setUser(data);
            localStorage.setItem("user", JSON.stringify(data));
            return true;
        } catch (err) {
            setError(err.message || "Erro ao fazer login");
            return false;
        } finally {
            setLoading(false);
        }
    }

    async function register(nome, email, senha) {
        setLoading(true);
        setError("");
        try {
            const newUser = await registerUser(nome, email, senha);
            setUser(newUser);
            localStorage.setItem("user", JSON.stringify(newUser));
            return true;
        } catch (err) {
            setError(err.message || "Erro ao cadastrar");
            return false;
        } finally {
            setLoading(false);
        }
    }

    function logout() {
        setUser(null);
        localStorage.removeItem("user");
    }

    return { user, loading, error, login, register, logout };
}
