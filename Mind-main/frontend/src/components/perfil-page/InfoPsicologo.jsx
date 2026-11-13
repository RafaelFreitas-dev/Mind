import { useAuth } from "../../context/AuthContext";
import { HiOutlinePhone, HiOutlineMail } from "react-icons/hi";
import fotoPsi from '../../assets/img/perfil-default.png';
import "../../assets/styles/perfil/info.css";
import { Link } from "react-router-dom";

export default function InfoPsicologo({ profileData }) {
  const { user } = useAuth();

  if (!profileData) return <p>Carregando...</p>;

  return (
    <div className="card-perfil-content">
      <div className="foto-perfil">
        <div className="banner-perfil"></div>
        <img id="perfilFoto" src={profileData.foto || fotoPsi} alt="Foto do Psicólogo" />
        <div className="info-perfil">
          <h3 id="perfilNome">{profileData.nome}</h3>

          <div className="container-info">
            <p id="perfilIdade">Idade:</p>
            <label>{profileData.idade || "idade teste"}</label>
          </div>

          <div className="container-info">
            <p id="perfilLocal">Local:</p>
            <label>{profileData.local || "local teste"}</label>
          </div>

          <div className="container-info">
            <p id="perfilLocal">CRP:</p>
            <label>{profileData.crp || ""}</label>
          </div>
        </div>
      </div>

      <div className="settings">
        <div className="container-contatos">
          <div className="contato">
            <button 
              type="button" 
              className="icon-btn icon-ui" 
              onClick={() => navigator.clipboard.writeText(profileData.telefone || "")}
            >
              <HiOutlinePhone />
            </button>
            <span>{profileData.telefone || "+55 11 9000-0000"}</span>
          </div>

          <div className="contato">
            <button 
              type="button" 
              className="icon-btn icon-ui" 
              onClick={() => navigator.clipboard.writeText(profileData.email || "")}
            >
              <HiOutlineMail />
            </button>
            <span>{profileData.local || "Cidade - UF"}</span>
          </div>
        </div>

        <div className="container-config-artigos">
          <Link to="/adicionar-artigos" className="button-config btn-mob">
            Criar Artigos
          </Link>
          <Link to={`/${user.tipo}/perfil/${user.id}/configuracoes`} className="button-config btn-mob">
            Configurações
          </Link>
        </div>
      </div>
    </div>
  );
}
