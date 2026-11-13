import { useLocation, useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import { usePsicologos } from "../../context/Psicologos";
import InfoPublicoPsicologo from "./InfoPublicoPsicologo.jsx";
import Calendario from "./Calendario.jsx";
import SobrePsicologo from "./SobrePsicologo.jsx";
import VerPsi from "../pop-ups/Verpsi.jsx";

export default function PerfilPublicoPsicologo() {
  const { id } = useParams();
  const location = useLocation();
  const { psicologos } = usePsicologos();
  const [perfil, setPerfil] = useState(null);
  const [openPsi, setOpenPsi] = useState(false);

  useEffect(() => {
    // 1️⃣ Se veio o perfil pelo navigate (state), usa ele direto
    if (location.state?.perfil) {
      setPerfil(location.state.perfil);
      return;
    }

    // 2️⃣ Se não veio, tenta buscar pelo contexto
    if (psicologos?.length > 0) {
      const encontrado = psicologos.find(p => String(p.id) === String(id));
      if (encontrado) {
        console.log("✅ Perfil encontrado no contexto:", encontrado);
        setPerfil(encontrado);
      }
    }
  }, [id, psicologos, location.state]);

  if (!perfil) return <div>Carregando perfil...</div>;

  return (
    <div className="container-section-perfil">
      <div className="sobre-notif-container">
        <InfoPublicoPsicologo />
        <SobrePsicologo />
      </div>

      <div className="perfil-container">
        <Calendario  />
         {openPsi && perfil && (
          <VerPsi
            open={openPsi}
            close={() => setOpenPsi(false)}
            perfil={perfil}
          />
         )}
      </div>
    </div>
  );
}
