import CardPsicologos from "../cards/CardPsicologos"
import { HiChevronRight } from "react-icons/hi";

export default function AreaCards({
    perfis,
    setSelectedPerfil,
    setOpenPsi,
    visualizacao
}) {
  return (
    <>
        <section className="section-home">
            <div className={`area-card-psicologos ${visualizacao}`}>
                {perfis.length === 0 ? (
                    <div style={{ margin: '2rem', textAlign: 'center' }}>Nenhum resultado encontrado.</div>
                ) : (
                    <CardPsicologos
                        perfis={perfis}
                        setSelectedPerfil={setSelectedPerfil}
                        setOpenPsi={setOpenPsi}
                        classType={visualizacao}
                    />
                )}
            </div>
            <div className="container-botao-mais">
                <button className="button-mais">Mais
                    <HiChevronRight className="seta-filtro" id="seta-local-checkbox" />
                </button>
            </div>
        </section>
    </>
  )
}
