module ASDF.Login.AJAX
    ( interpret
    ) where

import Prelude

import ASDF.Credentials (EmailAddress, Password)
import ASDF.Login.Algebra (Login (..))
import ASDF.Token (Token (..))
import Control.Monad.Aff.Class (class MonadAff, liftAff)
import Control.Monad.Eff.Exception (Error, error)
import Control.Monad.Error.Class (class MonadError, throwError)
import Data.Argonaut.Core (Json, jsonEmptyObject)
import Data.Argonaut.Decode (class DecodeJson, (.?), decodeJson)
import Data.Argonaut.Encode (class EncodeJson, (~>), (:=), encodeJson)
import Data.Either (either)
import Data.Maybe (Maybe)
import Data.Newtype (unwrap)
import Network.HTTP.Affjax (AJAX)

import Network.HTTP.Affjax as Affjax

baseURL :: String
baseURL = "http://localhost:8080"

interpret
    :: forall eff m
     . MonadAff (ajax :: AJAX | eff) m
    => Login ~> m
interpret (Login next emailAddress password) = liftAff $ do
    let request = encodeJson $ Request emailAddress password
    {response} <- Affjax.post (baseURL <> "/login") request
    Response token <- decodeJsonM response
    pure <<< next $ token

data Request = Request EmailAddress Password
newtype Response = Response (Maybe Token)

instance encodeJsonRequest :: EncodeJson Request where
    encodeJson (Request emailAddress password) =
        "email_address" := unwrap emailAddress ~>
        "password"      := unwrap password     ~>
        jsonEmptyObject

instance decodeJsonResponse :: DecodeJson Response where
    decodeJson json = do
        output <- decodeJson json >>= (_ .? "token")
        pure <<< Response $ Token <$> output

decodeJsonM
    :: forall m a
     . MonadError Error m
    => DecodeJson a
    => Json
    -> m a
decodeJsonM = either (throwError <<< error) pure <<< decodeJson
