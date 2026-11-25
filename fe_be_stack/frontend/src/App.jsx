import { Route, createBrowserRouter, createRoutesFromElements,RouterProvider } from 'react-router-dom'
import MainLayout from './layouts/MainLayout';
import HomePage from "./pages/HomePage"
import JobsPage from "./pages/JobsPage"
import NotFoundPage from "./pages/NotFoundPage"
import JobPage, { jobLoader } from "./pages/JobPage"
import ProfilePage from "./pages/ProfilePage"
import AddJobPage from "./pages/AddJobPage"
import EditJobPage from "./pages/EditJobPage"
import { useAuth0 } from "@auth0/auth0-react";
import Spinner from './components/Spinner';
import { Navigate } from 'react-router-dom';
import sun from './assets/images/sun-and-glasses-remix.svg';

const App = () => {

  // TODO: if you want to play with auth0, then comment out the following 3 lines and uncomment the auth0 stanza below
  const isLoading = false;
  const isAuthenticated = true;
  const user = {};
  // TODO: auth0 stanza start
  // const {
  //   isLoading, // Loading state, the SDK needs to reach Auth0 on load
  //   isAuthenticated,
  //   error,
  //   loginWithRedirect: login, // Starts the login flow
  //   logout: auth0Logout, // Starts the logout flow
  //   user, // User profile
  // } = useAuth0();
  // TODO: auth0 stanza end

  const signup = () =>
    login({ authorizationParams: { screen_hint: "signup" } });

  const logout = () =>
    auth0Logout({ logoutParams: { returnTo: window.location.origin } });

  // add new job
  const addJob = async (newJob) => {
    await fetch('/api/jobs', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(newJob)
    })
  }

  // delete job
  const deleteJob = async (id) => {
    // console.log("delete", id)
    await fetch(`/api/jobs/${id}`, {
      method: 'DELETE',
    })
  }

  // update job
  const updateJob = async (updatedJob) => {
    await fetch(`/api/jobs/${updatedJob.id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(updatedJob)
    })
  }

  const router = createBrowserRouter(
    createRoutesFromElements(
      <Route path='/' element={<MainLayout user={user}/>}>
        <Route index element={<HomePage />} />
        <Route path='/jobs' element={<JobsPage />} />
        <Route path='/profile' element={<ProfilePage user={user} logout={logout}/>} />
        <Route path='/add-job' element={<AddJobPage addJobSubmit={addJob}/>} />
        <Route path='/edit-job/:id' element={<EditJobPage updateJobSubmit={updateJob}/>} loader={jobLoader}/>
        <Route path='/jobs/:id' element={<JobPage deleteJob={deleteJob} />} loader={jobLoader}/>
        <Route path='*' element={<NotFoundPage />} />
      </Route>
    )
  );

  return isLoading ?
    (
      <section className="bg-blue-50 px-4 py-10">
        <div className="container-xl lg:container m-auto">
        <Spinner loading={isLoading}/>
        </div>
      </section>
    ) : ( 
      isAuthenticated ? (
    	  <RouterProvider router={router}/>
      ) : (
        <>
          <div className="container-xl lg:container m-auto">
            <div className="grid grid-cols-1 gap-4 p-4 rounded-lg">
              <div className="grid grid-cols-2">
                <img src={sun} alt="sun wearing sunglasses"/>
                <div className="grid grid-cols-1 justify-center items-center">
                  <h1 className="text-left ml-4 md:ml-0">FE_APP_NAME</h1>
                  <h2 className="text-left ml-4 md:ml-0">loren ipsum...</h2>
                </div>
              </div>
              <button
                className="bg-indigo-500 hover:bg-indigo-600 text-white font-bold py-2 px-4 rounded-full w-full focus:outline-none focus:shadow-outline"
                type="button"
                onClick={signup}
              >
              Signup
              </button>
              <button
                className="bg-indigo-500 hover:bg-indigo-600 text-white font-bold py-2 px-4 rounded-full w-full focus:outline-none focus:shadow-outline"
                type="button"
                onClick={login}
              >
              Login
              </button>
            </div>
          <h1 className="text-center">Access to this application is restricted to authorized users only.</h1>
          </div>
        </>
    )
  )
}
export default App
          // {error && <p>Error: {error.message}</p>}
