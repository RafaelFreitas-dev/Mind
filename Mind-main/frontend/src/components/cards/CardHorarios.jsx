import { HiChevronDown } from "react-icons/hi";
import { useState, useEffect } from "react"
import { criarHorario, deletarHorario } from "../../services/horarioService";
import { useAuth } from "../../context/AuthContext";

export default function CardHorarios({ horario, onSaved, onDeleted, onRemoveTemp }) {
    const { user } = useAuth();
    const [isDropdownOpen, setDropdownOpen] = useState(false);
    
    const isExisting = !!horario?.id;

    const [diaDaSemana, setDiaDaSemana] = useState(horario?.diaDaSemana || "Segunda");
    const [horaInicio, setHoraInicio] = useState(horario?.horaInicio || "");
    const [horaFim, setHoraFim] = useState(horario?.horaFim || "");

    const [loading, setLoading] = useState(false);
    const [error, setError] = useState("");

    // Calcula os 40 min extras quando a hora de início muda
    const calculateHour = (hour) => {
        setHoraInicio(hour);
        const [hh, mm] = hour.split(":").map(Number)
        if (isNaN(hh) || isNaN(mm)) return;

        const data = new Date();
        data.setHours(hh, mm, 0, 0)
        data.setMinutes(data.getMinutes() + 40);

        setHoraFim(data.toTimeString().slice(0,5))
    }
    
    const handleConfirmar = async () => {
        if (!horaInicio || !horaFim) {
            setError("Por favor, preencha o horário inicial.");
            return;
        }

        setLoading(true);
        setError("");
        try {
            if (!isExisting) {
                await criarHorario({
                    psicologoId: user.id,
                    diaDaSemana,
                    horaInicio,
                    horaFim
                });
                onSaved();
            } else {
                // Não temos rota de PUT ainda. Confirmar não faz nada em já existentes para este escopo.
                setDropdownOpen(false);
            }
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

    const handleCancelarOuDeletar = async () => {
        if (!isExisting) {
            onRemoveTemp();
        } else {
            setLoading(true);
            try {
                await deletarHorario(horario.id);
                onDeleted();
            } catch (err) {
                setError(err.message);
                setLoading(false);
            }
        }
    };

    return (
    <>
        <div className="container-agendamento">
            {error && <div role="alert" style={{color: "red", fontSize: "14px", marginBottom: "5px"}}>{error}</div>}
            <div className="container-horario">
                <div className="inputs-horarios">
                    <label className="sr-only" htmlFor={`dia-${horario.id || horario.tempId}`}>
                        Dia da semana
                    </label>
                    <select 
                        value={diaDaSemana} 
                        onChange={e => setDiaDaSemana(e.target.value)}
                        disabled={isExisting}>
                        <option disabled hidden>Segunda</option>
                        <option value="Domingo">Domingo</option>
                        <option value="Segunda">Segunda</option>
                        <option value="Terca">Terça</option>
                        <option value="Quarta">Quarta</option>
                        <option value="Quinta">Quinta</option>
                        <option value="Sexta">Sexta</option>
                        <option value="Sabado">Sábado</option>
                    </select>

                    <label className="sr-only" htmlFor={`inicio-${horario.id || horario.tempId}`}>
                        Hora de início
                    </label>
                    <input 
                        type="time" 
                        value={horaInicio}
                        disabled={isExisting}
                        onChange={(e) => calculateHour(e.target.value)}/>
                    <label className="sr-only" htmlFor={`inicio-${horario.id || horario.tempId}`}>
                        Hora de início
                    </label>
                    <input 
                        type="time" 
                        disabled={true}
                        value={horaFim}/>
                </div>
                <div className="arrow-options">

                    <button 
                        type="button" 
                        id="abrir-options-agendamento"
                        onClick={() => setDropdownOpen(!isDropdownOpen)}
                        className={isDropdownOpen ? "" : "active" }
                        aria-expanded={!isDropdownOpen}>

                        <HiChevronDown />
                        <span className="sr-only">Abrir opções do horário</span>
                    </button>

                </div>
            </div>
            
            <div 
                className="container-confirmar" 
                id="options-agendamento" 
                style={{ display: isDropdownOpen ? 'none' : 'flex' }}
                aria-hidden={isDropdownOpen}>

                <button 
                  className="cancelar-agendamento button-cancelar" 
                  onClick={handleCancelarOuDeletar}
                  disabled={loading}>
                   {!isExisting ? "Cancelar" : (loading ? "Deletando..." : "Deletar")}
                </button>

                {!isExisting && (
                  <button 
                    className="confirmar-agendamento button-confirm" 
                    onClick={handleConfirmar}
                    disabled={loading}>
                     {loading ? "Salvando..." : "Confirmar"}
                  </button>
                )}
            </div>
        </div>
    </>
  )
}
