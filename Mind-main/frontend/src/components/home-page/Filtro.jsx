import { useState } from "react";
import { HiChevronRight } from "react-icons/hi";

export default function Filtro({ 
    titulo, 
    opcoes = [], 
    selecionados, 
    setSelecionados 
}) {
  
    const [open, setOpen] = useState(false);
    
    const toggleFilter = () => setOpen(!open);
  
    const handleCheckboxChange = (opcao) => {
        setSelecionados((prev) =>
            prev.includes(opcao)
            ? prev.filter((item) => item !== opcao)
            : [...prev, opcao]
        );
    };
  
    return (
      <div className="filtro">
        <button type="button" className="button-confirm btn-searchbox" onClick={toggleFilter}>
          {titulo}
          <HiChevronRight
            className="seta-filtro"
            style={{
              transform: open ? "rotate(90deg)" : "rotate(0deg)",
              transition: "0.3s",
            }}
          />
        </button>
  
        {open && (
            <div className="checkbox-filter">
            {opcoes.map((opcao, i) => (
                <label key={i} className="checkbox-input">
                  <input
                    type="checkbox"
                    checked={selecionados.includes(opcao)}
                    onChange={() => handleCheckboxChange(opcao)}
                  />
                  <span className="titulo-checkbox">{opcao}</span>
                </label>
            ))}
          </div>
        )}
      </div>
    );
}
