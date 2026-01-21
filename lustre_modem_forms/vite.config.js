import { defineConfig } from 'vite'
import tailwindcss from '@tailwindcss/vite'
import gleam from "vite-gleam";

export default defineConfig({
  plugins: [
    tailwindcss(),
    gleam()
  ],
})
