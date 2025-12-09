const express = require('express');
const router = express.Router();
const GastoController = require('../controllers/GastoController');

// Define que GET /categorias chama o controller
router.get('/', GastoController.listarCategorias);

module.exports = router;