import { useState, useEffect } from "react";
import { useNavigate, Link, useLocation } from "react-router";
import { useAuth } from "../../context/AuthContext";

import '../../assets/styles/landing-page/hero-apresentacao.css';

export default function OptionsLogin() {

    const { login, error, loading, logout } = useAuth();
    const [form, setForm] = useState({ login: "", senha: "" });
    const [tipoUsuario, setTipoUsuario] = useState("paciente");

    const navigate = useNavigate();
    const location = useLocation();

    // Detectar tipo de usuário pela URL
    useEffect(() => {
        const path = location.pathname;

        if (path === "/login=0" || path === "/login") {
            setTipoUsuario("paciente");
        } else if (path === "/login=1") {
            setTipoUsuario("psicologo");
        } else if (path === "/login=2") {
            setTipoUsuario("voluntario");
        }
    }, [location.pathname]);

    return (
        <>
        <div role="region" className="container-options" aria-label="Tipo de usuário">
            <ul>
                <li>
                    <Link to="/login=0" 
                          className={tipoUsuario === "paciente" ? "active" : ""}
                          aria-current={tipoUsuario === "paciente" ? "true" : "false"}>
                        Paciente
                    </Link>
                </li>
                <li>
                    <Link to="/login=1" 
                          className={tipoUsuario === "psicologo" ? "active" : ""}
                          aria-current={tipoUsuario === "psicologo" ? "active" : ""}>
                        Psicologo
                    </Link>
                </li>
                <li>
                    <Link to="/login=2" 
                          className={tipoUsuario === "voluntario" ? "active" : ""}
                          aria-current={tipoUsuario === "voluntario" ? "active" : ""}>
                        Voluntario
                    </Link>
                </li>
            </ul>
        </div>
        </>
    )
}
