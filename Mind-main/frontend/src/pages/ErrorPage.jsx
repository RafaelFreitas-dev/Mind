import { Link } from "react-router-dom";
import { useAuth } from "../context/AuthContext";

export default function ErrorPage( {error}) {

    const { user } = useAuth();

    return (
        <div style={{
            minHeight: "80vh",
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
            justifyContent: "center",
            padding: "2rem",
            textAlign: "center"
        }}>
            <h1 style={{ fontSize: "4rem", margin: "0" }}>F</h1>
            <h2>Oops! Algo deu errado</h2>
            
            {error?.status === 404 ? (
                <>
                    <p>A página que você está procurando não foi encontrada.</p>
                </>
            ) : (
                <>
                    <p>Desculpe, ocorreu um erro inesperado.</p>
                    {error?.statusText && <p><i>{error.statusText}</i></p>}
                    {error?.message && <p><i>{error.message}</i></p>}
                </>
            )}

            <div style={{ 
                marginTop: "2rem", 
                display: "flex", 
                gap: "1rem",
                flexWrap: "wrap",
                justifyContent: "center"
            }}>
                <Link to="/" className="button-confirm">
                    Voltar para o início
                </Link>
                
                {user && (
                    <Link 
                        to={`/${user.tipo}/perfil/${user.id}`} 
                        className="button-proceed"
                    >
                        Ir para meu perfil
                    </Link>
                )}
            </div>
        </div>
    );
}