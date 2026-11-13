export default function FormArticle() {
  return (
    <>
        <h2>Novo artigo</h2>
        <div className="containers-articles">
            <h4>Titulo</h4>
            <input id="nomeEdit" type="text"/>
        </div>
        <div className="containers-articles">
            <h4>Corpo do artigo</h4>
            <span>Escreva o assunto que queira publicar conforme o título de seu artigo, insira links de artigos científicos e noticias sobre saúde mental confiáveis que queria compartilhar.</span>
            <textarea type="text" rows="4"></textarea>
        </div>
        <div className="containers-articles">
            <h4>Referencias</h4>
            <span>Compartilhe as referencias necessárias para o acesso da veracidade das informações passadas durante o artigo</span>
            <textarea type="text" rows="4"></textarea>
        </div>
        <div className="container-atualizar-article">
            <button id="btnAtualizarPerfil" className="btns button-confirm">Criar/atualizar</button>
        </div>
        <div className="artigos-publicados">
            <h2>Artigos publicados</h2>
        </div>
    </>
  )
}
