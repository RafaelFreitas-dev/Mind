package com.mind_your.mind.dto.response;

public class UploadImagemResponseDTO {
    private String mensagem;
    private String imgPerfil;

    public UploadImagemResponseDTO(String mensagem, String imgPerfil) {
        this.mensagem = mensagem;
        this.imgPerfil = imgPerfil;
    }

    public String getMensagem() {
        return mensagem;
    }

    public String getImgPerfil() {
        return imgPerfil;
    }
}