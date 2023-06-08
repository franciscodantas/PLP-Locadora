:- use_module(library(http/json)).
:- import('utils.pl').
:- consult('DataBase/GerenciadorBD.pl').
:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).

cadastrarFuncionario(Id,Nome,SenhaFunc, IdGerente, Senha, Resposta):-
    validaGerente(IdGerente, Senha, Resposta1),
    Resposta1 = 'Gerente validado!',
    atom_string(IdAtom, Id),
    get_funcionario_by_id(IdAtom, Funcionario),
    Funcionario = -1,
    add_funcionario(Id, Nome, SenhaFunc),
    Resposta = 'Funcionário cadastrado!'.

cadastrarFuncionario(_, _, _, _, _,'Cadastro não realizado!').

exibirFuncionario(ID, Resposta):-
    atom_string(IdAtom, ID),
    get_funcionario_by_id(IdAtom, Funcionario),
    Funcionario \= -1,
    extract_info_funcionarios_gerentes(Funcionario, _, Nome, _),
    string_concat('Nome: ', Nome, NomeLinha),
    string_concat(NomeLinha, ' - ', NomeTraco),
    string_concat(NomeTraco, ID, NomeTracoID),
    string_concat(NomeTracoID, '\n', Resposta).

exibirFuncionario(_, 'Funcionário não existe!').

listaFuncionarios(Resposta) :-
    get_funcionarios(Funcionarios),
    organizaListagemFuncionarios(Funcionarios, Resposta).

organizaListagemFuncionarios([], '').
organizaListagemFuncionarios([H|T], Resposta) :-
    organizaListagemFuncionarios(T, Resposta1),
    extract_info_funcionarios_gerentes(H, ID, Nome, _),
    string_concat(Nome, ' - ', NomeTraco),
    string_concat(NomeTraco, ID, NomeTracoID),
    string_concat(NomeTracoID, '\n', Resposta2),
    string_concat(Resposta2, Resposta1, Resposta).

validaGerente(IdGerente, Senha, Resposta) :-
    atom_string(IdGerenteAtom, IdGerente),
    get_gerente_by_id(IdGerenteAtom, Gerente),
    extract_info_funcionarios_gerentes(Gerente, _, _, SenhaAtual),
    atom_string(SenhaAtom, Senha),
    SenhaAtom = SenhaAtual,
    Gerente \= -1,
    Resposta = 'Gerente validado!', !.

/* As regras get_produto_em_destaque e seleciona_aluguel_destaque são
responsáveis por selecionar o produto em detaque positivo ou negativo
em relação ao aluguel. O produto com maior número de alugueis
pode ser obtido passando o átomo 'mais_alugado' para as regras.
Já o produto com menor número de alugueis pode ser obtido 
passando o átomo 'menos_alugado' para as regras */
seleciona_aluguel_destaque('mais_alugado', QtdAlugueis1, QtdAlugueis2, Produto1, Produto2, Destaque) :- 
    (QtdAlugueis1 > QtdAlugueis2 -> Destaque = Produto1 ; Destaque = Produto2).
seleciona_aluguel_destaque('menos_alugado', QtdAlugueis1, QtdAlugueis2, Produto1, Produto2, Destaque) :- 
    (QtdAlugueis1 > QtdAlugueis2 -> Destaque = Produto2 ; Destaque = Produto1).

get_produto_em_destaque([], _, Produto_Maior_Atual, Produto_Maior_Atual).
get_produto_em_destaque([Produto_Atual | Tail], Tipo_Destaque, Produto_Maior_Atual, Produto_Maior_Final) :- 
    extract_info_produtos(Produto_Atual, _, _, _, _, _, QtdAlugueis_Atual),
    extract_info_produtos(Produto_Maior_Atual, _, _, _, _, _, QtdAlugueis_Maior),
    seleciona_aluguel_destaque(Tipo_Destaque, QtdAlugueis_Atual, QtdAlugueis_Maior, Produto_Atual, Produto_Maior_Atual, Novo_Maior),
    get_produto_em_destaque(Tail, Tipo_Destaque, Novo_Maior, Produto_Maior_Final).

/* Essa regra é responsável por pegar 'n' produtos em destaque.
O destaque pode ser os 'n' produtos mais alugados ou os 'n' produtos
menos alugados */
get_n_destaques(_, 0, _, Destaques_Atuais, Destaques_Atuais).
get_n_destaques([], _, _, Destaques_Atuais, Destaques_Atuais).
get_n_destaques(Produtos, N, Tipo_Destaque, Destaques_Atuais, Destaques_Finais) :- 
    [Primeiro_Produto | _] = Produtos,
    get_produto_em_destaque(Produtos, Tipo_Destaque, Primeiro_Produto, Destaque),
    Novos_Destaques = [Destaque | Destaques_Atuais],
    remove_object(Produtos, Destaque, Novos_Produtos),
    Novo_N is N - 1,
    get_n_destaques(Novos_Produtos, Novo_N, Tipo_Destaque, Novos_Destaques, Destaques_Finais).

/* Essa regra é responsável por pegar os 3 filmes mais alugados do sistema */
get_top_filmes_mais_alugados(Filmes_Mais_Alugados) :- 
    get_filmes(Filmes),
    get_n_destaques(Filmes, 3, 'mais_alugado', [], Filmes_Mais_Alugados).

/* Essa regra é responsável por pegar os 3 filmes menos alugados do sistema */
get_top_filmes_menos_alugados(Filmes_Menos_Alugados) :- 
    get_filmes(Filmes),
    get_n_destaques(Filmes, 3, 'menos_alugado', [], Filmes_Menos_Alugados).

/* Essa regra é responsável por pegar os 3 séries mais alugados do sistema */
get_top_series_mais_alugadas(Series_Mais_Alugadas) :- 
    get_series(Serie),
    get_n_destaques(Serie, 3, 'mais_alugado', [], Series_Mais_Alugadas).

/* Essa regra é responsável por pegar os 3 séries menos alugados do sistema */
get_top_series_menos_alugadas(Series_Menos_Alugadas) :- 
    get_series(Serie),
    get_n_destaques(Serie, 3, 'menos_alugado', [], Series_Menos_Alugadas).

/* Essa regra é responsável por pegar os 3 jogos mais alugados do sistema */
get_top_jogos_mais_alugados(Jogos_Mais_Alugados) :- 
    get_jogos(Jogos),
    get_n_destaques(Jogos, 3, 'mais_alugado', [], Jogos_Mais_Alugados).
