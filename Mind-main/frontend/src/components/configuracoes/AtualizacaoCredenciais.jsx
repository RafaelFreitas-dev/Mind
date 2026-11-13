export default function AtualizacaoCredenciais({ formData, handleChange }) {
  return (
    <>
        <div className="container-input-2">
            <div className="input-e-span">
                <label htmlFor="loginEdit" className="login-titulo">Nome do login</label>
                <input 
                    id="loginEdit" 
                    type="text"
                    name="login" 
                    className="form-control" 
                    placeholder="Login"
                    value={formData.login}
                    onChange={handleChange}
                />
            </div>
            <div className="input-e-span">
                <label htmlFor="emailEdit" className="login-titulo">E-mail</label>
                <input 
                    id="emailEdit" 
                    type="email"
                    name="email"
                    className="form-control" 
                    placeholder="E-mail"
                    value={formData.email}
                    onChange={handleChange}
                />
            </div>
            <div className="input-e-span">
                <label htmlFor="senhaEdit" className="login-titulo">Nova Senha (deixe em branco para manter)</label>
                <input 
                    id="senhaEdit" 
                    type="password"
                    name="senha" 
                    className="form-control" 
                    placeholder="Nova senha"
                    value={formData.senha}
                    onChange={handleChange}
                />    
            </div>
        </div>
    </>
  )
}