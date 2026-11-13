import { CiGrid2H } from "react-icons/ci";
import { CiGrid2V } from "react-icons/ci";

export default function Visualizacao({ visualizacao, setVisualizacao }) {
    
    return (
        <>
            <div className="container-visualizacao">
                <h3>Visualização</h3>
                <div className="col-and-row">
                    <button
                        title="Cards na vertical"
                        className={`button-col icon-ui
                            ${visualizacao === "col" ?
                            " active" : ""}`}
                        onClick={() => setVisualizacao("col")}
                    >
                        <CiGrid2V className="icon-button" />
                    </button>
                    <button
                        title="Cards na horizontal"
                        className={`button-row icon-ui
                            ${visualizacao === "row" ? 
                            " active" : ""}`}
                        onClick={() => setVisualizacao("row")}
                    >
                        <CiGrid2H className="icon-button" />
                    </button>
                </div>
            </div>
        </>
    )
}
