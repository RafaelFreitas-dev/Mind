import { NavLink, useNavigate } from 'react-router-dom'
import { Link } from 'react-router-dom'
import { useState, useEffect, useRef } from 'react'
import { HiOutlineSearch, HiOutlineBell, HiChevronDown, HiChevronRight, HiOutlineX } from "react-icons/hi";
import { useAuth } from '../../context/AuthContext';
import foto from '../../assets/img/perfil-default.png';


export default function NavDesktop() {
    const [isDropdownOpen, setDropdownOpen] = useState(false);
    const dropdownRef = useRef(null); // referência para o dropdown

    const { user, isAuthenticated, logout } = useAuth();
    const navigate = useNavigate();

    const handleLogout = () => {
        logout();
        navigate("landing");
    };

    // 🔽 Fecha o dropdown ao clicar fora
    useEffect(() => {
        function handleClickOutside(event) {
            if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
                setDropdownOpen(false);
            }
        }

        document.addEventListener("mousedown", handleClickOutside);
        return () => {
            document.removeEventListener("mousedown", handleClickOutside);
        };
    }, []);


    const [isNotifOpen, setNotifOpen] = useState(false);
    const [openNotif, setOpenNotif] = useState(null);

    const notificacoes = [
        {
            id: 1,
            tipo: "mensagem",
            nome: "Daniel",
            texto: "Bom dia, precisa de algo?",
            hora: "19:03",
            foto: foto
        },
        {
            id: 2,
            tipo: "confirmacao",
            nome: "Dra. Lucia Amaral",
            data: "16/04/2026",
            horario: "9:00h a.m",
            foto: "../../assets/img/perfil-default.png"
        },
        {
            id: 3,
            tipo: "mensagem",
            nome: "Daniel",
            texto: "Esta ficando louco?",
            hora: "19:29",
            foto: foto
        },
        {
            id: 4,
            tipo: "confirmacao",
            nome: "Dra. Lucia Amaral",
            data: "16/04/2026",
            horario: "9:00h a.m",
            foto: "../../assets/img/perfil-default.png"
        },
        {
            id: 5,
            tipo: "confirmacao",
            nome: "Dra. Lucia Amaral",
            data: "16/04/2026",
            horario: "19:00h p.m",
            foto: "../../assets/img/perfil-default.png"
        },
    ];
    return (
        <>
            <nav id="nav-desktop">
                <ul>
                    <NavLink id="linkSobreNos" to="/sobre-nos">
                        <li>Sobre nós</li>
                    </NavLink>
                    <NavLink
                        id="linkPlanos"
                        to="/"
                        onClick={(e) => {
                            if (window.location.pathname === "/") {
                                e.preventDefault();
                                document.getElementById('planos')?.scrollIntoView({
                                    behavior: 'smooth'
                                });
                            }
                        }}>
                        <li>Planos</li>
                    </NavLink>
                    <NavLink id="linkArtigos" to="/artigos">
                        <li>Artigos</li>
                    </NavLink>
                    {isAuthenticated && (
                        <>
                            <NavLink to="/home">
                                <HiOutlineSearch id="search-icon-btn" className="icon-ui" />
                            </NavLink>
                        </>
                    )}
                    {isAuthenticated && (
                        <div className="notif-wrapper">
                            <button
                                className="notif-btn"
                                onClick={() => setNotifOpen(prev => !prev)}
                            >
                                <HiOutlineBell className="icon-ui" />

                                {notificacoes.length > 0 && (
                                    <span className="notif-badge">
                                        {notificacoes.length}
                                    </span>
                                )}
                            </button>

                            {isNotifOpen && (
                                <div
                                    className="notif-modal-overlay"
                                    onClick={() => setNotifOpen(false)}
                                >

                                    <div
                                        className="notif-modal"
                                        onClick={(e) => e.stopPropagation()}
                                    >
                                        <button
                                            className="notif-close"
                                            onClick={() => setNotifOpen(false)}
                                        >
                                            <HiOutlineX />
                                        </button>

                                        <h3 className="notif-title">Notificações</h3>

                                        {notificacoes.length === 0 && (
                                            <p>Sem notificações</p>
                                        )}

                                        {notificacoes.map((notif) => {

                                            if (notif.tipo === "mensagem") {

                                                return (

                                                    <div key={notif.id} className="notif-msg">

                                                        <img
                                                            src={notif.foto}
                                                            className="notif-avatar"
                                                        />

                                                        <div className="notif-msg-text">
                                                            <strong>{notif.nome}</strong>
                                                            <p>{notif.texto}</p>
                                                        </div>

                                                        <span className="notif-hora">
                                                            {notif.hora}
                                                        </span>

                                                    </div>

                                                )

                                            }

                                            if (notif.tipo === "confirmacao") {

                                                return (

                                                    <div key={notif.id} className="notif-confirm">

                                                        <div
                                                            className="notif-confirm-header"
                                                            onClick={() =>
                                                                setOpenNotif(
                                                                    openNotif === notif.id
                                                                        ? null
                                                                        : notif.id
                                                                )
                                                            }
                                                        >

                                                            <HiOutlineBell />

                                                            <p>
                                                                {notif.nome} confirmou seu agendamento
                                                            </p>

                                                            <span>
                                                                {openNotif === notif.id ? <HiChevronDown ></HiChevronDown> : <HiChevronRight ></HiChevronRight>}
                                                            </span>

                                                        </div>

                                                        {openNotif === notif.id && (
                                                            <div className="notif-confirm-body">
                                                                <p>
                                                                    <strong>Nome:</strong> {notif.nome}
                                                                </p>
                                                                <p>
                                                                    <strong>Data:</strong> {notif.data}
                                                                </p>
                                                                <p>
                                                                    <strong>Horário:</strong> {notif.horario}
                                                                </p>

                                                                <button className="btn-remarcar">
                                                                    Remarcar data/horário
                                                                </button>

                                                                <button className="btn-cancelar">
                                                                    Cancelar Agendamento
                                                                </button>
                                                            </div>
                                                        )}
                                                    </div>
                                                )
                                            }
                                            return null
                                        })}
                                    </div>
                                </div>
                            )}
                        </div>
                    )}
                </ul>
                <div className="nav-right-buttons" ref={dropdownRef}>
                    {!isAuthenticated ? (
                        <>
                            <Link to="login=0">
                                <button
                                    type="button"
                                    className="nav-btn-login"
                                    onClick={() => setDropdownOpen(prev => !prev)}
                                >
                                    {isAuthenticated ? user.nome : "Login"}
                                </button>
                            </Link>
                        </>

                    ) : (
                        <>
                            <button
                                type="button"
                                className="nav-btn-login"
                                onClick={() => setDropdownOpen(prev => !prev)}
                            >
                                {isAuthenticated ? user.nome : "Login"}
                            </button>
                        </>
                    )}

                    <div className={`nav-login-drop-wrapper ${isAuthenticated && isDropdownOpen ? "show" : ""}`}>
                        <div className="nav-login-drop">
                            {isAuthenticated ? (
                                <>
                                    {user && (
                                        <Link
                                            to={`/${user.tipo.toLowerCase()}/perfil/${user.id}`}
                                            onClick={() => setDropdownOpen(false)}
                                        >
                                            <button type="button">Meu Perfil</button>
                                        </Link>
                                    )}
                                    <Link
                                        to={`/${user.tipo}/perfil/${user.id}/configuracoes`}
                                        onClick={() => setDropdownOpen(false)}
                                    >
                                        <button type="button">Configurações</button>
                                    </Link>
                                    {user.tipo === "psicologo" && (
                                        <Link
                                            to="/adicionar-artigos"
                                            onClick={() => setDropdownOpen(false)}
                                        >
                                            <button type="button">Adicionar Artigos</button>
                                        </Link>
                                    )}
                                    <button
                                        type="button"
                                        onClick={() => {
                                            handleLogout();
                                            setDropdownOpen(false);
                                        }}
                                    >
                                        Sair
                                    </button>
                                </>
                            ) : (
                                <>
                                </>
                            )}
                        </div>
                    </div>
                </div>
            </nav>
        </>
    )
}
