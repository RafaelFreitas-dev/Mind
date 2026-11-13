import { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { Link } from "react-router-dom";
import { HiOutlinePhone, HiOutlineMail } from "react-icons/hi";
import { getImageUrl, getDefaultAvatar } from '../../utils/imageHelper';
import * as pacienteService from '../../services/pacienteService';
import * as psicologoService from '../../services/psicologoService';
import "../../assets/styles/perfil/info.css";

export default function Info({ profileData }) {
    const { user, updateUser } = useAuth();
    const [uploading, setUploading] = useState(false);
    const [uploadError, setUploadError] = useState(null);
    const [imageError, setImageError] = useState(false);

    // URL da imagem do perfil
    const imageUrl = imageError ? getDefaultAvatar() : getImageUrl(user?.imgPerfil);

    const handleImageUpload = async (e) => {
        const file = e.target.files[0];
        if (!file) return;

        console.log('Iniciando upload da imagem:', file.name);
        console.log('Usuário:', user?.tipo, user?.id);

        // Validar tamanho (máximo 5MB)
        if (file.size > 5 * 1024 * 1024) {
            setUploadError('A imagem deve ter no máximo 5MB');
            return;
        }

        // Validar tipo
        if (!file.type.startsWith('image/')) {
            setUploadError('Por favor, selecione uma imagem válida');
            return;
        }

        try {
            setUploading(true);
            setUploadError(null);

            // Upload baseado no tipo de usuário
            let response;
            if (user.tipo === 'psicologo') {
                console.log('Fazendo upload para psicólogo...');
                response = await psicologoService.uploadImagem(user.id, file);
            } else {
                console.log('Fazendo upload para paciente...');
                response = await pacienteService.uploadImagem(user.id, file);
            }

            console.log('Resposta do servidor:', response);

            // Verificar se recebeu o nome da imagem
            if (response && response.imgPerfil) {
                // Atualizar o contexto com o novo nome da imagem
                updateUser({ imgPerfil: response.imgPerfil });
                setImageError(false); // Resetar erro após upload bem-sucedido
                alert('Imagem atualizada com sucesso!');
                console.log('Contexto atualizado com:', response.imgPerfil);
            } else {
                throw new Error('Servidor não retornou o nome da imagem');
            }
            
        } catch (error) {
            console.error('Erro ao fazer upload:', error);
            setUploadError(error.message || 'Erro ao fazer upload da imagem');
        } finally {
            setUploading(false);
        }
    };

    return (
        <div className="card-perfil-content">
            <div className="foto-perfil">
                <div className="banner-perfil"></div>
                <img
                    id="perfilFoto"
                    src={imageUrl}
                    alt="Foto de Perfil"
                    onError={(e) => {
                        if (!imageError) {
                            console.warn('Imagem não encontrada, carregando imagem padrão (base64)');
                            setImageError(true);
                        }
                    }}
                />


                <input
                    id="upload-foto"
                    type="file"
                    accept="image/*"
                    onChange={handleImageUpload}
                    disabled={uploading}
                    style={{ display: 'none' }}
                />

                {uploadError && (
                    <div className="upload-error" style={{ color: 'red', marginTop: '10px' }}>
                        {uploadError}
                    </div>
                )}
                <div className="info-perfil">
                    <h3>{profileData?.nome} {profileData?.sobrenome}</h3>
                    <div className="container-info">
                        <p id="perfilIdade">Idade:</p>
                        <label>{profileData?.idade || "idade teste"}</label>
                    </div>
                    <div className="container-info">
                        <p id="perfilIdade">Local:</p>
                        <label>{profileData?.local || "local teste"}</label>
                    </div>
                </div>
            </div>
            <div className="settings">
                <div className="container-contatos">
                    <div className="contato">
                        <button
                            type="button"
                            className="icon-btn icon-ui"
                            onClick={() => navigator.clipboard.writeText(profileData?.telefone || "")}
                        >
                            <HiOutlinePhone />
                        </button>
                        <span>{profileData?.telefone || "+55 11 9000-0000"}</span>
                    </div>
                </div>

                <div className="container-config-artigos">
                    <Link to={`/${user.tipo}/perfil/${user.id}/configuracoes`} className="button-config btn-mob">
                        Configurações
                    </Link>
                </div>





            </div>

        </div>

    );
}