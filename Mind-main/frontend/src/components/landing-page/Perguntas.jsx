import "../../assets/styles/landing-page/perguntas.css";
import { HiChevronDown } from "react-icons/hi";
import { useState } from "react"
import {Link} from "react-router"

export default function Perguntas() {
  const [toggleQuestion, setToggleQuestion] = useState(null);

  let openQuestionBox = (index) => {
    setToggleQuestion(toggleQuestion === index ? null : index);
  }

  const listQuestions = [
    {
      "question": "Como funciona a terapia online?",
      "answer" : <p>A terapia online funciona como uma sessão tradicional, mas ocorre através de <span style={{ textDecoration: "underline" }}> videoconferência</span>. Você marca seu horário de acordo com a disponibilidade da agenda do psicologo escolhido, e se confirmado a sessão, o usuário receberá uma notificação em seu perfil da data e horário de registro, <span  style={{ backgroundColor: "#f8d982", padding: "2px 4px", borderRadius: "3px" }}>tendo início a consulta no tempo previsto de forma automatica, juntamente a entrada do profissional no ambiente de streaming </span>, sendo este privado e confidencial. Sendo tão eficaz quanto a terapia presencial para a maioria dos casos.</p>,
    },
    {
      "question": "Quanto tempo dura cada sessão?",
      "answer" : <p>Cada sessão tem duração média de 50 minutos, que é o padrão na psicologia clínica. A frequência (semanal, quinzenal ou mensal) será combinada entre você e o terapeuta, de acordo com suas necessidades.</p>,
    },
    {
      "question": "É realmente confidencial?",
      "answer" :  <p>Sim, utilizamos uma plataformas segura de apoio para videos chamadas e seguimos rigorosamente o <a href="https://www.crpsp.org/pagina/view/49" target="_blank" style={{textDecoration: "underline", color : "#16120D"}}>Código de Ética Profissional</a>. Suas sessões são protegidas por sigilo profissional, com exceção apenas dos casos previstos em lei (como risco de vida).</p>,
    },
    {
      "question": "Como saber se preciso de terapia?",
      "answer" : <p>A terapia pode ajudar em diversas situações: dificuldades emocionais, estresse, ansiedade, problemas de relacionamento, luto, ou simplesmente para autoconhecimento. Consultas psicologicas são para todos e não há uma restrição de necessidades, portanto não existem "problemas pequenos demais" para uma busca profissional. Qualquer duvida, temos uma sessão de artigos e noticias para você se interar sobre o assunto, <Link to="/artigos" style={{textDecoration: "underline", color :"#16120D"}}>aqui</Link>.</p>,
    },
  ]

  return (
    <>
      <section className="container-questions">
        <h1>Perguntas frequentes</h1>

        {listQuestions.map((item, index) => (
  <div key={item.question}>
            <button 
              className={`accordion ${toggleQuestion === index ? 'active' : ''}`}
              onClick={() => openQuestionBox(index)}>
                {item.question}
                <HiChevronDown className={`bi-icon ${toggleQuestion === index ? "arrow-icon" : ""}`}/>
            </button>

            <div 
              className="answer"
              style={{ display: toggleQuestion === index ? 'block' : 'none' }}>
              {item.answer}
            </div>
          </div>
        ))}

      </section>
    </>
  )
}
