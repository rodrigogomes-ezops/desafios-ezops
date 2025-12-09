import React, { useState, useEffect } from 'react';
import api from '../services/api';

const GastoForm = () => {
  // Estado para armazenar o formulário
  const [formData, setFormData] = useState({
    nome: '',
    valor: '',
    categoriaId: '', // Armazena o ID da categoria
    data: new Date().toISOString().substring(0, 10), // Data de hoje no formato YYYY-MM-DD
    formaPagamento: 'Pix',
  });
  
  // Estado para armazenar as categorias vindas da API
  const [categorias, setCategorias] = useState([]);
  const [message, setMessage] = useState('');
  
  // Carrega as categorias do Back-end
  useEffect(() => {
    api.get('/categorias').then(response => {
      setCategorias(response.data);
      // Define a primeira categoria como padrão
      if (response.data.length > 0) {
        setFormData(prev => ({ ...prev, categoriaId: response.data[0].id.toString() }));
      }
    }).catch(error => {
      console.error("Erro ao carregar categorias:", error);
    });
  }, []);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setMessage('Enviando...');
    
    // Converte o valor para número antes de enviar (o backend espera um Decimal/Number)
    const payload = {
        ...formData,
        valor: parseFloat(formData.valor), 
        categoriaId: parseInt(formData.categoriaId),
    };

    try {
      const response = await api.post('/gastos', payload);
      
      // Limpa o formulário após sucesso (exceto data e categoria)
      setFormData(prev => ({ ...prev, nome: '', valor: '' })); 

      // Exibe a mensagem de sucesso ou alerta de limite!
      if (response.data.status_limite.estourou) {
        setMessage(`⚠️ ALERTA: ${response.data.status_limite.mensagem}`);
      } else {
        setMessage('Gasto registrado com sucesso!');
      }

    } catch (error) {
      setMessage('Erro ao registrar gasto.');
      console.error(error);
    }
  };

  return (
    <div style={{ padding: '20px', maxWidth: '400px', margin: 'auto' }}>
      <h2>Novo Gasto</h2>
      {message && <p style={{ color: message.includes('ALERTA') ? 'red' : 'green' }}>{message}</p>}
      
      <form onSubmit={handleSubmit}>
        <label>Nome:</label>
        <input type="text" name="nome" value={formData.nome} onChange={handleChange} required />
        
        <label>Valor (R$):</label>
        <input type="number" name="valor" value={formData.valor} onChange={handleChange} step="0.01" required />
        
        <label>Data:</label>
        <input type="date" name="data" value={formData.data} onChange={handleChange} required />

        <label>Categoria:</label>
        <select name="categoriaId" value={formData.categoriaId} onChange={handleChange} required>
          {categorias.map(cat => (
            // O value do select é o ID, o que o nosso Backend espera!
            <option key={cat.id} value={cat.id}>
              {cat.nome}
            </option>
          ))}
        </select>
        
        <label>Forma de Pagamento:</label>
        <select name="formaPagamento" value={formData.formaPagamento} onChange={handleChange}>
          <option>Pix</option>
          <option>Débito</option>
          <option>Crédito</option>
          <option>Dinheiro</option>
        </select>
        
        <button type="submit">Registrar Gasto</button>
      </form>
    </div>
  );
};

export default GastoForm;