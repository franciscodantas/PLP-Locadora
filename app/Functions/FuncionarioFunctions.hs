module Functions.FuncionarioFunctions where
    import DataBase.GerenciadorBD as BD
    import Models.Filme
    import Models.Funcionario
    import Models.Cliente

    {- Lista os filmes do sistema -}
    listarFilmes:: String
    listarFilmes = organizaListagem (BD.getFilmeJSON "app/DataBase/Filme.json")

    {- Lista as series do sistema do sistema -}
    listarSeries:: String
    listarSeries = organizaListagem (BD.getSerieJSON "app/DataBase/Serie.json")

    {- Lista os jogos do sistema -}
    listarJogos:: String
    listarJogos = organizaListagem (BD.getJogoJSON "app/DataBase/Jogo.json")

    {- Lista os clientes do sistema -}
    listarClientes:: String
    listarClientes = organizaListagem (BD.getClienteJSON "app/DataBase/Cliente.json")

    {- cadastra um cliente no sistema -}
    cadastrarCliente :: String -> String -> String -> String -> IO String
    cadastrarCliente "" _ _ _ = return "Nome inválido"
    cadastrarCliente _ "" _ _ = return "Id inválido"
    cadastrarCliente nome idCliente idFun senha = do
        if validaFuncionario idFun senha then do
            BD.saveClienteJSON idCliente nome
            return (show (BD.getClienteByID idCliente (getClienteJSON "app/DataBase/Cliente.json")))
        else return "Cadastro falhou!"
    
    {- Faz a remoção do cliente no sistema -}
    excluirCliente :: String -> String -> String -> IO String
    excluirCliente "" _ _ = return "Id inválido"
    excluirCliente id idFun senha=  do
        if validaFuncionario idFun senha then do
            let original = getClienteJSON "app/DataBase/Cliente.json"
            let removida = removeClienteByID id (original)
            if removida == original then return "Não foi possivel realizar ação" else do
                saveAlteracoesCliente removida
                return "Remoção feita com sucesso"
        else return "Não foi possivel realizar ação"

    {- Lista o historico de um determinado cliente -}
    exibirHistorico :: String -> String
    exibirHistorico "" = "Id inválido!"
    exibirHistorico id = do
        let cliente = BD.getClienteByID id (getClienteJSON "app/DataBase/Cliente.json")
        "Historico do cliente: " ++ organizaListagem (Models.Cliente.historico cliente)

    {- cadastra uma serie no sistema -}
    cadastrarSerie :: String ->  String -> String -> String ->  String -> String -> String -> IO String
    cadastrarSerie _ _ "" _ _ _ _ = return "Id inválido!"
    cadastrarSerie _ _ _ "" _ _ _ = return "Nome inválido!"
    cadastrarSerie _ _ _ _ "" _ _ = return "Descrição inválida!"
    cadastrarSerie _ _ _ _ _ "" _ = return "Categoria inválida!"
    cadastrarSerie _ _ _ _ _ _ "" = return "Preço inválido!"
    cadastrarSerie idFun senha idSerie nome descricao categoria precoPorDia = do
        if validaFuncionario idFun senha then do
            BD.saveSerieJSON idSerie nome descricao categoria (read precoPorDia)
            return "Cadastro realizado"
        else
            return "Cadastro falhou"
    
     {- exclui uma serie do  sistema -}
    excluirSerie :: String -> String -> String -> IO String
    excluirSerie "" _ _ = return "Id inválido!"
    excluirSerie id idFun senha =  do
        if validaFuncionario idFun senha then do
            let original = getSerieJSON "app/DataBase/Serie.json"
            let removida = removeSerieByID id (original)
            if removida == original then return "Não foi possivel realizar ação" else do
                saveAlteracoesSerie removida
                return "Remoção feita com sucesso"
        else return "Não foi possivel realizar ação"

    {- cadastra um filme no sistema -}
    cadastrarFilme :: String ->  String -> String -> String ->  String -> String -> String -> IO String
    cadastrarFilme _ _ "" _ _ _ _ = return "Id inválido!"
    cadastrarFilme _ _ _ "" _ _ _ = return "Nome inválido!"
    cadastrarFilme _ _ _ _ "" _ _ = return "Descrição inválida!"
    cadastrarFilme _ _ _ _ _ "" _ = return "Categoria inválida!"
    cadastrarFilme _ _ _ _ _ _ "" = return "Preço inválido!"
    cadastrarFilme idFun senha idFilme nome descricao categoria precoPorDia = do
        if validaFuncionario idFun senha then do
            BD.saveFilmeJSON idFilme nome descricao categoria (read precoPorDia)
            return "Cadastro realizado"
        else
            return "Cadastro falhou"
    {- exclui um filme sistema -}
    excluirFilme :: String -> String -> String -> IO String
    excluirFilme "" _ _ = return "Id inválido!"
    excluirFilme id idFun senha =  do
        if validaFuncionario idFun senha then do
            let original = getFilmeJSON "app/DataBase/Filme.json"
            let removida = removeFilmeByID id (original)
            if removida == original then return "Não foi possivel realizar ação" else do
                saveAlteracoesFilme removida
                return "Remoção feita com sucesso"
        else return "Não foi possivel realizar ação"
    
    {- cadastra um jogo no sistema -}
    cadastrarJogo :: String ->  String -> String -> String ->  String -> String -> String -> IO String
    cadastrarJogo _ _ "" _ _ _ _ = return "Id inválido!"
    cadastrarJogo _ _ _ "" _ _ _ = return "Nome inválido!"
    cadastrarJogo _ _ _ _ "" _ _ = return "Descrição inválida!"
    cadastrarJogo _ _ _ _ _ "" _ = return "Categoria inválida!"
    cadastrarJogo _ _ _ _ _ _ "" = return "Preço inválido!"
    cadastrarJogo idFun senha idJogo nome descricao categoria precoPorDia = do
        if validaFuncionario idFun senha then do
            BD.saveJogoJSON idJogo nome descricao categoria (read precoPorDia)
            return "Cadastro realizado"
        else
            return "Cadastro falhou"

    {- exclui um jogo do sistema -}
    excluirJogo :: String -> String -> String -> IO String
    excluirJogo "" _ _ = return "Id inválido!"
    excluirJogo id idFun senha =  do
        if validaFuncionario idFun senha then do
            let original = getJogoJSON "app/DataBase/Jogo.json"
            let removida = removeJogoByID id (original)
            if removida == original then return "Não foi possivel realizar ação" else do
                saveAlteracoesJogo removida
                return "Remoção feita com sucesso"
        else return "Não foi possivel realizar ação"
    
     {- faz a organização das lista em uma string por linha usando a sua
        representação em string -}
    organizaListagem :: Show t => [t] -> String
    organizaListagem [] = ""
    organizaListagem (x:xs) = show x ++ "\n" ++ organizaListagem xs

     {- Faz a validação do funcionário, usando seu id e uma senha padrão
        para representar uma camada de segurança do sitesma -}
    validaFuncionario:: String -> String -> Bool
    validaFuncionario id senha = do
        let funcionarios = getFuncionarioJSON "app/DataBase/Funcionario.json"
            funcionario = getFuncionarioByID id funcionarios
        Models.Funcionario.identificador funcionario /= "-1" && senha == "12988"

