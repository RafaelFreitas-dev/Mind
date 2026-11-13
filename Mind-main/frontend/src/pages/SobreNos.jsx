import "../assets/styles/sobre-nos/sobre-nos.css"
import videoCall from "../assets/img/ilustracao_sobrenos.svg";
import therapySection from "../assets/img/imagem_sobrenos.jpg";
import {Link} from "react-router-dom"


export default function SobreNos() {
    
  return (
    <>
      <section className="container-sb-1">
        <img src={videoCall} alt="ilustração de uma video chamada" className="imagem-1"/>
        <div className="container-text-sb-1">
          <p>
              Nós, da Plataforma Mind - your mind, acreditamos que o bem-estar mental é fundamental para uma 
              vida saudável e equilibrada. Por isso, desenvolvemos uma plataforma que conecta pacientes a psicólogos
              qualificados, facilitando o acesso a cuidados psicológicos de qualidade.
          </p>
          <p>
              Assim, com a objetivo de democratizar o acesso à saúde mental, simplificamos o processo de busca 
              por ajuda profissional, ao formato online para um espaço seguro e acolhedor onde os pacientes possam 
              encontrar o apoio que precisam.
          </p>
        </div>
      </section>
      <section className="container-sb-2">
          <div className="container-text-sb-2">
              <p>
              Tendo uma lista diversificada de profissionais, facilitamos aos usuários que encontrem 
              psicólogos alinhados com suas necessidades e preferências. Também oferecendo a possibilidade 
              de auxilio aos profissionais recém-formados, ajudando-os a adquirir experiência na área da 
              psicologia.
              </p>
              <p>
                  Valorizamos o conforto, a empatia, a confidencialidade e a personalização em cada atendimento.
                  Por isso, nossa plataforma conta com recursos de avaliação de usuários e a 
                  possibilidade de agendar consultas online, tornando a experiência ainda mais acessível.
              </p>
              <p> 
                  Junte-se a nós e descubra como é fácil encontrar o suporte que você merece!
              </p>
              <div className="btn-area-sobrenos">
                <Link to="/#planos">
                    <button type="button" className="btn-sobre button-confirm">Conheça nossos planos</button>
                </Link>
              </div>
          </div>
          <img src={therapySection} alt="imagem de uma seção de terapia" className="imagem-2"/>
      </section>
    </>
  )
}
