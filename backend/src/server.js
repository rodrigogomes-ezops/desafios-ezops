require('dotenv').config();
const express = require('express');
const cors = require('cors');
const client = require('prom-client');
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

// ==========================================================
// MÉTRICAS PROMETHEUS
// ==========================================================

// 1. Métricas padrão do Node.js (CPU, Memória, Event Loop, GC)
const collectDefaultMetrics = client.collectDefaultMetrics;
collectDefaultMetrics({ 
  prefix: 'nodejs_',
  labels: { app: 'backend-financeiro' }
});

// 2. Contador de requisições HTTP (total de requests)
const httpRequestsTotal = new client.Counter({
  name: 'http_requests_total',
  help: 'Total de requisições HTTP recebidas',
  labelNames: ['method', 'route', 'status_code']
});

// 3. Histograma de duração das requisições HTTP
const httpRequestDuration = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duração das requisições HTTP em segundos',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.001, 0.005, 0.015, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10]
});

// 4. Gauge de requisições em andamento
const httpRequestsInProgress = new client.Gauge({
  name: 'http_requests_in_progress',
  help: 'Número de requisições HTTP em andamento',
  labelNames: ['method']
});

// 5. Contador de erros HTTP (4xx e 5xx)
const httpErrorsTotal = new client.Counter({
  name: 'http_errors_total',
  help: 'Total de erros HTTP (4xx e 5xx)',
  labelNames: ['method', 'route', 'status_code', 'error_type']
});

// 6. Métricas de negócio - Gastos
const gastosCreatedTotal = new client.Counter({
  name: 'gastos_created_total',
  help: 'Total de gastos criados'
});

const gastosDeletedTotal = new client.Counter({
  name: 'gastos_deleted_total',
  help: 'Total de gastos deletados'
});

const gastosValueTotal = new client.Counter({
  name: 'gastos_value_total',
  help: 'Valor total de gastos registrados (em centavos)'
});

// 7. Métricas de banco de dados
const dbQueryDuration = new client.Histogram({
  name: 'db_query_duration_seconds',
  help: 'Duração das queries ao banco de dados em segundos',
  labelNames: ['operation', 'table'],
  buckets: [0.001, 0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5]
});

const dbConnectionsActive = new client.Gauge({
  name: 'db_connections_active',
  help: 'Número de conexões ativas com o banco de dados'
});

// Exportar métricas para uso em outras partes da aplicação
app.locals.metrics = {
  gastosCreatedTotal,
  gastosDeletedTotal,
  gastosValueTotal,
  dbQueryDuration,
  dbConnectionsActive
};

// Middleware para métricas HTTP (DEVE vir antes das rotas)
app.use((req, res, next) => {
  // Ignorar endpoint de métricas
  if (req.path === '/metrics' || req.path === '/health') {
    return next();
  }

  const start = process.hrtime.bigint();
  httpRequestsInProgress.inc({ method: req.method });

  res.on('finish', () => {
    const duration = Number(process.hrtime.bigint() - start) / 1e9; // Converter para segundos
    const route = req.route ? req.route.path : req.path;
    const labels = { 
      method: req.method, 
      route: route, 
      status_code: res.statusCode 
    };

    // Registrar métricas
    httpRequestsTotal.inc(labels);
    httpRequestDuration.observe(labels, duration);
    httpRequestsInProgress.dec({ method: req.method });

    // Registrar erros
    if (res.statusCode >= 400) {
      const errorType = res.statusCode >= 500 ? 'server_error' : 'client_error';
      httpErrorsTotal.inc({ ...labels, error_type: errorType });
    }
  });

  next();
});

// Endpoint /metrics para Prometheus
app.get('/metrics', async (req, res) => {
  try {
    res.set('Content-Type', client.register.contentType);
    res.end(await client.register.metrics());
  } catch (error) {
    res.status(500).end(error.message);
  }
});

// Endpoint de health check
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
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