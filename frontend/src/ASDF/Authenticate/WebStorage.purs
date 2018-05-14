module ASDF.Authenticate.WebStorage
    ( interpret
    ) where

import Prelude

import ASDF.Authenticate.Algebra (Authenticate (..))
import ASDF.Token (Token (..))
import Control.Monad.Eff.Class (class MonadEff, liftEff)
import DOM (DOM)
import DOM.WebStorage.Storage (Storage, getItem, removeItem, setItem)

storageKey :: String
storageKey = "asdf:token"

interpret
    :: forall eff m
     . MonadEff (dom :: DOM | eff) m
    => Storage
    -> Authenticate ~> m
interpret s (GetToken next) =
    liftEff $ next <<< map Token <$> getItem storageKey s
interpret s (PutToken next (Token t)) =
    liftEff $ next <$ setItem storageKey t s
interpret s (DeleteToken next) =
    liftEff $ next <$ removeItem storageKey s
