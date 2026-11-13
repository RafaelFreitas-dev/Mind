import { useEffect } from "react";
import termos from "../data/termos_de_uso.json";
import "../assets/styles/termos/termos.css";

/*
 * Página de Termos de Uso (rota /termos-e-condicoes).
 *
 * O texto vem de src/data/termos_de_uso.json, o MESMO arquivo usado no app
 * (mobile/assets/termos_de_uso.json). Para mudar o texto, edite o JSON e
 * copie a versão nova para os dois lugares.
 *
 * O conteúdo é renderizado como texto pelo React, sem dangerouslySetInnerHTML,
 * seguindo o controle contra XSS do plano de segurança (RS05).
 */

const comContato = (texto) => texto.replaceAll("{contato}", termos.contatoEmail);

// Rola até a seção sem mexer na rota atual.
function rolarPara(evento, id) {
  evento.preventDefault();
  document.getElementById(id)?.scrollIntoView({ behavior: "smooth", block: "start" });
}

function Bloco({ bloco }) {
  switch (bloco.tipo) {
    case "paragrafo":
      return <p>{comContato(bloco.texto)}</p>;
    case "lista":
      return (
        <ul className="termos-lista">
          {bloco.itens.map((item, i) => (
            <li key={i}>{comContato(item)}</li>
          ))}
        </ul>
      );
    case "subtitulo":
      return <h3 className="termos-subtitulo">{comContato(bloco.texto)}</h3>;
    case "aviso":
      return <p className="termos-aviso">{comContato(bloco.texto)}</p>;
    default:
      return null; // tipos de bloco desconhecidos são ignorados
  }
}

export default function TermosCondicoes() {
  useEffect(() => {
    const tituloAnterior = document.title;
    document.title = `${termos.titulo} | Mind`;
    return () => {
      document.title = tituloAnterior;
    };
  }, []);

  return (
    <main className="termos-page">
      {/* div, e não <header>: o navbar-footer.css estiliza todo <header> do site */}
      <div className="termos-header" id="termos-topo">
        <h1>{termos.titulo}</h1>
        <p className="termos-meta">
          Versão {termos.versao} · Última atualização: {termos.atualizadoEm}
        </p>
        {termos.introducao.map((texto, i) => (
          <p key={i} className="termos-intro">
            {comContato(texto)}
          </p>
        ))}
      </div>

      <aside className="termos-emergencia" role="note" aria-label={termos.emergencia.titulo}>
        <strong>{termos.emergencia.titulo}</strong>
        <p>{termos.emergencia.texto}</p>
      </aside>

      <nav className="termos-sumario" aria-label="Sumário dos Termos de Uso">
        <h2>Sumário</h2>
        <ol>
          {termos.secoes.map((secao) => (
            <li key={secao.id}>
              <a href={`#${secao.id}`} onClick={(e) => rolarPara(e, secao.id)}>
                {secao.titulo}
              </a>
            </li>
          ))}
        </ol>
      </nav>

      {termos.secoes.map((secao, i) => (
        <section
          key={secao.id}
          id={secao.id}
          className="termos-secao"
          aria-labelledby={`${secao.id}-titulo`}
        >
          <h2 id={`${secao.id}-titulo`}>
            <span className="termos-numero">{i + 1}.</span> {secao.titulo}
          </h2>
          {secao.blocos.map((bloco, j) => (
            <Bloco key={j} bloco={bloco} />
          ))}
        </section>
      ))}

      <p className="termos-voltar">
        <a href="#termos-topo" onClick={(e) => rolarPara(e, "termos-topo")}>
          Voltar ao topo
        </a>
      </p>
    </main>
  );
}
