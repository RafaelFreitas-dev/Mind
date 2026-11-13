import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    port: process.env.VITE_PORT || 3000,
    host: '0.0.0.0',
    allowedHosts: [
      '5173-iq2f40vnftpa3nqwewxxi-2e9fe0aa.manus.computer',
      'localhost',
      '127.0.0.1'
    ],
  }
})
