import { NavLink } from 'react-router-dom'
import { useState } from 'react'
import { 
  HiOutlineHome, 
  HiOutlineUser, 
  HiOutlineSearch, 
  HiOutlineNewspaper, 
  HiOutlineQuestionMarkCircle 
} from "react-icons/hi";
import { useAuth } from '../../context/AuthContext';

export default function NavMobile() {
  const [activeIndex, setActiveIndex] = useState(2);
  const { user, isAuthenticated } = useAuth();

  const navItems = [
    { icon: <HiOutlineSearch />, to: "/home" },
    { icon: <HiOutlineNewspaper />, to: "/artigos" },
    { icon: <HiOutlineHome />, to: "/" },
    { 
      icon: <HiOutlineUser />, 
      to: isAuthenticated ? `/${user.tipo}/perfil/${user.id}` : `/login=0` 
    },
    { icon: <HiOutlineQuestionMarkCircle />, to: "/sobre-nos" },
  ];

  return (
    <nav className="nav-mobile">
      {navItems.map((item, index) => (
        <NavLink
          key={index}
          to={item.to}
          className={`nav-item ${activeIndex === index ? "active" : ""}`}
          onClick={() => setActiveIndex(index)}
        >
          {item.icon}
          <span className="indicator"></span>
        </NavLink>
      ))}
    </nav>
  );
}