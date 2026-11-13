import { HiArrowNarrowUp } from "react-icons/hi";
import "../../assets/styles/landing-page/infos.css"
import { Link } from "react-router"

export default function Informacoes() {

  const listInfo = [
    {
      "id" : 1,
      "title": "Objetivos de saúde mundial",
      "text": "Servindo como apoio para o cumprimentos dos objetivos da Organização Mundial da Saúde"
    },
    {
      "id" : 2,
      "title": "15% de carga global",
      "text": "Em cada sete jovens de 10 a 19 anos sofre de um transtorno mental"
    },
    {
      "id" : 3,
      "title": "86%",
      "text": "Dos brasileiros sofrem com algum tipo de transtorno mental"
    },
    {
      "id" : 4,
      "title": "5,8% tem quadro de depressão",
      "text": "A depressão atinge 5,8% da população brasileira, segundo a OPAS (Organização Pan-Americana de Sáude)"
    }
  ]

  return (
    <>
      <section className="section-info">
        <h1>A terapia online pode ti apoiar</h1>
        <p> A mind oferece um espaço seguro e sigiloso para falar sobre suas emoções sem precisar sair de casa. Podendo ser útil em situações do dia a dia — como dificuldades no trabalho, desafios nos relacionamentos, crises de ansiedade ou momentos de incerteza.</p>
        <div className="info-grid">

          {listInfo.map((item) => (
            <div key={item.id} className={`info info-${item.id}`}>
              <h2>{item.title}</h2>
              <p>{item.text}</p>
            </div>
          ))}
    
        </div>
        <div className="btn-ver-mais">
          <Link to="/artigos">
            <button>Ver mais <HiArrowNarrowUp className="icon-btn-ver-mais"/></button>
          </Link>
        </div>
      </section>
    </>
  )
}
