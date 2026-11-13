import { useState } from 'react';
import { getImageUrl } from '../../utils/imageHelper';

/**
 * Componente de imagem de perfil com fallback automático
 */
export default function ProfileImage({ src, alt, className, style, ...props }) {
    const [imgSrc, setImgSrc] = useState(getImageUrl(src));
    const [hasError, setHasError] = useState(false);

    const handleError = () => {
        if (!hasError) {
            setHasError(true);
            setImgSrc(getImageUrl(null)); // Usa imagem padrão
        }
    };

    return (
        <img 
            src={imgSrc} 
            alt={alt || "Foto de Perfil"} 
            className={className}
            style={style}
            onError={handleError}
            {...props}
        />
    );
}