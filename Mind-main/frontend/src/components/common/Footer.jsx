import {Link} from "react-router-dom"
import { HiOutlinePhone, HiOutlineMail } from "react-icons/hi";

export default function Footer() {

  return (
    <>
        <footer>
            <nav className="grid-footer" aria-label="Navegação geral do site">
                <ul>
                    <li><Link to="/sobre-nos">Sobre nós</Link></li>
                    <li><Link to="/artigos">Artigos</Link></li>
                    <li><Link to="/termos-e-condicoes">Termos de Uso</Link></li>
                    <li><Link to="">Entre para nosso time</Link></li>
                </ul>
                <div>
                    <ul>
                        <li>
                            <Link
                                to="/"
                                onClick={(e) => {
                                    if (window.location.pathname === "/") {
                                        e.preventDefault();
                                        document.getElementById('planos')?.scrollIntoView({
                                            behavior: 'smooth'
                                        });
                                    }
                                }}>Planos</Link>
                        </li>
                        <li>
                            <Link to="/:tipo(paciente|psicologo)/perfil/:id/configuracoes">Atribuições</Link>
                        </li>
                        <li>
                            <Link to="/adicionar-artigos">Canal de denúncia</Link>
                        </li>
                    </ul>
                    <p>Contatos:</p>
                    <div className="icon-btns">
                        <button className="icon-btn icon-ui" aria-label="Copiar email">
                            <HiOutlineMail
                                value="mind@falsoemail.com"
                                type="button"
                                title="copiar email"
                            />
                        </button>
                        <button className="icon-btn icon-ui" aria-label="Copiar telefone">
                            <HiOutlinePhone
                                value="(11) 1111-1111"
                                type="button"
                                title="copiar telefone"
                            />
                        </button>
                    </div>
                </div>
            </nav>
            <hr/>
            <p className="footer-copyright">&copy; 2025 All rights reserved - Mind</p>
        </footer>
    </>
  )
}