import { useAuth } from "../context/AuthContext";
import { useParams, Navigate } from "react-router-dom";

// importa as sections específicas
import SectionPsicologo from "../components/perfil-page/SectionPsicologo";
import SectionPaciente from "../components/perfil-page/SectionPaciente";
import { buscarPorId as buscarPaciente } from "../services/pacienteService";
import { buscarPorId as buscarPsicologo } from "../services/psicologoService";
import { useState, useEffect } from "react";

export default function Perfil() {
  const { user, loading } = useAuth();
  const { id, tipo } = useParams();
  const [profileData, setProfileData] = useState(null);
  const [loadingProfile, setLoadingProfile] = useState(true);

  useEffect(() => {
    async function loadProfile() {
      if (!user) return;
      try {
        setLoadingProfile(true);
        if (tipo.toLowerCase() === "psicologo") {
          const data = await buscarPsicologo(id);
          setProfileData(data);
        } else if (tipo.toLowerCase() === "paciente") {
          const data = await buscarPaciente(id);
          setProfileData(data);
        }
      } catch (err) {
        console.error("Erro ao carregar perfil completo", err);
      } finally {
        setLoadingProfile(false);
      }
    }
    loadProfile();
  }, [id, tipo, user]);

  if (loading || loadingProfile) {
    return <div>Carregando...</div>;
  }

  // 🔹 se não estiver logado
  if (!user) {
    return <Navigate to="/login" replace />;
  }

  // 🔹 se a URL não corresponder ao usuário logado
  if (String(user.id) !== String(id) || user.tipo.toLowerCase() !== tipo.toLowerCase()) {
    return (
      <div style={{ padding: "2rem", textAlign: "center" }}>
        <h2>Acesso Negado</h2>
        <p>Você só pode acessar seu próprio perfil.</p>
        <a href={`/${user.tipo}/perfil/${user.id}`}>
          Ir para meu perfil
        </a>
      </div>
    );
  }

  // 🔹 se for psicólogo, mostra o layout específico
  if (user.tipo.toLowerCase() === "psicologo") {
    return <SectionPsicologo profileData={profileData} />;
  }

  // 🔹 se for paciente, mostra o layout específico
  if (user.tipo.toLowerCase() === "paciente") {
    return <SectionPaciente profileData={profileData} />;
  }

  // fallback caso tipo seja inesperado
  return (
    <div style={{ padding: "2rem", textAlign: "center" }}>
      <h2>Tipo de usuário desconhecido</h2>
      <p>Entre em contato com o suporte.</p>
    </div>
  );
}
