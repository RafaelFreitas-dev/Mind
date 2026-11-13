import '../../assets/styles/perfil/sobre.css';
import { useAuth } from "../../context/AuthContext";

export default function Sobre({ profileData }) {
    const { user } = useAuth();

    return (
        <>
            <div className="infos">
                <div className="card-info-container">
                    <h4>Sobre mim:</h4>
                    <div className="card-sobre-container">
                        <p>{profileData?.sobreMim || "Nenhuma informação adicionada."}</p>
                    </div>
                </div>
                <div className="card-info-container">
                    <h4>Ficha do Paciente</h4>
                    <div className="card-ficha-container">
                        <div>
                            <strong>Medicamentos:</strong>
                            <p>{profileData?.medicamentos || "Nenhum medicamento registrado."}</p>
                        </div>
                        <div style={{ marginTop: "1rem" }}>
                            <strong>Preferências:</strong>
                            <p>{profileData?.preferencias || "Nenhuma preferência registrada."}</p>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}