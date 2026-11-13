import { HiOutlineX } from "react-icons/hi";
import "../../assets/styles/pop-ups/deletar.css";

export default function Deletar({ open = false, close = () => {}, onConfirm = () => {}, loading = false }) {
  if (!open) return null;
  
  const handleConfirm = () => {
    onConfirm();
  };
  
  return (
    <>
      <div className="pop-up-backdrop" onClick={close}></div>
      <div className="pop-up-deletar">
          <button 
            className="btn-cancelar-pop-up-deletar" 
            onClick={close}
            disabled={loading}>
            <HiOutlineX />
          </button>
          <h1>Deletar conta</h1>
          <span>Você tem certeza de que quer deletar a sua conta. Isso resultará na exclusão de seus dados, visibilidade aos psicólogos e qualquer informação adquirida pelo usuário durante a utilização da plataforma</span>
          <button 
            id='btnADeletarPerfil' 
            className="btn-deletar button-proceed"
            onClick={handleConfirm}
            disabled={loading}
            style={{
              opacity: loading ? 0.6 : 1,
              cursor: loading ? 'not-allowed' : 'pointer'
            }}
          >
            {loading ? 'Deletando...' : 'Confirmar'}
          </button>
      </div>
    </>
  )
}