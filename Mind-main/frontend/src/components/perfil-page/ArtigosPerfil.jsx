import { useState } from "react";
import { FaSearch, FaEye, FaThumbsUp } from "react-icons/fa";
import "../../assets/styles/perfil/artigos-perfil.css";

export default function ArtigosPerfil({ id }) {

  const [busca, setBusca] = useState("");

  const artigos = [
    {
      id: 1,
      titulo: "Titulo",
      descricao:
        "Lorem ipsum dolor sit amet consectetur. Venenatis bibendum odio diam magna vitae sit urna molestie imperdie...",
      likes: 15,
      views: 20,
    },
    {
      id: 2,
      titulo: "Titulo",
      descricao:
        "Lorem ipsum dolor sit amet consectetur. Venenatis bibendum odio diam magna vitae sit urna molestie imperdie...",
      likes: 15,
      views: 20,
    },
  ];

  const artigosFiltrados = artigos.filter((artigo) =>
    artigo.titulo.toLowerCase().includes(busca.toLowerCase())
  );

  return (
    <div className="artigos-container">

      <div className="artigos-header">
        <h2>Artigos Publicados</h2>

        <div className="search-box">
          <input
            type="text"
            placeholder="Buscar artigo..."
            value={busca}
            onChange={(e) => setBusca(e.target.value)}
          />
          <FaSearch />
        </div>
      </div>

      <div className="artigos-lista">
        {artigosFiltrados.map((artigo) => (
          <div className="artigo-card" key={artigo.id}>

            <div className="artigo-info">
              <h3>{artigo.titulo}</h3>

              <p>{artigo.descricao}</p>

              <div className="artigo-stats">
                <span>
                  <FaThumbsUp /> {artigo.likes}
                </span>

                <span>
                  <FaEye /> {artigo.views}
                </span>
              </div>
            </div>

            <button className="btn-ver">
              Ver
            </button>

          </div>
        ))}
      </div>

    </div>
  );
}