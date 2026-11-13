import '../../assets/styles/landing-page/hero-apresentacao.css';

import logomarca from '../../assets/img/logomarca.svg'
import logo from '../../assets/img/logo.svg'
import bg from "../../assets/img/Wallpaper01.png"
import bg2 from "../../assets/img/Wallpaper02.png"

import { Link } from 'react-router'

export default function Hero() {
  return (
    <>
      <main className="main">

        <span>
          <img className="bg2" src={bg2} alt="Imagem inicial do site" />
          <div className="heading-hero">
            <img src={logo} alt="logo do site" />
            <div className="heading-1">
              <img src={logomarca} alt="logomarca ou nome do sistema mind estilizado" />
              <h1>... your mind</h1>
            </div>
          </div>
          <p>A plataforma que tem cuidado com a sua saúde mental diária</p>
          <div className="buttons-hero">
          <Link
            to="/"
            onClick={(e) => {
              if (window.location.pathname === "/") {
                e.preventDefault();
                document.getElementById('planos')?.scrollIntoView({
                  behavior: 'smooth'
                });
              }
            }}>
            <button className="button-confirm" >Ver planos</button>
          </Link>
          <Link
            to="/login=0"
          >
            <button className="nav-btn-login btn-hero" >Começar</button>
          </Link>

        </div>
        </span>
        

      </main>
    </>
  )
}
