{-# LANGUAGE DeriveGeneric #-}
module Models.Gerente where

    import GHC.Generics
    
    data Gerente = Gerente {
        identificador :: String,
        nome:: String
    } deriving (Show, Generic)