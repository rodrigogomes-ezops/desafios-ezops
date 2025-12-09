import axios from 'axios';

// Certifique-se de que o backend está rodando na porta 3000
const api = axios.create({
  baseURL: 'http://localhost:3000', 
});

export const criarCategoria = async (nome, limite) => {
  const response = await fetch(`${BASE_URL}/categorias`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ nome, limite }),
  });
  if (!response.ok) {
    throw new Error('Erro ao criar categoria');
  }
  return await response.json();
};

export default api;