import { getDefaultWallpaper } from "../../utils/imageHelper";
import { useRef } from "react";

import { HiOutlineX } from "react-icons/hi";

export default function InfosPerfilPsicologo({ 
    formData, 
    handleChange,
    imgWallpaper,
    novaWallpaper,
    chooseWallpaper,
    especializacoes,
    adicionarEspecializacao,
    removerEspecializacao,
}) {
    const inputRef = useRef(null);
    const tagsEspecializacoes = [
        "Ansiedade",
        "Depressão",
        "Relacionamentos",
        "Autoestima",
        "Estresse",
    ];

  return (
    <>
        <section className="container-perfil" id="container-perfil" aria-labelledby="titulo-perfil">
            <h1 id="titulo-perfil">Perfil</h1>
            <div className="img-wallpaper">
                <img 
                    src={imgWallpaper || getDefaultWallpaper()}
                    alt="Wallpaper do perfil"
                    className="img-edit-wallpaper"
                    onError={(e) => {
                        e.currentTarget.onerror = null;
                        e.currentTarget.src = getDefaultAvatar();
                    }}
                />

                <div>
                    <label className="sr-only" htmlFor="file-image-psicologo" aria-hidden="true">Escolha uma imagem</label>
                    <input 
                        ref={inputRef}
                        id="file-image-psicologo" 
                        type="file" 
                        accept="image/*" 
                        aria-hidden="true"
                        onChange={chooseWallpaper}
                    />
                    <button
                        type="button"
                        className="btns button-confirm btns-image"
                        onClick={() => inputRef.current.click()}>
                        {novaWallpaper ? 'Wallpaper selecionado' : 'Mudar Wallpaper'}
                    </button>
                </div>  
            </div>

            <div className="container-sobre-mim">
                <label htmlFor="sobreMimEdit" className="login-titulo">Sobre mim</label>
                <span id="descricao-sobre-mim">Escreva sobre você, formações, histórico de estudos recentes, artigos publicados em portais de periodicos ou revistas cientificas</span>
                <textarea 
                    id="sobreMimEdit" 
                    type="text" 
                    name="sobreMim"
                    value={formData.sobreMim}
                    onChange={handleChange}
                    rows="4"
                    aria-describedby="descricao-sobre-mim"
                ></textarea>
            </div>

            <div className="container-especializacoes">
                <label htmlFor="especializacoesEdit" className="login-titulo">Especializações</label>
                <span id="descricao-especializacoes">Escolha as especializações que mais combinam com o seu perfil profissional.</span>
                <select
                    id="especializacoesEdit"
                    className="tags-especializacoes-input"
                    aria-describedby="descricao-especializacoes"
                    onChange={(e) => {
                        adicionarEspecializacao(e.target.value);
                        e.target.value = ""; // reseta
                    }}
                    defaultValue="">
                    <option value="" disabled>
                        Selecione uma especialização
                    </option>

                    {tagsEspecializacoes.map((esp) => (
                        <option key={esp} value={esp}>
                            {esp}
                        </option>
                    ))}
                </select>

                <ul className="tags-list" aria-label="especialidades selecionadas">
                    {especializacoes.map((esp) => (
                        <li key={esp} className="tag-item">
                            <span>{esp}</span>
                            <button
                                className="btn-remove-tag"
                                type="button"
                                onClick={() => removerEspecializacao(esp)}
                                aria-label={`Remover especialização ${esp}`}
                            >
                                <HiOutlineX />
                            </button>
                        </li>
                    ))}
                </ul>

            </div>
        </section>
    </>
  )
}