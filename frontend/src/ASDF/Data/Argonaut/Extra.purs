module Data.Argonaut.Extra
    ( decodeJsonM
    ) where

import Prelude

import Control.Monad.Eff.Exception (Error, error)
import Control.Monad.Error.Class (class MonadError, throwError)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Either (either)

decodeJsonM
    :: forall m a
     . MonadError Error m
    => DecodeJson a
    => Json
    -> m a
decodeJsonM = either (throwError <<< error) pure <<< decodeJson
