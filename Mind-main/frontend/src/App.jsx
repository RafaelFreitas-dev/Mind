  import { BrowserRouter, Routes, Route } from "react-router-dom";

  import "../src/assets/styles/main.css";
  import "../src/assets/styles/ui/buttons.css";
  import "../src/assets/styles//ui/icons.css";

  import MainLayout from "./layout/MainLayout";
  import LandingPage from "./pages/LandingPage";
  import Home from "./pages/Home";
  import Artigos from "./pages/Artigos";
  import Login from "./pages/Login";
  import Perfil from "./pages/Perfil";
  import PerfilPublicoPsicologo from "./components/perfil-page/SectionPublicoPsicologo";
  import SobreNos from "./pages/SobreNos";
  import AddArtigos from "./pages/AddArtigos";
  import Configuracoes from "./pages/Configuracoes";
  import TermosCondicoes from "./pages/TermosCondicoes";
  import VideoChamada from "./pages/VideoChamada";
  import Cadastro from "./pages/Cadastro";
  import RecuperarSenha from "./pages/RecuperarSenha";
  import ProtectedRoute from './components/ProtectedRoute';
  import ErrorPage from './pages/ErrorPage';

  export default function App() {

    return (
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<MainLayout />}>
            {/* Rotas públicas */}
            <Route path="/landing" element={<LandingPage />} />
            <Route index element={<LandingPage />} />
            <Route
              path="home"
              element={
                <ProtectedRoute>
                  <Home />
                </ProtectedRoute>
              }
            />

            <Route path="artigos" element={<Artigos />} />
            <Route path="sobre-nos" element={<SobreNos />} />
            <Route path="termos-e-condicoes" element={<TermosCondicoes />} />
            <Route path="/perfil/psicologo/:id" element={<PerfilPublicoPsicologo />} />

            {/* Rotas de autenticação */}
            <Route path='login=0' element={<Login />} />
            <Route path='login=1' element={<Login />} />
            <Route path='login=2' element={<Login />} />
            <Route path='cadastro=0' element={<Cadastro />} />
            <Route path='cadastro=1' element={<Cadastro />} />
            <Route path='cadastro=2' element={<Cadastro />} />
            <Route path='recuperar-senha' element={<RecuperarSenha />} />

            {/* Rotas protegidas - QUALQUER tipo de usuário */}
            <Route
              path=':tipo/perfil/:id'
              element={
                <ProtectedRoute>
                  <Perfil />
                </ProtectedRoute>
              }
            />
            <Route
              path=':tipo/perfil/:id/configuracoes'
              element={
                <ProtectedRoute>
                  <Configuracoes />
                </ProtectedRoute>
              }
            />
            <Route
              path=':tipo/perfil/:id/video-chamada'
              element={
                <ProtectedRoute>
                  <VideoChamada />
                </ProtectedRoute>
              }
            />

            {/* Rota protegida APENAS para psicólogos */}
            <Route
              path='adicionar-artigos'
              element={
                <ProtectedRoute requirePsicologo={true}>
                  <AddArtigos />
                </ProtectedRoute>
              }
            />


            {/* Rota nao encontrada */}
            <Route path="*" element={<ErrorPage />} />
          </Route>
        </Routes>
      </BrowserRouter>
    );
  }