export default function InfosGerais({ formData, handleChange, handleCepBlur, handleEnderecoBlur }) {

    const formatarData = (dtNascimento) => {
        if (!dtNascimento) return "";

        // Jackson serializa LocalDate como array [ano, mes, dia]
        if (Array.isArray(dtNascimento)) {
            const [ano, mes, dia] = dtNascimento;
            return `${ano}-${String(mes).padStart(2, "0")}-${String(dia).padStart(2, "0")}`;
        }

        // Se já vier como string "2000-09-13"
        return dtNascimento;
    };

    const isCepValid = (formData.cep || "").replace(/\D/g, "").length === 8;

    return (
        <>
            <div className="container-input-1">
                <div className="input-e-span">
                    <label htmlFor="nomeConfig" className="login-titulo">Nome</label>
                    <input
                        id="nomeConfig"
                        type="text"
                        className="form-control"
                        placeholder="Nome"
                        name="nome"
                        value={formData.nome}
                        onChange={handleChange}
                    />
                </div>

                <div className="input-e-span">
                    <label htmlFor="sobrenomeEdit" className="login-titulo">Sobrenome</label>
                    <input
                        id="sobrenomeEdit"
                        type="text"
                        name="sobrenome"
                        className="form-control"
                        placeholder="Sobrenome"
                        value={formData.sobrenome}
                        onChange={handleChange}
                    />
                </div>

                <div className="input-e-span">
                    <label htmlFor="nascimentoEdit" className="login-titulo">Data de nascimento</label>
                    <input
                        id="nascimentoEdit"
                        type="date"
                        name="dtNascimento"
                        className="form-control"
                        placeholder="Data de nascimento"
                        value={formatarData(formData.dtNascimento)}
                        onChange={handleChange}
                    />
                </div>

                <div className="input-e-span">
                    <label htmlFor="telefoneEdit" className="login-titulo">Telefone</label>
                    <input
                        id="telefoneEdit"
                        type="text"
                        name="telefone"
                        className="form-control"
                        placeholder="Telefone"
                        value={formData.telefone}
                        onChange={handleChange}
                    />
                </div>

                <div className="input-e-span">
                    <label htmlFor="cpfEdit" className="login-titulo">CPF</label>
                    <input
                        id="cpfEdit"
                        type="text"
                        name="CPF"
                        className="form-control"
                        placeholder="CPF"
                        value={formData.CPF}
                        onChange={handleChange}
                    />
                </div>

                <div className="input-e-span">
                    <label htmlFor="sexoEdit" className="login-titulo">Sexo</label>
                    <select
                        id="sexoEdit"
                        className="form-control"
                        name="sexo"
                        value={formData.sexo}
                        onChange={handleChange}
                    >
                        <option value="" disabled hidden>Escolher opções</option>
                        <option value="Feminino">Feminino</option>
                        <option value="Masculino">Masculino</option>
                        <option value="Outro">Outro</option>
                    </select>
                </div>

                <div className="input-e-span">
                    <label htmlFor="cepEdit" className="login-titulo">CEP</label>
                    <input
                        id="cepEdit"
                        type="text"
                        name="cep"
                        className="form-control"
                        placeholder="00000-000"
                        value={formData.cep}
                        onChange={handleChange}
                        onBlur={handleCepBlur}
                    />
                </div>

                <div className="input-e-span">
                    <label htmlFor="ruaEdit" className="login-titulo">Rua / Logradouro</label>
                    <input
                        id="ruaEdit"
                        type="text"
                        name="rua"
                        className="form-control"
                        placeholder="Rua"
                        value={formData.rua}
                        onChange={handleChange}
                        onBlur={handleEnderecoBlur}
                        readOnly={isCepValid}
                    />
                </div>

                <div className="input-e-span">
                    <label htmlFor="numeroEdit" className="login-titulo">Número</label>
                    <input
                        id="numeroEdit"
                        type="text"
                        name="numeroResidencia"
                        className="form-control"
                        placeholder="Número da Residência"
                        value={formData.numeroResidencia}
                        onChange={handleChange}
                    />
                </div>

                <div className="input-e-span">
                    <label htmlFor="cidadeEdit" className="login-titulo">Cidade</label>
                    <input
                        id="cidadeEdit"
                        type="text"
                        name="cidade"
                        className="form-control"
                        placeholder="Cidade"
                        value={formData.cidade}
                        onChange={handleChange}
                        onBlur={handleEnderecoBlur}
                        readOnly={isCepValid}
                    />
                </div>

                <div className="input-e-span">
                    <label htmlFor="ufEdit" className="login-titulo">UF</label>
                    <input
                        id="ufEdit"
                        type="text"
                        name="uf"
                        className="form-control"
                        placeholder="UF"
                        value={formData.uf}
                        onChange={handleChange}
                        onBlur={handleEnderecoBlur}
                        readOnly={isCepValid}
                    />
                </div>
            </div>
        </>
    );
}