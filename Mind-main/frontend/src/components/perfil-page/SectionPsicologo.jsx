import "../../assets/styles/perfil/section.css";
import InfoPsicologo from './InfoPsicologo.jsx';
import Calendario from './Calendario.jsx';
import SobrePsicologo from './SobrePsicologo.jsx';
import Notificacoes from './Notificacoes.jsx';
import Logout from './Logout.jsx';
import ArtigosPerfil from './ArtigosPerfil.jsx';

export default function SectionPsicologo({ profileData }) {
    return (
        <div className="container-section-perfil">
            <div className="sobre-notif-container">
                <InfoPsicologo profileData={profileData} />
                <SobrePsicologo profileData={profileData} />
                <ArtigosPerfil id={profileData?.id} />
            </div>
            <div className="perfil-container">
                <Logout />
                <Calendario id={profileData?.id} />
                <Notificacoes id={profileData?.id} />
            </div>
            
        </div>
    );
}
