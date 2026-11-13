import { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import background from "../../assets/img/background_input.png";
import "../../assets/styles/login-cadastro/input_recuperar_senha.css";
import { HiChevronLeft } from "react-icons/hi";
import { toast } from "react-toastify";


export default function SectionRecuperarSenha() {


    const navigate = useNavigate();

    const [loadingReset, setLoadingReset] = useState(false);

    const [step, setStep] = useState(1);

    const [form, setForm] = useState({
        email: "",
        codigo: "",
        senha: "",
        confirmarSenha: ""
    });

    const handleChange = (e) => {
        setForm({ ...form, [e.target.name]: e.target.value });
    };

    const enviarEmail = async (e) => {
    e.preventDefault();

    if (!form.email) {
        toast.error("Digite um email válido");
        return;
    }

    // chamada API
    console.log("Enviar código para:", form.email);

    toast.success("Código enviado para seu email");

    setStep(2);
};

    const confirmarCodigo = async (e) => {
        e.preventDefault();

        if (!form.codigo) return;

        // chamada API
        console.log("Código digitado:", form.codigo);

        toast.success("Código confirmado");

        setStep(3);
    };

    const redefinirSenha = async (e) => {
        e.preventDefault();

        if (!form.senha || !form.confirmarSenha) return;

        if (form.senha !== form.confirmarSenha) {
            toast.error("As senhas não coincidem");
            return;
        }

        try {
            setLoadingReset(true);

            // chamada API aqui
            await new Promise(resolve => setTimeout(resolve, 2000)); // simulação

            toast.success("Senha redefinida com sucesso");

            navigate("/login=0");

        } catch (error) {
            toast.error("Erro ao redefinir senha");
        } finally {
            setLoadingReset(false);
        }
    };


    const [animar, setAnimar] = useState(false);
    useEffect(() => {
    setAnimar(false);
    const timeout = setTimeout(() => setAnimar(true), 50);
    return () => clearTimeout(timeout);
}, [step]);

    return (
        <section className="login-inputs">
            <div className="background-img-login-cadastro">
                <img
                    className="background"
                    src={background}
                    alt="Imagem de fundo"
                />
            </div>

            <div className="container-input-login">

                <div className="container-icon-return-login">
                    <Link to="/login=0" className="icon-btn icon-return-login">
                        <HiChevronLeft />
                    </Link>
                </div>

                <h1>Recuperação de Senha</h1>

                {/* STEP 1 - EMAIL */}
                {step === 1 && (
                    <form className="inputs" onSubmit={enviarEmail} noValidate>
                        <div className={`login-input ${animar ? "animar" : ""}`}>

                            <div className={`input input-obrigatorio ${form.email ? "preenchido" : ""}`}>
                                <label>Email</label>
                                <input
                                    type="email"
                                    name="email"
                                    value={form.email}
                                    onChange={handleChange}
                                    placeholder="Digite seu email"
                                />
                            </div>

                        </div>

                        <button className="button-confirm" type="submit">
                            Enviar Código
                        </button>
                    </form>
                )}

                {/* STEP 2 - CÓDIGO */}
                {step === 2 && (
                    <form className="inputs" onSubmit={confirmarCodigo} noValidate>
                        <div className={`login-input ${animar ? "animar" : ""}`}>

                            <div className={`input input-obrigatorio ${form.codigo ? "preenchido" : ""}`}>
                                <label>Código de verificação</label>
                                <input
                                    type="text"
                                    name="codigo"
                                    value={form.codigo}
                                    onChange={handleChange}
                                    placeholder="Digite o código recebido"
                                />
                            </div>

                        </div>

                        <button className="button-confirm" type="submit">
                            Confirmar Código
                        </button>
                    </form>
                )}

                {/* STEP 3 - NOVA SENHA */}
                {step === 3 && (
                    <form className="inputs" onSubmit={redefinirSenha} noValidate>
                        <div className={`login-input ${animar ? "animar" : ""}`}>

                            <div className={`input input-obrigatorio ${form.senha ? "preenchido" : ""}`}>
                                <label>Nova Senha</label>
                                <input
                                    type="new-password"
                                    name="senha"
                                    value={form.senha}
                                    onChange={handleChange}
                                />
                            </div>

                            <div className={`input input-obrigatorio ${form.confirmarSenha ? "preenchido" : ""}`}>
                                <label>Confirmar Senha</label>
                                <input
                                    type="new-password"
                                    name="confirmarSenha"
                                    value={form.confirmarSenha}
                                    onChange={handleChange}
                                />
                            </div>

                        </div>

                        <button
                            type="submit"
                            className="button-confirm"
                            disabled={loadingReset}
                        >
                            {loadingReset ? "Redefinindo..." : "Redefinir Senha"}
                        </button>
                    </form>
                )}

            </div>
        </section>
    );
}