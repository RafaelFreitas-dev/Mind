import '../../assets/styles/perfil.css';
import Info from './Info.jsx';
import Calendario from './Calendario.jsx';
import Sobre from './Sobre.jsx';
import Notificacoes from './Notificacoes.jsx';


export default function Section() {

    return (
        <>
            <div className="container-section-perfil">
                <div className="perfil-container">
                    <Info />
                    <Calendario />
                </div>
                <div className="sobre-notif-container">
                    <Sobre />
                    <Notificacoes />
                </div>
            </div>
        </>
    )
}