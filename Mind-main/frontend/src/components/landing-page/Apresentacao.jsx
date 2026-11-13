import { Link } from "react-router"
import apresentacao from "../../assets/img/home_img_3.svg"
import '../../assets/styles/landing-page/hero-apresentacao.css';

export default function Apresentacao() {
  return (
    <>
      <section id="apresentacao">

        <div className="sessoes-online-box">
          <div className="tittle-box">
            <h3>Cuide-se</h3>
          </div>
          <div className="block-left">
            <h4>Sessões <span className="destaque">Online</span></h4>
            <p>Aqui nossa missão é tornar o cuidado psicológico acessível a todos, oferecendo uma plataforma intuitiva que conecta você a psicólogos qualificados, de forma simples e segura.</p>
          
          <span className="btn-article">
            <Link to="/sobre-nos">
              <button className="conhecer-btn button-confirm">Conhecer!</button>
            </Link>
          </span>
          </div>

        </div>

        <article className="block-right">
          <h4>Horários flexiveis</h4>
          <p>Aqui você tem flexibilidade: a plataforma funciona o tempo todo e você pode marcar seu atendimento no horário que fizer mais sentido para você</p>
          <img className="apres-img" src={apresentacao} alt="ilustração - simulando video chamada" />
        </article>

      </section>
    </>
  )
}
