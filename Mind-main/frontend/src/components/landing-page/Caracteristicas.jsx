import { 
  HiOutlinePuzzle, 
  HiOutlineLightBulb, 
  HiOutlineUserGroup, 
  HiOutlineEye } from "react-icons/hi";

import "../../assets/styles/landing-page/caracteristicas.css"

export default function Caracteristicas() {

  // informações de cada card
  const listCaract = [
    {
      "title": "Especialidades",
      "icon": <HiOutlinePuzzle className="bi-icon"/>,
      "text": "Com variadas especialidades, nossos profissionais tem como foco o aprimoramento de suas abordagens para o melhor atendimento."
    },
    {
      "title": "Profissionas",
      "icon": <HiOutlineUserGroup className="bi-icon"/>,
      "text": "Nossos profissionais são altamente capacitados e estão sempre inovando para proporcionar um atendimento humanizado e eficiente."
    },
    {
      "title" : "Conhecimento",
      "icon": <HiOutlineLightBulb className="bi-icon"/>,
      "text": "Valorizamos o conhecimento contínuo para garantir que cada atendimento seja baseado nas melhores práticas e técnicas atualizadas."
    },
    {
      "title": "Cuidado",
      "icon": <HiOutlineEye className="bi-icon"/>,
      "text": "O cuidado está no centro de tudo o que fazemos, garantindo que cada pessoa receba um atendimento atencioso e personalizado"
    }
  ]

  return (
    <>
      <section className="section-caract">
        <h1>Aqui você encontra</h1>

        <article className="container-goals">
          {listCaract.map((item, index) => (
            <div key={index} className="goal">
                <span>
                    {item.icon}
                    <h2>{item.title}</h2>
                </span>
                <p>{item.text}</p>
            </div>
          ))}
        </article>

      </section>
    </>
  )
}