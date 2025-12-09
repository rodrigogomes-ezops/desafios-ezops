require('dotenv').config();
const express = require('express');
const cors = require('cors');
const gastosRoutes = require('./routes/gastos.routes');
const categoriaRoutes = require('./routes/categoria.routes');
const relatorioRoutes = require('./routes/relatorio.routes');

const app = express();

// Definição da origem permitida (o endereço onde seu React está rodando)
const corsOptions = {
  origin: 'http://localhost:5173', // <--- Mude para a porta real do seu React se for diferente de 5173
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  credentials: true,
  optionsSuccessStatus: 204
};

app.use(cors());
app.use(express.json());

// Usa as rotas de gastos
// Tudo que estiver em gastosRoutes começará com /gastos
app.use('/gastos', gastosRoutes);
app.use('/categorias', categoriaRoutes);
app.use('/relatorios', relatorioRoutes);
app.get('/', (req, res) => {
  res.json({ message: 'API Financeira rodando!' });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});