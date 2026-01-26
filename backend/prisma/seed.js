const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Iniciando seed do banco de dados...');

  // Insere as categorias iniciais
  const categorias = [
    { nome: 'Comida', limiteMensal: 1000.00 },
    { nome: 'Transporte', limiteMensal: 500.00 },
    { nome: 'Lazer', limiteMensal: 300.00 },
    { nome: 'Moradia', limiteMensal: 1500.00 },
  ];

  for (const categoria of categorias) {
    // Usa upsert para evitar duplicatas (cria se não existir, atualiza se existir)
    const categoriaCriada = await prisma.categoria.upsert({
      where: { nome: categoria.nome },
      update: { limiteMensal: categoria.limiteMensal },
      create: categoria,
    });
    console.log(`✅ Categoria "${categoriaCriada.nome}" criada/atualizada com limite de R$ ${categoriaCriada.limiteMensal}`);
  }

  console.log('✨ Seed concluído com sucesso!');
}

main()
  .catch((e) => {
    console.error('❌ Erro ao executar seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });