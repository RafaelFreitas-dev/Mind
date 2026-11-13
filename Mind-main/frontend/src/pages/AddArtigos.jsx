import "../assets/styles/add-artigos/add-artigos.css";
import "../assets/styles/configuracoes/configuracoes.css"; // Utilizando de alguns layouts da página de configurações

import FormArticle from "../components/add-artigos/FormArticle";
import PublishedArticle from "../components/add-artigos/PublishedArticle";
import DefaultImg from "../assets/img/articles.png"
import { useState } from "react";

export default function AddArtigos() {
  const [imgArticle, setImgArticle] = useState(DefaultImg);

  const chooseImgArticle = (img) => {
        const file = img.target.files[0];
        const formData = new FormData();

        const imageUrl = URL.createObjectURL(file);
        setImgArticle(imageUrl);

        formData.append('imagem', file);
        console.log(imageUrl);
  }
    
  return (
    <>
      <section className="config">
          <div className="container-section">
            {/* Foto de perfil */}
            <div className="container-img">
                <div className="img-options">

                    <img id="imagePreview" src={imgArticle} alt="" className="imgEdit"/>
                    <div>
                        <input 
                            id="foto-preview" 
                            type="file" 
                            accept="image/*" 
                            onChange={(e) => chooseImgArticle(e)}
                            required/>
                        <label className="btns button-confirm" htmlFor="foto-preview">Mudar Foto</label>
                    </div>
                    
                </div>
            </div>
            <div className="container-inputs">
                <div className="containers-articles">
                  <FormArticle />
                  <PublishedArticle />
                </div>  
            </div>
          </div>
      </section>
    </>
  )
}
