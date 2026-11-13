// ================= IMPORTS =================
import { useState, useEffect } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import background from "../../assets/img/background_input.png";
import "../../assets/styles/login-cadastro/input_cadastro.css";
import OptionsCadastro from "./OptionsCadastro";
import TermosCondicoes from "../../pages/TermosCondicoes";
import { useAuth } from "../../context/AuthContext";
import { HiChevronLeft } from "react-icons/hi";
import { toast } from "react-toastify";

// ================= COMPONENT =================
export default function InputCadastro() {
    const location = useLocation();
    const navigate = useNavigate();
    const { registerUser, loading, error } = useAuth();
    const [loadingCep, setLoadingCep] = useState(false);
    const [etapaTermos, setEtapaTermos] = useState(false);

    // ================= STATES =================
    const [errors, setErrors] = useState({});
    const [tipoUsuario, setTipoUsuario] = useState("paciente");
    const [animar, setAnimar] = useState(false);

    const [form, setForm] = useState({
        nome: "",
        dataNascimento: "",
        email: "",
        localidade: "",
        cpf: "",
        sobrenome: "",
        cep: "",
        uf: "",
        cidade: "",
        rua: "",
        numeroResidencia: "",
        telefone: "",
        genero: "",
        crp: "",
        especialidade: "",
        ra: "",
        token: "",
        senha: "",
        confirmarSenha: ""
    });

    // ================= HELPERS =================
    async function buscarCep(cep) {
        const response = await fetch(`https://viacep.com.br/ws/${cep}/json/`);
        if (!response.ok) throw new Error();

        const data = await response.json();
        if (data.erro) throw new Error();

        return data;
    }

    async function handleBuscarCep(cep) {
        try {
            setLoadingCep(true);

            const data = await buscarCep(cep);

            setForm((prev) => ({
                ...prev,
                rua: data.logradouro || "",
                cidade: data.localidade || "",
                uf: data.uf || "",
            }));

        } catch {
            toast.error("CEP não encontrado");
        } finally {
            setLoadingCep(false);
        }
    }

    // ================= VALIDATION =================
    const validate = () => {
        let newErrors = {};

        if (!form.nome) newErrors.nome = "Nome é obrigatório";

        if (!form.dataNascimento) {
            newErrors.dataNascimento = "Data de nascimento é obrigatória";
        } else {
            const data = new Date(form.dataNascimento);
            const hoje = new Date();

            const idade = hoje.getFullYear() - data.getFullYear();
            const fezAniversario =
                hoje.getMonth() > data.getMonth() ||
                (hoje.getMonth() === data.getMonth() && hoje.getDate() >= data.getDate());

            const idadeFinal = fezAniversario ? idade : idade - 1;

            if (data > hoje) {
                newErrors.dataNascimento = "Data não pode ser no futuro";
            } else if (idadeFinal < 18) {
                newErrors.dataNascimento = "Você deve ter pelo menos 18 anos";
            } else if (idadeFinal > 100) {
                newErrors.dataNascimento = "Idade inválida";
            }
        }

        if (!form.cpf) newErrors.cpf = "CPF é obrigatório";

        if (!form.email) {
            newErrors.email = "Email é obrigatório";
        } else if (!/\S+@\S+\.\S+/.test(form.email)) {
            newErrors.email = "Email inválido";
        }

        if (!form.cep) newErrors.cep = "CEP obrigatório";
        if (!form.rua) newErrors.rua = "Rua obrigatória";
        if (!form.uf) newErrors.uf = "UF obrigatória";
        if (!form.cidade) newErrors.cidade = "Cidade obrigatória";
        if (!form.numeroResidencia) newErrors.numeroResidencia = "Número obrigatório";

        if (!form.senha) {
            newErrors.senha = "Senha obrigatória";
        } else if (form.senha.length < 6) {
            newErrors.senha = "Mínimo 6 caracteres";
        }

        if (form.senha !== form.confirmarSenha) {
            newErrors.confirmarSenha = "Senhas não coincidem";
        }

        // Tipo usuário
        if (tipoUsuario === "paciente") {
            if (!form.telefone) newErrors.telefone = "Telefone obrigatório";
            if (!form.genero) newErrors.genero = "Gênero obrigatório";
        }

        if (tipoUsuario === "psicologo") {
            if (!form.crp) newErrors.crp = "CRP obrigatório";
            if (!form.especialidade) newErrors.especialidade = "Especialidade obrigatória";
        }

        if (tipoUsuario === "voluntario") {
            if (!form.ra) newErrors.ra = "RA obrigatório";
            if (!form.token) newErrors.token = "Token obrigatório";
        }

        setErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    // ================= EFFECTS =================
    useEffect(() => {
        const path = location.pathname;

        if (path === "/cadastro=0" || path === "/cadastro") {
            setTipoUsuario("paciente");
        } else if (path === "/cadastro=1") {
            setTipoUsuario("psicologo");
        } else if (path === "/cadastro=2") {
            setTipoUsuario("voluntario");
        }

        // animação
        setAnimar(false);
        const timeout = setTimeout(() => setAnimar(true), 50);

        return () => clearTimeout(timeout);
    }, [location.pathname]);

    // ================= HANDLERS =================
    const handleCepBlur = (e) => {
        const relatedName = e.relatedTarget?.name;
        if (["rua", "cidade", "uf", "numeroResidencia"].includes(relatedName)) return;

        const cepLimpo = form.cep.replace(/\D/g, "");
        if (cepLimpo.length === 8) {
            handleBuscarCep(cepLimpo);
        }
    };

    const handleEnderecoBlur = async (e) => {
        const relatedName = e.relatedTarget?.name;
        if (["cep", "rua", "cidade", "uf", "numeroResidencia"].includes(relatedName)) return;

        const cepLimpo = form.cep?.replace(/\D/g, "");
        if (!cepLimpo && form.uf?.length === 2 && form.cidade?.length >= 3 && form.rua?.length >= 3) {
            try {
                setLoadingCep(true);
                const response = await fetch(`https://viacep.com.br/ws/${form.uf}/${form.cidade}/${form.rua}/json/`);
                const data = await response.json();
                if (data && data.length > 0) {
                    setForm((prev) => ({
                        ...prev,
                        cep: data[0].cep
                    }));
                    toast.success("CEP encontrado e preenchido automaticamente!");
                }
            } catch (error) {
                console.error("Erro ao consultar CEP pelo endereço:", error);
            } finally {
                setLoadingCep(false);
            }
        }
    };

    function handleChange(e) {
        const { name, value } = e.target;

        setForm((prev) => ({
            ...prev,
            [name]: value,
        }));

        if (errors[name]) {
            setErrors((prev) => ({ ...prev, [name]: "" }));
        }
    }

    const handleSubmit = async (e) => {
        e.preventDefault();

        if (!validate()) {
            const firstError = Object.keys(errors)[0];
            document.querySelector(`[name="${firstError}"]`)?.focus();
            return;
        }

        setEtapaTermos(true);
        window.scrollTo(0, 0);
    };

    const confirmarCadastro = async () => {
        if (!etapaTermos || loading) return;
        const userData = {
            nome: form.nome,
            sobrenome: form.sobrenome,
            email: form.email,
            senha: form.senha,
            dtNascimento: form.dataNascimento,
            genero: form.genero,
            telefone: form.telefone,

            cep: form.cep,
            numeroResidencia: form.numeroResidencia,

            cpf: form.cpf,
            tipoUsuario: tipoUsuario,
        };

        if (tipoUsuario === "psicologo") {
            userData.crp = form.crp;
            userData.especialidade = form.especialidade;
        } else if (tipoUsuario === "voluntario") {
            userData.ra = form.ra;
            userData.token = form.token;
        }

        const result = await registerUser(userData);

        if (result?.success) {
            toast.success("Cadastro realizado", {
                position: "top-center",
                theme: "light",
                draggable: true,
            });
            navigate("/login=0");
        } else {
            toast.error(error || "Erro ao cadastrar");
        }
    };

    // ================= DATAS =================
    const hoje = new Date();
    const isCepValid = (form.cep || "").replace(/\D/g, "").length === 8;

    const maxDate = new Date(
        hoje.getFullYear() - 18,
        hoje.getMonth(),
        hoje.getDate()
    ).toISOString().split("T")[0];

    const minDate = new Date(
        hoje.getFullYear() - 100,
        hoje.getMonth(),
        hoje.getDate()
    ).toISOString().split("T")[0];


    if (etapaTermos) {
        return (
            <div className="cadastro-etapa-termos">
                <div className="cadastro-termos-etapa">Etapa 2 de 2 · Termos de Uso</div>
                <TermosCondicoes />
                <div className="cadastro-termos-acoes">
                    <button type="button" disabled={loading} onClick={() => { setEtapaTermos(false); window.scrollTo(0, 0); }}>
                        Voltar / Não aceito
                    </button>
                    <button type="button" disabled={loading} onClick={confirmarCadastro}>
                        {loading ? "Cadastrando..." : "Li e aceito os Termos de Uso"}
                    </button>
                </div>
                <p className="cadastro-termos-etapa">Ao aceitar, seu cadastro será concluído.</p>
            </div>
        );
    }

    return (
        <section className="login-inputs">
            <div className="background-img-login-cadastro">
                <img
                    className="background"
                    src={background}
                    alt="Imagem de fundo da tela de cadastro"
                />
            </div>
            <div className="container-input-login">
                <div className="container-icon-return-login">
                    <Link to="/login=0" className="icon-btn icon-return-login" aria-label="Voltar para login">
                        <HiChevronLeft aria-hidden="true"/>
                    </Link>
                </div>

                <h1 id="signinPageForm">Cadastro</h1>
                <OptionsCadastro />

                {/* Desativa a validação automática do navegador */}
                <form className="inputs" onSubmit={handleSubmit} noValidate>
                    <div className={`cadastro-input ${animar ? "animar" : ""}`}>
                        <div className={`input input-obrigatorio ${form.nome ? "preenchido" : ""}`}>
                            <label htmlFor="nameInputSignIn" >Nome</label>
                            <input
                                id="nameInputSignIn"
                                type="text"
                                name="nome"
                                value={form.nome}
                                onChange={handleChange}
                                placeholder="Seu nome"
                                autoComplete="given-name"
                                className={errors.nome ? "error" : ""}
                                required
                            />
                            {errors.nome && <span className="error-text" role="alert">{errors.nome}</span>}
                        </div>
                        <div className="input">
                            <label htmlFor="sobrenomeInputSignIn">Sobrenome</label>
                            <input
                                id="sobrenomeInputSignIn"
                                type="text"
                                name="sobrenome"
                                value={form.sobrenome}
                                onChange={handleChange}
                                placeholder="Seu sobrenome"
                                autoComplete="family-name"
                                className={errors.sobrenome ? "error" : ""}
                            />
                            {errors.sobrenome && <span className="error-text" role="alert">{errors.sobrenome}</span>}
                        </div>
                        <div className={`input input-obrigatorio ${form.dataNascimento ? "preenchido" : ""}`}>
                            <label htmlFor="dataInputSignIn">Data de Nascimento</label>
                            <input
                                id="dataInputSignIn"
                                name="dataNascimento"
                                type="date"
                                value={form.dataNascimento}
                                onChange={handleChange}
                                min={minDate}
                                max={maxDate}
                                className={errors.dataNascimento ? "error" : ""}
                                required
                            />
                            {errors.dataNascimento && <span className="error-text" role="alert">{errors.dataNascimento}</span>}
                        </div>
                        <div className={`input input-obrigatorio ${form.cpf ? "preenchido" : ""}`}>
                            <label htmlFor="cpfInputSignIn" >CPF</label>
                            <input
                                id="cpfInputSignIn"
                                name="cpf"
                                type="text"
                                value={form.cpf}
                                onChange={handleChange}
                                placeholder="000.000.000-00"
                                autoComplete="off"
                                className={errors.cpf ? "error" : ""}
                                required
                            />
                            {errors.cpf && <span className="error-text" role="alert">{errors.cpf}</span>}
                        </div>
                        <div className={`input input-obrigatorio ${form.email ? "preenchido" : ""}`}>
                            <label htmlFor="emailInputSignIn">Email</label>
                            <input
                                id="emailInputSignIn"
                                name="email"
                                type="email"
                                value={form.email}
                                onChange={handleChange}
                                placeholder="seuemail@gmail.com "
                                autoComplete="email"
                                className={errors.email ? "error" : ""}
                                required
                            /> {errors.email && <span className="error-text" role="alert">{errors.email}</span>}
                        </div>
                        <div className={`input ${form.cep ? "preenchido" : ""} input-obrigatorio`}>
                            <label htmlFor="cepInputSignIn">CEP</label>

                            <div style={{ position: "relative" }}>
                                <input
                                    id="cepInputSignIn"
                                    name="cep"
                                    type="text"
                                    value={form.cep}
                                    onChange={handleChange}
                                    placeholder="00000-000"
                                    autoComplete="postal-code"
                                    className={errors.cep ? "error" : ""}
                                    onBlur={handleCepBlur}
                                    required
                                />

                                {loadingCep && (
                                    <span className="loading-cep">Buscando...</span>
                                )}
                            </div>
                            {errors.cep && <span className="error-text" role="alert">{errors.cep}</span>}
                        </div>
                        <div className={`input input-obrigatorio ${form.uf ? "preenchido" : ""}`}>
                            <label htmlFor="ufInputSignIn">UF</label>
                            <input
                                id="ufInputSignIn"
                                name="uf"
                                type="text"
                                value={form.uf}
                                onChange={handleChange}
                                placeholder="SP"
                                className={errors.uf ? "error" : ""}
                                onBlur={handleEnderecoBlur}
                                readOnly={isCepValid}
                                required
                            /> {errors.uf && <span className="error-text" role="alert">{errors.uf}</span>}
                        </div>
                        <div className={`input input-obrigatorio ${form.cidade ? "preenchido" : ""}`}>
                            <label htmlFor="cidadeInputSignIn">Cidade</label>
                            <input
                                id="cidadeInputSignIn"
                                name="cidade"
                                type="text"
                                value={form.cidade}
                                onChange={handleChange}
                                placeholder="Diadema"
                                className={errors.cep ? "error" : ""}
                                onBlur={handleEnderecoBlur}
                                readOnly={isCepValid}
                                required
                            /> {errors.cidade && <span className="error-text" role="alert">{errors.cidade}</span>}
                        </div>
                        <div className={`input input-obrigatorio ${form.rua ? "preenchido" : ""}`}>
                            <label htmlFor="ruaInputSignIn">Rua</label>
                            <input
                                id="ruaInputSignIn"
                                name="rua"
                                type="text"
                                value={form.rua}
                                onChange={handleChange}
                                placeholder="Centro"
                                className={errors.rua ? "error" : ""}
                                onBlur={handleEnderecoBlur}
                                readOnly={isCepValid}
                                required
                            /> {errors.rua && <span className="error-text" role="alert">{errors.rua}</span>}
                        </div>
                        <div className={`input input-obrigatorio ${form.numeroResidencia ? "preenchido" : ""}`}>
                            <label htmlFor="numeroInputSignIn">Número da residencia</label>
                            <input
                                id="numeroInputSignIn"
                                name="numeroResidencia"
                                type="text"
                                value={form.numeroResidencia}
                                onChange={handleChange}
                                placeholder="123"
                                className={errors.cep ? "error" : ""}
                            />{errors.numeroResidencia && <span className="error-text" role="alert">{errors.numeroResidencia}</span>}

                        </div>


                        {/* Campos específicos */}
                        {tipoUsuario === "paciente" && (
                            <>
                                <div className={`input input-obrigatorio ${form.telefone ? "preenchido" : ""}`}>
                                    <label htmlFor="telefoneInputSignIn">Telefone</label>
                                    <input
                                        id="telefoneInputSignIn"
                                        name="telefone"
                                        type="tel"
                                        value={form.telefone}
                                        onChange={handleChange}
                                        placeholder="11 94002-8922"
                                        autoComplete="tel"
                                        className={errors.telefone ? "error" : ""}
                                    /> {errors.telefone && <span className="error-text" role="alert">{errors.telefone}</span>}
                                </div>
                                <div className={`input input-obrigatorio ${form.genero ? "preenchido" : ""}`}>
                                    <label htmlFor="generoInputSignIn">Gênero</label>
                                    <input
                                        id="generoInputSignIn"
                                        name="genero"
                                        type="text"
                                        value={form.genero}
                                        onChange={handleChange}
                                        placeholder="Masculino / Feminino"
                                        autoComplete="sex"
                                        className={errors.genero ? "error" : ""}
                                    /> {errors.genero && <span className="error-text" role="alert">{errors.genero}</span>}
                                </div>
                            </>
                        )}

                        {tipoUsuario === "psicologo" && (
                            <>
                                <div className={`input input-obrigatorio ${form.crp ? "preenchido" : ""}`}>
                                    <label htmlFor="crpInputSignIn">CRP</label>
                                    <input
                                        id="crpInputSignIn"
                                        name="crp"
                                        type="text"
                                        value={form.crp}
                                        onChange={handleChange}
                                        placeholder="06/12345"
                                        className={errors.crp ? "error" : ""}
                                        required
                                    /> {errors.crp && <span className="error-text" role="alert">{errors.crp}</span>}
                                </div>
                                <div className={`input input-obrigatorio ${form.especialidade ? "preenchido" : ""}`}>
                                    <label htmlFor="especialidadeInputSignIn">Especialidade</label>
                                    <input
                                        id="especialidadeInputSignIn"
                                        name="especialidade"
                                        type="text"
                                        value={form.especialidade}
                                        onChange={handleChange}
                                        placeholder="Terapia Cognitivo-Comportamental"
                                        className={errors.especialidade ? "error" : ""}
                                    /> {errors.especialidade && <span className="error-text" role="alert">{errors.especialidade}</span>}
                                </div>
                            </>
                        )}

                        {tipoUsuario === "voluntario" && (
                            <>
                                <div className={`input input-obrigatorio ${form.ra ? "preenchido" : ""}`}>
                                    <label htmlFor="raInputSignIn">R.A</label>
                                    <input
                                        id="raInputSignIn"
                                        name="ra"
                                        type="text"
                                        value={form.ra}
                                        onChange={handleChange}
                                        placeholder="123456"
                                        className={errors.ra ? "error" : ""}
                                    /> {errors.ra && <span className="error-text" role="alert">{errors.ra}</span>}
                                </div>
                                <div className={`input input-obrigatorio ${form.token ? "preenchido" : ""}`}>
                                    <label htmlFor="tokenInputSignIn">Token</label>
                                    <input
                                        id="tokenInputSignIn"
                                        name="token"
                                        type="text"
                                        value={form.token}
                                        onChange={handleChange}
                                        placeholder="Token de autorização"
                                        className={errors.dataNascimento ? "error" : ""}
                                    /> {errors.token && <span className="error-text" role="alert">{errors.token}</span>}
                                </div>
                            </>
                        )}
                        <div className={`input input-obrigatorio ${form.senha ? "preenchido" : ""}`}>
                            <label htmlFor="senhaInputSignIn">Senha</label>
                            <input
                                id="senhaInputSignIn"
                                name="senha"
                                type="password"
                                value={form.senha}
                                onChange={handleChange}
                                autoComplete="new-password"
                                className={errors.senha ? "error" : ""}
                                required
                            />{errors.senha && <span className="error-text" role="alert">{errors.senha}</span>}
                        </div>
                        <div className={`input input-obrigatorio ${form.confirmarSenha ? "preenchido" : ""}`}>
                            <label htmlFor="confirmSenhaInputSignIn">Confirmar Senha</label>
                            <input
                                id="confirmSenhaInputSignIn"
                                name="confirmarSenha"
                                type="password"
                                value={form.confirmarSenha}
                                onChange={handleChange}
                                autoComplete="new-password"
                                className={errors.confirmarSenha ? "error" : ""}
                                required
                            />{errors.confirmarSenha && <span className="error-text" role="alert">{errors.confirmarSenha}</span>}
                        </div>
                    </div>
                    <div className="container-cadastrar-entrar">
                        <button type="submit" className="button-confirm" disabled={loading}
                        >

                            Continuar
                        </button>
                    </div>

                    
                </form>
            </div>
        </section>
    );
}
