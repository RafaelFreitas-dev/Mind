import '../../assets/styles/landing-page/section.css';
import Hero from "../landing-page/Hero"
import Apresentacao from "../landing-page/Apresentacao"
import Caracteristicas from "../landing-page/Caracteristicas"
import Informacoes from "../landing-page/Informacoes"
import Perguntas from "../landing-page/Perguntas"
import Planos from "../landing-page/Planos"

import { Link } from 'react-router'

export default function Section() {
    return (
        <>
            <div className="section-landing-page">
                <Hero />
                <Apresentacao />
                <Caracteristicas />
                <Informacoes />
                <Planos />
                <Perguntas />
            </div>

        </>
    )
}
