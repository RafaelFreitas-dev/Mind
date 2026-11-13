import "../../assets/styles/landing-page/planos.css";

export default function Planos() {

  const listPlanos = [
    {
      "title": "Acolhimento",
      "price": 50,
      "type": "por sessão",
      "topics": [
        "Sessões de acolhimento para alívio de angustias e tensões do dia a dia",
        "Recepção de curta duração de no máximo 30 minutos"
      ]
    },
    {
      "title": "Sessões psicológicas",
      "price": 90,
      "type": "por mês",
      "topics": [
        "Sessões que promovem acolhimento e possibilidades de transformações internas em uma abordagem profissional",
        "Apoio de no mínimo 1 hora com psicologos especializados a sua escolha"
      ]
    },
    {
      "title": "Casal",
      "price": 150,
      "type": "por sessão",
      "topics": [
        "Sessões que promovem acolhimento e possibilidades de transformações internas em uma abordagem profissional",
        "Apoio de no mínimo 1 hora com psicologos especializados a sua escolha"
      ]
    }
  ]

  return (
    <>
      <section id="planos" className="section-planos">
        <h1>Conheça nossos Planos</h1>

        <div className="container-plans">

          {listPlanos.map((item) => (
            <div key={item.title} className="cards">
              <div className="card-title">
                <h1>{item.title}</h1>
                <h2>R$ <span>{item.price}</span>/ {item.type}</h2>
              </div>
              <div className="card-topics">
                <ul>
                  {item.topics.map((list) => (
                    <li key={list}>{list}</li>
                  ))}
                </ul>
              </div>
              <button className="button-planos">Assinar</button>
            </div>
          ))}

        </div>
      </section>
    </>
  )
}
