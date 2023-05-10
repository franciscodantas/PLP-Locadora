{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE InstanceSigs #-}

module Models.Filme where
    import GHC.Generics
    
    data Filme = Filme {
        identificador :: String,
        nome:: String,        
        descricao:: String,
        categoria:: String,
        qtdAlugueis:: Int,
        precoPorDia:: Float
    } deriving (Generic,Eq)

    instance Show Filme where
        show :: Filme -> String
        show (Filme identificador nome descricao categoria qtdAlugueis precoPorDia) = "Nome: " ++ nome ++ "\n(" ++ filter (\c -> c /= '/' && c /= '\'') descricao ++ ")\n" ++ "Valor por dia: R$" ++ show precoPorDia