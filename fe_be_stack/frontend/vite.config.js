import react from '@vitejs/plugin-react'
import { defineConfig,loadEnv } from 'vite'
import tailwindcss from '@tailwindcss/vite'

// https://vite.dev/config/
// TODO: authenticate calls to backend apis
export default defineConfig(({mode}) => {
  const env = loadEnv (mode, process.cwd(), 'VITE_')

  return {
    define: {
      'process.env': env,
    },
    plugins: [react(), tailwindcss()],
    server: {
      port : env.VITE_DEV_WEB_SERVER_PORT ? Number(env.VITE_DEV_WEB_SERVER_PORT) : 5173,
      proxy: {
        '/api': {
          target: env.VITE_API_SERVER_URL ? env.VITE_API_SERVER_URL : "http://localhost:5000",
          changeOrigin: true,
        }
      }
    }
  }
}
)
