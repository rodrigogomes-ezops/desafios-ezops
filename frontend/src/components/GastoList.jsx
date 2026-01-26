import React, { useState, useEffect } from 'react';
import api from '../services/api';

const GastoList = () => {
  const [gastos, setGastos] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    setLoading(true);
    // Busca a listagem detalhada
    api.get('/gastos')
      .then(response => {
        setGastos(response.data);
        setLoading(false);
      })
      .catch(error => {
        console.error("Erro ao carregar lista de gastos:", error);
        setLoading(false);
      });
  }, []); // O array vazio garante que a busca só ocorre uma vez

  if (loading) {
    return <p>Carregando lista de gastos...</p>;
  }

  return (
    <div style={{ padding: '20px', width: '90%', margin: '20px auto' }}>
      <h3>Gastos Recentes</h3>
      {gastos.length === 0 ? (
        <p>Nenhum gasto registrado ainda.</p>
      ) : (
        <table>
          <thead>
            <tr>
              <th>Nome</th>
              <th>Valor (R$)</th>
              <th>Categoria</th>
              <th>Pagamento</th>
              <th>Data</th>
            </tr>
          </thead>
          <tbody>
            {gastos.map(gasto => (
              <tr key={gasto.id}>
                <td>{gasto.nome}</td>
                <td>{parseFloat(gasto.valor).toFixed(2)}</td>
                <td>{gasto.categoria.nome}</td>
                <td>{gasto.formaPagamento}</td>
                <td>{new Date(gasto.data).toLocaleDateString('pt-BR')}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
};

export default GastoList;