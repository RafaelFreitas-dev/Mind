import { useState, useEffect } from "react";
import { useNavigate, Link, useLocation } from "react-router";
import background from "../../assets/img/background_input.png";
import "../../assets/styles/login-cadastro/input_login.css";
import OptionsLogin from "./OptionsLogin";
import { useAuth } from "../../context/AuthContext";
import { toast } from 'react-toastify';

export default function InputLogin() {
    const { login, error, loading, logout } = useAuth();
    const [form, setForm] = useState({ login: "", senha: "" });
    const [tipoUsuario, setTipoUsuario] = useState("paciente");
    const [animar, setAnimar] = useState(false);


    const [errors, setErrors] = useState({
        login: "",
        senha: ""
    });

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
        // animação
        setAnimar(false);
        const timeout = setTimeout(() => setAnimar(true), 50);

        return () => clearTimeout(timeout);
    }, [location.pathname]);



    const handleSubmit = async (e) => {
    e.preventDefault();

    if (!form.login || !form.senha) {
        setErrors({
            login: !form.login ? "Digite o login" : "",
            senha: !form.senha ? "Digite a senha" : ""
        });

        toast.error("Preencha todos os campos");
        return;
    }

    const result = await login(form.login, form.senha, tipoUsuario);

    if (!result.success) {
        setErrors({
            login: "Login ou senha inválidos",
            senha: "Login ou senha inválidos"
        });
        return;
    }

    const { user } = result;

    const mapaTipos = {
        "0": "paciente",
        "1": "psicologo",
        "2": "voluntario"
    };

    const tipoRotaNumero = location.pathname.split("=")[1];
    const tipoRota = mapaTipos[tipoRotaNumero];
    const tipoUser = user.tipo.toLowerCase().trim();

    if (tipoRota && tipoRota !== tipoUser) {
        toast.error(`Você está tentando acessar como ${tipoRota}, mas sua conta é ${tipoUser}.`, {
            position: "top-center",
            autoClose: 4000
        });

        logout();
        return;
    }

    toast.success("Logado");
    navigate("/home");
};

    return (
        <>  
            <section className="login-inputs">
                <div className="background-img-login-cadastro">
                    <img className="background"
                        src={background}
                        alt="Imagem de fundo - tela de cadastro"
                    />
                </div>
                <div className="container-input-login" id="loginPageForm">
                    <h1>Login</h1>
                    < OptionsLogin />
                    <form className="inputs" onSubmit={handleSubmit}>
                        <div className={`login-input ${animar ? "animar" : ""}`}>
                            <div className={`input input-obrigatorio ${form.login ? "preenchido" : ""}`}>
                                <label htmlFor="loginInput" >Login</label>
                                <input
                                    id="loginInput"
                                    type="text"
                                    name="login"
                                    value={form.login}
                                    onChange={(e) => {
                                        setForm({ ...form, login: e.target.value });
                                        setErrors((prev) => ({ ...prev, login: "" }));
                                    }}
                                    placeholder="E-mail ou nome do usuário"
                                    autoComplete="username"
                                    className={errors.login ? "error" : ""}
                                />{errors.login && <span className="error-text">{errors.login}</span>}
                            </div>
                            <div className={`input input-obrigatorio ${form.senha ? "preenchido" : ""}`}>
                                <label htmlFor="senhaLogInInput" >Senha</label>
                                <input
                                    id="senhaLogInInput"
                                    type="password"
                                    name="senha"
                                    value={form.senha}
                                    onChange={(e) => {
                                        setForm({ ...form, senha: e.target.value });
                                        setErrors((prev) => ({ ...prev, senha: "" }));
                                    }}
                                    placeholder="Senha"
                                    autoComplete="current-password"
                                    className={errors.senha ? "error" : ""}
                                />{errors.senha && <span className="error-text">{errors.senha}</span>}
                            </div>

                        </div>



                        <div className="container-cadastrar-entrar">
                            <div className="container-links">
                                <Link to="/cadastro=0" className="link-cadastro">
                                    Não tenho cadastro
                                </Link>
                                <Link to="/recuperar-senha" className="link-cadastro">
                                    Esqueci a senha
                                </Link>
                            </div>

                            <button
                                type="submit"
                                className="button-confirm login-button"
                                disabled={loading}>
                                {loading ? "Entrando..." : "Entrar"}
                            </button>
                        </div>

                    </form>
                </div>
            </section>
        </>
    )
}
