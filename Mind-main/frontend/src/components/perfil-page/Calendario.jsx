import React, { useState } from "react";
import "../../assets/styles/perfil/calendario.css";
import { HiChevronLeft, HiChevronRight } from "react-icons/hi";

const diasSemana = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"];

function formatDia(date) {
  return date.toISOString().split("T")[0];
}

function gerarDiasCalendario(data) {

  const ano = data.getFullYear();
  const mes = data.getMonth();

  const primeiroDia = new Date(ano, mes, 1);
  const ultimoDia = new Date(ano, mes + 1, 0);

  const dias = [];

  const inicio = primeiroDia.getDay();
  const totalDias = ultimoDia.getDate();

  const ultimoDiaMesAnterior = new Date(ano, mes, 0).getDate();

  // dias do mês anterior
  for (let i = inicio - 1; i >= 0; i--) {
    dias.push(new Date(ano, mes - 1, ultimoDiaMesAnterior - i));
  }

  // dias do mês atual
  for (let i = 1; i <= totalDias; i++) {
    dias.push(new Date(ano, mes, i));
  }

  // dias do próximo mês
  let proxDia = 1;

  while (dias.length % 7 !== 0) {
    dias.push(new Date(ano, mes + 1, proxDia));
    proxDia++;
  }

  return dias;
}


export default function Calendario() {

  const hoje = new Date();

  const [mesAtual, setMesAtual] = useState(new Date());
  

  const diasCalendario = gerarDiasCalendario(mesAtual);


  function mesAnterior() {
    const novaData = new Date(mesAtual);
    novaData.setMonth(novaData.getMonth() - 1);
    setMesAtual(novaData);
  }

  function mesProximo() {
    const novaData = new Date(mesAtual);
    novaData.setMonth(novaData.getMonth() + 1);
    setMesAtual(novaData);
  }

  return (
    <div className="container-calendario">

      <h1>Agenda</h1>

      <div className="header-calendario">

        <button onClick={mesAnterior} className="button-seta-calendario">
          <HiChevronLeft />
        </button>

        <h2>
          {mesAtual.toLocaleString("pt-BR", {
            month: "long",
          })}
        </h2>

        <button onClick={mesProximo} className="button-seta-calendario">
          <HiChevronRight />
        </button>

      </div>

      <div className="grid-calendario">

        {diasSemana.map((dia, i) => (


          <div key={i} className="dia-semana">
            {dia}
          </div>
        ))}

        {diasCalendario.map((dia, i) => {

          const isHoje =
            dia &&
            dia.getDate() === hoje.getDate() &&
            dia.getMonth() === hoje.getMonth() &&
            dia.getFullYear() === hoje.getFullYear();

          const isOutroMes =
            dia && dia.getMonth() !== mesAtual.getMonth();

          return (
            <div
              key={i}
              className={`dia-calendario 
      ${isHoje ? "dia-hoje" : ""} 
      ${isOutroMes ? "dia-outro-mes" : ""}`}

            >

              <div className="numero-dia">
                {dia ? dia.getDate() : ""}
              </div>

            </div>
          );
        })}


      </div>
      <div className="container-legenda">
        <div className="block-legenda">
          <span className="consulta-marcada"></span>
          <p>Consuta-marcada</p>
        </div>
        <div className="block-legenda">
          <span className="consulta-nao-confirmada"></span>
          <p>Consulta não confirmada</p>
        </div>
      </div>
    </div>
  );
}