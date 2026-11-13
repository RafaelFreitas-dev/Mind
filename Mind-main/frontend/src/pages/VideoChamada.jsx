import { useAuth } from '../context/AuthContext';
import { useParams, Navigate, useNavigate } from 'react-router-dom';
import { useEffect, useRef, useState } from 'react';
import { Video, VideoOff, Mic, MicOff, PhoneOff } from 'lucide-react';
import '../components/video-chamada/streaming.css';

export default function VideoChamada() {
    const { user, loading } = useAuth();
    const { id, tipo } = useParams();
    const navigate = useNavigate();
    const jitsiContainerRef = useRef(null);
    const [jitsiApi, setJitsiApi] = useState(null);
    const [isMuted, setIsMuted] = useState(false);
    const [isVideoOn, setIsVideoOn] = useState(true);
    const [roomName, setRoomName] = useState('');
    const [isInCall, setIsInCall] = useState(false);

    useEffect(() => {
        // Carregar o script do Jitsi apenas uma vez
        if (!window.JitsiMeetExternalAPI) {
            const script = document.createElement('script');
            script.src = 'https://meet.jit.si/external_api.js';
            script.async = true;
            document.body.appendChild(script);

            script.onload = () => {
                console.log('Jitsi script carregado');
            };

            script.onerror = () => {
                console.error('Erro ao carregar Jitsi');
                alert('Erro ao carregar videochamada. Verifique sua conexão.');
            };
        }

        return () => {
            // Limpar ao desmontar
            if (jitsiApi) {
                jitsiApi.dispose();
            }
        };
    }, []);

    const initJitsi = () => {
        if (!roomName.trim()) {
            alert('Digite o nome da sala!');
            return;
        }

        if (!jitsiContainerRef.current) {
            console.error('Container não encontrado');
            return;
        }

        const domain = 'meet.jit.si';
        const options = {
            roomName: roomName.trim(),
            width: '100%',
            height: '100%',
            parentNode: jitsiContainerRef.current,
            configOverwrite: {
                startWithAudioMuted: true,
                startWithVideoMuted: false,
                prejoinPageEnabled: false,
                disableDeepLinking: true,
                enableWelcomePage: false,
                requireDisplayName: false,
                enableClosePage: false,
                defaultLanguage: 'pt',
                disableProfile: true,
                hideConferenceSubject: false,
                enableUserRolesBasedOnToken: false,
                disableInviteFunctions: true,
                doNotStoreRoom: true,
                enableFeaturesBasedOnToken: false,
                hideAddRoomButton: true,
                enableInsecureRoomNameWarning: false,
            },
            interfaceConfigOverwrite: {
                TOOLBAR_BUTTONS: [
                    'microphone', 'camera', 'hangup',
                    'chat', 'desktop', 'fullscreen',
                    'settings', 'tileview'
                ],
                SHOW_JITSI_WATERMARK: false,
                SHOW_WATERMARK_FOR_GUESTS: false,
                HIDE_INVITE_MORE_HEADER: true,
                DISABLE_JOIN_LEAVE_NOTIFICATIONS: true,
                HIDE_DEEP_LINKING_LOGO: true,
                PROVIDER_NAME: 'MindCare',
                MOBILE_APP_PROMO: false,
            },
            userInfo: {
                displayName: user?.nome || 'Usuário',
            }
        };

        const api = new window.JitsiMeetExternalAPI(domain, options);
        setJitsiApi(api);
        setIsInCall(true);

        // Event listeners
        api.addEventListener('videoConferenceLeft', () => {
            handleEndCall();
        });

        api.addEventListener('videoConferenceJoined', () => {
            console.log('Entrou na conferência');
        });

        api.addEventListener('audioMuteStatusChanged', (e) => {
            setIsMuted(e.muted);
        });

        api.addEventListener('videoMuteStatusChanged', (e) => {
            setIsVideoOn(!e.muted);
        });
    };

    const toggleMute = () => {
        if (jitsiApi) {
            jitsiApi.executeCommand('toggleAudio');
        }
    };

    const toggleVideo = () => {
        if (jitsiApi) {
            jitsiApi.executeCommand('toggleVideo');
        }
    };

    const handleEndCall = () => {
        if (jitsiApi) {
            jitsiApi.dispose();
            setJitsiApi(null);
        }
        setIsInCall(false);
        navigate(`/${user.tipo}/perfil/${user.id}`);
    };

    const handleStartCall = () => {
        if (!window.JitsiMeetExternalAPI) {
            alert('Aguarde o Jitsi carregar...');
            setTimeout(handleStartCall, 1000); // Tentar novamente em 1s
            return;
        }
        
        // Aguardar o container estar pronto
        setIsInCall(true);
        setTimeout(() => {
            if (jitsiContainerRef.current) {
                initJitsi();
            } else {
                console.error('Container ainda não está pronto');
                setIsInCall(false);
            }
        }, 100);
    };

    if (loading) {
        return (
            <div style={{ 
                minHeight: "80vh", 
                display: "flex", 
                alignItems: "center", 
                justifyContent: "center" 
            }}>
                <p>Carregando...</p>
            </div>
        );
    }

    if (!user) {
        return <Navigate to="/login=0" replace />;
    }

    // Modo debug: permite acesso mesmo com IDs diferentes
    // if (user.id !== id || user.tipo !== tipo) { ... }

    return (
        <section className="section-stream">
            <div className="container-psi">
                {!isInCall ? (
                    // Tela de entrada - escolher sala
                    <div className="join-screen">
                        <div className="join-content">
                            <h2> Entrar na Videochamada</h2>
                            <p>Modo Debug: Entre em qualquer sala</p>
                            
                            <div className="form-group">
                                <label htmlFor="roomName">Nome da Sala:</label>
                                <input
                                    type="text"
                                    id="roomName"
                                    value={roomName}
                                    onChange={(e) => setRoomName(e.target.value)}
                                    placeholder="Ex: SalaTerapia123"
                                    className="input-room"
                                    onKeyPress={(e) => {
                                        if (e.key === 'Enter') handleStartCall();
                                    }}
                                />
                            </div>

                            <div className="quick-rooms">
                                <p>Ou use uma sala rápida:</p>
                                <button 
                                    className="btn-quick-room"
                                    onClick={() => {
                                        const sala = 'MindDebug';
                                        setRoomName(sala);
                                        startCallWithRoom(sala);
                                    }}
                                >
                                    MindDebug
                                </button>
                                <button 
                                    className="btn-quick-room"
                                    onClick={() => {
                                        const sala = `Mind_${user.id.slice(0, 8)}`;
                                        setRoomName(sala);
                                        startCallWithRoom(sala);
                                    }}
                                >
                                    Mind_{user.id.slice(0, 8)}
                                </button>
                            </div>

                            <button 
                                className="btn-entrar button-confirm"
                                onClick={handleStartCall}
                                disabled={!roomName.trim()}
                            >
                                Entrar na Sala
                            </button>
                        </div>
                    </div>
                ) : (
                    // Container do Jitsi Meet
                    <>
                        <div 
                            ref={jitsiContainerRef} 
                            id="jitsi-container"
                        />
                        
                        {/* Controles customizados */}
                        <div className="container-ajusts">
                            <div className="btns-stream">
                                {/* Botão Câmera */}
                                <button 
                                    className={`btn-control ${!isVideoOn ? 'disabled' : ''}`}
                                    onClick={toggleVideo}
                                    title={isVideoOn ? "Desligar câmera" : "Ligar câmera"}
                                >
                                    {isVideoOn ? (
                                        <Video size={28} color="white" />
                                    ) : (
                                        <VideoOff size={28} color="white" />
                                    )}
                                </button>

                                {/* Botão Encerrar */}
                                <button 
                                    className="btn-control btn-hangup"
                                    onClick={handleEndCall}
                                    title="Encerrar chamada"
                                >
                                    <PhoneOff size={28} color="white" />
                                </button>

                                {/* Botão Microfone */}
                                <button 
                                    className={`btn-control ${isMuted ? 'disabled' : ''}`}
                                    onClick={toggleMute}
                                    title={isMuted ? "Ligar microfone" : "Desligar microfone"}
                                >
                                    {isMuted ? (
                                        <MicOff size={28} color="white" />
                                    ) : (
                                        <Mic size={28} color="white" />
                                    )}
                                </button>
                            </div>
                        </div>
                    </>
                )}
            </div>

            {/* Área lateral */}
            <div className="container-paciente">
                <div className="info-sessao">
                    <h3>Informações</h3>
                    <p><strong>Usuário:</strong> {user.nome}</p>
                    <p><strong>Tipo:</strong> {user.tipo}</p>
                    {isInCall && (
                        <>
                            <p><strong>Sala:</strong></p>
                            <p className="room-code">{roomName}</p>
                            <div className="info-tip">
                                Compartilhe este nome de sala com a outra pessoa para entrarem juntos!
                            </div>
                        </>
                    )}
                    {!isInCall && (
                        <div className="info-tip">
                            Modo Debug Ativo<br/>
                            Você pode entrar em qualquer sala sem restrições.
                        </div>
                    )}
                </div>
            </div>
        </section>
    );
}