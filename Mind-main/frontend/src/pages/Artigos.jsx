import "../assets/styles/artigos/artigos.css"
import CardArtigos from "../components/cards/CardArtigos"
import article01 from "../assets/img/article01.jpg";
import article02 from "../assets/img/article02.jpg";
import articles from "../assets/img/articles.png";


export default function Artigos() {

  const infoTest = [
    {
      id: 1,
      img: article01,
      tipo: "destaque", 
      title: "Importância da consulta psicologica",
      autor: "@LuigiAmaral",
      text:  "Segundo a OMS em seu relatório sobre Saúde Mental Global ao cumprimento dos objetivos de saúde entre 2013 a 2030. A saúde mental existe em um processo complexo e contínuo de experiências que variam de um estado de bem-estar a estados debilitantes de grande sofrimento e dor emocional.Problemas como crises econômicas, polarização social, emergências de saúde pública e humanitárias generalizadas, deslocamento forçado e a crescente crise climáticas expõe circunstâncias como pobreza, violência e desigualdade como principal elemento de risco ao sofrimentos de problemas de saúde mental.Portanto, nos da Mind, assim como os Objetivos da ODS, temos o compromisso de influenciar no debate sobre saúde mental e disponibilizar um ambiente acolhedor para o bem-estar social. Tendo assim a ciência popular que a sáude psicológica é valida e é um direito de todos",
      references: [
        "https://www.who.int/teams/mental-health-and-substance-use/world-mental-health-report"
      ]
    },
    {
      id: 2,
      img: article02,
      tipo: "destaque", 
      title: "Números de emergência para segurança pessoal",
      autor: "@LuigiAmaral",
      text:  <p> Em situações de risco, ter acesso rápido aos números de emergência é essencial para garantir a segurança e o atendimento adequado. No Brasil, diversos serviços públicos estão disponíveis 24 horas por dia para atender a população em casos de urgência. <br /> A Polícia Militar (190) é o contato imediato para ocorrências de segurança pública, como assaltos, violência doméstica ou perturbação da ordem. Já o Corpo de Bombeiros (193) atua em incêndios, acidentes de trânsito, resgates e salvamentos diversos. <br /> Para emergências médicas, o SAMU (192) é responsável pelo atendimento pré-hospitalar, enviando ambulâncias equipadas com profissionais de saúde. <br /> Outros números também são fundamentais: a Polícia Civil (197) para investigações e denúncias, a Polícia Rodoviária Federal (191) e a Polícia Rodoviária Estadual (198) para ocorrências em rodovias. Além disso, a Defesa Civil (199) atua em situações de desastres naturais, como enchentes e deslizamentos. <br /> Há ainda o Disque Denúncia (118) e a Guarda Municipal (153), que reforçam a segurança local e recebem informações da população para prevenir crimes e garantir a ordem. Conhecer e divulgar esses números pode salvar vidas, facilitar o trabalho das autoridades e garantir que o socorro chegue de forma mais rápida e eficiente. </p> ,
      references: []
    },
    {
      id: 3,
      img: articles,
      tipo: "normal", 
      title: "Lorem ipsum dolor sit amet consectetur adipisicing elit.",
      autor: "@Unknown",
      text:  "Lorem, ipsum dolor sit amet consectetur adipisicing elit. Vel blanditiis veniam veritatis alias, iure tempora. Natus aperiam nisi accusantium neque explicabo quisquam? Voluptates quod esse, eaque molestiae eligendi ab nam perferendis! Consequatur at porro deleniti debitis suscipit adipisci nam magni quidem! Nesciunt delectus numquam, voluptatum aliquid ea eius soluta? Optio alias sed inventore quasi aperiam, incidunt illo soluta earum voluptas neque non ipsam voluptatum tenetur consectetur ea hic corrupti officia animi! Natus similique mollitia a et quos ut itaque cupiditate tempora, autem vero exercitationem minima non molestias cum sit. Mollitia officia exercitationem fugiat incidunt quo neque culpa libero eaque omnis.",
      references: []
    }
  ]

  let tipoDestaque = infoTest.filter((info) => info.tipo == "destaque")
  let tipoNormal = infoTest.filter((info) => info.tipo == "normal")


  return (
    <>
      <main className="artigo-sect">
          <h1>Artigos de Saúde Mental</h1>
          <h2>Rápidas dicas e recomendações sobre saúde mental e segurança pessoal para o seu dia a dia</h2>
          <hr/> 
          <section id="local_dos_artigos" className="artigos">

            <main className="destaques">
              <h3>Destaques</h3>
              {tipoDestaque.map((info, i) => (
                <CardArtigos key={i} info={info} styleArticle={"column"}/>
              ))}
            </main>

            <aside className="outros-artigos">
              <h3>Outros artigos</h3>
              {tipoNormal.map((info, i) => (
                <CardArtigos key={i} info={info}/>
              ))}
            </aside>

          </section>
      </main>
    </>
  )
}
