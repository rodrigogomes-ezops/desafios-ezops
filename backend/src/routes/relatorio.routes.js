const express = require('express');
const router = express.Router();
const GastoController = require('../controllers/GastoController');

// Define que POST /gastos chama o controller
router.get('/relatorios/categorias', GastoController.relatorioPorCategoria);
module.exports = router;