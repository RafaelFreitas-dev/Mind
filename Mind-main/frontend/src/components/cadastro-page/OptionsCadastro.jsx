import { useState, useEffect } from "react";
import { Link, useLocation } from "react-router";
import "../../assets/styles/landing-page/hero-apresentacao.css";

export default function OptionsCadastro() {
    const [tipoUsuario, setTipoUsuario] = useState("paciente");
    const location = useLocation();

    // Detectar tipo de usuário pela URL
    useEffect(() => {
        const path = location.pathname;

        if (path === "/cadastro=0" || path === "/cadastro") {
            setTipoUsuario("paciente");
        } else if (path === "/cadastro=1") {
            setTipoUsuario("psicologo");
        } else if (path === "/cadastro=2") {
            setTipoUsuario("voluntario");
        }
    }, [location.pathname]);

    return (
          <div role="region" className="container-options" aria-label="Tipo de usuário">
            <ul>
                <li>
                    <Link to="/cadastro=0" 
                          className={tipoUsuario === "paciente" ? "active" : ""}
                          aria-current={tipoUsuario === "paciente" ? "true" : "false"}>
                        Paciente
                    </Link>
                </li>
                <li>
                    <Link to="/cadastro=1" 
                          className={tipoUsuario === "psicologo" ? "active" : ""}
                          aria-current={tipoUsuario === "psicologo" ? "active" : ""}>
                        Psicologo
                    </Link>
                </li>
                <li>
                    <Link to="/cadastro=2" 
                          className={tipoUsuario === "voluntario" ? "active" : ""}
                          aria-current={tipoUsuario === "voluntario" ? "active" : ""}>
                        Voluntario
                    </Link>
                </li>
            </ul>
        </div>
    );
}
