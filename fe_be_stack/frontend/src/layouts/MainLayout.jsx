import { Outlet } from 'react-router-dom';
import NavBar from '../components/Navbar';
import { ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

const MainLayout = ({user}) => {
	return (
	  <>
	    <NavBar user={user}/>
	    <Outlet />
	    <ToastContainer />
	  </>
	)
}
export default MainLayout
