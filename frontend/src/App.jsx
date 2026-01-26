import GastoForm from './components/GastoForm';
import Dashboard from './components/Dashboard'; 
import GastoList from './components/GastoList'; // Novo componente

function App() {
  return (
    <>
      <header>
        <h1>Registro Financeiro</h1>
      </header>
      <main style={{ display: 'flex', justifyContent: 'space-around', flexWrap: 'wrap' }}>
        {/* Formulário de Cadastro */}
        <GastoForm /> 
        
        {/* Gráfico de Dashboard */}
        <Dashboard /> 
      </main>
      
      {/* Lista de Gastos Abaixo do Dashboard */}
      <GastoList /> 
    </>
  );
}

export default App;