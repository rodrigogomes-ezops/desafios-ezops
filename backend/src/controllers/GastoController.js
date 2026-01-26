const prisma = require('../database/client');

// Nova função: Listar todas as categorias
exports.listarCategorias = async (req, res) => {
  try {
    const categorias = await prisma.categoria.findMany({
      select: {
        id: true, // O Front precisa do ID para enviar no POST
        nome: true // O Front precisa do NOME para exibir
      },
      orderBy: {
        nome: 'asc'
      }
    });

    return res.status(200).json(categorias);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Erro ao buscar categorias." });
  }
};

exports.listarGastos = async (req, res) => {
  try {
    const gastos = await prisma.gasto.findMany({
      // Inclui a categoria para que o frontend possa exibir o nome
      include: {
        categoria: true 
      },
      // Ordena do mais recente para o mais antigo
      orderBy: {
        data: 'desc'
      }
    });

    return res.status(200).json(gastos);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Erro ao buscar gastos." });
  }
};

exports.criarGasto = async (req, res) => {
  // 1. Recebe os dados do Front-end (ou Postman)
  const { nome, valor, categoriaId, data, formaPagamento } = req.body;

  try {
    // Conversão: O valor vem como número, mas o banco espera Decimal
    // A data vem como string, precisamos converter para objeto Date
    const novoGasto = await prisma.gasto.create({
      data: {
        nome,
        valor: valor, 
        categoriaId: Number(categoriaId),
        data: new Date(data),
        formaPagamento
      }
    });

    // --- LÓGICA DE ALERTA DE LIMITE ---
    
    // 2. Descobrir qual é o limite dessa categoria
    const categoria = await prisma.categoria.findUnique({
      where: { id: Number(categoriaId) }
    });

    // 3. Calcular datas de início e fim do mês do gasto
    const dataGasto = new Date(data);
    const inicioMes = new Date(dataGasto.getFullYear(), dataGasto.getMonth(), 1);
    const fimMes = new Date(dataGasto.getFullYear(), dataGasto.getMonth() + 1, 0);

    // 4. Somar todos os gastos dessa categoria neste mês
    const somaGastos = await prisma.gasto.aggregate({
      _sum: { valor: true },
      where: {
        categoriaId: Number(categoriaId),
        data: {
          gte: inicioMes, // Maior ou igual ao dia 1
          lte: fimMes     // Menor ou igual ao último dia
        }
      }
    });

    // 5. Verificar se estourou
    const totalGasto = Number(somaGastos._sum.valor); // Valor total acumulado
    const limite = Number(categoria.limiteMensal);
    
    let alerta = false;
    let mensagemAlerta = "";

    if (limite > 0 && totalGasto > limite) {
      alerta = true;
      mensagemAlerta = `Atenção! Você estourou o limite de R$ ${limite} para ${categoria.nome}. Total gasto: R$ ${totalGasto}`;
    }

    // Retorna tudo para quem chamou (o Front-end vai ler isso)
    return res.status(201).json({
      gasto: novoGasto,
      status_limite: {
        estourou: alerta,
        mensagem: mensagemAlerta,
        total_acumulado: totalGasto
      }
    });

  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Erro ao criar gasto." });
  }
};

exports.relatorioPorCategoria = async (req, res) => {
  try {
    // 1. Determina o mês atual (simplificado para o mês corrente)
    const now = new Date();
    const inicioMes = new Date(now.getFullYear(), now.getMonth(), 1);
    const fimMes = new Date(now.getFullYear(), now.getMonth() + 1, 0);

    // 2. Agrupamento e Soma via Prisma
    const gastosAgrupados = await prisma.gasto.groupBy({
      by: ['categoriaId'], // Agrupar por ID da Categoria
      _sum: {
        valor: true, // Somar o campo 'valor'
      },
      where: {
        data: {
          gte: inicioMes,
          lte: fimMes,
        },
      },
    });

    // 3. Buscar os Nomes das Categorias (o resultado acima só tem o ID)
    const categorias = await prisma.categoria.findMany({
      select: { id: true, nome: true },
    });
    
    // Mapeia o resultado para um formato amigável ao Front-end (Nome e Valor)
    const relatorioFinal = gastosAgrupados.map(g => {
      const categoriaInfo = categorias.find(c => c.id === g.categoriaId);
      
      return {
        name: categoriaInfo ? categoriaInfo.nome : 'Desconhecido',
        value: g._sum.valor ? parseFloat(g._sum.valor.toFixed(2)) : 0, // Formato numérico para o gráfico
      };
    }).filter(item => item.value > 0); // Remove categorias com gasto zero

    return res.status(200).json(relatorioFinal);

  } catch (error) {
    console.error("Erro no relatório por categoria:", error);
    return res.status(500).json({ error: "Erro ao gerar relatório." });
  }
};