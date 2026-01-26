import axios from 'axios';

// URL da API: 
// - Em desenvolvimento: http://localhost:3000
// - Em produção: usa VITE_API_URL ou padrão '/api' (se houver proxy configurado)
// - Para CloudFront: usar a URL completa do CloudFront do backend
const baseURL = import.meta.env.DEV 
  ? 'http://localhost:3000' 
  : (import.meta.env.VITE_API_URL || '/api');

const api = axios.create({
  baseURL: baseURL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const criarCategoria = async (nome, limite) => {
  try {
    const response = await api.post('/categorias', { nome, limite });
    return response.data;
  } catch (error) {
    console.error('Erro ao criar categoria:', error);
    throw error;
  }
};

export default api;