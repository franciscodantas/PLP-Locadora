# PLP-Locadora

Imagine uma locadora de filmes, séries e jogos super moderna! Você pode facilmente buscar e adicionar seus títulos favoritos ao carrinho. Quer uma sugestão? A locadora recomenda filmes, séries e jogos mais populares ou com base no seu histórico de aluguel. Os funcionários podem cadastrar novos clientes e editar o acervo, enquanto o gerente pode gerir funcionários e acompanhar as estatísticas de vendas. Com certeza, uma ótima opção para quem gosta de entretenimento em casa!

Clique [aqui](https://docs.google.com/document/d/1Hd8hqg1ZLk40Qy2-A8kXrYkZBt3Vb7vGPT5a1jN4DLM/edit?usp=sharing) para ver as especificações.

| Desenvolvedor                           | Github                                  | Função                         |
| -------------------------------------- | --------------------------------------- | ------------------------------|
| Felipe Jerônimo Bernardo da Silva      | [Github](https://github.com/FelipeJer)  | Funções em Gerente             |
| Francisco Antonio Dantas de Sousa      | [Github](https://github.com/franciscodantas) | Funções em Funcionário e Gerente |
| João Pedro Juvino dos Santos           | [Github](https://github.com/joao-juvino) | Funções em Banco de Dados e Cliente |
| Paulo Victor Machado de Souza          | [Github](https://github.com/paulo-vms)  | Funções em Cliente             |
| Victor Alexandre Cavalcanti Macedo     | [Github](https://github.com/AlexWasHeree) | Função Menu                    |

## Implementação Funcional (Haskell)

Para esse projeto foi usado o Cabal, por isso será necessária sua instalação na máquina. Recomenda-se instalar o [GHCup](https://www.haskell.org/ghcup/) para tal.

### Instruções para execução

1. Certifique-se de ter clonado a `branch main`.
2. Faça o `clean` do projeto para garantir a corretude do sistema:

   ```sh
   cabal clean
    ```
2. `build` o projeto para que todas as dependências sejam instaladas:

    ```sh
    cabal build
    ```
3. Execute o sistema com `run`:

    ```sh
    cabal run
    ```
