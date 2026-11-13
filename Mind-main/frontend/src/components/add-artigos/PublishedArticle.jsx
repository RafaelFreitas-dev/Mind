import CardArtigos from "../cards/CardArtigos";
import articles from "../../assets/img/articles.png";

export default function PublishedArticle() {
    const infoTest = [
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

  return (
    <>
        {infoTest.map((item, i) => (
            <CardArtigos key={i} info={item}/>
        ))}
    </>
  )
}
