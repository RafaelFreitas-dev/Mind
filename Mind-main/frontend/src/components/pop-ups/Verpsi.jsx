import { CgProfile } from "react-icons/cg";
import fotoPsi from '../../assets/img/perfil-default.png'
import Calendario from '../perfil-page/Calendario';
import "../../assets/styles/pop-ups/verpsi.css";
import { useNavigate } from "react-router-dom";


export default function VerPsi({ open = false, close = () => { }, perfil }) {
  const navigate = useNavigate();
  // não renderiza se modal fechado ou sem perfil
  if (!open || !perfil) return null;

  const nome = perfil.nome || "Sem nome";
  const local = perfil.local || "Sem localização";
  const idade = perfil.idade || "--";
  const tags = Array.isArray(perfil.tags) ? perfil.tags : (perfil.tags ? [perfil.tags] : []);
  const foto = perfil.foto || fotoPsi;
  const handleOpenProfile = () => {
  console.log("➡️ Enviando perfil para a rota:", perfil);
  navigate(`/perfil/psicologo/${perfil.id}`, { state: { perfil } });
};



  return (
    <div className="container-ver-psi">
      <div className="container-info-psi">
        <div className="container-dados">
          <h2>{nome}</h2>
          <p><b>Idade:</b> {idade}</p>
          <p><b>Local:</b> {local}</p>
          <button
            className="icon-btn icon-ui"
            onClick={handleOpenProfile}
          >
            <CgProfile />
          </button>

        </div>
        <div className="container-conhecimentos">
          <h2>Conhecimentos:</h2>
          {tags.length === 0 ? (
            <p style={{ margin: 0 }}>Nenhuma especialidade informada</p>
          ) : (
            tags.map((t, i) => (
              <span key={i} className="tag-chip" data-speciality={t}>{t}</span>
            ))
          )}
        </div>
        <img src={foto} alt={nome} />
      </div>
      <Calendario />
      <div className="container-agendar">
        <div className="container-legenda">
          <div className="tag-legenda">
            <span className="color-tag-ocupado"></span>
            <p>Ocupado</p>
          </div>
          <div className="tag-legenda">
            <span className="color-tag-livre"></span>
            <p>Em aberto</p>
          </div>
        </div>
        <div className="btn-agendar-cancelar">
          <button className="btn-cancelar" onClick={close}>Cancelar</button>
          <button className="btn-agendar">Agendar</button>
        </div>
      </div>
    </div>
  )
}
