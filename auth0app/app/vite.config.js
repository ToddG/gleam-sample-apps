import { defineConfig } from 'vite';
import gleam from "vite-gleam";

export default defineConfig({
    plugins: [gleam()],
    // prevent vite from obscuring rust errors
    clearScreen: false,
    server: {
        port: 5173,
        strictPort: true,
    },
});
