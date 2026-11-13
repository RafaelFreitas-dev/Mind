import { createContext, useContext, useState, useEffect } from "react";
import { authService } from "../services/authService";

const AuthContext = createContext();

export function AuthProvider({ children }) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");

    // Recarrega usuário do localStorage no refresh da página
    useEffect(() => {
        const token = authService.getToken();
        const savedUser = localStorage.getItem("user");

        if (token && savedUser) {
            setUser(JSON.parse(savedUser));
        }
        setLoading(false);
    }, []);

    // Login
    async function login(login, senha, tipo) {
        setLoading(true);
        setError("");
        try {
            // 1. Autentica e recebe token + refreshToken
            const authData = await authService.login(login, senha, tipo);

            // 2. Busca dados completos do usuário
            const userData = await authService.getUserData(authData.username, authData.tipo);

            setUser(userData);
            localStorage.setItem("user", JSON.stringify(userData));
            return { success: true, user: userData };
        } catch (err) {
            const errorMessage = err.message || "Erro ao fazer login";
            setError(errorMessage);
            return { success: false, error: errorMessage };
        } finally {
            setLoading(false);
        }
    }

    // Cadastro genérico (paciente, psicólogo ou voluntário)
    async function registerUser(userData) {
        setLoading(true);
        setError("");

        try {
            let newUser;
            const tipo = userData.tipo || userData.tipoUsuario;

            if (tipo === "paciente") {
                newUser = await authService.registerPaciente(userData);
            } else if (tipo === "psicologo") {
                newUser = await authService.registerPsicologo(userData);
            } else if (tipo === "voluntario") {
                newUser = await authService.registerVoluntario(userData);
            } else {
                throw new Error("Tipo de usuário inválido");
            }

            // Login automático após cadastro
            await login(userData.email, userData.senha, tipo);

            return { success: true, user: newUser };
        } catch (err) {
            const errorMessage = err.message || "Erro ao cadastrar usuário";
            setError(errorMessage);
            return { success: false, error: errorMessage };
        } finally {
            setLoading(false);
        }
    }

    // Logout — invalida refresh token no backend
    async function logout() {
        await authService.logout();
        setUser(null);
    }

    // Atualizar usuário no estado e localStorage
    function updateUser(newData) {
        const updatedUser = { ...user, ...newData };
        setUser(updatedUser);
        localStorage.setItem("user", JSON.stringify(updatedUser));
    }

    const value = {
        user,
        loading,
        error,
        login,
        registerUser,
        logout,
        updateUser,
        isAuthenticated: !!user,
        isPaciente: user?.tipo === "paciente",
        isPsicologo: user?.tipo === "psicologo",
        isVoluntario: user?.tipo === "voluntario",
    };

    return (
        <AuthContext.Provider value={value}>
            {children}
        </AuthContext.Provider>
    );
}

export function useAuth() {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error("useAuth deve ser usado dentro de AuthProvider");
    }
    return context;
}