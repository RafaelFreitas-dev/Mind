import InfosGerais from "./InfosGerais"
import AtualizacaoCredenciais from "./AtualizacaoCredenciais"
import InfosPerfilPsicologo from "./InfosPerfilPsicologo"
import InfosPerfilPaciente from "./InfosPerfilPaciente"
import Deletar from "../pop-ups/Deletar"
import Horarios from "./Horarios";
import { useRef } from "react";
import { getImageUrl, getDefaultAvatar } from "../../utils/imageHelper";

export default function ConfiguracoesViewPage({
    user,

    imgPerfil,
    novaImagem,
    chooseImgPerfil,

    imgWallpaper,
    novaWallpaper,
    chooseWallpaper,

    handleAtualizarPerfil,
    handleDeletarConta,
    salvando,
    deletando,
    isOpen,
    setIsOpen,
    formData,
    handleChange,
    handleCepBlur,
    handleEnderecoBlur,

    especializacoes,
    novaEspecializacao,
    setNovaEspecializacao,
    adicionarEspecializacao,
    removerEspecializacao
}) {
    const inputRef = useRef(null);
  return (
    <>
        <section className="config">
            <div className="container-section">
                <div className="container-img">
                    <div className="img-options" id="configPageForm">
                        <img 
                            id="imagePreview" 
                            src={imgPerfil || getDefaultAvatar()}
                            alt={novaImagem ? "Pré-visualização da foto de perfil" : "Foto de perfil atual"}
                            className="imgEdit"
                            onError={(e) => {
                                e.currentTarget.onerror = null;
                                e.currentTarget.src = getDefaultAvatar();
                            }}
                        />
                        
                        <label className="sr-only" htmlFor="file-image" aria-hidden="true">Escolha uma imagem</label>
                        <input 
                            ref={inputRef}
                            id="file-image" 
                            type="file" 
                            accept="image/*" 
                            aria-hidden="true"
                            onChange={chooseImgPerfil}
                        />
                        <button
                            type="button"
                            className="btns button-confirm btns-image"
                            onClick={() => inputRef.current.click()}>
                            {novaImagem ? 'Foto Selecionada' : 'Mudar Foto'}
                        </button>
                    </div>
                    <nav aria-label="Seções das configurações">
                        <ul className="atalhos">
                            <li><a href="#formAtualizar" id="Geral">Geral</a></li>
                            <li><a href="#container-perfil" id="Perfil">Perfil</a></li>
                            {user?.tipo === "psicologo" && (
                                <li><a href="#container-horario-atendimento" id="Horarios">Horarios de atendimentos</a></li>
                            )}
                            <li><a href="#deletar-conta" id="Deletar">Deletar conta</a></li>
                        </ul>
                    </nav>
                </div>

                <form onSubmit={handleAtualizarPerfil} aria-labelledby="configPageForm" className="container-inputs container-perfil" id="formAtualizar">
                    <h1>Geral</h1>

                    <div>
                        <InfosGerais 
                            formData={formData}
                            handleChange={handleChange}
                            handleCepBlur={handleCepBlur}
                            handleEnderecoBlur={handleEnderecoBlur} />
                        <AtualizacaoCredenciais 
                            formData={formData}
                            handleChange={handleChange} />

                        {user?.tipo === "psicologo" ? (
                            <InfosPerfilPsicologo
                                imgWallpaper={imgWallpaper}
                                novaWallpaper={novaWallpaper}
                                chooseWallpaper={chooseWallpaper}

                                especializacoes={especializacoes}
                                novaEspecializacao={novaEspecializacao}
                                setNovaEspecializacao={setNovaEspecializacao}
                                adicionarEspecializacao={adicionarEspecializacao}
                                removerEspecializacao={removerEspecializacao}

                                formData={formData}
                                handleChange={handleChange}/>
                        ) : (
                            <InfosPerfilPaciente
                                formData={formData}
                                handleChange={handleChange}
                            />
                        )}
                        
                        {user?.tipo === "psicologo" && (
                            <Horarios />
                        )}

                        <div className="container-atualizar">
                            <button 
                                id="btnAtualizarPerfil" 
                                className="button-confirm"
                                type="submit"
                                disabled={salvando}
                                style={{ 
                                    opacity: salvando ? 0.6 : 1,
                                    cursor: salvando ? 'not-allowed' : 'pointer'
                                }}
                            >
                                {salvando ? 'Salvando...' : 'Atualizar perfil'}
                            </button>
                        </div> 
                    </div>

                </form>
            </div>

            <div className="container-deletar" id="deletar-conta">
                <span>Uma vez deletada sua conta, não será possível recupera-la. Tenha certeza!</span>
                <button 
                    className="btn-deletar button-attention" 
                    id="btn-abrir-pop-up"
                    onClick={() => setIsOpen(true)}
                    disabled={deletando}
                >
                    Deletar conta
                </button>
            </div>

            <Deletar 
                open={isOpen} 
                close={() => setIsOpen(false)}
                onConfirm={handleDeletarConta}
                loading={deletando}
            />
        </section>
    </>
  )
}
