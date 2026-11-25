# React + Vite

This template provides a minimal setup to get React working in Vite with HMR and some Oxlint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Oxc](https://oxc.rs)
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/)

## React Compiler

The React Compiler is not enabled on this template because of its impact on dev & build performances. To add it, see [this documentation](https://react.dev/learn/react-compiler/installation).

## Expanding the Oxlint configuration

If you are developing a production application, we recommend using TypeScript with type-aware lint rules enabled. Check out the [TS template](https://github.com/vitejs/vite/tree/main/packages/create-vite/template-react-ts) for information on how to integrate TypeScript and Oxlint's TypeScript related rules in your project.

# https://www.youtube.com/watch?v=LDB4uaJ87e0
# https://www.youtube.com/watch?v=mnrXWgLGHak&list=PL97WcWV-aHf4qnwgVub8nk_9TRKzlAuWr



   35  sudo apt install npm
   36  sudo apt install pnpm
   37  npm install pnpm
   38  pnpm
   43  npm install && npm run dev
   44  npm install @ariakit/react
   90  npm run dev
  102  npm create vite@latest my-react-app -- --template react
  110  npm install @ariakit/react
  118  npm create vite@latest vite-app --template react
  122  npm run dev
  123  npm run dev
  124  npm run dev
  126  npm install tailwindcss @tailwindcss/vite
  201  npm i -g vscode-langservers-extracted
  202  sudo npm i -g vscode-langservers-extracted
  203  sudo npm install -g typescript@6 typescript-language-server
  204  sudo npm i -g vscode-langservers-extracted
  207  sudo npm i -g @tailwindcss/language-server
  289  npm i autoprefixer
  290  npm i postcss
  291  npm tailwindcss init -p
  331  npm run dev
  332  npm install @ariakit/react
  353  npm run dev
  365  npm create vite@latest crash
  366  npm run dev
  367  npm i
  368  npm run dev
  369  npm run
  372  npm i
  373  npm run
  374  npm run dev
  375  npm run dev
  392  npm i react-icons
  396  npm i react-router-dom
  407  npm i json-server
  421  npm i react-spinners
  441  history|grep npm
       npm i react-toastify
      npm install @auth0/auth0-react@2.x
  npm install @mui/material @emotion/react @emotion/styled

---------------------
This works, meaning, the return at the
bottom {job.title} works, but the
console log statements all show 'job' as
null
---------------------
import {useState, useEffect} from 'react';
import { useParams } from 'react-router-dom'; 
import Spinner from '../components/Spinner';

const JobPage = () => {
  const { id } = useParams();
  const [job, setJob] = useState(null);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    const fetchJob = async () => {
      const apiUrl = `/api/jobs/${id}`
      try{
        const res = await fetch(apiUrl);
        const data = await res.json();
        console.log("job page: data", data);
        setJob(data);
        console.log("job page: job", job);
      }
      catch(error){
        console.log('error fetching data', error);
      }
      finally{
        setLoading(false);
        console.log("job page2: job", job);
      }
    }
    fetchJob();
  }, [])

	return (
	  loading ? <Spinner /> : (
	    <h1>{job.title}</h1>
	  )
	)
}

export default JobPage
