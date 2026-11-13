import { Link } from "react-router-dom";
import { useAuth } from "../../context/AuthContext";
import { Bookmark, Clock } from "lucide-react";
import "../../assets/styles/perfil/notificacoes.css";

export default function Notificacoes() {
  const { user } = useAuth();

  return (
    <div className="notif-container">

      <div className="notif-header">
        <h1>Próximas</h1>
      </div>

      <div className="notif-card">
        <div className="notif-left">
          <div className="icon-green">
            <Bookmark size={28} />
          </div>
          <span className="notif-date">13/03</span>
        </div>

        <Link to={`/${user.tipo}/perfil/${user.id}/video-chamada`}>
          <button className="btn-start">Iniciar</button>
        </Link>
      </div>

      <div className="notif-card">
        <div className="notif-left">
          <div className="icon-orange">
            <Clock size={28} />
          </div>
          <span className="notif-date">20/03</span>
        </div>

        <button className="btn-view">Ver</button>
      </div>

      <div className="notif-card">
        <div className="notif-left">
          <div className="icon-green">
            <Bookmark size={28} />
          </div>
          <span className="notif-date">27/03</span>
        </div>

        <button className="btn-view">Ver</button>
      </div>

    </div>
  );
}