import React, { useState, useEffect } from 'react';
import { PieChart, Pie, Tooltip, Legend, Cell } from 'recharts';
import api from '../services/api';

const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042', '#AF19FF', '#FF19A0'];

const Dashboard = () => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Busca os dados do endpoint de relatório que criamos
    api.get('/gastos/relatorios/categorias')
      .then(response => {
        setData(response.data);
        setLoading(false);
      })
      .catch(error => {
        console.error("Erro ao carregar dados do dashboard:", error);
        setLoading(false);
      });
  }, []);

  if (loading) {
    return <p>Carregando Dashboard...</p>;
  }
  
  // Se não houver dados, exibe uma mensagem
  if (data.length === 0) {
    return <p>Sem gastos registrados neste mês para gerar o gráfico.</p>;
  }

  return (
    <div style={{ padding: '20px', textAlign: 'center' }}>
      <h2>Visão Geral dos Gastos (Mês Atual)</h2>
      
      <PieChart width={500} height={400}>
        <Pie
          data={data}
          dataKey="value"
          nameKey="name"
          cx="50%" // Centro X
          cy="50%" // Centro Y
          outerRadius={150}
          fill="#8884d8"
          label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
        >
          {
            data.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
            ))
          }
        </Pie>
        <Tooltip formatter={(value, name) => [`R$ ${value}`, name]} />
        <Legend />
      </PieChart>
    </div>
  );
};

export default Dashboard;