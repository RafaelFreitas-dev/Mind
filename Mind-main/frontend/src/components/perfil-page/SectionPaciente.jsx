import "../../assets/styles/perfil/section.css";
import Info from './Info.jsx';
import Calendario from './Calendario.jsx';
import Sobre from './Sobre.jsx';
import Notificacoes from './Notificacoes.jsx';
import Logout from './Logout.jsx';

export default function SectionPaciente({ profileData }) {
    return (
        <div className="container-section-perfil">
            <div className="sobre-info-container">
               <Info profileData={profileData} />
                <Sobre profileData={profileData} />
            </div>
            <div className="perfil-container">
                <Logout />
                <Calendario id={profileData?.id} />
                <Notificacoes id={profileData?.id} />
            </div>
        </div>
    );
}
