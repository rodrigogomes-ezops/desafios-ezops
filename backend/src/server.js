require('dotenv').config();
const express = require('express');
const cors = require('cors');
const gastosRoutes = require('./routes/gastos.routes');
const categoriaRoutes = require('./routes/categoria.routes');
// Se você não tiver o arquivo de rotas de relatório separado e ele estiver dentro de gastos, 
// pode remover a linha abaixo ou comentar se der erro.
// const relatorioRoutes = require('./routes/relatorio.routes'); 

const app = express();
const router = express.Router(); 


const allowedOrigins = process.env.CORS_ORIGIN 
  ? process.env.CORS_ORIGIN.split(',') 
  : ['http://localhost:5173', 'http://localhost:8080'];

const corsOptions = {
  origin: function (origin, callback) {
    if (!origin) return callback(null, true);
    
    if (allowedOrigins.indexOf(origin) !== -1 || allowedOrigins.includes('*')) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
  credentials: true,
  optionsSuccessStatus: 204
};

app.use(cors(corsOptions));
app.use(express.json());
router.use('/gastos', gastosRoutes);
router.use('/categorias', categoriaRoutes);


router.get('/', (req, res) => {
  res.json({ message: 'API Financeira acessível via /api' });
});

app.use('/api', router);


app.get('/', (req, res) => {
  res.json({ message: 'Servidor Online! Use /api para acessar os recursos.' });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});