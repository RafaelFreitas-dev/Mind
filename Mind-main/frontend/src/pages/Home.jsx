import SearchSection from "../components/home-page/SearchSection";
import AreaCards from "../components/home-page/AreaCards";
import VerPsi from "../components/pop-ups/Verpsi";
import ActiveFilters from "../components/home-page/ActiveFilters";
import { useState, useEffect } from "react";
import { usePsicologos } from "../context/Psicologos";
import '../assets/styles/home/filtros-home.css';
import '../assets/styles/home/card-psicologo.css';

export default function Home() {
  // Filtros
  const [selectedSpecialities, setSelectedSpecialities] = useState([]);
  const [selectedLocals, setSelectedLocals] = useState([]);
  const [visualizacao, setVisualizacao] = useState("col");
  const [selectedDays, setSelectedDays] = useState([]);
  const [selectedRatings, setSelectedRatings] = useState([]);
  const [searchText, setSearchText] = useState(""); // Texto de busca
  // Cards
  const [openPsi, setOpenPsi] = useState(false);
  const [selectedPerfil, setSelectedPerfil] = useState(null);

  const { psicologos, loading, error, recarregar } = usePsicologos();

  // Ao montar a Home, se a lista estiver vazia (erro ou fetch falhou antes do backend subir),
  // tenta buscar os dados de novo. O [] garante que só roda uma vez por montagem.
  useEffect(() => {
    if (!loading && (error || psicologos.length === 0)) {
      recarregar();
    }
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  // Mapear os dados dos psicólogos
  const perfis = (psicologos || []).map(p => ({
      id: p.id,
      nome: p.nome,
      idade: p.idade,
      local: p.local,
      tags: p.tags || [],
      foto: p.foto || null,
      horarios: p.horarios || {},
      // Dados extras disponíveis
      email: p.email,
      telefone: p.telefone,
      genero: p.genero,
      crp: p.crp,
      sobreMim: p.sobreMim
  }));

  // Extrair locais únicos dos perfis
  const locais = [...new Set(perfis.map(perfil => perfil.local))];

  // Aplicar filtros
  const perfisFiltrados = perfis.filter(perfil => {
      // Filtro de texto (busca por nome, especialidade, local)
      const matchTexto = searchText.trim() === "" || 
        perfil.nome.toLowerCase().includes(searchText.toLowerCase()) ||
        perfil.local.toLowerCase().includes(searchText.toLowerCase()) ||
        perfil.tags.some(tag => tag.toLowerCase().includes(searchText.toLowerCase())) ||
        (perfil.sobreMim && perfil.sobreMim.toLowerCase().includes(searchText.toLowerCase())) ||
        (perfil.crp && perfil.crp.toLowerCase().includes(searchText.toLowerCase()));
      
      const matchEspecialidade = selectedSpecialities.length === 0
          || perfil.tags.some(tag => selectedSpecialities.includes(tag));
      const matchLocal = selectedLocals.length === 0
          || selectedLocals.includes(perfil.local);
      
      return matchTexto && matchEspecialidade && matchLocal;
  });

  // Exibir estado de carregamento
  if (loading) {
    return (
      <>
        <SearchSection 
          selectedSpecialities={selectedSpecialities}
          setSelectedSpecialities={setSelectedSpecialities}
          selectedLocals={selectedLocals}
          setSelectedLocals={setSelectedLocals}
          locais={locais}
          selectedRatings={selectedRatings}
          setSelectedRatings={setSelectedRatings}
          selectedDays={selectedDays}
          setSelectedDays={setSelectedDays}
          visualizacao={visualizacao}
          setVisualizacao={setVisualizacao}
          searchText={searchText}
          setSearchText={setSearchText}
        />
        <div style={{ 
          textAlign: 'center', 
          padding: '3rem', 
          fontSize: '1.1rem',
          color: '#666' 
        }}>
          Carregando psicólogos...
        </div>
      </>
    );
  }

  // Exibir erro se houver
  if (error) {
    return (
      <>
        <SearchSection 
          selectedSpecialities={selectedSpecialities}
          setSelectedSpecialities={setSelectedSpecialities}
          selectedLocals={selectedLocals}
          setSelectedLocals={setSelectedLocals}
          locais={locais}
          selectedRatings={selectedRatings}
          setSelectedRatings={setSelectedRatings}
          selectedDays={selectedDays}
          setSelectedDays={setSelectedDays}
          visualizacao={visualizacao}
          setVisualizacao={setVisualizacao}
          searchText={searchText}
          setSearchText={setSearchText}
        />
        <div style={{ 
          textAlign: 'center', 
          padding: '3rem', 
          fontSize: '1.1rem',
          color: '#d32f2f' 
        }}>
          Erro ao carregar psicólogos: {error}
        </div>
      </>
    );
  }

  return (
    <>
      <SearchSection 
        selectedSpecialities={selectedSpecialities}
        setSelectedSpecialities={setSelectedSpecialities}
        selectedLocals={selectedLocals}
        setSelectedLocals={setSelectedLocals}
        locais={locais}
        selectedRatings={selectedRatings}
        setSelectedRatings={setSelectedRatings}
        selectedDays={selectedDays}
        setSelectedDays={setSelectedDays}
        visualizacao={visualizacao}
        setVisualizacao={setVisualizacao}
        searchText={searchText}
        setSearchText={setSearchText}
      />
      <AreaCards
        perfis={perfisFiltrados} 
        setSelectedPerfil={setSelectedPerfil} 
        setOpenPsi={setOpenPsi}
        visualizacao={visualizacao}
      />
      {openPsi && selectedPerfil && (
          <VerPsi
              open={openPsi}
              close={() => setOpenPsi(false)}
              perfil={selectedPerfil}
          />
      )}
    </>
  );
}