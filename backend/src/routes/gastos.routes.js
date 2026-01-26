const express = require('express');
const router = express.Router();
const GastoController = require('../controllers/GastoController');
// const CategoriaController = require('../controllers/CategoriaController');

// 1. ROTA DE CRIAÇÃO (POST /gastos) - Está funcionando
router.post('/', GastoController.criarGasto);
router.get('/', GastoController.listarGastos);
router.get('/relatorios/categorias', GastoController.relatorioPorCategoria);
// router.post('/categorias', CategoriaController.criarCategoria);

module.exports = router;