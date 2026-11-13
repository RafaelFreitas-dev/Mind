import { useEffect } from "react";

export default function ApiLibras() {
  useEffect(() => {

    if (document.getElementById("vlibras-script")) return;
    
    const script = document.createElement("script");
    script.src = "https://vlibras.gov.br/app/vlibras-plugin.js";
    script.id = "vlibras-script";
    script.async = true;

    script.onload = () => {
      const initVLibras = () => {
        if (window.VLibras) {
          
          const container = document.createElement("div");
          container.setAttribute("vw", "");
          container.className = "enabled";
          container.innerHTML = `
            <div vw-access-button className="active"></div>
            <div vw-plugin-wrapper>
              <div className="vw-plugin-top-wrapper"></div>
            </div>
          `;
          document.body.appendChild(container);

          new window.VLibras.Widget("https://vlibras.gov.br/app");
          console.log("✅ VLibras inicializado com sucesso!");
        } else {
          console.warn("⏳ Aguardando VLibras...");
          setTimeout(initVLibras, 500);
        }
      };
      initVLibras();
    };

    document.body.appendChild(script);
  }, []);

  return null;
}
