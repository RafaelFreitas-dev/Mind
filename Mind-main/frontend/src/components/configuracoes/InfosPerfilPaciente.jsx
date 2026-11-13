import { getDefaultWallpaper } from "../../utils/imageHelper";
import { useRef } from "react";

export default function InfosPerfilPaciente({
    formData, 
    handleChange,
    imgWallpaper,
    novaWallpaper,
    chooseWallpaper
}) {
    const inputRef = useRef(null);
  return (
    <>
        <section className="container-perfil" 
             id="container-perfil"
             aria-labelledby="titulo-perfil">
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
                    <label className="sr-only" htmlFor="file-image-paciente" aria-hidden="true">Escolha uma imagem</label>
                    <input 
                        ref={inputRef}
                        id="file-image-paciente" 
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
                <label htmlFor="sobreMimEdit" className="login-titulo" >Sobre mim</label>
                <span id="descricao-sobre-mim">Escreva sobre você, condições médicas e diagnósticos recentes.</span>
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

            <div className="container-medicamento">
                <label id="Medicamento" htmlFor="medicamentosEdit" className="login-titulo">Medicamento</label>
                <span id="descricao-medicamentos">Escreva sobre medicamentos já em uso, périodo de seu consumo, e se necessário, efeitos colateras pessoais.</span>
                <textarea 
                    id="medicamentosEdit"
                    type="text"
                    name="medicamentos"
                    value={formData.medicamentos}
                    onChange={handleChange}
                    aria-labelledby="Medicamento"
                    aria-describedby="descricao-medicamentos"
                ></textarea>
            </div>

            <div className="container-preferencias">
                <label id="Preferencias" htmlFor="preferenciasEdit" className="login-titulo">Preferências</label>
                <span id="descricao-preferencia">Preferências de atendimento e assuntos</span>
                <textarea 
                    id="preferenciasEdit" 
                    type="text"
                    name="preferencias"
                    value={formData.preferencias}
                    onChange={handleChange}
                    aria-labelledby="Preferencias"
                    aria-describedby="descricao-preferencia"
                ></textarea>
            </div>
        </section>
    </>
  )
}