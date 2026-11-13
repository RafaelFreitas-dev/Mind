import "../../assets/styles/perfil/logout.css";
import { useAuth } from '../../context/AuthContext';
import { HiOutlineLogout } from "react-icons/hi";

export default function Logout() {
    const { user, isAuthenticated, logout } = useAuth();
    const handleLogout = () => {
        logout();
        navigate("landing");
    };

    return (

        <div className={`container-sair`}>
            {isAuthenticated ? (
                <button
                    type="button"
                    className='icon-sair'
                    onClick={() => {
                        handleLogout();
                        setDropdownOpen(false);
                    }}
                >
                    <HiOutlineLogout />

                </button>
            ) : (
                <>
                </>
            )}<h3>Log out</h3>
        </div>
        

    );
}