require('dotenv').config();
const express = require('express');
const cors = require('cors');
const client = require('prom-client'); //
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

// 1. Coletar métricas padrão (CPU, Memória)
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics();

// 2. Métrica Customizada: Histograma para duração de requisições HTTP
const httpRequestDurationMicroseconds = new client.Histogram({
  name: 'http_request_duration_ms',
  help: 'Duration of HTTP requests in ms',
  labelNames: ['method', 'route', 'code'],
  buckets: [0.1, 5, 15, 50, 100, 500]
});

// Middleware para medir o tempo de resposta
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    // Evita gravar rotas de métricas ou assets estáticos se não quiser
    if (req.path !== '/metrics') {
        httpRequestDurationMicroseconds
        .labels(req.method, req.route ? req.route.path : req.path, res.statusCode)
        .observe(duration);
    }
  });
  next();
});

// 3. Endpoint /metrics que o Prometheus vai ler
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', client.register.contentType);
  res.end(await client.register.metrics());
});

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