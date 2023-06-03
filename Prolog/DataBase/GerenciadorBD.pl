:- use_module(library(http/json)).

%%% MÉTODOS GERAIS %%%
load_json_file(File, Data) :-
    open(File, read, Stream),
    json_read(Stream, Data),
    close(Stream).

save_json_file(File, Data) :-
    open(File, write, Stream),
    json_write(Stream, Data),
    close(Stream).

save_object(File, Element) :- 
    load_json_file(File, Data),
    New_Data = [Element | Data],
    save_json_file(File, New_Data).

extract_info_produtos(json([id=Id, nome=Nome, descricao=Descricao, categoria=Categoria, precoPorDia=PrecoPorDia, qtdAlugueis=QtdAlugueis]), Id, Nome, Descricao, Categoria, PrecoPorDia, QtdAlugueis).
extract_info_clientes(json([id=Id, nome=Nome, carrinho=Carrinho, historico=Historico]), Id, Nome, Carrinho, Historico).

extract_info_object('produtos', Head_Object, Object_Id) :- extract_info_produtos(Head_Object, Object_Id, _, _, _, _, _).
extract_info_object('clientes', Head_Object, Object_Id) :- extract_info_clientes(Head_Object, Object_Id, _, _, _).

seach_id([], _, -1, _) :- !. % Caso não o objeto buscado não exista, -1 é retornado
seach_id([Head_Object|Tail], Id, Object, Type) :- 
    extract_info_object(Type, Head_Object, Object_Id),
    (Object_Id = Id -> Object = Head_Object; seach_id(Tail, Id, Object, Type)).

seach_nome([], _, -1) :- !. % Caso não o objeto buscado não exista, -1 é retornado
seach_nome([Head_Object|Tail], Nome, Object) :- 
    extract_info_produtos(Head_Object, _, Object_Nome, _, _, _, _),
    (Object_Nome = Nome -> Object = Head_Object; seach_nome(Tail, Nome, Object)).

get_object_by_id(File, Id, Object, Type) :- 
    load_json_file(File, Data),
    seach_id(Data, Id, Object, Type).

get_object_by_nome(File, Nome, Object) :- 
    load_json_file(File, Data),
    seach_nome(Data, Nome, Object).

remove_object([], _, []).
remove_object([Header|Tail], Object, Final_Data) :-
    remove_object(Tail, Object, Data),
    (Header = Object -> Final_Data = Data ; Final_Data = [Header | Data]).

remove_object_by_id(File, Id, Type) :-
    load_json_file(File, Data),
    seach_id(Data, Id, Object, Type),
    remove_object(Data, Object, Final_Data),
    save_json_file(File, Final_Data).

%%% REGRAS PARA FILMES %%%
get_filmes(Data) :- load_json_file('DataBase/Filme.json', Data).
add_filme(ID, Nome, Descricao, Categoria, Preco) :- 
    Filme = json([id=ID, nome=Nome, descricao=Descricao, categoria=Categoria, preco=Preco, qtdAlugueis=0]),
    save_object('Filme.json', Filme).
get_filme_by_id(Id, Filme) :- get_object_by_id('Filme.json', Id, Filme, 'produtos').
get_filme_by_nome(Nome, Filme) :- get_object_by_nome('Filme.json', Nome, Filme).
remove_filme_by_id(Id) :- remove_object_by_id('Filme.json', Id, 'produtos').

%%% REGRAS PARA SÉRIES %%%
get_series(Data) :- load_json_file('Serie.json', Data).
add_serie(ID, Nome, Descricao, Categoria, Preco) :- 
    Serie = json([id=ID, nome=Nome, descricao=Descricao, categoria=Categoria, preco=Preco, qtdAlugueis=0]),
    save_object('Serie.json', Serie).
get_serie_by_id(Id, Serie) :- get_object_by_id('Serie.json', Id, Serie, 'produtos').
get_serie_by_nome(Nome, Serie) :- get_object_by_nome('Serie.json', Nome, Serie).
remove_serie_by_id(Id) :- remove_object_by_id('Serie.json', Id, 'produtos').

%%% REGRAS PARA JOGOS %%%
get_jogos(Data) :- load_json_file('Jogo.json', Data).
add_jogo(ID, Nome, Descricao, Categoria, Preco) :- 
    Jogo = json([id=ID, nome=Nome, descricao=Descricao, categoria=Categoria, preco=Preco, qtdAlugueis=0]),
    save_object('Jogo.json', Jogo).
get_jogo_by_id(Id, Jogo) :- get_object_by_id('Jogo.json', Id, Jogo, 'produtos').
get_jogo_by_nome(Nome, Jogo) :- get_object_by_nome('Jogo.json', Nome, Jogo).
remove_jogo_by_id(Id) :- remove_object_by_id('Jogo.json', Id, 'produtos').

%%% REGRAS PARA CLIENTES %%%
get_cientes(Data) :- load_json_file('Cliente.json', Data).
add_cliente(ID, Nome) :- 
    Cliente = json([id=ID, nome=Nome, carrinho=[], hitorico=[]]),
    save_object('Cliente.json', Cliente).
get_cliente_by_id(Id, Cliente) :- get_object_by_id('Cliente.json', Id, Cliente, 'clientes').

