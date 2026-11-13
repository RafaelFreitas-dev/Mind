import { Navigate } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

// Componente para proteger rotas que precisam de autenticação
export default function ProtectedRoute({ children, requirePsicologo = false }) {
    const { isAuthenticated, isPsicologo, loading } = useAuth();

    // Aguardar carregamento
    if (loading) {
        return (
            <div style={{ 
                minHeight: "80vh", 
                display: "flex", 
                alignItems: "center", 
                justifyContent: "center" 
            }}>
                <p>Carregando...</p>
            </div>
        );
    }

    // Se não está autenticado, redirecionar para login
    if (!isAuthenticated) {
        return <Navigate to="/login=0" replace />;
    }

    // Se a rota requer psicólogo mas o usuário não é psicólogo
    if (requirePsicologo && !isPsicologo) {
        return (
            <div style={{ 
                padding: "2rem", 
                textAlign: "center",
                minHeight: "80vh",
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                justifyContent: "center"
            }}>
                <h2>Acesso Restrito</h2>
                <p>Esta área é exclusiva para psicólogos.</p>
                <a href="/home" className="button-confirm" style={{ marginTop: "1rem" }}>
                    Voltar para o início
                </a>
            </div>
        );
    }

    return children;
}