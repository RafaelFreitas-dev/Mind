import React, { createContext, useContext, useState, useEffect } from 'react';

const PsicologosContext = createContext(null);

// Função para listar psicólogos SEM autenticação
async function listarPsicologosSemAuth() {
  const response = await fetch('http://localhost:8080/psicologos', {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
    }
  });

  if (!response.ok) {
    throw new Error('Erro ao buscar psicólogos');
  }

  return response.json();
}

export function PsicologosProvider({ children }) {
  const [psicologos, setPsicologos] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Buscar psicólogos do backend ao montar o componente
  useEffect(() => {
    async function carregarPsicologos() {
      try {
        setLoading(true);
        const dados = await listarPsicologosSemAuth();
        
        // Transformar os dados do backend para o formato esperado pelos componentes
        const psicologosFormatados = dados.map(p => ({
          id: p.id,
          nome: `${p.nome} ${p.sobrenome}`.trim(),
          idade: p.idade?.toString() || "N/A",
          local: p.endereco || "Local não informado",
          tags: p.especialidade ? [p.especialidade] : [],
          foto: p.imgPerfil || null,
          horarios: {}, // Pode ser implementado posteriormente
          // Dados adicionais que podem ser úteis
          email: p.email,
          telefone: p.telefone,
          genero: p.genero,
          crp: p.crp,
          sobreMim: p.sobreMim
        }));
        
        setPsicologos(psicologosFormatados);
        setError(null);
      } catch (err) {
        console.error("Erro ao carregar psicólogos:", err);
        setError(err.message);
        setPsicologos([]); // Manter array vazio em caso de erro
      } finally {
        setLoading(false);
      }
    }

    carregarPsicologos();
  }, []);

  function getById(id) {
    return psicologos.find(p => p.id === id) || null;
  }

  function getByName(nome) {
    return psicologos.find(p => p.nome.toLowerCase().includes(nome.toLowerCase())) || null;
  }

  // Função para recarregar os dados (útil após atualizações)
  async function recarregar() {
    try {
      setLoading(true);
      const dados = await listarPsicologosSemAuth();
      
      const psicologosFormatados = dados.map(p => ({
        id: p.id,
        nome: `${p.nome} ${p.sobrenome}`.trim(),
        idade: p.idade?.toString() || "N/A",
        local: p.endereco || "Local não informado",
        tags: p.especialidade ? [p.especialidade] : [],
        foto: p.imgPerfil || null,
        horarios: {},
        email: p.email,
        telefone: p.telefone,
        genero: p.genero,
        crp: p.crp,
        sobreMim: p.sobreMim
      }));
      
      setPsicologos(psicologosFormatados);
      setError(null);
    } catch (err) {
      console.error("Erro ao recarregar psicólogos:", err);
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <PsicologosContext.Provider value={{ 
      psicologos, 
      loading, 
      error, 
      getById, 
      getByName,
      recarregar 
    }}>
      {children}
    </PsicologosContext.Provider>
  );
}

export function usePsicologos() {
  const ctx = useContext(PsicologosContext);
  if (!ctx) throw new Error('usePsicologos must be used within PsicologosProvider');
  return ctx;
}