import { HiOutlineReply } from "react-icons/hi";

export default function FullArticle({info, open = false, close = () => {}}) {
    if (!open) return null;
    return (
        <>  
            <div className="pop-up-backdrop" onClick={close}></div>
            <main className="pop-up-article-open" >
                <button className="btn-article-popup button-open-pop-up" onClick={close}>
                    <HiOutlineReply />
                    <span>Voltar</span>
                </button>
                <article className="pop-up-full-article">
                    <img src={info.img} alt="imagem do artigo aberto para leitura" className="img-full-article"/>
                    <h1>{info.title}</h1>
                    <span>{info.autor}</span>
                    <p>{info.text}</p>
                    <h2>Referencias</h2>
                    <p>{info.references.map((ref, i) => (
                        <li key={i} className="references-item">
                            <a href={ref} target="_blank">
                                {ref}
                            </a>
                        </li>
                    ))}</p>
                </article>
            </main>
        </>
    )
}
