import defaultAvatar from "../assets/img/perfil-default.png";
import defaultWallpaper from "../assets/img/wallpaper-default.png";
const API_URL = "http://localhost:8080";

// Imagem SVG padrão em base64 como fallback absoluto
const DEFAULT_AVATAR_BASE64 = defaultAvatar; // Substitua pelo caminho correto do seu arquivo de imagem
const DEFAULT_WALLPAPER = defaultWallpaper;
/**
 * Retorna a URL completa para uma imagem de perfil
 * @param {string} imgPerfil - Nome do arquivo (ex: "perfil-snoopy.png")
 * @returns {string} URL completa da imagem
 */
export function getImageUrl(imgPerfil) {
    // Se não houver imagem ou for string vazia, retorna imagem padrão do servidor
    if (!imgPerfil || imgPerfil.trim() === "" || imgPerfil === "null" || imgPerfil === "undefined") {
        return `${API_URL}/api/images/default`;
    }

    // Se já for uma URL completa, retorna como está
    if (imgPerfil.startsWith('http://') || imgPerfil.startsWith('https://')) {
        return imgPerfil;
    }

    // Se for um blob URL (preview local), retorna como está
    if (imgPerfil.startsWith('blob:')) {
        return imgPerfil;
    }

    // Se for data URL (base64), retorna como está
    if (imgPerfil.startsWith('data:')) {
        return imgPerfil;
    }

    // Retorna a URL do endpoint de imagens
    return `${API_URL}/api/images/${imgPerfil}`;
}

/**
 * Retorna a imagem padrão em base64 (nunca falha)
 * @returns {string} Data URL da imagem padrão
 */
export function getDefaultAvatar() {
    return DEFAULT_AVATAR_BASE64;
}
export function getDefaultWallpaper() {
    return DEFAULT_WALLPAPER;
}

/**
 * Retorna a URL para upload de imagem
 * @param {string} id - ID do usuário
 * @param {string} tipo - Tipo do usuário ("paciente" ou "psicologo")
 * @returns {string} URL do endpoint de upload
 */
export function getUploadUrl(id, tipo) {
    const endpoint = tipo === "psicologo" ? "psicologos" : "pacientes";
    return `${API_URL}/${endpoint}/${id}/imagem`;
}

/**
 * Handler para erro de imagem (usa como onError)
 * @param {Event} e - Evento de erro da imagem
 */
export function handleImageError(e) {
    console.warn('Erro ao carregar imagem, usando default');
    e.target.src = getDefaultAvatar();
    e.target.onerror = null;
}